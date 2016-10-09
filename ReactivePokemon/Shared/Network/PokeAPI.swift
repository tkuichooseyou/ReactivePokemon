import Moya

private let pageLimit = 100

enum PokeAPI {
    case pokemonPage(page: Int)
    case pokemon(id: String)
    case type(id: String)

    var base: String {
        return "http://pokeapi.co/api/v2"
    }
}

extension PokeAPI : TargetType {
    var baseURL: URL { return URL(string: base)! }

    var path: String {
        switch self {
        case .pokemonPage: return "/pokemon"
        case .pokemon(let id): return "/pokemon/\(id)"
        case .type(let id): return "/type/\(id)"
        }
    }

    var task: Task {
        switch self {
        case .pokemonPage: return .request
        case .pokemon: return .request
        case .type: return .request
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .pokemonPage, .pokemon, .type: return .GET
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .pokemon, .type: return nil
        case .pokemonPage(let page):
            return [
                "limit": String(pageLimit) as AnyObject,
                "offset": String(pageLimit*page) as AnyObject,
            ]
        }
    }

    var sampleData: Data {
        switch self {
        case .pokemonPage:
            return PokeAPI.stubbedResponse("pokemonPage0")
        case .pokemon:
            return PokeAPI.stubbedResponse("pokemon1")
        case .type:
            return PokeAPI.stubbedResponse("type1")
        }
    }

    private static func stubbedResponse(_ filename: String, bundle: Bundle? = nil) -> Data! {
        class TestClass: NSObject { }

        let bundle = bundle ?? Bundle(for: TestClass.self)
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {return nil}
        return try! Data(contentsOf: path)
    }
}
