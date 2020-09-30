import UIKit

extension UICollectionViewCell {
    func fitSize() -> CGSize {
        self.contentView.systemLayoutSizeFitting(
            CGSize(width: 0, height: 0),
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func fitSize(width: CGFloat) -> CGSize {
        self.contentView.systemLayoutSizeFitting(
            CGSize(width: width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}
