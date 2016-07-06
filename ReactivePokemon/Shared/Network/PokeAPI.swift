import Moya

enum PokeAPI {
    case PokemonList
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
        case .PokemonList: return "/pokemon"
        case .Pokemon(let id): return "/pokemon/\(id)"
        case .Type(let id): return "/type/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .PokemonList, .Pokemon, .Type: return .GET
        }
    }

    var parameters: [String: AnyObject]? {
        switch self {
        case .PokemonList, .Pokemon, .Type: return nil
        }
    }

    var sampleData: NSData {
        switch self {
        case .PokemonList:
            return NSData()
        case .Pokemon:
            return NSData()
        case .Type:
            return NSData()
        }
    }
}
