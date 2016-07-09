import Foundation
import Moya
import ReactiveCocoa

private protocol ErrorHandlerType {
    func handleError(error: ErrorType)
    func handleError(moyaError: Moya.Error, target: TargetType)
    func handleAssertionFailure(message: String)
    func log(message: String)
}

extension ErrorHandlerType {
    func handleError(moyaError: Moya.Error, target: TargetType) {
        switch moyaError {
        case let .ImageMapping(response): log("Image mapping error: \(response.description)")
        case let .JSONMapping(response): log(response.description)
        case let .StringMapping(response): log(response.description)
        case .StatusCode(let response):
            switch response.statusCode {
            case 408: log("Timeout: \(response.description)")
            default: log(response.description)
            }
        case let .Data(response): log(response.description)
        case let .Underlying(error):
            let error = error as NSError
            switch error.code {
            case NSURLErrorTimedOut, NSURLErrorNotConnectedToInternet: log("Timeout")
            default: log(error.debugDescription)
            }
        }
    }
}


class ErrorHandler {
    private static var sharedInstance: ErrorHandlerType = (DebugDetector.debuggerAttached() ? DebugErrorHandler() : ReleaseErrorHandler())

    static func handleError(error: ErrorType) {
        sharedInstance.handleError(error)
    }

    static func handleError(moyaError: Moya.Error, target: TargetType) {
        sharedInstance.handleError(moyaError, target: target)
    }

    static func handleAssertionFailure(message: String) {
        sharedInstance.handleAssertionFailure(message)
    }
}

private class ReleaseErrorHandler : ErrorHandlerType {
    func handleError(error: ErrorType) {
        let error = error as NSError
        log(error.description)
    }

    func handleAssertionFailure(message: String) {
        log(message)
    }

    func log(message: String) {
        // log
    }
}

private class DebugErrorHandler : ErrorHandlerType {
    private var debugAssertionFailure = false
    func handleError(error: ErrorType) {
        switch error {
        default:
            let message = "Error: \(error)"
            showAlert(message)
        }
    }

    func handleAssertionFailure(message: String) {
        showAlert(message)
    }

    func log(message: String) {
        showAlert(message)
    }

    private func showAlert(message: String) {
        if debugAssertionFailure { assertionFailure(message) }
        guard let rootVC = (UIApplication.sharedApplication().delegate as! AppDelegate).rootViewController else { ErrorHandler.handleAssertionFailure("Missing RootViewController"); return }
        UIAlertController.Alert(message.substringToIndex(message.startIndex.advancedBy(500)))
            .withOKAction(title: "Debug", handler: {_ in
                self.debugAssertionFailure = true
            })
            .withCancelButton("Ignore error", handler: {_ in
                self.debugAssertionFailure = false
            })
            .showFrom(rootVC)
    }
}
