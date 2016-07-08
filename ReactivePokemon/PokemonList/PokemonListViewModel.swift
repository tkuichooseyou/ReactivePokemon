import ReactiveCocoa

protocol PokemonListViewModelType : CollectionViewModel {}

class PokemonListViewModel: PokemonListViewModelType {
    private let pokemonService: PokemonServiceType
    private let latestPokemonPage = MutableProperty<PokemonPage?>(nil)
    let cellUpdaters = MutableProperty<[CellUpdaterType]>([])

    init(pokemonService: PokemonServiceType = PokemonService()) {
        self.pokemonService = pokemonService
        let latestPokemonPageSignal = pokemonService.getPokemonPage(0)
        cellUpdaters <~ latestPokemonPage.signal
            .map(pokemonPageToCellUpdaters)
            .map { [unowned self] in
                return self.cellUpdaters.value + $0
        }
        latestPokemonPage <~ latestPokemonPageSignal
        latestPokemonPageSignal.start()
    }

    private func pokemonPageToCellUpdaters(pokemonPage: PokemonPage?) -> [CellUpdaterType] {
        guard let pokemonPage = pokemonPage else { return [] }
        return pokemonPage.results.map { pokemon in
            let vm = PokemonCellViewModel(pokemonPagePokemon: pokemon)
            return CellUpdater<PokemonCell>(viewModel: vm)
        }
    }
}
