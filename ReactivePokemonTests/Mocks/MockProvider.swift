import Moya
import ReactiveCocoa
import Argo

@testable import ReactivePokemon

final class MockProvider: ProviderType {
    private let mockMoyaProvider = ReactiveCocoaMoyaProvider<PokeAPI>(stubClosure: MoyaProvider.ImmediatelyStub)

    func request(target: PokeAPI) -> SignalProducer<JSON, Error> {
        return mockMoyaProvider.request(target)
            .map { response in
                guard let j = try? NSJSONSerialization.JSONObjectWithData(response.data, options: []) else {
                    assertionFailure("Bad JSON"); return JSON("Bad JSON")
                }
                return JSON(j)
        }
    }
}
