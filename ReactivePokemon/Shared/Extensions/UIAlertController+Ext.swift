import UIKit

extension UIAlertController {
    static func ErrorAlert(_ message: String, apiStatusCode: String?) -> UIAlertController {
        let alertController = UIAlertController(title: message, message: apiStatusCode, preferredStyle: .alert)
        return alertController
    }

    static func Alert(_ message: String) -> UIAlertController {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        return alertController
    }

    static func Alert(_ title:String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alertController
    }

    func withOKAction(style: UIAlertActionStyle = .default, title: String = "OK", handler:@escaping (UIAlertAction) -> Void) -> UIAlertController {
        let OKAction = UIAlertAction(title: title, style: style) { (action) in  handler(action) }
        self.addAction(OKAction)
        return self
    }

    func withCancelButton(_ title: String, handler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let cancelAction = UIAlertAction(title: title, style: .cancel) { (action) in handler(action) }
        self.addAction(cancelAction)
        return self
    }

    func showFrom(_ viewController: UIViewController){
        viewController.present(self, animated: true, completion: nil)
    }
}
