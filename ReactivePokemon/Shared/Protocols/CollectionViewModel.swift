import ReactiveSwift

protocol CollectionViewModel {
    var cellUpdaters: MutableProperty<[CellUpdaterType]> { get }
    func numberOfItemsInSection(_ section: Int) -> Int
}

extension CollectionViewModel {
    func numberOfItemsInSection(_ section: Int) -> Int {
        return cellUpdaters.value.count
    }
}
