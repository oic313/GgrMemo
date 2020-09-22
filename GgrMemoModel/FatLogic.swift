import Foundation
import RealmSwift
import GgrMemoUtility



final public class FatLogic {
    
}

private extension FatLogic {
    static func searchTag(tag: Tag) -> TagData? {
        let realm = try! Realm()
        let savedTagData = realm.objects(TagData.self).filter("tag == %@" , tag.value).sorted(byKeyPath: "updateDate", ascending: false).first
        return savedTagData
    }
    
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
}

public extension FatLogic {
    
    static func addTag(tag: Tag){
        guard !tag.value.isEmptyByTrimming else { return }
        
        if let savedTagData = searchTag(tag: tag) {
            updateTag(tag: tag, savedTagDate: savedTagData)
        } else {
            addNewTag(tag: tag)
        }
    }
    
    private static func addNewTag(tag: Tag) {
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        // Realmに書き込み
        let savedTagData = TagData()
        try! realm.write {
//            savedTagData.createDate = NSDate()
            savedTagData.tag = tag.value
            savedTagData.updateDate = NSDate()
            savedTagData.color = tag.color.rawValue
            savedTagData.isChecked = false
            realm.add(savedTagData)
        }
    }
    
    private static func updateTag(tag: Tag, savedTagDate: TagData) {
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        // Realmに書き込み
        let savedTagData = savedTagDate
        try! realm.write {
            savedTagData.updateDate = NSDate()
            savedTagData.color = tag.color.rawValue
            savedTagData.isChecked = false
            realm.add(savedTagData)
        }
    }
    
    static func addMemo(memo: Memo, tag: Tag){
        guard !memo.value.isEmptyByTrimming else { return }
        addNewMemo(memo: memo, tag: tag)
    }
    
    private static func addNewMemo(memo: Memo, tag: Tag) {
        // Realmを初期化
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let savedMemoData = MemoData()
        // Realmに書き込み
        try! realm.write {
//            savedMemoData.createDate = NSDate()
            savedMemoData.updateDate = NSDate()
            savedMemoData.memo = memo.value
            savedMemoData.tag = tag.value
            realm.add(savedMemoData)
        }
    }
    
    private static func updateMemo(memo: Memo, tag: Tag, savedMemoDate: MemoData) {
        // Realmを初期化
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
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
    
    static func togleMemoCheckedStatus(memo: Memo) {
        guard let savedMemoData = searchMemo(memo: memo) else { return }
        updateMemoCheckedStatus(savedMemoDate: savedMemoData, bool: savedMemoData.togleCheckStatus)
    }
    
    private static func updateMemoCheckedStatus(savedMemoDate: MemoData, bool: Bool) {
        // Realmを初期化
        let realm = try! Realm()
        // Realmに書き込み
        try! realm.write {
            savedMemoDate.isChecked = bool
        }
    }
    
    static func deleteCheckedMemos() {
        let savedMemoData = searchCheckedMemos(isChecked: true)
        savedMemoData.forEach {deleteMemo(memo: $0) }
    }

    
    static func searchIncludeSpaceTagList() -> [Tag] {
        var tagList = searchAllTag()
        tagList.insert(Tag("", color: .sub), at: 0)
        return tagList
    }
    
    static func searchAllTag() -> [Tag] {
        let realm = try! Realm()
        let savedMemoData = realm.objects(TagData.self).sorted(byKeyPath: "updateDate", ascending: false)
        let tags = Array(savedMemoData.map{ $0.value })
        return tags
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

final class TagData: Object {
    @objc dynamic var createDate: NSDate = NSDate()
    @objc dynamic var updateDate: NSDate = NSDate()
    @objc dynamic var tag = ""
    @objc dynamic var color = ""
    @objc dynamic var isChecked = false
    
    var value: Tag { Tag(tag, color: ColorAsset(rawValue: color) ?? .sub) }
}

