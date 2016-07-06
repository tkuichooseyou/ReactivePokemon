import Foundation
import UIKit

protocol CellUpdaterType {
    var reuseIdentifier: String { get }
    var cellClass: AnyClass { get }

    func updateCell(cell: UICollectionViewCell)
    func updateCell(cell: UITableViewCell)
}

struct CellUpdater<Cell where Cell: UpdatableView> : CellUpdaterType {
    let viewModel: Cell.ViewModel
    let reuseIdentifier = String(Cell)
    let cellClass: AnyClass = Cell.self

    func updateCell(cell: UICollectionViewCell) {
        (cell as? Cell)?.update(viewModel: viewModel)
    }

    func updateCell(cell: UITableViewCell) {
        (cell as? Cell)?.update(viewModel: viewModel)
    }
}

