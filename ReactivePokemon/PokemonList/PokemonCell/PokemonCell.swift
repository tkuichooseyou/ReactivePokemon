import UIKit
import Haneke

final class PokemonCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.hnk_cancelSetImage()
        imageView.image = ImagesCatalog.pokeballImage
    }
}

extension PokemonCell : UpdatableView {
    typealias ViewModel = PokemonCellViewModelType

    func update(viewModel: ViewModel) {
        tag = viewModel.pokemonID
        nameLabel.text = viewModel.nameText
        viewModel.imageURL.startWithValues { [weak self] in
            guard let url = $0 , self?.tag == viewModel.pokemonID else { return }
            self?.imageView?.hnk_setImageFromURL(url)
        }
    }
}

extension PokemonCell : NibLoadableCell {}
