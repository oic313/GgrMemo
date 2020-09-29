import UIKit
import GgrMemoPresenter

final public class MemoListViewController: UIViewController {
    
    @IBOutlet private weak var memoCollectionView: UICollectionView!
    private let presenter = MemoListPresenter()
    
    private var model: MemoListViewModel?
    private var displayList: [CollectionViewCellType] {
        model?.displayList ?? []
    }
    private var selectedTapAction: TapAction
    private var selectedUseOfficialApp: UseOfficialAppFlagState
    
    private lazy var tagCellHelper: TagCollectionViewCell? = {
        UINib(nibName: TagCollectionViewCell.className, bundle: Bundle(for: TagCollectionViewCell.self)).instantiate(withOwner: nil).first as? TagCollectionViewCell
    }()
    
    private lazy var memoCellHelper: MemoCollectionViewCell? = {
        UINib(nibName: MemoCollectionViewCell.className, bundle: Bundle(for: MemoCollectionViewCell.self)).instantiate(withOwner: nil).first as? MemoCollectionViewCell
    }()
    
    public init(){
        selectedTapAction = .checked
        selectedUseOfficialApp = .on
        super.init(nibName: nil, bundle: Bundle(for: Self.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.view = self
        presenter.showPage()
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        let addMemoViewController = AddMemoViewController()
        present(addMemoViewController, animated: true, completion: nil)
    }
    
}


extension MemoListViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.displayList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.displayList[section] {
        case .memoList(let memoList):
            return memoList.memos.count
        default:
            return 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch self.displayList[indexPath.section] {
        case .setting(let list):
            let cell: SettingCollectionViewCell = collectionView.dequeueReusableCell(cellClass: SettingCollectionViewCell.self, indexPath: indexPath)
            cell.setCell(displayList: list, tapAction: selectedTapAction, useOfficialApp: selectedUseOfficialApp)
            cell.delegate = self
            return cell
        case .tag(let tag):
            let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(cellClass: TagCollectionViewCell.self, indexPath: indexPath)
            cell.setupCell(tag: tag)
            return cell
        case .memoList(let memoList):
            let cell: MemoCollectionViewCell = collectionView.dequeueReusableCell(cellClass: MemoCollectionViewCell.self, indexPath: indexPath)
            cell.setupCell(memo: memoList.memos[indexPath.row], color: memoList.color)
            return cell
        case .space:
            let cell: SpaceCollectionViewCell = collectionView.dequeueReusableCell(cellClass: SpaceCollectionViewCell.self, indexPath: indexPath)
            return cell
        }
    }
    
}

extension MemoListViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.displayList[indexPath.section] {
        case .setting:
            return .init(width: view.frame.width, height: 40)
        case .tag(let tag):
            guard let cell = tagCellHelper else { return .zero }
            cell.setupCell(tag: tag)            
            return cell.fitSize(width: UIScreen.main.bounds.size.width - 30)
        case .memoList(let memoList):
            guard let cell = memoCellHelper else { return .zero }
            cell.setupCell(memo: memoList.memos[indexPath.row], color: memoList.color)
            return cell.fitSize(width: UIScreen.main.bounds.size.width/2 - 60/2 - 10/2)
        case .space:
            return .init(width: view.frame.width, height: view.frame.height/4)
        }
    }
    
    // cell達の周囲の余白
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch self.displayList[section] {
        case .tag:
            return UIEdgeInsets(top: 30.0, left: 0.0, bottom: 0.0, right: 0.0)
        case .memoList:
            return UIEdgeInsets(top: 10.0, left: 30.0, bottom: 0.0, right: 30.0)
        default:
            return UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
    
    // cell単体の縦方向の間隔
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    // cell単体の横方向の間隔
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
}

extension MemoListViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        true  // 変更
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        true  // 変更
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    //TODO: いつかいい感じにする
    // Cell がタップで選択されたときに呼ばれる
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if case .memoList(let memoList) = self.displayList[indexPath.section] {
            switch selectedTapAction {
            case .checked:
                view.isUserInteractionEnabled = false
                presenter.checkedMemo(memo: memoList.memos[indexPath.row], indexPath: indexPath)
            case .edit:
                let addMemoViewController = AddMemoViewController(memoList: [memoList.memos[indexPath.row]])
                present(addMemoViewController, animated: true, completion: nil)
            case .search:
                let str = "https://www.google.co.jp/search?q=\(memoList.memos[indexPath.row].value)"
                openUrl(mobileUrl: str.url, appUrl: str.url)
            case .searchOnYoutube:
                let app = "youtube://results?search_query=\(memoList.memos[indexPath.row].value)"
                let mobile = "https://m.youtube.com/results?search_query=\(memoList.memos[indexPath.row].value)"
                openUrl(mobileUrl: mobile.url, appUrl: app.url)
            case .searchOnTwitter:
                let app = "twitter://search?query=\(memoList.memos[indexPath.row].value)"
                let mobile = "https://mobile.twitter.com/search?lang=ja&q=\(memoList.memos[indexPath.row].value)&src=typed_query"
                openUrl(mobileUrl: mobile.url, appUrl: app.url)
            }
        } else if case .tag(let tag) = self.displayList[indexPath.section] {
            switch selectedTapAction {
            case .checked:
                view.isUserInteractionEnabled = false
                presenter.checkedTag(tag: tag, indexPath: indexPath)
            case .edit:
                if case .memoList(let memoList) = self.displayList[indexPath.section + 1] {
                    let addMemoViewController = AddMemoViewController(memoList: memoList.memos, tag: tag)
                    present(addMemoViewController, animated: true, completion: nil)
                }
            default:
                return
            }
        }
        return
    }
    
}


extension MemoListViewController: MemoListView {
    
    public func redraw(model: MemoListViewModel) {
        self.model = model
        memoCollectionView.reloadData()
        view.isUserInteractionEnabled = true
    }
}

extension MemoListViewController: ParentView {
    
    public func popupSettingView(cellType: SettingViewCellType, cell: UICollectionViewCell){
        let settingViewController = SettingViewController(displayType: cellType)
        // スタイルの指定
        settingViewController.modalPresentationStyle = .popover
        // サイズの指定
        settingViewController.preferredContentSize = CGSize(width: 200, height: 200)
        // 表示するViewの指定
        settingViewController.popoverPresentationController?.sourceView = memoCollectionView
        // ピヨッと表示する位置の指定
        settingViewController.popoverPresentationController?.sourceRect = cell.frame
        // 矢印が出る方向の指定
        settingViewController.popoverPresentationController?.permittedArrowDirections = .any
        // デリゲートの設定
        settingViewController.popoverPresentationController?.delegate = self
        settingViewController.delegate = self
        present(settingViewController, animated: true, completion: nil)
    }
    
    public func setUseOfficialAppFlag(useOfficialAppFlag: UseOfficialAppFlagState){
        selectedUseOfficialApp = useOfficialAppFlag
    }
}

extension MemoListViewController: UIPopoverPresentationControllerDelegate {
    // iPhoneで表示させる場合に必要
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .none
    }
}

extension MemoListViewController: TransitionSourceView {
    
    public func tapedEditAction(action: EditAction) {
        switch action {
        case .deleteMemo:
            view.isUserInteractionEnabled = false
            presenter.deleteCheckedMemos()
        case .deleteTag:
            view.isUserInteractionEnabled = false
            presenter.deleteCheckedTags()
        case .cancelCecked:
            view.isUserInteractionEnabled = false
            presenter.deselectionAll()
        }
    }
    
    public func tapedTapAction(action: TapAction) {
        selectedTapAction = action
        memoCollectionView.reloadData()
    }
    
}

private extension MemoListViewController {
    func configure() {
        // UICollectionViewDataSourceのあるクラスを示す
        memoCollectionView.dataSource = self
        // UICollectionViewDelegateFlowLayoutのあるクラスを示す
        memoCollectionView.delegate = self
        memoCollectionView.registerCell(cellClass: SettingCollectionViewCell.self)
        memoCollectionView.registerCell(cellClass: MemoCollectionViewCell.self)
        memoCollectionView.registerCell(cellClass: TagCollectionViewCell.self)
        memoCollectionView.registerCell(cellClass: SpaceCollectionViewCell.self)
        memoCollectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed)))
    }
    
    @objc func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        // 押された位置でcellのPathを取得
        let point = recognizer.location(in: memoCollectionView)
        guard let indexPath = memoCollectionView.indexPathForItem(at: point) else { return }
        guard let cell = memoCollectionView.cellForItem(at: indexPath) else { return }
        
        if recognizer.state == .began {
            if case .memoList = self.displayList[indexPath.section] {
                let buttonViewController = ButtonViewController()
                buttonViewController.modalPresentationStyle = .custom
                buttonViewController.transitioningDelegate = self
                
                let hoge = buttonViewController.presentationController as! CustomPresentationController
                hoge.hoge = memoCollectionView.nowPosition(cell: cell)
                
                present(buttonViewController, animated: false, completion: nil)
            }
            // 長押しされた場合の処理
            print("長押しされたcellのSection:\(String(describing: indexPath.section))")
            print("長押しされたcellのindexPath:\(String(describing: indexPath.row))")
        }
    }
    
    func openUrl(mobileUrl: URL?, appUrl: URL?) {
        guard let mobileUrl = mobileUrl, let appUrl = appUrl else { return }
        if selectedUseOfficialApp.isOn && UIApplication.shared.canOpenURL(appUrl) {
            UIApplication.shared.open(appUrl)
        } else {
            present(WebViewController(url: mobileUrl), animated: true, completion: nil)
        }
    }
    
}

extension MemoListViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

final class CustomPresentationController: UIPresentationController {
    
    var hoge: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        CGSize(width: 300, height: 300)
    }
    
    // 呼び出し先のView Controllerのframeを返す
    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect()
        let containerBounds = containerView!.bounds
        let childContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
        presentedViewFrame.size = childContentSize
        presentedViewFrame.center.x = hoge.center.x
        presentedViewFrame.center.y = hoge.center.y
        return presentedViewFrame
    }
    
}

extension CGRect {
    /** Creates a rectangle with the given center and dimensions
     - parameter center: The center of the new rectangle
     - parameter size: The dimensions of the new rectangle
     */
    init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
    }
    
    /** the coordinates of this rectangles center */
    var center: CGPoint
    {
        get { return CGPoint(x: centerX, y: centerY) }
        set { centerX = newValue.x; centerY = newValue.y }
    }
    
    /** the x-coordinate of this rectangles center
     - note: Acts as a settable midX
     - returns: The x-coordinate of the center
     */
    var centerX: CGFloat {
        get { return midX }
        set { origin.x = newValue - width * 0.5 }
    }
    
    /** the y-coordinate of this rectangles center
     - note: Acts as a settable midY
     - returns: The y-coordinate of the center
     */
    var centerY: CGFloat {
        get { return midY }
        set { origin.y = newValue - height * 0.5 }
    }
    
    // MARK: - "with" convenience functions
    
    /** Same-sized rectangle with a new center
     - parameter center: The new center, ignored if nil
     - returns: A new rectangle with the same size and a new center
     */
    func with(center: CGPoint?) -> CGRect {
        return CGRect(center: center ?? self.center, size: size)
    }
    
    /** Same-sized rectangle with a new center-x
     - parameter centerX: The new center-x, ignored if nil
     - returns: A new rectangle with the same size and a new center
     */
    func with(centerX: CGFloat?) -> CGRect {
        return CGRect(center: CGPoint(x: centerX ?? self.centerX, y: centerY), size: size)
    }
    
    /** Same-sized rectangle with a new center-y
     - parameter centerY: The new center-y, ignored if nil
     - returns: A new rectangle with the same size and a new center
     */
    func with(centerY: CGFloat?) -> CGRect {
        return CGRect(center: CGPoint(x: centerX, y: centerY ?? self.centerY), size: size)
    }
    
    /** Same-sized rectangle with a new center-x and center-y
     - parameter centerX: The new center-x, ignored if nil
     - parameter centerY: The new center-y, ignored if nil
     - returns: A new rectangle with the same size and a new center
     */
    func with(centerX: CGFloat?, centerY: CGFloat?) -> CGRect {
        return CGRect(center: CGPoint(x: centerX ?? self.centerX, y: centerY ?? self.centerY), size: size)
    }
}


extension UICollectionView {
    func nowPosition(cell: UICollectionViewCell) -> CGRect {
        let point = CGPoint(x: cell.frame.origin.x - self.contentOffset.x, y: cell.frame.origin.y - self.contentOffset.y)
        let size = cell.bounds.size
        return CGRect(x: point.x, y: point.y, width: size.width, height: size.height)
    }
}
