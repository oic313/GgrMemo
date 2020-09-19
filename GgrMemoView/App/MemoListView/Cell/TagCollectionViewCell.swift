import UIKit
import GgrMemoUtility
import GgrMemoPresenter

final class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 30).isActive = true
        
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
    }
    
    func setupCell(tag: Tag) {
        tagLabel.text = tag.displayValue
        self.backgroundColor = tag.color.value
    }

}
