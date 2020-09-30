import UIKit
import GgrMemoPresenter

public protocol ParentView: AnyObject {
    func popupSettingView(cellType: SettingViewCellType, cell: UICollectionViewCell)
    func setUseOfficialAppFlag(useOfficialAppFlag: UseOfficialAppFlagState)
}

final class SettingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var settingCollectionView: UICollectionView!
    public weak var delegate: ParentView?  // NOTE: これがdelegate
    private var displayList: [SettingViewCellType] = []
    private var tapAction: TapAction = .checked
    private var useOfficialApp: UseOfficialAppFlagState = .on

    private lazy var settingCellHelper: SettingCellOfCell? = {
        UINib(nibName: SettingCellOfCell.className, bundle: Bundle(for: SettingCellOfCell.self)).instantiate(withOwner: nil).first as? SettingCellOfCell
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        settingCollectionView.dataSource = self
        settingCollectionView.delegate = self
        
        settingCollectionView.registerCell(cellClass: SettingCellOfCell.self)
        
        //        if let flowLayout = settingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        //            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        //        }
        
    }
    
    func setCell(displayList: [SettingViewCellType], tapAction: TapAction, useOfficialApp: UseOfficialAppFlagState) {
        self.displayList = displayList
        self.tapAction = tapAction
        self.useOfficialApp = useOfficialApp
        settingCollectionView.reloadData()
    }
    
}



extension SettingCollectionViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        displayList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SettingCellOfCell = collectionView.dequeueReusableCell(cellClass: SettingCellOfCell.self, indexPath: indexPath)
        switch displayList[indexPath.row] {
        case .edit(_):
            cell.setupCell(text: "編集")
        case .tapActionEdit(_):
            cell.setupCell(text: tapAction.rawValue)
        case .useOfficialAppFlag:
            cell.setupCell(text: useOfficialApp.rawValue)
        }
        return cell
        
    }
    
}

extension SettingCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let cell = settingCellHelper {
            switch displayList[indexPath.row] {
            case .edit(_):
                cell.setupCell(text: "編集")
            case .tapActionEdit(_):
                cell.setupCell(text: tapAction.rawValue)
            case .useOfficialAppFlag:
                cell.setupCell(text: useOfficialApp.rawValue)
            }
            return cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        }
        return .zero
    }
    
    // cell達の周囲の余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        
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

extension SettingCollectionViewCell: UICollectionViewDelegate {
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
        guard let view = delegate else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        switch displayList[indexPath.row] {
        
        case .edit(_):
            view.popupSettingView(cellType: displayList[indexPath.row], cell: cell)
        case .tapActionEdit(_):
            view.popupSettingView(cellType: displayList[indexPath.row], cell: cell)
        case .useOfficialAppFlag:
            useOfficialApp.toggle()
            settingCollectionView.reloadData()
            view.setUseOfficialAppFlag(useOfficialAppFlag: useOfficialApp)
        }
        
    }
    
}
