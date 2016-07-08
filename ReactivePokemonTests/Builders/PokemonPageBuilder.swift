@testable import ReactivePokemon

final class PokemonPageBuilder {
    private var count: Int {
        return results.count
    }

    var previous: String?
    var next: String?
    var results: [PokemonPage.Pokemon] = [PokemonPagePokemonBuilder().build()]

    func build() -> PokemonPage {
        return PokemonPage(count: count, previous: previous, next: next, results: results)
    }
}

