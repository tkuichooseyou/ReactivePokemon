import UIKit
import Moya
import Result
import ReactiveSwift
import ReactiveCocoa

final class PokemonListViewController: UIViewController {
    @IBOutlet private weak var collectionView: PokemonListCollectionView!
    @IBOutlet private weak var searchTextField: UITextField! {
        didSet {
//            let signal: Signal<String?, NoError> = searchTextField.reactive.continuousTextValues.throttle(0.5, on: QueueScheduler.main)
//            let (signal, observer) = Signal<String?, NoError>.pipe()
//            let disposable = collectionView.pokemonListViewModel.pokemonFilterName <~ signal

            let property = MutableProperty(0)
            let signal = Signal<Int, NoError>.pipe()
            signal <~ property
            property <~ signal
        }
    }
}
