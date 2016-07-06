import ReactiveCocoa

protocol PokemonListViewModelType : CollectionViewModel {
}

class PokemonListViewModel: PokemonListViewModelType {
    private let pokemonService: PokemonService
    let cellUpdaters = MutableProperty<[CellUpdaterType]>([])

    init(pokemonService: PokemonService = PokemonService()) {
        self.pokemonService = pokemonService
        cellUpdaters <~ pokemonService.getPokemonList().map(pokemonListToCellUpdaters)
    }

    private func pokemonListToCellUpdaters(pokemonList: [Pokemon]) -> [CellUpdaterType] {
        return pokemonList.map { pokemon in
            let vm = PokemonCellViewModel(pokemon: pokemon)
            return CellUpdater<PokemonCell>(viewModel: vm)
        }
    }
}
