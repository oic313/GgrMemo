import UIKit
import GgrMemoUtility

class ColorListCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var colorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = colorView.frame.width/2
    }
    
    func setupCell(color: ColorAsset) {
        colorView.backgroundColor = color.value
    }
}
