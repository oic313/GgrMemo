import UIKit
import GgrMemoUtility

extension UICollectionView {
    
    func registerCell(cellClass: UICollectionViewCell.Type){
        self.register(UINib(nibName: cellClass.className, bundle: Bundle(for:cellClass.self)), forCellWithReuseIdentifier: cellClass.className)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(cellClass: UICollectionViewCell.Type, indexPath: IndexPath) -> T {
        self.dequeueReusableCell(withReuseIdentifier: cellClass.className, for: indexPath) as! T
    }
}
