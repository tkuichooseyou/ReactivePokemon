import Argo
import Curry

struct PokemonSprites {
    let front_default: String
}

extension PokemonSprites : Decodable {
    static func decode(j: JSON) -> Decoded<PokemonSprites> {
        return curry(PokemonSprites.init)
            <^> j <| "front_default"
    }
}

extension PokemonSprites : Equatable {}

func ==(lhs: PokemonSprites, rhs: PokemonSprites) -> Bool {
    return lhs.front_default == rhs.front_default
}
