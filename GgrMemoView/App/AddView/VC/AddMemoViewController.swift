import UIKit
import GgrMemoUtility
import GgrMemoPresenter

final class AddMemoViewController: UIViewController {
    
    @IBOutlet weak var memoCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    private let presenter = AddMemoPresenter()
    private let tagList: [Tag]
    private let tagColorList: [ColorAsset]
    private let initTag: Tag
    private var memoList = [Memo]()
    private var selectedMemoIndexPath: IndexPath? = nil
    private var selectedColor: ColorAsset

    private var memo: Memo? {
        guard let text = memoTextField.text else { return nil }
        guard !text.isEmptyByTrimming else { return nil }
        return Memo(text, isChecked: true)
    }
    
    private var tag: Tag {
        Tag(tagTextField?.text?.trimming ?? "", color: selectedColor, isChecked: false)
    }
    
    public init(memoList: [Memo] = [], tag: Tag = Tag("", color: .sub, isChecked: false)) {
        self.initTag = tag
        self.selectedColor = tag.color
        self.memoList = memoList
        self.tagList = presenter.tagList
        self.tagColorList = presenter.tagColorList
        super.init(nibName: nil, bundle: Bundle(for: Self.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UICollectionViewDataSourceのあるクラスを示す
        memoCollectionView.dataSource = self
        // UICollectionViewDelegateFlowLayoutのあるクラスを示す
        memoCollectionView.delegate = self
        memoCollectionView.registerCell(cellClass: AddMemoCollectionViewCell.self)

        if let flowLayout = memoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        tagCollectionView.registerCell(cellClass: TagListCollectionViewCell.self)
        if let flowLayout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.registerCell(cellClass: ColorListCollectionViewCell.self)
        if let flowLayout = colorCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        memoTextField.delegate = self

        tagCollectionView.layer.cornerRadius = 5
        tagCollectionView.layer.masksToBounds = true
        
        colorCollectionView.layer.borderColor = ColorAsset.sub.value?.cgColor
        colorCollectionView.layer.borderWidth = 1
        colorCollectionView.layer.cornerRadius = 5
        colorCollectionView.layer.masksToBounds = true
        
        if tagList.isEmpty {
            tagCollectionView.isHidden = true
        }
        
        tagTextField.text = initTag.value
        applySelectedColor(initTag.color)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        memoTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }

    }
    
    @IBAction func TapAddButton(_ sender: Any) {
        guard !(memoTextField.text?.isEmptyByTrimming ?? true) || !memoList.isEmpty else { return }
        if let memo = memo { hasAppendMemoList(memo: memo) }
        presenter.addMemoData(addModel: AddMemoViewModel(tag: tag, memos: memoList))
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AddMemoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // MEMO: 既存セルの更新か新規追加
        guard let memo = memo else { return true }

        if let indexPath = selectedMemoIndexPath {
            updateMemoCell(memo: memo, indexPath: indexPath)
        } else {
            addMemoCell(memo: memo)
        }
        return true
    }
    
}

extension AddMemoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == memoCollectionView {
            return memoList.count
        } else if collectionView == tagCollectionView {
            return tagList.count
        } else if collectionView == colorCollectionView {
            return tagColorList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == memoCollectionView {
            let cell :AddMemoCollectionViewCell = collectionView.dequeueReusableCell(cellClass: AddMemoCollectionViewCell.self, indexPath: indexPath)
            cell.setupCell(memo: memoList[indexPath.row], color: selectedColor)
            return cell
        } else if collectionView == tagCollectionView {
            let cell: TagListCollectionViewCell = collectionView.dequeueReusableCell(cellClass: TagListCollectionViewCell.self, indexPath: indexPath)
            cell.setupCell(tag: tagList[indexPath.row])
            return cell
        } else if collectionView == colorCollectionView {
            let cell: ColorListCollectionViewCell = collectionView.dequeueReusableCell(cellClass: ColorListCollectionViewCell.self, indexPath: indexPath)
            cell.setupCell(color: tagColorList[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

extension AddMemoViewController: UICollectionViewDelegateFlowLayout {
    
    // cell達の周囲の余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 100.0)
        
    }
    
    // cell単体の縦方向の間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    // cell単体の横方向の間隔
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        30
//    }
    
    
}

extension AddMemoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        true  // 変更
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        true  // 変更
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        true
    }

    
    // Cell がタップで選択されたときに呼ばれる
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == memoCollectionView {
            togleMemoCellSelectionState(collectionView: collectionView, indexPath: indexPath)
        } else if collectionView == tagCollectionView {
            tagTextField.text = tagList[indexPath.row].value
        } else if collectionView == colorCollectionView {
            guard let text = tagTextField.text else { return }
            guard !text.isEmptyByTrimming else { return }
            applySelectedColor(tagColorList[indexPath.row])
        }
        
    }
    
    // Cell がタップで選択解除されたときに呼ばれる
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == memoCollectionView {
            togleMemoCellSelectionState(collectionView: collectionView, indexPath: indexPath)
        }
    }

}

private extension AddMemoViewController {
    
    func hasAppendMemoList(memo: Memo) {
        memoTextField.text = nil
        memoList.append(contentsOf: [memo])
    }
    
    func togleMemoCellSelectionState(collectionView: UICollectionView, indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AddMemoCollectionViewCell else { return }
         // MEMO: もう一回同じcellがタップされた
         if selectedMemoIndexPath == indexPath {
             selectedMemoIndexPath = nil
             memoTextField.text = nil
             cell.isSelected = false
         } else {
             selectedMemoIndexPath = indexPath
            memoTextField.text = memoList[indexPath.row].value
         }

         cell.applySelectionState()
    }
    
    func updateMemoCell(memo: Memo, indexPath: IndexPath) {
        memoList[indexPath.row] = memo
        memoCollectionView.reloadItems(at: [indexPath])
        // MEMO: togleCellSelectionState内でもう一回タップした時にmemoTextField.textを""にしてるから、先にmemoTextFieldを更新している
        togleMemoCellSelectionState(collectionView: memoCollectionView, indexPath: indexPath)
    }
    
    func addMemoCell(memo: Memo) {
        hasAppendMemoList(memo: memo)
        memoCollectionView.insertItems(at: [IndexPath(row: memoList.count - 1, section: 0)])
    }
    
    func applySelectedColor(_ color: ColorAsset) {
        selectedColor = color
        memoCollectionView.reloadData()
        tagCollectionView.backgroundColor = selectedColor.value
        tagCollectionView.reloadData()
        colorCollectionView.layer.borderColor = selectedColor.value?.cgColor
    }
}
