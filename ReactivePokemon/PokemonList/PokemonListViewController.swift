import UIKit
import ReactiveCocoa
import Moya
import Result

final class PokemonListViewController: UIViewController {
    private let pokemonService = PokemonService()
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var searchTextField: UITextField! {
        didSet {
            searchTextField.rac_textSignal().toSignalProducer()
                .map { $0 as! String }
                .flatMapError { _ in return SignalProducer<String, NoError>.empty }
                .throttle(0.5, onScheduler: QueueScheduler())
                .flatMap(.Latest, transform: pokemonService.getPokemonByID)
                .map(pokemonDescription)
                .observeOn(UIScheduler())
                .startWithNext(updateTextView)
        }
    }

    private func updateTextView(string: String) {
        textView.text = string
    }

    private func pokemonDescription(pokemon: Pokemon?) -> String {
        guard let pokemon = pokemon else { return "Pokemon not found" }
        return "ID: \(pokemon.id) \n" +
        "Name: \(pokemon.name) \n" +
        "Types: \(pokemon.types.map {$0.type.name}) \n"
    }
}

