import UIKit
import GgrMemoUtility
import GgrMemoPresenter

final class MemoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var checkMarkView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width/2 - 30).isActive = true
        
        self.layer.borderColor = ColorAsset.thin.value?.cgColor
        self.layer.borderWidth = 1
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
        checkMarkView.isHidden = !isCecked
        memoLabel.hoge(isCecked)
    }
    
    
}

extension UILabel {
    func hoge(_ b: Bool) {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.text ?? "")

        if b {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorAsset.thin.value! , range: NSMakeRange(0, attributeString.length))

        } else {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorAsset.text.value! , range: NSMakeRange(0, attributeString.length))

        }
        self.attributedText = attributeString
    }
}
