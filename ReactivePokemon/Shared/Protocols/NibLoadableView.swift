import Foundation
import UIKit

protocol NibLoadableCell: class {
    static var nibName: String { get }
}

extension NibLoadableCell where Self: UIView {
    static var nibName: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}
