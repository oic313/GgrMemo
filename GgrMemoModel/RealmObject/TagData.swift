import Foundation
import RealmSwift
import GgrMemoUtility

final class TagData: Object {
    @objc dynamic var createDate: NSDate = NSDate()
    @objc dynamic var updateDate: NSDate = NSDate()
    @objc dynamic var tag = ""
    @objc dynamic var color = ""
    @objc dynamic var isChecked = false
    
    var value: Tag { Tag(tag, color: ColorAsset(rawValue: color) ?? .sub, isChecked: isChecked) }
    var togleCheckStatus: Bool { !isChecked }
}
