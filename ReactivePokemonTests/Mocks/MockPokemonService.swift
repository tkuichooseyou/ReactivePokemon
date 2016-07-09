import ReactiveCocoa
import Result

@testable import ReactivePokemon

final class MockPokemonService : PokemonServiceType  {
    var stubPokemonPage: PokemonPage?
    var stubPokemon: Pokemon?

    func getPokemonPage(page: Int) -> SignalProducer<PokemonPage?, NoError> {
        return SignalProducer(value: stubPokemonPage)
    }

    func getPokemonByID(id: String) -> SignalProducer<Pokemon?, NoError> {
        return SignalProducer(value: stubPokemon)
    }
}
