import UIKit

final class CustomPresentationController: UIPresentationController {
    
    var rect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        CGSize(width: 300, height: 300)
    }
    
    // 呼び出し先のView Controllerのframeを返す
    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect()
        let containerBounds = containerView!.bounds
        let childContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
        presentedViewFrame.size = childContentSize
        presentedViewFrame.center.x = rect.center.x
        presentedViewFrame.center.y = rect.center.y + UIApplication.shared.statusBarFrame.height
        return presentedViewFrame
    }
    
}
