import Argo
import Curry

struct PokemonSprite {
    let front_default: String
}

extension PokemonSprite : Decodable {
    static func decode(j: JSON) -> Decoded<PokemonSprite> {
        return curry(PokemonSprite.init)
            <^> j <| "front_default"
    }
}