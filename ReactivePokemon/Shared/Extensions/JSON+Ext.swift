import Foundation
import Argo
import Haneke

extension Argo.JSON : DataConvertible, DataRepresentable {
    public typealias Result = Argo.JSON

    public static func convertFromData(data: NSData) -> Result? {
        do {
            let j = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
            return JSON(j)
        } catch {
            ErrorHandler.handleError(error)
            return nil
        }
    }

    public func asData() -> NSData! {
        return try? NSJSONSerialization.dataWithJSONObject(encode().JSONObject(), options: NSJSONWritingOptions())
    }
}
