import UIKit
import GgrMemoUtility

extension ColorAsset {
    var value: UIColor? {
        UIColor(named: self.rawValue, in: Bundle(identifier: "GgrMemo.GgrMemoView"), compatibleWith: nil)
    }
}
