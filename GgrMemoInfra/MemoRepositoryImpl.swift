import GgrMemoUtility
import GgrMemoDomain
import RealmSwift

public class MemoRepositoryImpl: MemoRepository {
    
    public init(){}
    
    public func searchMemo(memo: Memo) -> Memo? {
        searchMemoData(memo: memo)?.value
    }
    
    public func searchCheckedMemos(isChecked: Bool) -> [Memo] {
        let realm = try! Realm()
        let savedMemoData = realm.objects(MemoData.self).filter("isChecked == %@", isChecked)
        let memos = Array(savedMemoData.map{ $0.value })
        return memos
    }
    
    public func deleteMemo(memo: Memo) {
        let realm = try! Realm()
        guard let savedMemoData = realm.objects(MemoData.self).filter("id == %@", memo.id ?? "").first else { return }
        try! realm.write {
            realm.delete(savedMemoData)
        }
    }
    
    public func addNewMemo(memo: Memo, tag: Tag) {
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
    
    public func updateMemo(memo: Memo, tag: Tag) {
        // Realmを初期化
        let realm = try! Realm()
        //        print(Realm.Configuration.defaultConfiguration.fileURL!)
        guard let savedMemoData = searchMemoData(memo: memo) else { return }
        // Realmに書き込み
        try! realm.write {
            savedMemoData.updateDate = NSDate()
            savedMemoData.memo = memo.value
            savedMemoData.tag = tag.value
            savedMemoData.isChecked = false
            realm.add(savedMemoData)
        }
    }
    
    public func updateMemoCheckedStatus(savedMemo: Memo, bool: Bool) {
        // Realmを初期化
        let realm = try! Realm()
        guard let savedMemoData = searchMemoData(memo: savedMemo) else { return }
        // Realmに書き込み
        try! realm.write {
            savedMemoData.isChecked = bool
        }
    }
    
    public func searchAllMemoData() -> [Memo] {
        let realm = try! Realm()
        let savedMemoData = realm.objects(MemoData.self).sorted(byKeyPath: "updateDate", ascending: false)
        let memos = Array(savedMemoData.map{ $0.value })
        return memos
    }
    
    public func searchMemoWithMatchTag(tag: Tag) -> [Memo] {
        let realm = try! Realm()
        let savedMemoData = realm.objects(MemoData.self).filter("tag == %@", tag.value).sorted(byKeyPath: "updateDate", ascending: false)
        let memos = Array(savedMemoData.map{ $0.value })
        return memos
    }
    
}

private extension MemoRepositoryImpl {
    func searchMemoData(memo: Memo) -> MemoData? {
        let realm = try! Realm()
        let savedMemoData = realm.objects(MemoData.self).filter("id == %@", memo.id ?? "").first
        return savedMemoData
    }
}
