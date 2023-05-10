import SwiftUI

@main
struct ImageTopApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var appDelegate = CustomAppDelegate() // Add this line

    var body: some Scene {
        @NSApplicationDelegateAdaptor(CustomAppDelegate.self) var appDelegate

        WindowGroup {
            ContentView()
            .environmentObject(appDelegate) // Add this line
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .background(WindowAccessor { window in
                appDelegate.mainWindow = window
                window.delegate = appDelegate // Set the delegate
                window.setFrame(NSScreen.main?.frame ?? NSRect.zero, display: false, animate: false) // Set initial frame
            })
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}

struct WindowAccessor: NSViewRepresentable {
    let callback: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async { [weak view] in
            if let window = view?.window {
                self.callback(window)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

