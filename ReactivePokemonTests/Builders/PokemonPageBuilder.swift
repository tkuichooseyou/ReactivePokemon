@testable import ReactivePokemon

final class PokemonPageBuilder {
    private var count: Int {
        return results.count
    }

    var previous: String?
    var next: String?
    var results: [PokemonPage.Pokemon] = [PokemonPagePokemonBuilder().build()]

    func withPrevious(_ previous: String?) -> PokemonPageBuilder {
        self.previous = previous
        return self
    }

    func withNext(_ next: String?) -> PokemonPageBuilder {
        self.next = next
        return self
    }

    func withResults(_ results: [PokemonPage.Pokemon]) -> PokemonPageBuilder {
        self.results = results
        return self
    }

    func build() -> PokemonPage {
        return PokemonPage(count: count, previous: previous, next: next, results: results)
    }
}

