import UIKit
import GgrMemoUtility
import GgrMemoPresenter

final class MemoCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var memoLabel: UILabel!
    @IBOutlet private weak var colorView: UIView!
    @IBOutlet private weak var checkMarkView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib() 
        self.layer.borderColor = ColorAsset.thin.value?.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    func setupCell(memo: Memo, color: ColorAsset) {
        memoLabel.text = memo.value
        memoLabel.strikethrough(false)
        colorView.backgroundColor = color.value
        self.applyCheckedState(isCecked: memo.isChecked)
    }
    
    func applyCheckedState(isCecked: Bool){
        if isCecked {
            memoLabel.textColor = ColorAsset.thin.value
        } else {
            memoLabel.textColor = ColorAsset.text.value
        }
        checkMarkView.isHidden = !isCecked
        memoLabel.strikethrough(isCecked)
    }
    
    
}
