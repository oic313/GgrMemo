import UIKit

final class SettingViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.widthAnchor.constraint(equalToConstant: 200).isActive = true

    }
    
    func setupCell(text: String) {
        label.text = text
    }

}
