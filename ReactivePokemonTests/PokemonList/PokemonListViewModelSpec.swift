import Quick
import Nimble
@testable import ReactivePokemon

class PokemonListViewModelSpec: QuickSpec {
    override func spec() {
        describe("PokemonListViewModel") {
            describe("init") {
                it("initializes cell updaters from pokemon page") {
                    let pokemonPage = PokemonPageBuilder().build()
                    let mockPokemonService = MockPokemonService()
                    mockPokemonService.stubPokemonPage = pokemonPage
                    let viewModel = PokemonListViewModel(pokemonService: mockPokemonService)

                    let cellViewModel = (viewModel.cellUpdaters.value.first as? CellUpdater<PokemonCell>)?.viewModel as? PokemonCellViewModel
                    let expectedCellViewModel = PokemonCellViewModel(pokemonPagePokemon: pokemonPage.results.first!)
                    expect(viewModel.cellUpdaters.value.count).to(equal(1))
                    expect(cellViewModel).to(equal(expectedCellViewModel))
                }
            }
        }
    }
}
