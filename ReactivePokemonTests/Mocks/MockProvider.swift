import Moya
import ReactiveSwift
import Argo

@testable import ReactivePokemon

final class MockProvider: ProviderType {
    private let mockMoyaProvider = ReactiveCocoaMoyaProvider<PokeAPI>(stubClosure: MoyaProvider.ImmediatelyStub)

    func request(_ target: PokeAPI) -> SignalProducer<JSON, Moya.Error> {
        return mockMoyaProvider.request(token: target)
            .map { response in
                guard let j = try? JSONSerialization.jsonObject(with: response.data, options: []) else {
                    ErrorHandler.handleAssertionFailure("Bad JSON"); return JSON("Bad JSON")
                }
                return JSON(j)
        }
    }
}
