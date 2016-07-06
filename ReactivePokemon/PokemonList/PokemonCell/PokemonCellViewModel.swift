import UIKit

protocol PokemonCellViewModelType {
    var imageURL: NSURL? { get }
    var nameText: String { get }
}

struct PokemonCellViewModel : PokemonCellViewModelType {
    let pokemon: Pokemon

    var imageURL: NSURL? {
        guard let string = pokemon.sprites.first?.front_default else { return nil }
        return NSURL(string: string)
    }

    var nameText: String {
        return pokemon.name
    }
}
