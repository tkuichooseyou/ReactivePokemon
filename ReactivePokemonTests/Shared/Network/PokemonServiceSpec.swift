import Quick
import Nimble
@testable import ReactivePokemon

class PokemonServiceSpec: QuickSpec {
    override func spec() {
        describe("PokemonService") {
            describe("getPokemonPage") {
                it("returns signal with pokemon page") {
                    let pokemonService = PokemonService(provider: MockProvider())
                    var enteredClosure = false

                    pokemonService.getPokemonPage(0).startWithNext { pokemonPage in
                        enteredClosure = true
                        expect(pokemonPage?.count).to(equal(811))
                        expect(pokemonPage?.previous).to(beNil())
                        expect(pokemonPage?.next).to(equal("http://pokeapi.co/api/v2/pokemon/?limit=200&offset=200"))
                        expect(pokemonPage?.results.count).to(equal(200))
                    }

                    expect(enteredClosure).toEventually(beTrue())
                }
            }
        }
    }
}
