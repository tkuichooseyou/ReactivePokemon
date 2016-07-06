import Argo
import Curry

struct PokemonPage {
    let count: Int
    let previous: String
    let next: String
    let results: [PokemonPage.Pokemon]
}

extension PokemonPage : Decodable {
    static func decode(j: JSON) -> Decoded<PokemonPage> {
        return curry(PokemonPage.init)
            <^> j <| "count"
            <*> j <| "previous"
            <*> j <| "next"
            <*> j <|| "results"
    }

    struct Pokemon : Decodable {
        let url: String
        let name: String

        var id: String {
            guard let id = url.componentsSeparatedByString("/").dropLast().last else {
                assertionFailure()
                return ""
            }
            return id
        }


        static func decode(j: JSON) -> Decoded<Pokemon> {
            return curry(Pokemon.init)
                <^> j <| "url"
                <*> j <| "name"
        }
    }
}

