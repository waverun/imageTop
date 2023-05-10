import SwiftUI
import UniformTypeIdentifiers
import AppKit
import GameplayKit
import HotKey
//import KeyboardShortcuts

private func calculateWatchPosition(parentSize: CGSize) -> (CGFloat, CGFloat) {
    var seed = UInt64(Date().timeIntervalSince1970)
    let seedData = Data(bytes: &seed, count: MemoryLayout<UInt64>.size)
    let generator = GKARC4RandomSource(seed: seedData)

    let x = CGFloat(generator.nextUniform()) * (parentSize.width * 0.8 - parentSize.width * 0.2) + parentSize.width * 0.2
    let y = CGFloat(generator.nextUniform()) * (parentSize.height * 0.8 - parentSize.height * 0.2) + parentSize.height * 0.2
    
    return (x, y)
}

struct ContentView: View {
    @EnvironmentObject var customAppDelegate: CustomAppDelegate

    @NSApplicationDelegateAdaptor(CustomAppDelegate.self) var appDelegate

    @State private var hotkey: HotKey? = HotKey(key: .escape, modifiers: [.control, .command])

    @State private var testText: String = ""

    @AppStorage("replaceImageAfter") private var replaceImageAfter: TimeInterval = 10
    @AppStorage("selectedFolderPath") private var selectedFolderPath: String = ""
    @AppStorage("imageTopFolderBookmark") private var imageTopFolderBookmarkData: Data?
    @AppStorage("hotKeyString") private var hotKeyString: String = "escape"
    @AppStorage("modifierKeyString1") private var keyString1: String = "command"
    @AppStorage("modifierKeyString2") private var keyString2: String = "control"

    @State private var imageName: String?
    @State private var timer: Timer? = nil
    @State private var imageNames: [String] = []
//    @State private var imageFolder: String?
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

    
    init() {
        if let screenSize = NSScreen.main?.frame.size {
            let (xValue, yValue) = calculateWatchPosition(parentSize: screenSize)
            _x = State(initialValue: xValue)
            _y = State(initialValue: yValue)
        }
    }
    
    private func startAccessingFolder() {
        if let bookmarkData = imageTopFolderBookmarkData {
            do {
                var isStale = false
                let url = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
                if isStale {
                    print("Bookmark data is stale")
                } else {
                    if url.startAccessingSecurityScopedResource() {
                        print("Successfully accessed security-scoped resource")
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

    private func updateHotKey() {
        if let key = Key(string: hotKeyString) {
            var modifiers: NSEvent.ModifierFlags = []
            if let modifier = Keyboard.stringToModifier(keyString1) {
                modifiers.insert(modifier)
            }
            if let modifier = Keyboard.stringToModifier(keyString2) {
                modifiers.insert(modifier)
            }
            hotkey?.isPaused = true
            hotkey = HotKey(key: key, modifiers: modifiers)
            hotkey!.keyDownHandler = hotkeyPressed
        }
    }

    private func showApp() {
        setupScreenChangeTimer()
//        DispatchQueue.main.async {
//            NSApp.activate(ignoringOtherApps: true)
//            appDelegate.isMainWindowVisible = true
//            appDelegate.mainWindow?.center()
            NSWindow.setFullScreen()
//        }
    }

    private func hotkeyPressed() {
        print("hotkey pressed")
        showApp()
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
        if imageOrBackgroundChangeTimer == nil {
            imageOrBackgroundChangeTimer = Timer.scheduledTimer(withTimeInterval: replaceImageAfter, repeats: true) { [self] _ in
                changeScreenImageOrColor()
            }
        }
    }
    
    private func changeScreenImageOrColor() {
        _ = imageMode ? loadRandomImage() : changeBackgroundColor()
    }
        
    private func loadRandomImage() {
        print("loadRandomImage")
        var newRandomImageName: String? = nil
        repeat {
            newRandomImageName = imageNames.randomElement()
        } while newRandomImageName == imageName && showSecondImage
          || newRandomImageName == secondImageName && !showSecondImage
        
        if let randomImageName = newRandomImageName {
            let imageFolder = selectedFolderPath
            if showSecondImage {
                imageName = "\(imageFolder)/\(randomImageName)"
            } else {
                secondImageName = "\(imageFolder)/\(randomImageName)"
            }
            showSecondImage.toggle()
        }
    }

//    private func loadRandomImage() {
//        print("loadRandomImage")
//        if let randomImageName = imageNames.randomElement() {
//            let imageFolder = selectedFolderPath
//            if showSecondImage {
//                imageName = "\(imageFolder)/\(randomImageName)"
//            } else {
//                secondImageName = "\(imageFolder)/\(randomImageName)"
//            }
//            showSecondImage.toggle()
//        }
//    }
        
    private func hideApp() {
        NSWindow.exitFullScreen()

        if imageOrBackgroundChangeTimer == nil {
            return
        }
        print("hideApp")
        if gIgnoreHideCount > 0 {
            gIgnoreHideCount -= 1
            return
        }
//        appDelegate.mainWindow?.orderOut(nil)
//        appDelegate.isMainWindowVisible = false
        imageOrBackgroundChangeTimer?.invalidate()
        imageOrBackgroundChangeTimer = nil
    
    }
    
    private func loadImageNames() {
        let imageFolder = selectedFolderPath
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
            setupScreenChangeTimer()
            startAccessingFolder()
            NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .mouseMoved]) { event in
                hideApp()
                return event
            }
//            hotkey.keyDownHandler = hotkeyPressed
            updateHotKey()
        }
        .onChange(of: hotKeyString) { _ in
            updateHotKey()
        }
        .onChange(of: keyString1) { _ in
            updateHotKey()
        }
        .onChange(of: keyString2) { _ in
            updateHotKey()
        }
        .onChange(of: selectedFolderPath) { _ in
            startAccessingFolder()
        }
        .onDisappear {
            timer?.invalidate()
            imageOrBackgroundChangeTimer?.invalidate()
            if let url = URL(string: selectedFolderPath) {
                url.stopAccessingSecurityScopedResource()
            }
        }
        .onReceive(customAppDelegate.$showWindow, perform: { _ in
            setupScreenChangeTimer()
        })

    }
}
