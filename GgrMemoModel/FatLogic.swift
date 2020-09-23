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
    
    
    static func addNewTag(tag: Tag) {
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        // Realmに書き込み
        let savedTagData = TagData()
        try! realm.write {
            savedTagData.tag = tag.value
            savedTagData.updateDate = NSDate()
            savedTagData.color = tag.color.rawValue
            savedTagData.isChecked = false
            realm.add(savedTagData)
        }
    }
    
    static func updateTag(tag: Tag, savedTagDate: TagData) {
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
    
    static func searchCheckedTags(isChecked: Bool) -> [Tag] {
        let realm = try! Realm()
        let savedTagData = realm.objects(TagData.self).filter("isChecked == %@", isChecked)
        let tags = Array(savedTagData.map{ $0.value })
        return tags
    }
    
    static func deleteTag(tag: Tag) {
        let realm = try! Realm()
        guard let savedTagData = realm.objects(TagData.self).filter("tag == %@", tag.value ).first else { return }
        try! realm.write {
            realm.delete(savedTagData)
        }
    }
    
    static func updateTagCheckedStatus(savedTagDate: TagData, bool: Bool) {
        // Realmを初期化
        let realm = try! Realm()
        // Realmに書き込み
        try! realm.write {
            savedTagDate.isChecked = bool
        }
    }
}

private extension FatLogic {

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
        print(Realm.Configuration.defaultConfiguration.fileURL!)
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
    
    static func updateMemoCheckedStatus(savedMemoDate: MemoData, bool: Bool) {
        // Realmを初期化
        let realm = try! Realm()
        // Realmに書き込み
        try! realm.write {
            savedMemoDate.isChecked = bool
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
    
    static func searchIncludeSpaceTagList() -> [Tag] {
        var tagList = searchAllTag()
        tagList.insert(Tag("", color: .sub, isChecked: false), at: 0)
        return tagList
    }
    
    static func searchAllTag() -> [Tag] {
        let realm = try! Realm()
        let savedMemoData = realm.objects(TagData.self).sorted(byKeyPath: "updateDate", ascending: false)
        let tags = Array(savedMemoData.map{ $0.value })
        return tags
    }
    
    static func deleteCheckedTags() {
        searchCheckedTags(isChecked: true).forEach {
            searchtMemoWithMatchTag(tag: $0).forEach { deleteMemo(memo: $0) }
            deleteTag(tag: $0)
        }
    }

    static func togleTagCheckedStatus(tag: Tag) {
        guard let savedTagData = searchTag(tag: tag) else { return }
        updateTagCheckedStatus(savedTagDate: savedTagData, bool: savedTagData.togleCheckStatus)
    }
    
    static func deselectionAllTag() {
        searchCheckedTags(isChecked: true).forEach {         updateTagCheckedStatus(savedTagDate: searchTag(tag: $0)!, bool: false) }
    }
}

public extension FatLogic {

    static func addMemo(memo: Memo, tag: Tag){
        guard !memo.value.isEmptyByTrimming else { return }
        
        if let savedMemoData = searchMemo(memo: memo) {
            updateMemo(memo: memo, tag: tag, savedMemoDate: savedMemoData)
        } else {
            addNewMemo(memo: memo, tag: tag)
        }
    }
    
    static func togleMemoCheckedStatus(memo: Memo) {
        guard let savedMemoData = searchMemo(memo: memo) else { return }
        updateMemoCheckedStatus(savedMemoDate: savedMemoData, bool: savedMemoData.togleCheckStatus)
    }
    
    static func deleteCheckedMemos() {
        searchCheckedMemos(isChecked: true).forEach { deleteMemo(memo: $0) }
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
    
    static func deselectionAllMemo() {
        searchCheckedMemos(isChecked: true).forEach {         updateMemoCheckedStatus(savedMemoDate: searchMemo(memo: $0)!, bool: false) }
    }
}


final class TagData: Object {
    @objc dynamic var createDate: NSDate = NSDate()
    @objc dynamic var updateDate: NSDate = NSDate()
    @objc dynamic var tag = ""
    @objc dynamic var color = ""
    @objc dynamic var isChecked = false
    
    var value: Tag { Tag(tag, color: ColorAsset(rawValue: color) ?? .sub, isChecked: isChecked) }
    var togleCheckStatus: Bool { !isChecked }
}

