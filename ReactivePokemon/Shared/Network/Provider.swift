import Moya
import ReactiveCocoa
import Argo
import Haneke

protocol ProviderType {
    func request(target: PokeAPI) -> SignalProducer<Argo.JSON, Error>
}

struct Provider : ProviderType {
    let cache = Cache<Argo.JSON>(name: "github")

    static let sharedInstance = Provider()
    private static var reactiveCocoaMoyaProvider: ReactiveCocoaMoyaProvider<PokeAPI> = ReactiveCocoaMoyaProvider()

    func request(target: PokeAPI) -> SignalProducer<Argo.JSON, Error> {
        return SignalProducer { observer, disposable in
            self.cache.fetch(key: target.fullURLString)
                .onSuccess { json in
                    observer.sendNext(json)
                }.onFailure { _ in
                    Provider.reactiveCocoaMoyaProvider.request(target)
                        .map { response in
                            guard let j = try? NSJSONSerialization.JSONObjectWithData(response.data, options: []) else {
                                ErrorHandler.handleAssertionFailure("Bad JSON for request target: \(target)")
                            }
                            observer.sendNext(Argo.JSON(j))
                    }

            }
        }
    }
}
