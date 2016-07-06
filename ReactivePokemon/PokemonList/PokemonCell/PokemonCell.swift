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

        viewModel.imageURL.startWithNext { [weak imageView] in
            guard let url = $0 else { return }
            imageView?.hnk_setImageFromURL(url)
        }
        nameLabel.text = viewModel.nameText
    }
}

extension PokemonCell : NibLoadableCell {}
