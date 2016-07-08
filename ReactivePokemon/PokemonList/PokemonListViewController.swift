import UIKit
import Moya
import Result

final class PokemonListViewController: UIViewController {
    @IBOutlet private weak var collectionView: PokemonListCollectionView!
    @IBOutlet private weak var searchTextField: UITextField! {
        didSet {
//            searchTextField.rac_textSignal().toSignalProducer()
//                .map { $0 as! String }
//                .flatMapError { _ in return SignalProducer<String, NoError>.empty }
//                .throttle(0.5, onScheduler: QueueScheduler())
//                .flatMap(.Latest, transform: pokemonService.getPokemonByID)
//                .map(pokemonDescription)
//                .observeOn(UIScheduler())
//                .startWithNext(updateTextView)
        }
    }

    private func pokemonDescription(pokemon: Pokemon?) -> String {
        guard let pokemon = pokemon else { return "Pokemon not found" }
        return "ID: \(pokemon.id) \n" +
        "Name: \(pokemon.name) \n" +
        "Types: \(pokemon.types.map {$0.type.name}) \n"
    }
}

