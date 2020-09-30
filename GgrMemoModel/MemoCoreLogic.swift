import RealmSwift
import GgrMemoUtility

class MemoCoreLogic {

    static func searchMemo(memo: Memo) -> MemoData? {
        let realm = try! Realm()
        let savedMemoData = realm.objects(MemoData.self).filter("id == %@", memo.id ?? "").first
        return savedMemoData
    }
    
    static func searchCheckedMemos(isChecked: Bool) -> [Memo] {
        let realm = try! Realm()
        let savedMemoData = realm.objects(MemoData.self).filter("isChecked == %@", isChecked)
        let memos = Array(savedMemoData.map{ $0.value })
        return memos
    }
    
    static func deleteMemo(memo: Memo) {
        let realm = try! Realm()
        guard let savedMemoData = realm.objects(MemoData.self).filter("id == %@", memo.id ?? "").first else { return }
        try! realm.write {
            realm.delete(savedMemoData)
        }
    }
    
    static func addNewMemo(memo: Memo, tag: Tag) {
        // Realmを初期化
        let realm = try! Realm()
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let savedMemoData = MemoData()
        // Realmに書き込み
        try! realm.write {
            savedMemoData.updateDate = NSDate()
            savedMemoData.memo = memo.value
            savedMemoData.tag = tag.value
            realm.add(savedMemoData)
        }
    }
    
    static func updateMemo(memo: Memo, tag: Tag, savedMemoDate: MemoData) {
        // Realmを初期化
        let realm = try! Realm()
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let savedMemoData = savedMemoDate
        // Realmに書き込み
        try! realm.write {
            savedMemoData.updateDate = NSDate()
            savedMemoData.memo = memo.value
            savedMemoData.tag = tag.value
            savedMemoData.isChecked = false
            realm.add(savedMemoData)
        }
    }
    
    static func updateMemoCheckedStatus(savedMemoDate: MemoData, bool: Bool) {
        // Realmを初期化
        let realm = try! Realm()
        // Realmに書き込み
        try! realm.write {
            savedMemoDate.isChecked = bool
        }
    }
    
    static func searchAllMemoData() -> [Memo] {
        let realm = try! Realm()
        let savedMemoData = realm.objects(MemoData.self).sorted(byKeyPath: "updateDate", ascending: false)
        let memos = Array(savedMemoData.map{ $0.value })
        return memos
    }
    
    static func searchtMemoWithMatchTag(tag: Tag) -> [Memo] {
        let realm = try! Realm()
        let savedMemoData = realm.objects(MemoData.self).filter("tag == %@", tag.value).sorted(byKeyPath: "updateDate", ascending: false)
        let memos = Array(savedMemoData.map{ $0.value })
        return memos
    }
    
}




