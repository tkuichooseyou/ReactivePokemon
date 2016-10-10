import ReactiveSwift

protocol CollectionViewModel {
    associatedtype Cell : UpdatableView
    var cellUpdaters: MutableProperty<[CellUpdater<Cell>]> { get }
    func numberOfItemsInSection(_ section: Int) -> Int
}

extension CollectionViewModel {
    func numberOfItemsInSection(_ section: Int) -> Int {
        return cellUpdaters.value.count
    }
}
