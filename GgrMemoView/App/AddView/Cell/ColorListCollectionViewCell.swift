import UIKit
import GgrMemoUtility

class ColorListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var colorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.cornerRadius = colorView.frame.width/2
        //        self.layer.borderColor = ColorAsset.thin.color?.cgColor
    }
    
    func setupCell(color: ColorAsset) {
        colorView.backgroundColor = color.value
    }
}
