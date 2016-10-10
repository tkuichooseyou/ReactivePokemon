import UIKit
import ReactiveSwift

final class PokemonListCollectionView: UICollectionView {
    let pokemonListViewModel = PokemonListViewModel()
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
        register(PokemonCell.self)
        disposable = pokemonListViewModel.cellUpdaters.producer
            .observe(on: UIScheduler())
            .startWithValues { [weak self] _ in
                self?.reloadData()
        }
    }
}

extension PokemonListCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonListViewModel.numberOfItemsInSection(section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellUpdater = pokemonListViewModel.cellUpdaters.value[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellUpdater.reuseIdentifier, for: indexPath as IndexPath)
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
