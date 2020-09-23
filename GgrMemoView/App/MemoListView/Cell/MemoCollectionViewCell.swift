import UIKit
import GgrMemoUtility
import GgrMemoPresenter

final class MemoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var checkMarkView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib() 
        self.layer.borderColor = ColorAsset.thin.value?.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    

    
    func setupCell(memo: Memo, color: ColorAsset) {
        memoLabel.text = memo.value
        memoLabel.hoge(false)
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
        memoLabel.hoge(isCecked)
    }
    
    
}

extension UILabel {
    func hoge(_ b: Bool) {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.text ?? "")

        if b {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))

        } else {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
        }
        self.attributedText = attributeString
    }
}
