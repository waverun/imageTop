import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
//    @AppStorage("inactivityDuration") private var inactivityDuration: TimeInterval = 120
    @AppStorage("replaceImageAfter") private var replaceImageAfter: TimeInterval = 10
    @AppStorage("selectedFolderPath") private var selectedFolderPath: String = ""
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .padding()
            
            GeometryReader { geometry in
                Form {
                    VStack {
                        HStack {
                            Text("Hotkey")
                                .frame(width: geometry.size.width * 0.33, alignment: .leading)
                            KeyboardShortcuts.Recorder(for: .init("showHideApp"))
                                .frame(width: 120)
                            Spacer()
                        }.padding(.leading)
                        HStack {
                            Text("Replace Image After")
                                .frame(width: geometry.size.width * 0.635, alignment: .leading)
                            FocusableTextField(text: Binding(get: {
                                String(replaceImageAfter)
                            }, set: { newValue in
                                if let value = TimeInterval(newValue) {
                                    replaceImageAfter = value
                                }
                            }), formatter: NumberFormatter())
                                .multilineTextAlignment(.trailing)
                                .frame(width: 50
                                )
                            Spacer()
                        }.padding(.leading)
                        HStack {
                            Text("Image Folder")
                                .frame(width: geometry.size.width * 0.58, alignment: .leading)
                            Button("Select...") {
                                openFolderPicker()
                            }
                            Spacer()
                        }.padding(.leading)
                        
                        Text(selectedFolderPath)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                }
            }
        }
        .frame(width: 245, height: 200)
        .allowsHitTesting(true) // Add this modifier
        .onAppear {
            DispatchQueue.main.async {
                if let textField = NSApp.keyWindow?.firstResponder as? NSTextField {
                    textField.becomeFirstResponder()
                } else {
                    if let firstTextField = NSApp.keyWindow?.contentView?.findSubview(ofType: NSTextField.self) {
                        firstTextField.becomeFirstResponder()
                    }
                }
            }
        }
    }
    
    private func openFolderPicker() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        
        openPanel.begin { result in
            if result == .OK {
                selectedFolderPath = openPanel.urls[0].path
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
