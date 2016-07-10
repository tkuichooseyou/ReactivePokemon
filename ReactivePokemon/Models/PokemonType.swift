import Argo
import Curry

struct PokemonType {
    let slot: Int
    let type: Type
}

struct Type {
    let url: String
    let name: String

    var id: String {
        guard let result = url.characters.split("/").map(String.init).last else {
            ErrorHandler.handleAssertionFailure("Pokemon type ID missing for url: \(url)")
            return ""
        }
        return result
    }
}

extension PokemonType : Decodable {
    static func decode(j: JSON) -> Decoded<PokemonType> {
        return curry(PokemonType.init)
            <^> j <| "slot"
            <*> j <| "type"
    }
}

extension Type : Decodable {
    static func decode(j: JSON) -> Decoded<Type> {
        return curry(Type.init)
            <^> j <| "url"
            <*> j <| "name"
    }
}

extension PokemonType : Equatable {}

func ==(lhs: PokemonType, rhs: PokemonType) -> Bool {
    return lhs.slot == rhs.slot && lhs.type == rhs.type
}

extension Type : Equatable {}

func ==(lhs: Type, rhs: Type) -> Bool {
    return lhs.url == rhs.url && lhs.name == rhs.name
}
