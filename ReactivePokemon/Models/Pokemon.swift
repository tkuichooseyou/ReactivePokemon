import Argo
import Curry
import Runes

struct Pokemon {
    let id: Int
    let name: String
    let types: [PokemonType]
    let sprites: PokemonSprites
}

extension Pokemon : Decodable {
    static func decode(_ j: JSON) -> Decoded<Pokemon> {
        return curry(Pokemon.init)
            <^> j <| "id"
            <*> j <| "name"
            <*> j <|| "types"
            <*> j <| "sprites"
    }
}

extension Pokemon : Equatable {}

func ==(lhs: Pokemon, rhs: Pokemon) -> Bool {
    return (
        lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.types == rhs.types &&
            lhs.sprites == rhs.sprites)
}
