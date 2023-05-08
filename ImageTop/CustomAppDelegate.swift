import Cocoa
import SwiftUI

var gIgnoreHideCount = 0

class CustomAppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    @Published var isMainWindowVisible: Bool = true // Add this line

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
        
        // Initialize settings window
        settingsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        settingsWindow.contentView = NSHostingView(rootView: SettingsView())
        settingsWindow.title = "Settings"
        settingsWindow.level = .floating
        settingsWindow.center()
        
        // Maximize the main window
        if let window = NSApplication.shared.windows.first {
            window.setFrame(NSScreen.main?.frame ?? NSRect.zero, display: true, animate: true)
        }
    }

    @objc func showMainWindow() {
        mainWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        gIgnoreHideCount = 2
        print("d1: showMainWindow")
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
    
    @objc func openSettings(sender: AnyObject) {
        settingsWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        settingsWindow.makeFirstResponder(nil)
    }
}
