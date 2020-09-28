import UIKit
import GgrMemoUtility
import GgrMemoPresenter

final class AddMemoCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var memoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.layer.borderColor = ColorAsset.thin.value?.cgColor
    }
    
    func setupCell(memo: Memo, color: ColorAsset) {
        memoLabel.text = memo.value
        self.backgroundColor = color.value
    }
    
    func applySelectionState(color: ColorAsset) {
        if isSelected {
            self.layer.borderWidth = 1
            self.backgroundColor = ColorAsset.main.value
        } else {
            self.layer.borderWidth = 0
            self.backgroundColor = color.value
        }
    }

}
