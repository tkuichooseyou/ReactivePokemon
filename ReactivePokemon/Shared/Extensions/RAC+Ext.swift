import ReactiveCocoa
import Result

extension UITextField {
    func getTextSignalProducer() -> SignalProducer<String, NoError> {
        return self.rac_textSignal()
            .toSignalProducer()
            .map { $0 as! String }
            .flatMapError { _ in SignalProducer<String, NoError>.empty }
    }
}
