import SwiftUI

@main
struct ImageTopApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        @NSApplicationDelegateAdaptor(CustomAppDelegate.self) var appDelegate

        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
