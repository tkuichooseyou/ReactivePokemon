import UIKit
import ReactiveCocoa
import Result

protocol PokemonCellViewModelType {
    var imageURL: SignalProducer<NSURL?, NoError> { get }
    var nameText: String { get }
    var pokemonID: Int { get }
}

struct PokemonCellViewModel : PokemonCellViewModelType {
    private let pokemonService: PokemonService
    private let pokemon = MutableProperty<Pokemon?>(nil)
    private let pokemonPagePokemon: PokemonPage.Pokemon
    var pokemonID: Int { return Int(pokemonPagePokemon.id)! }

    init(pokemonPagePokemon: PokemonPage.Pokemon, pokemonService: PokemonService = PokemonService()) {
        self.pokemonService = pokemonService
        self.pokemonPagePokemon = pokemonPagePokemon
        let pokemonSignal = pokemonService.getPokemonByID(pokemonPagePokemon.id)
        pokemon <~ pokemonSignal
        pokemonSignal.start()
    }

    var imageURL: SignalProducer<NSURL?, NoError> {
        return pokemon.producer.map { pokemon in
            guard let pokemon = pokemon else { return nil }
            let string = pokemon.sprites.front_default
            return NSURL(string: string)
        }
    }

    var nameText: String {
        return pokemonPagePokemon.name
    }
}

extension PokemonCellViewModel : Equatable {}

func ==(lhs: PokemonCellViewModel, rhs: PokemonCellViewModel) -> Bool {
    return lhs.pokemonPagePokemon == rhs.pokemonPagePokemon
}
