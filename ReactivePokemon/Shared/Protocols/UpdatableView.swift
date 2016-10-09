import Foundation
import UIKit

protocol UpdatableView: class {
    associatedtype ViewModel

    func update(viewModel: ViewModel)
}
