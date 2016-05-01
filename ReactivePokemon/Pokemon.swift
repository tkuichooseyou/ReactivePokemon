import Argo
import Curry

struct Pokemon {
    let id: Int
    let name: String
    let types: [PokemonType]
}

struct PokemonType {
    let slot: Int
    let type: Type
}

struct Type {
    let url: String
    let name: String
}

extension Pokemon : Decodable {
    static func decode(j: JSON) -> Decoded<Pokemon> {
        return curry(Pokemon.init)
            <^> j <| "id"
            <*> j <| "name"
            <*> j <|| "types"
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

