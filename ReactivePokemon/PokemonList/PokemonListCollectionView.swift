import UIKit
import ReactiveCocoa

final class PokemonListCollectionView: UICollectionView {
    let pokemonListViewModel: PokemonListViewModelType = PokemonListViewModel()
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
        disposable = pokemonListViewModel.cellUpdaters.producer
            .observeOn(UIScheduler())
            .startWithNext { [weak self] _ in
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
        let width = collectionView.frame.width - 20
        let height = collectionView.frame.height
        return CGSize(width: width, height: height/8)
    }
}

extension PokemonListCollectionView: UICollectionViewDelegate {
}
