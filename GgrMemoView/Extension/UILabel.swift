import UIKit

extension UILabel {
    func strikethrough(_ bool: Bool) {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.text ?? "")
        if bool {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        } else {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
        }
        self.attributedText = attributeString
    }
    
}
