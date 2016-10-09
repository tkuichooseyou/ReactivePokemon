import ReactiveSwift
import enum Result.NoError
import UIKit

extension UITextField {
    public var rac_textSignal: SignalProducer<String, NoError> {
        return NotificationCenter.default
            .reactive.notifications(forName: .UITextViewTextDidChange, object: self)
            .map { notification in
                (notification.object as! UITextField).text ?? ""
        }
    }
}
