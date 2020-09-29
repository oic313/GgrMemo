import UIKit
import GgrMemoUtility

extension UICollectionView {
    
    func registerCell(cellClass: UICollectionViewCell.Type){
        self.register(UINib(nibName: cellClass.className, bundle: Bundle(for:cellClass.self)), forCellWithReuseIdentifier: cellClass.className)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(cellClass: UICollectionViewCell.Type, indexPath: IndexPath) -> T {
        self.dequeueReusableCell(withReuseIdentifier: cellClass.className, for: indexPath) as! T
    }

    func nowPosition(cell: UICollectionViewCell) -> CGRect {
        let point = CGPoint(x: cell.frame.origin.x - self.contentOffset.x, y: cell.frame.origin.y - self.contentOffset.y)
        let size = cell.bounds.size
        return CGRect(x: point.x, y: point.y, width: size.width, height: size.height)
    }
}
