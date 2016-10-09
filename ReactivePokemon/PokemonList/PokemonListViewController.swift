import UIKit
import Moya
import Result
import ReactiveSwift

final class PokemonListViewController: UIViewController {
    @IBOutlet private weak var collectionView: PokemonListCollectionView!
    @IBOutlet private weak var searchTextField: UITextField! {
        didSet {
            collectionView.pokemonListViewModel.pokemonFilterName <~ searchTextField
                .rac_textSignal
                .throttle(0.5, on: QueueScheduler())
        }
    }
}

