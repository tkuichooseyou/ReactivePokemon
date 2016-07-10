import UIKit
import Moya
import Result
import ReactiveCocoa

final class PokemonListViewController: UIViewController {
    @IBOutlet private weak var collectionView: PokemonListCollectionView!
    @IBOutlet private weak var searchTextField: UITextField! {
        didSet {
            collectionView.pokemonListViewModel.pokemonFilterName <~ searchTextField
                .getTextSignalProducer()
                .throttle(0.5, onScheduler: QueueScheduler())
        }
    }
}

