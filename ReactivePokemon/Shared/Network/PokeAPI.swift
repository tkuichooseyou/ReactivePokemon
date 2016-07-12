import Moya

private let pageLimit = 151

enum PokeAPI {
    case PokemonPage(page: Int)
    case Pokemon(id: String)
    case Type(id: String)

    var base: String {
        return "http://pokeapi.co/api/v2"
    }
}

extension PokeAPI : TargetType {
    var baseURL: NSURL { return NSURL(string: base)! }

    var path: String {
        switch self {
        case .PokemonPage: return "/pokemon"
        case .Pokemon(let id): return "/pokemon/\(id)"
        case .Type(let id): return "/type/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .PokemonPage, .Pokemon, .Type: return .GET
        }
    }

    var parameters: [String: AnyObject]? {
        switch self {
        case .Pokemon, .Type: return nil
        case .PokemonPage(let page):
            return [
                "limit": String(pageLimit),
                "offset": String(pageLimit*page),
            ]
        }
    }

    var sampleData: NSData {
        switch self {
        case .PokemonPage:
            return PokeAPI.stubbedResponse("pokemonPage0")
        case .Pokemon:
            return PokeAPI.stubbedResponse("pokemon1")
        case .Type:
            return PokeAPI.stubbedResponse("type1")
        }
    }

    private static func stubbedResponse(filename: String, bundle: NSBundle? = nil) -> NSData! {
        @objc class TestClass: NSObject { }

        let bundle = bundle ?? NSBundle(forClass: TestClass.self)
        guard let path = bundle.pathForResource(filename, ofType: "json") else {return nil}
        return NSData(contentsOfFile: path)
    }
}
