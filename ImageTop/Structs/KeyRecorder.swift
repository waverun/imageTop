//import SwiftUI
//import AppKit
//import KeyboardShortcuts
//
//struct KeyRecorder: NSViewRepresentable {
//    @Binding var keyString: String
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeNSView(context: Context) -> KeyRecorderTextField {
//        let textField = KeyRecorderTextField()
//        textField.keyRecorderDelegate = context.coordinator
//        textField.stringValue = keyString
//        textField.alignment = .center
//        textField.isBordered = true
//        textField.bezelStyle = .squareBezel
//        return textField
//    }
//
//    func updateNSView(_ nsView: KeyRecorderTextField, context: Context) {
//        nsView.stringValue = keyString
//    }
//
//    class Coordinator: NSObject, KeyRecorderTextFieldDelegate {
//        var parent: KeyRecorder
//
//        init(_ parent: KeyRecorder) {
//            self.parent = parent
//        }
//
//        func keyRecorderTextField(_ textField: KeyRecorderTextField, didReceiveKeyDown event: NSEvent) {
//            if let characters = event.charactersIgnoringModifiers {
//                parent.keyString = characters.uppercased()
//            }
//        }
//    }
//}
//
////import SwiftUI
////
////struct KeyRecorder: NSViewRepresentable {
////    @Binding var keyString: String
////    @FocusState private var isKeyRecorderFocused: Bool
////
////    func makeCoordinator() -> Coordinator {
////        Coordinator(self)
////    }
////
////    func makeNSView(context: Context) -> KeyRecorderTextField {
////        let textField = KeyRecorderTextField()
////        textField.keyDownHandler = context.coordinator.handleKeyDown(_:)
////        return textField
////    }
////
////    func updateNSView(_ nsView: KeyRecorderTextField, context: Context) {
////        if isKeyRecorderFocused {
////            nsView.becomeFirstResponder()
////        }
////    }
////
////    class Coordinator: NSObject {
////        var parent: KeyRecorder
////
////        init(_ parent: KeyRecorder) {
////            self.parent = parent
////        }
////
////        func handleKeyDown(_ event: NSEvent) {
////            if let characters = event.charactersIgnoringModifiers {
////                parent.keyString = characters.uppercased()
////            }
////        }
////    }
////}
//
////import SwiftUI
////import HotKey
////import AppKit
//////import Carbon
////
////struct KeyRecorder: NSViewRepresentable {
////    @Binding var keyString: String
////
////    func makeCoordinator() -> Coordinator {
////        Coordinator(self)
////    }
////
////    func makeNSView(context: Context) -> KeyRecorderTextField {
////        let textField = KeyRecorderTextField()
////        textField.delegate = context.coordinator
////        textField.isEditable = false
////        textField.stringValue = keyString
////        textField.keyDownHandler = { event in
////            if let key = Key(carbonKeyCode: UInt32(event.keyCode)) {
////                DispatchQueue.main.async {
////                    self.keyString = key.description
////                }
////            }
////        }
////        return textField
////    }
////
////    func updateNSView(_ nsView: KeyRecorderTextField, context: Context) {
////        nsView.stringValue = keyString
////    }
////
////    class Coordinator: NSObject, NSTextFieldDelegate {
////        var parent: KeyRecorder
////
////        init(_ textField: KeyRecorder) {
////            self.parent = textField
////        }
////    }
////}
