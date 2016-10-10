import ReactiveSwift
import Result

protocol PokemonListViewModelType : CollectionViewModel {
    var pokemonFilterName: MutableProperty<String> { get }
}

class PokemonListViewModel: PokemonListViewModelType {
    private let pokemonService: PokemonServiceType
    private let pokemonPage = MutableProperty<PokemonPage?>(nil)
    let pokemonFilterName = MutableProperty<String>("")
    let cellUpdaters = MutableProperty<[CellUpdater<PokemonCell>]>([])
    private var cellVMCache = NSCache<NSString, PokemonCellViewModel>()

    init(pokemonService: PokemonServiceType = PokemonService()) {
        self.pokemonService = pokemonService
        let latestPokemonPageSignal = pokemonService.getPokemonPage(0)
        pokemonPage <~ latestPokemonPageSignal

        let fullCellUpdaterSignal = pokemonPage.producer
            .map {$0?.results ?? []}
            .map(pokemonPageResultsToCellUpdaters)
            .on(value: { cellUpdaters in
                DispatchQueue.global(qos: .userInitiated).async {
                    let strideBy = 10
                    let groupCount = cellUpdaters.count / strideBy
                    let remainderIndices = (groupCount * strideBy)..<cellUpdaters.count

                    DispatchQueue.concurrentPerform(iterations: groupCount) { strideIndex in
                        let startIndex = strideIndex*strideBy
                        (startIndex..<startIndex+strideBy).forEach { index in
                            let cellUpdater = cellUpdaters[index]
                            cellUpdater.viewModel.start()
                        }

                    }

                    remainderIndices.forEach { index in
                        let cellUpdater = cellUpdaters[index]
                        cellUpdater.viewModel.start()
                    }
                }
            })

        let filteredCellUpdaterSignal = pokemonFilterName.producer
            .map(filteredResults)
            .map(pokemonPageResultsToCellUpdaters)

        let signal: SignalProducer<[CellUpdater<PokemonCell>], NoError> = SignalProducer(values:fullCellUpdaterSignal, filteredCellUpdaterSignal).flatten(.merge)


        cellUpdaters <~ signal
        latestPokemonPageSignal.start()
    }

    private var pokemonPageResults: [PokemonPage.Pokemon] {
        return pokemonPage.value?.results ?? []
    }

    private func filteredResults(filterName: String) -> [PokemonPage.Pokemon] {
        guard let name = filterName.nilIfEmpty()?.lowercased() else { return pokemonPageResults }
        return pokemonPageResults.filter { pokemon in
            pokemon.name.lowercased().contains(name)
        }
    }

    private func pokemonPageResultsToCellUpdaters(pokemonPageResults: [PokemonPage.Pokemon]) -> [CellUpdater<PokemonCell>] {
        return pokemonPageResults.map { pokemon in
            let id = NSString(string: pokemon.id)
            guard let cachedVM = cellVMCache.object(forKey: id) else {
                let vm = PokemonCellViewModel(pokemonPagePokemon: pokemon)
                cellVMCache.setObject(vm, forKey: id)
                return CellUpdater<PokemonCell>(viewModel: vm)
            }
            return CellUpdater<PokemonCell>(viewModel: cachedVM)
        }
    }
}
