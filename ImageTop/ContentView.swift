import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var imageName: String?
    @State private var timer: Timer? = nil
    @State private var inactivityDuration: TimeInterval = 1 // Set your predefined time (in seconds)
    @State private var imageNames: [String] = []
    @State private var imageFolder: String?

    private func loadRandomImage() {
        if let randomImageName = imageNames.randomElement(), let imageFolder = imageFolder {
            imageName = "\(imageFolder)/\(randomImageName)"
        }
    }

    private func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: inactivityDuration, repeats: false) { _ in
            DispatchQueue.main.async {
                self.loadRandomImage()
            }
        }
    }
    
    private func requestFolderAccess() {
        let openPanel = NSOpenPanel()
        openPanel.title = "Select the Downloads folder"
        openPanel.message = "Please select the Downloads folder to grant access."
        openPanel.allowedContentTypes = [UTType.folder]
        openPanel.allowsOtherFileTypes = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.begin { response in
            if response == .OK, let url = openPanel.url {
                do {
                    let bookmarkData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                    UserDefaults.standard.set(bookmarkData, forKey: "DownloadsFolderBookmark")
                    startAccessingDownloadsFolder()
                } catch {
                    print("Error creating security-scoped bookmark: \(error)")
                }
            }
        }
    }

//    private func requestFolderAccess() {
//            let openPanel = NSOpenPanel()
//            openPanel.title = "Select the Downloads folder"
//            openPanel.message = "Please select the Downloads folder to grant access."
//            openPanel.allowedFileTypes = ["none"]
//            openPanel.allowsOtherFileTypes = false
//            openPanel.canChooseFiles = false
//            openPanel.canChooseDirectories = true
//            openPanel.canCreateDirectories = false
//            openPanel.begin { response in
//                if response == .OK, let url = openPanel.url {
//                    do {
//                        let bookmarkData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
//                        UserDefaults.standard.set(bookmarkData, forKey: "DownloadsFolderBookmark")
//                        startAccessingDownloadsFolder()
//                    } catch {
//                        print("Error creating security-scoped bookmark: \(error)")
//                    }
//                }
//            }
//        }

    private func startAccessingDownloadsFolder() {
            if let bookmarkData = UserDefaults.standard.data(forKey: "DownloadsFolderBookmark") {
                do {
                    var isStale = false
                    let url = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
                    if isStale {
                        print("Bookmark data is stale")
                    } else {
                        if url.startAccessingSecurityScopedResource() {
                            imageFolder = url.path
                            loadImageNames()
                        } else {
                            print("Error accessing security-scoped resource")
                        }
                    }
                } catch {
                    print("Error resolving security-scoped bookmark: \(error)")
                }
            }
        }

//    private func requestFolderAccess() {
//        let openPanel = NSOpenPanel()
//        openPanel.title = "Select the Downloads folder"
//        openPanel.message = "Please select the Downloads folder to grant access."
//        openPanel.allowedFileTypes = ["none"]
//        openPanel.allowsOtherFileTypes = false
//        openPanel.canChooseFiles = false
//        openPanel.canChooseDirectories = true
//        openPanel.canCreateDirectories = false
//        openPanel.begin { response in
//            if response == .OK, let url = openPanel.url {
//                UserDefaults.standard.set(url, forKey: "DownloadsFolderURL")
//                imageFolder = url.path
//                loadImageNames()
//            }
//        }
//    }

    private func loadImageNames() {
        if let imageFolder = imageFolder {
            let folderURL = URL(fileURLWithPath: imageFolder)
            let fileManager = FileManager.default
            do {
                let contents = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                imageNames = contents.compactMap { $0.pathExtension.lowercased() == "jpg" || $0.pathExtension.lowercased() == "png" ? $0.lastPathComponent : nil }
                loadRandomImage()
            } catch {
                print("Error loading image names: \(error)")
            }
        }
    }

    var body: some View {
        ZStack {
            if let imageName = imageName {
                Image(nsImage: NSImage(contentsOfFile: imageName)!)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            if UserDefaults.standard.data(forKey: "DownloadsFolderBookmark") != nil {
                startAccessingDownloadsFolder()
            } else {
                requestFolderAccess()
            }
            //            if let url = UserDefaults.standard.url(forKey: "DownloadsFolderURL") {
//                imageFolder = url.path
//                loadImageNames()
//            } else {
//                requestFolderAccess()
//            }
            resetTimer()
            NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .mouseMoved]) { event in
                if imageName != nil {
                    imageName = nil
                }
                resetTimer()
                return event
            }
        }
        .onDisappear {
            timer?.invalidate()
            if let url = URL(string: imageFolder ?? "") {
                url.stopAccessingSecurityScopedResource()
            }
            
        }
    }
}

//import SwiftUI
//
//struct ContentView: View {
//    @State private var imageName: String?
//    @State private var timer: Timer? = nil
//    @State private var inactivityDuration: TimeInterval = 1 // Set your predefined time (in seconds)
//    @State private var imageNames: [String] = []
//    @State private var imageFolder: String?
//
//    private func loadRandomImage() {
//        if let randomImageName = imageNames.randomElement(), let imageFolder = imageFolder {
//            imageName = "\(imageFolder)/\(randomImageName)"
//        }
//    }
//
//    private func resetTimer() {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: inactivityDuration, repeats: false) { _ in
//            DispatchQueue.main.async {
//                self.loadRandomImage()
//            }
//        }
//    }
//
//    private func requestFolderAccess() {
//        let openPanel = NSOpenPanel()
//        openPanel.title = "Select the Downloads folder"
//        openPanel.message = "Please select the Downloads folder to grant access."
//        openPanel.allowedFileTypes = ["none"]
//        openPanel.allowsOtherFileTypes = false
//        openPanel.canChooseFiles = false
//        openPanel.canChooseDirectories = true
//        openPanel.canCreateDirectories = false
//        openPanel.begin { response in
//            if response == .OK, let url = openPanel.url {
//                imageFolder = url.path
//                loadImageNames()
//            }
//        }
//    }
//
//    private func loadImageNames() {
//        if let imageFolder = imageFolder {
//            let folderURL = URL(fileURLWithPath: imageFolder)
//            let fileManager = FileManager.default
//            do {
//                let contents = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//                imageNames = contents.compactMap { $0.pathExtension.lowercased() == "jpg" || $0.pathExtension.lowercased() == "png" ? $0.lastPathComponent : nil }
//                loadRandomImage()
//            } catch {
//                print("Error loading image names: \(error)")
//            }
//        }
//    }
//
//    var body: some View {
//        ZStack {
//            if let imageName = imageName {
//                Image(nsImage: NSImage(contentsOfFile: imageName)!)
//                    .resizable()
//                    .scaledToFill()
//                    .edgesIgnoringSafeArea(.all)
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .onAppear {
//            requestFolderAccess()
//            resetTimer()
//            NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .mouseMoved]) { event in
//                if imageName != nil {
//                    imageName = nil
//                }
//                resetTimer()
//                return event
//            }
//        }
//        .onDisappear {
//            timer?.invalidate()
//        }
//    }
//}

//import SwiftUI
//
//struct ContentView: View {
//    @State private var imageName: String?
//    @State private var timer: Timer? = nil
//    @State private var inactivityDuration: TimeInterval = 1 // Set your predefined time (in seconds)
//    @State private var imageNames: [String] = []
//
//    let imageFolder = "/Users/shy/Downloads"
//
//    private func loadRandomImage() {
//        if let randomImageName = imageNames.randomElement() {
//            imageName = randomImageName
//        }
//    }
//
//    private func resetTimer() {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: inactivityDuration, repeats: false) { _ in
//            DispatchQueue.main.async {
//                self.loadRandomImage()
//            }
//        }
//    }
//
//    var body: some View {
//        ZStack {
//            if let imageName = imageName {
//                Image(nsImage: NSImage(contentsOfFile: "\(imageFolder)/\(imageName)")!)
//                    .resizable()
//                    .scaledToFill()
//                    .edgesIgnoringSafeArea(.all)
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .onAppear {
//            let folderURL = URL(fileURLWithPath: imageFolder) // Use imageFolder as the full path
//            let fileManager = FileManager.default
//            do {
//                let contents = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//                imageNames = contents.compactMap { $0.pathExtension.lowercased() == "jpg" || $0.pathExtension.lowercased() == "png" ? $0.lastPathComponent : nil }
//                loadRandomImage()
//            } catch {
//                print("Error loading image names: \(error)")
//            }
//
//            resetTimer()
//            NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .mouseMoved]) { event in
//                if imageName != nil {
//                    imageName = nil
//                }
//                resetTimer()
//                return event
//            }
//        }
//        .onDisappear {
//            timer?.invalidate()
//        }
//    }
//}

//import SwiftUI
//
//struct ContentView: View {
//    @State private var showImage = false
//    @State private var timer: Timer? = nil
//    @State private var inactivityDuration: TimeInterval = 5 // Set your predefined time (in seconds)
//
//    private func resetTimer() {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: inactivityDuration, repeats: false) { _ in
//            DispatchQueue.main.async {
//                self.showImage = true
//            }
//        }
//    }
//
//    var body: some View {
//        ZStack {
//            if showImage {
//                Image("cockpit") // Replace with your image name
//                    .resizable()
//                    .scaledToFill()
//                    .edgesIgnoringSafeArea(.all)
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .onAppear {
//            resetTimer()
//            NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .mouseMoved]) { event in
//                if self.showImage {
//                    self.showImage = false
//                }
//                self.resetTimer()
//                return event
//            }
//        }
//        .onDisappear {
//            timer?.invalidate()
//        }
//    }
//}

//import SwiftUI
//
//struct ContentView: View {
//    @State private var showImage = false
//    @State private var timer: Timer? = nil
//    @State private var inactivityDuration: TimeInterval = 1 // Set your predefined time (in seconds)
//
//    private func resetTimer() {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: inactivityDuration, repeats: false) { _ in
//            DispatchQueue.main.async {
//                self.showImage = true
//            }
//        }
//    }
//
//    var body: some View {
//        ZStack {
//            if showImage {
//                Image("cockpit") // Replace with your image name
//                    .resizable()
//                    .scaledToFill()
//                    .edgesIgnoringSafeArea(.all)
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .onAppear {
//            resetTimer()
//            NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .mouseMoved]) { event in
//                if self.showImage {
//                    self.showImage = false
//                    self.resetTimer()
//                }
//                return event
//            }
//        }
//        .onDisappear {
//            timer?.invalidate()
//        }
//    }
//}

////
////  ContentView.swift
////  ImageTop
////
////  Created by Shay  on 05/05/2023.
////
//
//import SwiftUI
//import CoreData
//
//struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
