import Moya

private let pageLimit = 100

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
            return NSData()
        case .Pokemon:
            return NSData()
        case .Type:
            return NSData()
        }
    }
}
