import Moya
import ReactiveCocoa
import Argo

protocol ProviderType {
    func request(target: PokeAPI) -> SignalProducer<JSON, Error>
}

struct Provider : ProviderType {
    static let sharedInstance = Provider()
    private static var reactiveCocoaMoyaProvider: ReactiveCocoaMoyaProvider<PokeAPI> = ReactiveCocoaMoyaProvider()

    func request(target: PokeAPI) -> SignalProducer<JSON, Error> {
        return Provider.reactiveCocoaMoyaProvider.request(target)
            .map { response in
                guard let j = try? NSJSONSerialization.JSONObjectWithData(response.data, options: []) else {
                    ErrorHandler.handleAssertionFailure("Bad JSON for request target: \(target)"); return JSON("Bad JSON")
                }
                return JSON(j)
        }
    }
}
