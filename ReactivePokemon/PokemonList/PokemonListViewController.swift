import UIKit
import ReactiveCocoa
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

final class PokemonListCollectionView: UICollectionView {
    private let pokemonListViewModel: PokemonListViewModelType = PokemonListViewModel()
    private var disposable: Disposable?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }

    deinit {
        disposable?.dispose()
    }

    private func setup() {
        delegate = self
        dataSource = self
        register(PokemonCell)
        disposable = pokemonListViewModel.cellUpdaters.producer.startWithNext { [weak self] _ in
            self?.reloadData()
        }
    }
}

extension PokemonListCollectionView: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonListViewModel.numberOfItemsInSection(section)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellUpdater = pokemonListViewModel.cellUpdaters.value[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellUpdater.reuseIdentifier, forIndexPath: indexPath)
        cellUpdater.updateCell(cell)
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height/5)
    }
}

extension PokemonListCollectionView: UICollectionViewDelegate {
}
