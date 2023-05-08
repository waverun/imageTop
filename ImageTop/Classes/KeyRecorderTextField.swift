////import AppKit
////
////class KeyRecorderTextField: NSTextField {
////    var keyDownHandler: ((NSEvent) -> Void)?
////
////    override func keyDown(with event: NSEvent) {
////        keyDownHandler?(event)
////    }
////}
//
//import AppKit
//
//protocol KeyRecorderTextFieldDelegate: AnyObject {
//    func keyRecorderTextField(_ textField: KeyRecorderTextField, didReceiveKeyDown event: NSEvent)
//}
//
//class KeyRecorderTextField: NSTextField {
//    weak var keyRecorderDelegate: KeyRecorderTextFieldDelegate?
//
//    override func keyDown(with event: NSEvent) {
//        keyRecorderDelegate?.keyRecorderTextField(self, didReceiveKeyDown: event)
//    }
//}
