#if canImport(UIKit)
import UIKit
extension UIView {
    var viewSafeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return safeAreaInsets
        } else  {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    var viewSafeAreaLayoutGuide: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide
        } else {
            return layoutMarginsGuide
        }
    }

    @available(iOS 11.0, *)
    private func roundCorners(corners: CACornerMask, _ value: CGFloat = 10) {
        self.clipsToBounds = false
        self.layer.cornerRadius = value
        self.layer.maskedCorners = corners
    }

    private func roundCorners(corners: UIRectCorner, _ value: CGFloat = 10) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: value * 2, height: value * 2)).cgPath
        layer.backgroundColor = UIColor.green.cgColor
        layer.mask = rectShape
    }

    func roundTopCorners(_ value: CGFloat = 10) {
        if #available(iOS 11.0, *) {
            roundCorners(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], value)
        } else {
            self.roundCorners(corners: [.topLeft, .topRight], value)
        }
    }
}
#endif
