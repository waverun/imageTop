import Cocoa
import SwiftUI

class CustomAppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.setFrame(NSScreen.main?.frame ?? NSRect.zero, display: true, animate: true)
        }
    }
}
