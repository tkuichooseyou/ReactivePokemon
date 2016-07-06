import UIKit

final class PokemonCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
}

extension PokemonCell : UpdatableView {
    typealias ViewModel = PokemonCellViewModelType

    func update(viewModel viewModel: ViewModel) {
        imageView.image = ImagesCatalog.pokeballImage

//        viewModel.imageURL.flatMap { imageView.hnk_setImageFromURL($0) }
        nameLabel.text = viewModel.nameText
    }
}

extension PokemonCell : NibLoadableCell {}
