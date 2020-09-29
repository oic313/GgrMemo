import GgrMemoUtility
import GgrMemoPresenter
import UIKit

enum Direction {
    case right
    case left
}

protocol TapActionView: AnyObject {
    func tapedAction(action: TapAction, memo: Memo)
}

final class ButtonViewController: UIViewController {
    
    @IBOutlet private weak var sXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var lXConstraint: NSLayoutConstraint!
    private let direction: Direction
    private let memo: Memo
    weak var delegate: TapActionView?
    
    public init(direction: Direction, memo: Memo){
        self.direction = direction
        self.memo = memo
        super.init(nibName: nil, bundle: Bundle(for: Self.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func tapCheck(_ sender: Any) {
        guard let delegate = delegate else { return }
        dismiss(animated: false, completion: nil)
        delegate.tapedAction(action: .checked, memo: memo)
    }
    
    @IBAction func tapEdit(_ sender: Any) {
        guard let delegate = delegate else { return }
        dismiss(animated: false, completion: nil)
        delegate.tapedAction(action: .edit, memo: memo)
    }
    
    @IBAction func tapSearch(_ sender: Any) {
        guard let delegate = delegate else { return }
        self.dismiss(animated: false, completion: nil)
        delegate.tapedAction(action: .search, memo: memo)
    }
    
    @IBAction func tapSearchTwitter(_ sender: Any) {
        guard let delegate = delegate else { return }
        dismiss(animated: false, completion: nil)
        delegate.tapedAction(action: .searchOnTwitter, memo: memo)
    }
    
    @IBAction func tapSearchYoutube(_ sender: Any) {
        guard let delegate = delegate else { return }
        dismiss(animated: false, completion: nil)
        delegate.tapedAction(action: .searchOnYoutube, memo: memo)
    }
    
}

private extension ButtonViewController {
    func configure() {
        if case .left = direction {
            sXConstraint.constant = -sXConstraint.constant
            mXConstraint.constant = -mXConstraint.constant
            lXConstraint.constant = -lXConstraint.constant
        }
    }
}
