import UIKit

final class ButtonViewController: UIViewController {

    @IBOutlet private weak var sXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var lXConstraint: NSLayoutConstraint!
    
    public init(){
        super.init(nibName: nil, bundle: Bundle(for: Self.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sXConstraint.constant = -sXConstraint.constant
        mXConstraint.constant = -mXConstraint.constant
        lXConstraint.constant = -lXConstraint.constant


    }

    @IBAction func tapCancel(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
