import Foundation
import Moya
import ReactiveSwift

private protocol ErrorHandlerType {
    func handleError(_ error: Swift.Error)
    func handleError(_ moyaError: Moya.Error, target: TargetType)
    func handleAssertionFailure(_ message: String)
    func log(_ message: String)
}

extension ErrorHandlerType {
    func handleError(_ moyaError: Moya.Error, target: TargetType) {
        switch moyaError {
        case let .imageMapping(response): log("Image mapping error: \(response.description)")
        case let .jsonMapping(response): log(response.description)
        case let .stringMapping(response): log(response.description)
        case .statusCode(let response):
            switch response.statusCode {
            case 408: log("Timeout: \(response.description)")
            default: log(response.description)
            }
        case let .data(response): log(response.description)
        case let .underlying(error):
            let error = error as NSError
            switch error.code {
            case NSURLErrorTimedOut, NSURLErrorNotConnectedToInternet: log("Timeout")
            default: log(error.debugDescription)
            }
        }
    }
}


class ErrorHandler {
    fileprivate static var sharedInstance: ErrorHandlerType = (DebugDetector.debuggerAttached() ? DebugErrorHandler() : ReleaseErrorHandler())

    static func handleError(_ error: Swift.Error) {
        sharedInstance.handleError(error)
    }

    static func handleError(_ moyaError: Moya.Error, target: TargetType) {
        sharedInstance.handleError(moyaError, target: target)
    }

    static func handleAssertionFailure(_ message: String) {
        sharedInstance.handleAssertionFailure(message)
    }
}

private class ReleaseErrorHandler : ErrorHandlerType {
    func handleError(_ error: Swift.Error) {
        let error = error as NSError
        log(error.description)
    }

    func handleAssertionFailure(_ message: String) {
        log(message)
    }

    func log(_ message: String) {
        // log
    }
}

private class DebugErrorHandler : ErrorHandlerType {
    fileprivate var debugAssertionFailure = false
    func handleError(_ error: Swift.Error) {
        switch error {
        default:
            let message = "Error: \(error)"
            showAlert(message)
        }
    }

    func handleAssertionFailure(_ message: String) {
        showAlert(message)
    }

    func log(_ message: String) {
        showAlert(message)
    }

    fileprivate func showAlert(_ message: String) {
        if debugAssertionFailure { assertionFailure(message) }
        guard let rootVC = (UIApplication.shared.delegate as! AppDelegate).rootViewController else { ErrorHandler.handleAssertionFailure("Missing RootViewController"); return }
        let substring = message.substring(to: message.index(message.startIndex, offsetBy: 500))
        UIAlertController.Alert(substring)
            .withOKAction(title: "Debug", handler: {_ in
                self.debugAssertionFailure = true
            })
            .withCancelButton("Ignore error", handler: {_ in
                self.debugAssertionFailure = false
            })
            .showFrom(rootVC)
    }
}
