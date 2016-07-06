import ReactiveCocoa

protocol CollectionViewModel {
    var cellUpdaters: MutableProperty<[CellUpdaterType]> { get }
    func numberOfItemsInSection(section: Int) -> Int
}

extension CollectionViewModel {
    func numberOfItemsInSection(section: Int) -> Int {
        return cellUpdaters.value.count
    }
}