import UIKit
import GgrMemoUtility

final class TagListCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(tag: Tag) {
        tagLabel.text = tag.value
    }

}
