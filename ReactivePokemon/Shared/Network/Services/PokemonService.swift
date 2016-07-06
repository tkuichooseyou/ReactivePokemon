import Moya
import ReactiveCocoa
import Result
import Argo

final class PokemonService {
    private let provider: ProviderType

    init(provider: ProviderType = Provider.sharedInstance) {
        self.provider = provider
    }

    func getPokemonPage(page: Int) -> SignalProducer<PokemonPage?, NoError> {
        return provider.request(.PokemonPage(page: page))
            .map(PokemonPage.decode)
            .map { $0.value }
            .flatMapError { _ in
                assertionFailure()
                return SignalProducer<PokemonPage?, NoError>.empty
            }
    }

    func getPokemonByID(id: String) -> SignalProducer<Pokemon?, NoError> {
        return provider.request(.Pokemon(id: id))
            .map(Pokemon.decode)
            .map { $0.value }
            .flatMapError { _ in
                assertionFailure()
                return SignalProducer<Pokemon?, NoError>.empty
        }
    }

}
