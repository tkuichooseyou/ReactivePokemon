import UIKit
import Haneke

final class PokemonCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.hnk_cancelSetImage()
        imageView.image = ImagesCatalog.pokeballImage
    }
}

extension PokemonCell : UpdatableView {
    typealias ViewModel = PokemonCellViewModelType

    func update(viewModel viewModel: ViewModel) {
        tag = viewModel.pokemonID
        nameLabel.text = viewModel.nameText
        viewModel.imageURL.startWithNext { [weak self] in
            guard let url = $0 where self?.tag == viewModel.pokemonID else { return }
            self?.imageView?.hnk_setImageFromURL(url)
        }
    }
}

extension PokemonCell : NibLoadableCell {}
