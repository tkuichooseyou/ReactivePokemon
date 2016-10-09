import Foundation
import UIKit

protocol CellUpdaterType {
    var reuseIdentifier: String { get }

    func updateCell(_ cell: UICollectionViewCell)
    func updateCell(_ cell: UITableViewCell)
}

struct CellUpdater<Cell> : CellUpdaterType where Cell: UpdatableView {
    let viewModel: Cell.ViewModel
    let reuseIdentifier = String(describing: Cell.self)

    func updateCell(_ cell: UICollectionViewCell) {
        (cell as? Cell)?.update(viewModel: viewModel)
    }

    func updateCell(_ cell: UITableViewCell) {
        (cell as? Cell)?.update(viewModel: viewModel)
    }
}

