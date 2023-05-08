import SwiftUI
import UniformTypeIdentifiers
import AppKit
import GameplayKit
import HotKey

private func calculateWatchPosition(parentSize: CGSize) -> (CGFloat, CGFloat) {
    var seed = UInt64(Date().timeIntervalSince1970)
    let seedData = Data(bytes: &seed, count: MemoryLayout<UInt64>.size)
    let generator = GKARC4RandomSource(seed: seedData)

    let x = CGFloat(generator.nextUniform()) * (parentSize.width * 0.8 - parentSize.width * 0.2) + parentSize.width * 0.2
    let y = CGFloat(generator.nextUniform()) * (parentSize.height * 0.8 - parentSize.height * 0.2) + parentSize.height * 0.2
    
    return (x, y)
}

struct ContentView: View {
    let hotkey = HotKey(key: .escape, modifiers: [.control, .command])
    let onMainWindowHide: (() -> Void)?

    @State private var testText: String = ""

//    @AppStorage("inactivityDuration") private var inactivityDuration: TimeInterval = 120
    @AppStorage("replaceImageAfter") private var replaceImageAfter: TimeInterval = 10
    @AppStorage("selectedFolderPath") private var selectedFolderPath: String = ""

    @State private var imageName: String?
    @State private var timer: Timer? = nil
    @State private var imageNames: [String] = []
    @State private var imageFolder: String?
    @State private var imageOrBackgroundChangeTimer: Timer? = nil
    @State private var backgroundColor: Color = Color.white
    @State private var imageMode = true
    @State private var fadeColor: Color = Color.clear
    @State private var showFadeColor: Bool = false
    @State private var secondImageName: String?
    @State private var showSecondImage: Bool = false
    @State private var x: CGFloat = {
        if let screenSize = NSScreen.main?.frame.size {
            return calculateWatchPosition(parentSize: screenSize).0
        }
        return 0
    }()

    @State private var y: CGFloat = {
        if let screenSize = NSScreen.main?.frame.size {
            return calculateWatchPosition(parentSize: screenSize).1
        }
        return 0
    }()

    
    init(onMainWindowHide: @escaping () -> Void = {}) {
        self.onMainWindowHide = onMainWindowHide

        if let screenSize = NSScreen.main?.frame.size {
            let (xValue, yValue) = calculateWatchPosition(parentSize: screenSize)
            _x = State(initialValue: xValue)
            _y = State(initialValue: yValue)
        }
    }
    
    private func hotkeyPressed() {
        print("hotkey pressed")
    }
    
    private func resetImageOrBackgroundChangeTimer() {
        imageOrBackgroundChangeTimer?.invalidate()
        setupScreenChangeTimer()
    }

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

        withAnimation(.linear(duration: 1)) {
            showFadeColor.toggle()
        }
    }
        
    private func setupScreenChangeTimer() {
        imageOrBackgroundChangeTimer = Timer.scheduledTimer(withTimeInterval: replaceImageAfter, repeats: true) { [self] _ in
            changeScreenImageOrColor()
        }
    }
    
    private func changeScreenImageOrColor() {
        _ = imageMode ? loadRandomImage() : changeBackgroundColor()
    }
        
    private func loadRandomImage() {
        print("loadRandomImage")
        if let randomImageName = imageNames.randomElement(), let imageFolder = imageFolder {
            if showSecondImage {
                imageName = "\(imageFolder)/\(randomImageName)"
            } else {
                secondImageName = "\(imageFolder)/\(randomImageName)"
            }
            showSecondImage.toggle()
        }
    }

//    private func resetTimer() {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: inactivityDuration, repeats: false) { _ in
//            DispatchQueue.main.async {
//                changeScreenImageOrColor()
//            }
//        }
//    }
    
    private func hideApp() {
        onMainWindowHide?()
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
        GeometryReader { geometry in
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                fadeColor
                    .opacity(showFadeColor ? 1 : 0)
                    .edgesIgnoringSafeArea(.all)
    
                if let imageName = imageName {
                    Image(nsImage: NSImage(contentsOfFile: imageName)!)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .opacity(showSecondImage ? 0 : 1)
                        .animation(.linear(duration: 1), value: showSecondImage)
                }
                
                if let secondImageName = secondImageName {
                    Image(nsImage: NSImage(contentsOfFile: secondImageName)!)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .opacity(showSecondImage ? 1 : 0)
                        .animation(.linear(duration: 1), value: showSecondImage)
                }
                
                DigitalWatchView(x: x, y: y)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: replaceImageAfter) { newValue in
            resetImageOrBackgroundChangeTimer()
        }
        .onAppear {
            if UserDefaults.standard.data(forKey: "DownloadsFolderBookmark") != nil {
                startAccessingDownloadsFolder()
            } else {
                requestFolderAccess()
            }
//            resetTimer()
            setupScreenChangeTimer()
            
            NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .mouseMoved]) { event in
                hideApp()
                return event
            }
            hotkey.keyDownHandler = hotkeyPressed
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
