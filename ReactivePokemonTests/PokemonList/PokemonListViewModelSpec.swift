import Quick
import Nimble
@testable import ReactivePokemon

class PokemonListViewModelSpec: QuickSpec {
    override func spec() {
        describe("PokemonListViewModel") {
            var mockPokemonService: MockPokemonService!
            beforeEach {
                mockPokemonService = MockPokemonService()
            }

            describe("init") {
                context("cellUpdaters") {
                    var viewModel: PokemonListViewModel!
                    let filterName = "bulbasaur"
                    let pokemonPagePokemonOne = PokemonPagePokemonBuilder()
                        .withName(filterName)
                        .build()
                    let pokemonPagePokemonTwo = PokemonPagePokemonBuilder()
                        .withName("ivysaur")
                        .build()
                    let pokemonPagePokemons = [pokemonPagePokemonOne, pokemonPagePokemonTwo]
                    let pokemonPage = PokemonPageBuilder()
                        .withResults(pokemonPagePokemons)
                        .build()

                    beforeEach {
                        mockPokemonService.stubPokemonPage = pokemonPage
                        viewModel = PokemonListViewModel(pokemonService: mockPokemonService)
                    }

                    it("returns all cell updaters on initialization with empty filter name") {
                        let cellViewModelOne = (viewModel.cellUpdaters.value.first as? CellUpdater<PokemonCell>)?.viewModel as? PokemonCellViewModel
                        let cellViewModelTwo = (viewModel.cellUpdaters.value.last as? CellUpdater<PokemonCell>)?.viewModel as? PokemonCellViewModel
                        let expectedCellViewModelOne = PokemonCellViewModel(pokemonPagePokemon: pokemonPagePokemonOne, index: 0)
                        let expectedCellViewModelTwo = PokemonCellViewModel(pokemonPagePokemon: pokemonPagePokemonTwo, index: 1)

                        expect(viewModel.cellUpdaters.value.count).to(equal(2))
                        expect(cellViewModelOne).to(equal(expectedCellViewModelOne))
                        expect(cellViewModelTwo).to(equal(expectedCellViewModelTwo))
                    }

                    it("returns all cell updaters if filter name is empty") {
                        viewModel.pokemonFilterName.swap("")
                        let cellViewModelOne = (viewModel.cellUpdaters.value.first as? CellUpdater<PokemonCell>)?.viewModel as? PokemonCellViewModel
                        let cellViewModelTwo = (viewModel.cellUpdaters.value.last as? CellUpdater<PokemonCell>)?.viewModel as? PokemonCellViewModel
                        let expectedCellViewModelOne = PokemonCellViewModel(pokemonPagePokemon: pokemonPagePokemonOne, index: 0)
                        let expectedCellViewModelTwo = PokemonCellViewModel(pokemonPagePokemon: pokemonPagePokemonTwo, index: 1)

                        expect(viewModel.cellUpdaters.value.count).to(equal(2))
                        expect(cellViewModelOne).to(equal(expectedCellViewModelOne))
                        expect(cellViewModelTwo).to(equal(expectedCellViewModelTwo))
                    }

                    it("returns cell updaters matching filter name") {
                        viewModel.pokemonFilterName.swap(filterName)

                        let cellViewModel = (viewModel.cellUpdaters.value.first as? CellUpdater<PokemonCell>)?.viewModel as? PokemonCellViewModel
                        let expectedCellViewModel = PokemonCellViewModel(pokemonPagePokemon: pokemonPagePokemonOne, index: 0)
                        
                        expect(viewModel.cellUpdaters.value.count).to(equal(1))
                        expect(cellViewModel).to(equal(expectedCellViewModel))
                    }
                }
            }
        }
    }
}
