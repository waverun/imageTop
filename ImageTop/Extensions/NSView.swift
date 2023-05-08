import SwiftUI

extension NSView {
    func findSubview<T: NSView>(ofType type: T.Type) -> T? {
        for subview in subviews {
            if let subviewOfType = subview as? T {
                return subviewOfType
            }
            if let nestedSubview = subview.findSubview(ofType: type) {
                return nestedSubview
            }
        }
        return nil
    }
}
