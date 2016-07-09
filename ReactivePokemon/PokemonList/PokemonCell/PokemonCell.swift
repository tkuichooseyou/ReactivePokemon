import UIKit
import Haneke

final class PokemonCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
}

extension PokemonCell : UpdatableView {
    typealias ViewModel = PokemonCellViewModelType

    func update(viewModel viewModel: ViewModel) {
        imageView.image = ImagesCatalog.pokeballImage

        tag = viewModel.index
        viewModel.imageURL.startWithNext { [weak self] in
            guard let url = $0 where
            self?.tag == viewModel.index else { return }
            self?.imageView?.hnk_setImageFromURL(url)
        }
        nameLabel.text = viewModel.nameText
    }
}

extension PokemonCell : NibLoadableCell {}
