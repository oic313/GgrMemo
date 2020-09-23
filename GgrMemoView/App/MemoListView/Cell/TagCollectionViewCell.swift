import UIKit
import GgrMemoUtility
import GgrMemoPresenter

final class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
    }
    
    func setupCell(tag: Tag) {
        tagLabel.text = tag.displayValue
        self.applyCheckedState(isCecked: tag.isChecked, tagColor: tag.color)
    }
    
    func applyCheckedState(isCecked: Bool, tagColor: ColorAsset){
        if isCecked {
            self.backgroundColor = ColorAsset.thin.value
//            tagLabel.textColor = tagColor.value
        } else {
            self.backgroundColor = tagColor.value
//            tagLabel.textColor = ColorAsset.text.value
        }
        checkMark.isHidden = !isCecked
        tagLabel.hoge(isCecked)
    }
}
