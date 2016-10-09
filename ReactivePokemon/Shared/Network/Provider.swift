import Moya
import ReactiveSwift
import Argo

protocol ProviderType {
    func request(_ target: PokeAPI) -> SignalProducer<JSON, Moya.Error>
}

struct Provider : ProviderType {
    static let sharedInstance = Provider()
    private static var reactiveCocoaMoyaProvider: ReactiveCocoaMoyaProvider<PokeAPI> = ReactiveCocoaMoyaProvider()

    func request(_ target: PokeAPI) -> SignalProducer<JSON, Moya.Error> {
        return Provider.reactiveCocoaMoyaProvider
            .request(token: target)
            .map { response in
                guard let j = try? JSONSerialization.jsonObject(with: response.data, options: []) else {
                    ErrorHandler.handleAssertionFailure("Bad JSON for request target: \(target)"); return JSON("Bad JSON")
                }
                return JSON(j)
        }
    }
}
