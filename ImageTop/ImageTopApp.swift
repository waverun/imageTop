import SwiftUI

@main
struct ImageTopApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        @NSApplicationDelegateAdaptor(CustomAppDelegate.self) var appDelegate

        WindowGroup {
            ContentView()
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

//import SwiftUI
//
//@main
//struct ImageTopApp: App {
//    let persistenceController = PersistenceController.shared
//
//    var body: some Scene {
//        @NSApplicationDelegateAdaptor(CustomAppDelegate.self) var appDelegate
//
//        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
//    }
//}
