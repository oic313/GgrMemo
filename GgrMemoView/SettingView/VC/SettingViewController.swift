import UIKit
import GgrMemoUtility
import GgrMemoPresenter

public protocol TransitionSourceView: AnyObject {
    func tapedEditAction(action: EditAction)
    func tapedTapAction(action: TapAction)
}

final class SettingViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private let displayType: SettingViewCellType
    weak var delegate: TransitionSourceView?  // NOTE: これがdelegate

    public init(displayType: SettingViewCellType) {
        self.displayType = displayType
        super.init(nibName: nil, bundle: Bundle(for: Self.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorAsset.main.value
        // UICollectionViewDataSourceのあるクラスを示す
        collectionView.dataSource = self
        // UICollectionViewDelegateFlowLayoutのあるクラスを示す
        collectionView.delegate = self
        collectionView.registerCell(cellClass: SettingViewCell.self)

        
    }
}


extension SettingViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch displayType {
        case .edit(let list):
            return list.count
        case .tapActionEdit(let list):
            return list.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SettingViewCell = collectionView.dequeueReusableCell(cellClass: SettingViewCell.self, indexPath: indexPath)
        
        switch displayType {
        case .edit(let list):
            cell.setupCell(text: list[indexPath.section].rawValue)
        case .tapActionEdit(let list):
            cell.setupCell(text: list[indexPath.section].rawValue)
        }
        return cell
        
    }
    
}

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width, height: 35)
    }
    // cell達の周囲の余白
    // cellをdaysPerWeekで割った余りを横方向の余白に当てることで割り切れなかった分の空白を埋めている
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
        
    }
    
    // cell単体の縦方向の間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    // cell単体の横方向の間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
}

extension SettingViewController: UICollectionViewDelegate {
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
        guard let delegate = delegate else { return }
        switch displayType {
        case .edit(let list):
            delegate.tapedEditAction(action: list[indexPath.section])
            self.dismiss(animated: true, completion: nil)
        case .tapActionEdit(let list):
            delegate.tapedTapAction(action: list[indexPath.section])
            self.dismiss(animated: true, completion: nil)
        }
        return
    }
    
}
