import Argo
import Curry

struct Pokemon {
    let id: Int
    let name: String
    let types: [PokemonType]
    let sprites: [PokemonSprite]
}

extension Pokemon : Decodable {
    static func decode(j: JSON) -> Decoded<Pokemon> {
        return curry(Pokemon.init)
            <^> j <| "id"
            <*> j <| "name"
            <*> j <|| "types"
            <*> j <|| "sprites"
    }
}

