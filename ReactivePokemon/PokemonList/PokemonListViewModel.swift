import ReactiveCocoa

protocol PokemonListViewModelType : CollectionViewModel {
    var pokemonFilterName: MutableProperty<String> { get }
}

class PokemonListViewModel: PokemonListViewModelType {
    private let pokemonService: PokemonServiceType
    private let pokemonPages = MutableProperty<[PokemonPage]>([])
    let pokemonFilterName = MutableProperty<String>("")
    let cellUpdaters = MutableProperty<[CellUpdaterType]>([])

    init(pokemonService: PokemonServiceType = PokemonService()) {
        self.pokemonService = pokemonService
        let latestPokemonPageSignal = pokemonService.getPokemonPage(0)
        pokemonPages <~ latestPokemonPageSignal
            .map { [unowned self] pokemonPage in
                guard let pokemonPage = pokemonPage else { return self.pokemonPages.value }
                return self.pokemonPages.value + [pokemonPage]
        }

        cellUpdaters <~ pokemonFilterName.producer
            .map(filteredResults)
            .map(pokemonPageResultsToCellUpdaters)
        latestPokemonPageSignal.start()
    }

    private var pokemonPageResults: [PokemonPage.Pokemon] {
        return pokemonPages.value.reduce([]) { memo, next in memo + next.results }
    }

    private func filteredResults(filterName: String) -> [PokemonPage.Pokemon] {
        guard let name = filterName.nilIfEmpty() else { return pokemonPageResults }
        return pokemonPageResults.filter { pokemon in
            pokemon.name.localizedCaseInsensitiveContainsString(name)
        }
    }

    private func pokemonPageResultsToCellUpdaters(pokemonPageResults: [PokemonPage.Pokemon]) -> [CellUpdaterType] {
        return pokemonPageResults.enumerate().map { index, pokemon in
            let vm = PokemonCellViewModel(pokemonPagePokemon: pokemon, index: index)
            return CellUpdater<PokemonCell>(viewModel: vm)
        }
    }
}
