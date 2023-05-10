import AppKit

extension NSWindow {
    static private func setOrExitFullScreen(exit: Bool) {
        if let window = NSApplication.shared.windows.first {
           let isFullScreen = window.styleMask.contains(.fullScreen)
            if isFullScreen && exit || !isFullScreen && !exit {
                window.toggleFullScreen(nil)
            }
        }
    }
    
    static public func setFullScreen() {
        setOrExitFullScreen(exit: false)
    }
    
    static public func exitFullScreen() {
        setOrExitFullScreen(exit: true)
    }

}
