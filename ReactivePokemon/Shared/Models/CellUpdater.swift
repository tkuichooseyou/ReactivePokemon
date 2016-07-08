import Foundation
import UIKit

protocol CellUpdaterType {
    var reuseIdentifier: String { get }

    func updateCell(cell: UICollectionViewCell)
    func updateCell(cell: UITableViewCell)
}

struct CellUpdater<Cell where Cell: UpdatableView> : CellUpdaterType {
    let viewModel: Cell.ViewModel
    let reuseIdentifier = String(Cell)

    func updateCell(cell: UICollectionViewCell) {
        (cell as? Cell)?.update(viewModel: viewModel)
    }

    func updateCell(cell: UITableViewCell) {
        (cell as? Cell)?.update(viewModel: viewModel)
    }
}

