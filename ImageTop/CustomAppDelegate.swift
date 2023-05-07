import Cocoa
import SwiftUI

class CustomAppDelegate: NSObject, NSApplicationDelegate {
    var mainWindow: NSWindow?
    var statusBarItem: NSStatusItem!
    var settingsWindow: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        mainWindow = NSApplication.shared.windows.first
        if let window = mainWindow {
            window.setFrame(NSScreen.main?.frame ?? NSRect.zero, display: true, animate: true)
        }
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusBarItem.button {
            button.image = NSImage(systemSymbolName: "display.2", accessibilityDescription: "Settings")
        }
        
        // Create the menu
        let menu = NSMenu()
        menu.addItem(withTitle: "Show", action: #selector(showMainWindow), keyEquivalent: "")
        menu.addItem(withTitle: "Settings", action: #selector(openSettings), keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        
        // Assign the menu to the status bar item
        statusBarItem.menu = menu
        
        //        // Add status bar icon
        //        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        //        if let button = statusBarItem.button {
        //            button.image = NSImage(systemSymbolName: "display.2", accessibilityDescription: "Settings")
        //            button.action = #selector(statusBarButtonClicked)
        //        }
        
        // Initialize settings window
        settingsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        settingsWindow.contentView = NSHostingView(rootView: SettingsView())
        settingsWindow.title = "Settings"
        settingsWindow.center()
        
        // Maximize the main window
        if let window = NSApplication.shared.windows.first {
            window.setFrame(NSScreen.main?.frame ?? NSRect.zero, display: true, animate: true)
        }
    }

    @objc func showMainWindow() {
        mainWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
    
    @objc func openSettings(sender: AnyObject) {
        settingsWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

//import Cocoa
//import SwiftUI
//
//class CustomAppDelegate: NSObject, NSApplicationDelegate {
//    func applicationDidFinishLaunching(_ notification: Notification) {
//        if let window = NSApplication.shared.windows.first {
//            window.setFrame(NSScreen.main?.frame ?? NSRect.zero, display: true, animate: true)
//        }
//    }
//}
