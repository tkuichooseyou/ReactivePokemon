@testable import ReactivePokemon

final class PokemonPagePokemonBuilder {
    var url: String = "http://pokeapi.co/api/v2/pokemon/1/"
    var name: String = "bulbasaur"

    func build() -> PokemonPage.Pokemon {
        return PokemonPage.Pokemon(url: url, name: name)
    }
}

