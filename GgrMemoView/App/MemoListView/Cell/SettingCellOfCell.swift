import UIKit
import GgrMemoUtility
import GgrMemoPresenter

final class SettingCellOfCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = label.frame.height/3
        self.layer.masksToBounds = true
        self.layer.borderColor = ColorAsset.thin.value?.cgColor
        self.layer.borderWidth = 1
    }
    
    func setupCell(text: String) {
        label.text = text
    }

}
