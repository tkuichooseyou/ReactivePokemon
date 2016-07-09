import UIKit

extension UIAlertController {
    static func ErrorAlert(message: String, apiStatusCode: String?) -> UIAlertController {
        let alertController = UIAlertController(title: message, message: apiStatusCode, preferredStyle: .Alert)
        return alertController
    }

    static func Alert(message: String) -> UIAlertController {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .Alert)
        return alertController
    }

    static func Alert(title:String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        return alertController
    }

    func withOKAction(style style: UIAlertActionStyle = .Default, title: String = "OK", handler:(UIAlertAction) -> Void) -> UIAlertController {
        let OKAction = UIAlertAction(title: title, style: style) { (action) in  handler(action) }
        self.addAction(OKAction)
        return self
    }

    func withCancelButton(title: String, handler: (UIAlertAction) -> Void) -> UIAlertController {
        let cancelAction = UIAlertAction(title: title, style: .Cancel) { (action) in handler(action) }
        self.addAction(cancelAction)
        return self
    }

    func showFrom(viewController: UIViewController){
        viewController.presentViewController(self, animated: true, completion: nil)
    }
}
