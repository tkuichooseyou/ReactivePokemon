import Argo
import Curry
import Runes

struct PokemonPage {
    let count: Int
    let previous: String?
    let next: String?
    let results: [PokemonPage.Pokemon]
}

extension PokemonPage : Decodable {
    static func decode(_ j: JSON) -> Decoded<PokemonPage> {
        return curry(PokemonPage.init)
            <^> j <| "count"
            <*> j <|? "previous"
            <*> j <|? "next"
            <*> j <|| "results"
    }

    struct Pokemon : Decodable, Equatable {
        let url: String
        let name: String

        var id: String {
            guard let id = url.components(separatedBy: "/").dropLast().last else {
                ErrorHandler.handleAssertionFailure("Bad Pokemon url JSON: \(url)");
                return ""
            }
            return id
        }

        static func decode(_ j: JSON) -> Decoded<Pokemon> {
            return curry(Pokemon.init)
                <^> j <| "url"
                <*> j <| "name"
        }
    }
}

extension PokemonPage : Equatable {}

func ==(lhs: PokemonPage, rhs: PokemonPage) -> Bool {
    return (
        lhs.count == rhs.count &&
            lhs.previous == rhs.previous &&
            lhs.next == rhs.next &&
            lhs.results == rhs.results)
}

func ==(lhs: PokemonPage.Pokemon, rhs: PokemonPage.Pokemon) -> Bool {
    return lhs.url == rhs.url && lhs.name == rhs.name
}
