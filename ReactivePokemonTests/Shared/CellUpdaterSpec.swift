import Quick
import Nimble
import UIKit
@testable import ReactivePokemon

class CellUpdaterSpec: QuickSpec {
    override func spec() {
        describe("CellUpdater") {
            describe("updateCell") {
                it("updates cell with view model") {
                    let testCell = TestCell()
                    let testCellVM = TestCellViewModel()
                    let cellUpdater = CellUpdater<TestCell>(viewModel: testCellVM)
                    cellUpdater.updateCell(testCell)

                    expect(testCell.updateReceivedArg!).to(equal(testCellVM))
                }
            }
        }
    }
}

class TestCell: UITableViewCell, UpdatableView {
    typealias ViewModel = TestCellViewModel
    var updateReceivedArg: TestCellViewModel?

    func update(viewModel: ViewModel) {
        updateReceivedArg = viewModel
    }
}

class TestCellViewModel: Equatable {}

func ==(lhs: TestCellViewModel, rhs: TestCellViewModel) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

struct TestCollectionViewModel {
    let cellUpdaters: [CellUpdaterType]

    init(cellUpdaters: [CellUpdaterType]) {
        self.cellUpdaters = cellUpdaters
    }

    init(cellUpdaterCount: Int) {
        let testCellVM = TestCellViewModel()
        let range = 1...cellUpdaterCount
        let cellUpdaters = range.map { (number: Int) -> CellUpdaterType in
            let cellUpdater: CellUpdaterType = CellUpdater<TestCell>(viewModel: testCellVM)
            return cellUpdater
        }
        self.cellUpdaters = cellUpdaters
    }
}
