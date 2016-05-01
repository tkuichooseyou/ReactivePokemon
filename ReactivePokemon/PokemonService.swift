import Moya
import ReactiveCocoa
import Result

final class PokemonService {
    private let provider: ProviderType

    init(provider: ProviderType = Provider.sharedInstance) {
        self.provider = provider
    }

    func getPokemonByID(id: String) -> SignalProducer<Pokemon?, NoError> {
        return provider.request(.Pokemon(id: id))
            .map(Pokemon.decode)
            .map { $0.value }
            .flatMapError { _ in return SignalProducer<Pokemon?, NoError>.empty }
    }
}
