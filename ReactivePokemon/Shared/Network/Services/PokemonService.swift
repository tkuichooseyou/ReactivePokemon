import Moya
import ReactiveCocoa
import Result
import Argo

protocol PokemonServiceType {
    func getPokemonPage(page: Int) -> SignalProducer<PokemonPage?, NoError>
    func getPokemonByID(id: String) -> SignalProducer<Pokemon?, NoError>
}

final class PokemonService : PokemonServiceType {
    private let provider: ProviderType

    init(provider: ProviderType = Provider.sharedInstance) {
        self.provider = provider
    }

    func getPokemonPage(page: Int) -> SignalProducer<PokemonPage?, NoError> {
        return provider.request(.PokemonPage(page: page))
            .map(PokemonPage.decode)
            .map { $0.value }
            .flatMapError { error in
                assertionFailure("Error: \(error)")
                return SignalProducer<PokemonPage?, NoError>.empty
            }
    }

    func getPokemonByID(id: String) -> SignalProducer<Pokemon?, NoError> {
        return provider.request(.Pokemon(id: id))
            .retry(1)
            .map(Pokemon.decode)
            .map { $0.value }
            .flatMapError { error in
                assertionFailure("Error: \(error)")
                return SignalProducer<Pokemon?, NoError>.empty
        }
    }

}
