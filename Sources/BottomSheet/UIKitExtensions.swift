#if canImport(UIKit)
import UIKit
extension UIView {
    var viewSafeAreaInsets: UIEdgeInsets {
        if #available(iOSApplicationExtension 11.0, *) {
            return safeAreaInsets
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    var viewSafeAreaLayoutGuide: UILayoutGuide {
        if #available(iOSApplicationExtension 11.0, *) {
            return safeAreaLayoutGuide
        } else {
            return layoutMarginsGuide
        }
    }
}
#endif
