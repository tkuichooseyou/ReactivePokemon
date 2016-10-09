import ReactiveSwift
import Result

protocol PokemonListViewModelType : CollectionViewModel {
    var pokemonFilterName: MutableProperty<String> { get }
}

class PokemonListViewModel: PokemonListViewModelType {
    private let pokemonService: PokemonServiceType
    private let pokemonPages = MutableProperty<[PokemonPage]>([])
    let pokemonFilterName = MutableProperty<String>("")
    let cellUpdaters = MutableProperty<[CellUpdaterType]>([])
    private var cellVMCache = [String: PokemonCellViewModel]()

    init(pokemonService: PokemonServiceType = PokemonService()) {
        self.pokemonService = pokemonService
        let latestPokemonPageSignal = pokemonService.getPokemonPage(0)
        pokemonPages <~ latestPokemonPageSignal
            .map { [unowned self] pokemonPage in
                guard let pokemonPage = pokemonPage else { return self.pokemonPages.value }
                return self.pokemonPages.value + [pokemonPage]
        }

        let fullCellUpdaterSignal = pokemonPages.producer
            .map {$0.reduce([]) { memo, next in memo + next.results}}
            .map(pokemonPageResultsToCellUpdaters)

        let filteredCellUpdaterSignal = pokemonFilterName.producer
            .map(filteredResults)
            .map(pokemonPageResultsToCellUpdaters)

        let signal: SignalProducer<[CellUpdaterType], NoError> = SignalProducer(values:fullCellUpdaterSignal, filteredCellUpdaterSignal).flatten(.merge)
        cellUpdaters <~ signal
        latestPokemonPageSignal.start()
    }

    private var pokemonPageResults: [PokemonPage.Pokemon] {
        return pokemonPages.value.reduce([]) { memo, next in memo + next.results }
    }

    private func filteredResults(filterName: String) -> [PokemonPage.Pokemon] {
        guard let name = filterName.nilIfEmpty()?.lowercased() else { return pokemonPageResults }
        return pokemonPageResults.filter { pokemon in
            pokemon.name.lowercased().contains(name)
        }
    }

    private func pokemonPageResultsToCellUpdaters(pokemonPageResults: [PokemonPage.Pokemon]) -> [CellUpdaterType] {
        return pokemonPageResults.map { pokemon in
            guard let cachedVM = cellVMCache[pokemon.id] else {
                let vm = PokemonCellViewModel(pokemonPagePokemon: pokemon)
                cellVMCache[pokemon.id] = vm
                return CellUpdater<PokemonCell>(viewModel: vm)
            }
            return CellUpdater<PokemonCell>(viewModel: cachedVM)
        }
    }
}
