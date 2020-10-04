import UIKit
import GgrMemoUtility
import GgrMemoPresenter

final class AddMemoViewController: UIViewController {
    
    @IBOutlet private weak var memoCollectionView: UICollectionView!
    @IBOutlet private weak var tagCollectionView: UICollectionView!
    @IBOutlet private weak var colorCollectionView: UICollectionView!
    @IBOutlet private weak var memoTextField: UITextField!
    @IBOutlet private weak var tagTextField: UITextField!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    private let presenter = AddMemoPresenter()
    private let tagList: [Tag]
    private let tagColorList: [ColorAsset]
    private let initTag: Tag
    private var memoList = [Memo]()
    private var selectedMemoIndexPath: IndexPath? = nil
    private var selectedColor: ColorAsset
    
    private lazy var addMemoCellHelper: AddMemoCollectionViewCell? = {
        UINib(nibName: AddMemoCollectionViewCell.className, bundle: Bundle(for: AddMemoCollectionViewCell.self)).instantiate(withOwner: nil).first as? AddMemoCollectionViewCell
    }()
    
    private lazy var tagListCellHelper: TagListCollectionViewCell? = {
        UINib(nibName: TagListCollectionViewCell.className, bundle: Bundle(for: TagListCollectionViewCell.self)).instantiate(withOwner: nil).first as? TagListCollectionViewCell
    }()
    
    private lazy var colorListCellHelper: ColorListCollectionViewCell? = {
        UINib(nibName: ColorListCollectionViewCell.className, bundle: Bundle(for: ColorListCollectionViewCell.self)).instantiate(withOwner: nil).first as? ColorListCollectionViewCell
    }()
    
    private var memo: Memo? {
        guard let text = memoTextField.text else { return nil }
        guard !text.isEmptyByTrimming else { return nil }
        return Memo(text, isChecked: false)
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
        configure()
        memoTextField.layer.borderWidth = 1
        memoTextField.layer.cornerRadius = 5
        memoTextField.layer.borderColor = ColorAsset.thin.value?.cgColor
        tagTextField.layer.borderWidth = 1
        tagTextField.layer.cornerRadius = 5
        tagTextField.layer.borderColor = ColorAsset.thin.value?.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        memoTextField.becomeFirstResponder()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.viewDidLoad()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        //キーボードの高さを取得
        guard let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        UIView.animate(withDuration: duration , delay: 0.5, animations: {
            self.bottomConstraint.constant = rect.height + 10
        })
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        guard !(memoTextField.text?.isEmptyByTrimming ?? true) || !memoList.isEmpty else { return }
        adaptMemo()
        presenter.addMemoData(addModel: AddMemoViewModel(tag: tag, memos: memoList))
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddMemoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        adaptMemo()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == memoCollectionView {
            guard let cell = addMemoCellHelper else { return .zero }
            cell.setupCell(memo: memoList[indexPath.row], color: selectedColor)
            return cell.fitSize()
        } else if collectionView == tagCollectionView {
            guard let cell = tagListCellHelper else { return .zero }
            cell.setupCell(tag: tagList[indexPath.row])
            return cell.fitSize()
        } else if collectionView == colorCollectionView {
            guard let cell = colorListCellHelper else { return .zero }
            cell.setupCell(color: tagColorList[indexPath.row])
            return cell.fitSize()
        }
        return .zero
    }
    
    // cell達の周囲の余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
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

extension AddMemoViewController: AddMemoView {
    func dissmiss() {
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: true)
            presentingViewController?.endAppearanceTransition()
        }
        self.dismiss(animated: true)
    }
}

private extension AddMemoViewController {
    func configure() {
        configureMemoCollectionView()
        configureTagCollectionView()
        configureColorCollectionView()
        if tagList.isEmpty { tagCollectionView.isHidden = true }
        memoTextField.delegate = self
        tagTextField.text = initTag.value
        applySelectedColor(initTag.color)
        presenter.view = self
    }
    
    func configureMemoCollectionView() {
        memoCollectionView.dataSource = self
        memoCollectionView.delegate = self
        memoCollectionView.registerCell(cellClass: AddMemoCollectionViewCell.self)
    }
    
    func configureTagCollectionView() {
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        tagCollectionView.registerCell(cellClass: TagListCollectionViewCell.self)
        tagCollectionView.layer.cornerRadius = 5
        tagCollectionView.layer.masksToBounds = true
    }
    
    func configureColorCollectionView() {
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.registerCell(cellClass: ColorListCollectionViewCell.self)
        colorCollectionView.layer.borderColor = ColorAsset.sub.value?.cgColor
        colorCollectionView.layer.borderWidth = 2
        colorCollectionView.layer.cornerRadius = 5
        colorCollectionView.layer.masksToBounds = true
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
    
    func adaptMemo() {
        // MEMO: 既存セルの更新か新規追加
        if selectedMemoIndexPath != nil {
            updateMemoCell()
        } else {
            guard let memo = memo else { return }
            addMemoCell(memo: memo)
        }
    }
    
    func updateMemoCell() {
        guard let text = memoTextField.text else { return }
        guard let indexPath = selectedMemoIndexPath else { return }
        if text.isEmptyByTrimming {
            memoList.remove(at: indexPath.row)
            memoCollectionView.deleteItems(at: [indexPath])
            selectedMemoIndexPath = nil
        } else {
            memoList[indexPath.row] = Memo(text, isChecked: false, id: memoList[indexPath.row].id)
            memoCollectionView.reloadItems(at: [indexPath])
            togleMemoCellSelectionState(collectionView: memoCollectionView, indexPath: indexPath)
        }
    }
    
    func addMemoCell(memo: Memo) {
        memoTextField.text = nil
        memoList.append(contentsOf: [memo])
        memoCollectionView.insertItems(at: [IndexPath(row: memoList.count - 1, section: 0)])
        memoCollectionView.scrollToItem(at: IndexPath(row: memoList.count - 1, section: 0), at: .right, animated: true)
    }
    
    func applySelectedColor(_ color: ColorAsset) {
        selectedColor = color
        memoCollectionView.reloadData()
        tagCollectionView.backgroundColor = selectedColor.value
        tagCollectionView.reloadData()
        colorCollectionView.layer.borderColor = selectedColor.value?.cgColor
    }
}
