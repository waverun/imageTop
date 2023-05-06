import SwiftUI
import UniformTypeIdentifiers
import AppKit

struct ContentView: View {
    @State private var imageName: String?
    @State private var timer: Timer? = nil
    @State private var inactivityDuration: TimeInterval = 10 // Set your predefined time (in seconds)
    @State private var imageNames: [String] = []
    @State private var imageFolder: String?
    @State private var imageOrBackgroundChangeTimer: Timer? = nil
    @State private var backgroundColor: Color = Color.white
    @State private var imageMode = true
    @State private var fadeColor: Color = Color.clear
    @State private var showFadeColor: Bool = false
    
    private func randomGentleColor() -> Color {
        let colors: [Color] = [
            Color(red: 0.96, green: 0.52, blue: 0.49),
            Color(red: 0.96, green: 0.81, blue: 0.48),
            Color(red: 0.53, green: 0.84, blue: 0.71),
            Color(red: 0.48, green: 0.57, blue: 0.87),
            Color(red: 0.74, green: 0.54, blue: 0.86),
            Color(red: 0.91, green: 0.46, blue: 0.85),
            Color(red: 0.98, green: 0.63, blue: 0.45),
            Color(red: 0.98, green: 0.84, blue: 0.45),
            Color(red: 0.84, green: 0.98, blue: 0.45),
            Color(red: 0.45, green: 0.98, blue: 0.83),
            Color(red: 0.45, green: 0.74, blue: 0.98),
            Color(red: 0.78, green: 0.45, blue: 0.98)
        ]
        
        return colors.randomElement() ?? Color.white
    }
    
    private func changeBackgroundColor() {
        imageName = nil
        let newColor = randomGentleColor()
        fadeColor = newColor
        
        showFadeColor = true
    }
        
    private func setupScreenChangeTimer() {
        imageOrBackgroundChangeTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [self] _ in
            changeScreenImageOrColor()
        }
    }
    
    private func changeScreenImageOrColor() {
        _ = imageMode ? loadRandomImage() : changeBackgroundColor()
    }
    
    private func loadRandomImage() {
        print("loadRandomImage")
        if let randomImageName = imageNames.randomElement(), let imageFolder = imageFolder {
            imageName = "\(imageFolder)/\(randomImageName)"
        }
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: inactivityDuration, repeats: false) { _ in
            DispatchQueue.main.async {
                //                self.loadRandomImage()
                changeScreenImageOrColor()
            }
        }
    }
    
    private func exitApp() {
        NSApplication.shared.terminate(self)
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
    
    private func loadImageNames() {
        if let imageFolder = imageFolder {
            let folderURL = URL(fileURLWithPath: imageFolder)
            let fileManager = FileManager.default
            do {
                let contents = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                imageNames = contents.compactMap { $0.pathExtension.lowercased() == "jpg" || $0.pathExtension.lowercased() == "png" ? $0.lastPathComponent : nil }
                imageMode = imageNames.count >= 2
                changeScreenImageOrColor()
            } catch {
                print("Error loading image names: \(error)")
            }
        }
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .opacity(showFadeColor ? 0 : 1)
                .edgesIgnoringSafeArea(.all)
                .animation(.linear(duration: 1))
            
            fadeColor
                .opacity(showFadeColor ? 1 : 0)
                .edgesIgnoringSafeArea(.all)
                .animation(.linear(duration: 1))
            
            if let imageName = imageName {
                Image(nsImage: NSImage(contentsOfFile: imageName)!)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: showFadeColor) { _ in
            withAnimation(.linear(duration: 1)) {
                backgroundColor = backgroundColor
                fadeColor = fadeColor
            }
        }
        .onAppear {
            
            if UserDefaults.standard.data(forKey: "DownloadsFolderBookmark") != nil {
                startAccessingDownloadsFolder()
            } else {
                requestFolderAccess()
            }
            resetTimer()
            setupScreenChangeTimer()
            NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .mouseMoved]) { event in
                exitApp()
                return event
                //                if imageName != nil {
                //                    imageName = nil
                //                }
                //                resetTimer()
                //                return event
            }
        }
        .onDisappear {
            timer?.invalidate()
            imageOrBackgroundChangeTimer?.invalidate()
            if let url = URL(string: imageFolder ?? "") {
                url.stopAccessingSecurityScopedResource()
            }
            
        }
    }
}
