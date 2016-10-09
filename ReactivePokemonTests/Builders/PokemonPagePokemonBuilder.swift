@testable import ReactivePokemon

final class PokemonPagePokemonBuilder {
    var url: String = "http://pokeapi.co/api/v2/pokemon/1/"
    var name: String = "bulbasaur"

    func withURL(_ url: String) -> PokemonPagePokemonBuilder {
        self.url = url
        return self
    }

    func withName(_ name: String) -> PokemonPagePokemonBuilder {
        self.name = name
        return self
    }

    func build() -> PokemonPage.Pokemon {
        return PokemonPage.Pokemon(url: url, name: name)
    }
}

