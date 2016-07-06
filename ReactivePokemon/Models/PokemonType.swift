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
            assertionFailure("Pokemon type ID missing")
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

