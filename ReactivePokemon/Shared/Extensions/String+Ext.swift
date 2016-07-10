import Foundation

extension String {
    func nilIfEmpty() -> String? {
        return self == "" ? nil : self
    }
}
