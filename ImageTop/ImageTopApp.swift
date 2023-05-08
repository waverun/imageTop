import SwiftUI

@main
struct ImageTopApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var appDelegate = CustomAppDelegate() // Add this line

    var body: some Scene {
        @NSApplicationDelegateAdaptor(CustomAppDelegate.self) var appDelegate

        WindowGroup {
            ContentView(
//                onMainWindowHide: {
//                if gIgnoreHideCount > 0 {
//                    gIgnoreHideCount -= 1
//                    return
//                }
//                appDelegate.mainWindow?.orderOut(nil)
//                print("d1: onMainWindowHide")
//            }
            )
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .background(WindowAccessor { window in
                appDelegate.mainWindow = window
            })
        }
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

