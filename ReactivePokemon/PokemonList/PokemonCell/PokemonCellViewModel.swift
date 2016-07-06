import UIKit
import ReactiveCocoa
import Result

protocol PokemonCellViewModelType {
    var imageURL: SignalProducer<NSURL?, NoError> { get }
    var nameText: String { get }
}

struct PokemonCellViewModel : PokemonCellViewModelType {
    let pokemonService: PokemonService
    let pokemonPagePokemon: PokemonPage.Pokemon
    let pokemon = MutableProperty<Pokemon?>(nil)

    init(pokemonPagePokemon: PokemonPage.Pokemon, pokemonService: PokemonService = PokemonService()) {
        self.pokemonService = pokemonService
        self.pokemonPagePokemon = pokemonPagePokemon
        pokemon <~ pokemonService.getPokemonByID(pokemonPagePokemon.id)
    }

    var imageURL: SignalProducer<NSURL?, NoError> {
        return pokemon.producer.map { pokemon in
            guard let pokemon = pokemon else { return nil }
            guard let string = pokemon.sprites.first?.front_default else { return nil }
            return NSURL(string: string)
        }
    }

    var nameText: String {
        return pokemonPagePokemon.name
    }
}
