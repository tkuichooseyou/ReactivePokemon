import Moya
import ReactiveSwift
import Result
import Argo

protocol PokemonServiceType {
    func getPokemonPage(_ page: Int) -> SignalProducer<PokemonPage?, NoError>
    func getPokemonByID(_ id: String) -> SignalProducer<Pokemon?, NoError>
}

final class PokemonService : PokemonServiceType {
    private let provider: ProviderType

    init(provider: ProviderType = Provider.sharedInstance) {
        self.provider = provider
    }

    func getPokemonPage(_ page: Int) -> SignalProducer<PokemonPage?, NoError> {
        return provider.request(.pokemonPage(page: page))
            .map(PokemonPage.decode)
            .map { $0.value }
            .flatMapError { error in
                ErrorHandler.handleError(error)
                return SignalProducer<PokemonPage?, NoError>.empty
            }
    }

    func getPokemonByID(_ id: String) -> SignalProducer<Pokemon?, NoError> {
        return provider.request(.pokemon(id: id))
            .retry(upTo: 1)
            .map(Pokemon.decode)
            .map { $0.value }
            .flatMapError { error in
                ErrorHandler.handleError(error)
                return SignalProducer<Pokemon?, NoError>.empty
        }
    }

}
