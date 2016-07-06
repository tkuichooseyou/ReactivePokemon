import Moya
import ReactiveCocoa
import Result
import Argo

final class PokemonService {
    private let provider: ProviderType

    init(provider: ProviderType = Provider.sharedInstance) {
        self.provider = provider
    }

    func getPokemonList() -> SignalProducer<[Pokemon], NoError> {
        return provider.request(.PokemonList)
            .map { (json: JSON) -> [Decoded<Pokemon>] in
                switch json {
                case .Array(let array):
                    return array.map(Pokemon.decode)
                default:
                    return []
                }
            }.map { $0.flatMap { $0.value } }
            .flatMapError { _ in
                assertionFailure()
                return SignalProducer<[Pokemon], NoError>.empty
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
