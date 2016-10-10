import UIKit
import ReactiveSwift
import Result

protocol PokemonCellViewModelType {
    var imageURL: SignalProducer<URL?, NoError> { get }
    var nameText: String { get }
    var pokemonID: Int { get }
    func start()
}

final class PokemonCellViewModel : PokemonCellViewModelType {
    private let pokemonService: PokemonService
    private let pokemon = MutableProperty<Pokemon?>(nil)
    fileprivate let pokemonPagePokemon: PokemonPage.Pokemon
    var pokemonID: Int { return Int(pokemonPagePokemon.id)! }

    init(pokemonPagePokemon: PokemonPage.Pokemon, pokemonService: PokemonService = PokemonService()) {
        self.pokemonService = pokemonService
        self.pokemonPagePokemon = pokemonPagePokemon
    }

    var imageURL: SignalProducer<URL?, NoError> {
        return pokemon.producer.map { pokemon in
            guard let pokemon = pokemon else { return nil }
            let string = pokemon.sprites.front_default
            return URL(string: string)
        }
    }

    var nameText: String {
        return pokemonPagePokemon.name
    }

    func start() {
        let pokemonSignal = pokemonService.getPokemonByID(pokemonPagePokemon.id)
        pokemon <~ pokemonSignal
        pokemonSignal.start()
    }
}

extension PokemonCellViewModel : Equatable {}

func ==(lhs: PokemonCellViewModel, rhs: PokemonCellViewModel) -> Bool {
    return lhs.pokemonPagePokemon == rhs.pokemonPagePokemon
}
