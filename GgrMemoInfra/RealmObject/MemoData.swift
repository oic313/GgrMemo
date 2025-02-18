import Foundation
import RealmSwift
import GgrMemoUtility

final class MemoData: Object {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var createDate: NSDate = NSDate()
    @objc dynamic var updateDate: NSDate = NSDate()
    @objc dynamic var memo = ""
    @objc dynamic var tag = ""
    @objc dynamic var isChecked = false

    var value: Memo { Memo(memo, isChecked: isChecked, id: id) }
    
    override static func primaryKey() -> String? { "id" }
}
