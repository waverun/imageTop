import SwiftUI

struct SettingsView: View {
    @AppStorage("replaceImageAfter") private var replaceImageAfter: TimeInterval = 10
    @AppStorage("selectedFolderPath") private var selectedFolderPath: String = ""
    @AppStorage("hotKeyString") private var keyString: String = "Escape"

    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .padding()
            
            GeometryReader { geometry in
                Form {
                    VStack {
                        HStack {
                            Text("Hot key Name")
                                .frame(width: geometry.size.width * 0.35, alignment: .leading)
                            TextField("", text: $keyString)
                                .frame(width: 120)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
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
                                .frame(width: 50)
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

//import SwiftUI
//import KeyboardShortcuts
//
//struct SettingsView: View {
////    @AppStorage("inactivityDuration") private var inactivityDuration: TimeInterval = 120
//    @AppStorage("replaceImageAfter") private var replaceImageAfter: TimeInterval = 10
//    @AppStorage("selectedFolderPath") private var selectedFolderPath: String = ""
//    @AppStorage("keyString") private var keyString: String = "Escape"
//
//    @FocusState private var isKeyRecorderFocused: Bool
//
//    var body: some View {
//        VStack {
//            Text("Settings")
//                .font(.title)
//                .padding()
//
//            GeometryReader { geometry in
//                Form {
//                    VStack {
//                        HStack {
//                            Text("Hotkey")
//                                .frame(width: geometry.size.width * 0.35, alignment: .leading)
//                            KeyRecorder(keyString: $keyString)
//                                .frame(width: 120)
////                                .focus(isKeyRecorderFocused)
//                            Spacer()
//                        }.padding(.leading)
//                        HStack {
//                            Text("Replace Image After")
//                                .frame(width: geometry.size.width * 0.635, alignment: .leading)
//                            FocusableTextField(text: Binding(get: {
//                                String(replaceImageAfter)
//                            }, set: { newValue in
//                                if let value = TimeInterval(newValue) {
//                                    replaceImageAfter = value
//                                }
//                            }), formatter: NumberFormatter())
//                                .multilineTextAlignment(.trailing)
//                                .frame(width: 50
//                                )
//                            Spacer()
//                        }.padding(.leading)
//                        HStack {
//                            Text("Image Folder")
//                                .frame(width: geometry.size.width * 0.58, alignment: .leading)
//                            Button("Select...") {
//                                openFolderPicker()
//                            }
//                            Spacer()
//                        }.padding(.leading)
//
//                        Text(selectedFolderPath)
//                            .foregroundColor(.gray)
//                            .lineLimit(1)
//                            .truncationMode(.middle)
//                    }
//                }
//            }
//        }
//        .frame(width: 245, height: 200)
//        .allowsHitTesting(true) // Add this modifier
//        .onAppear {
//            DispatchQueue.main.async {
//                isKeyRecorderFocused = true
//            }
//        }
//    }
//
//    private func openFolderPicker() {
//        let openPanel = NSOpenPanel()
//        openPanel.canChooseFiles = false
//        openPanel.canChooseDirectories = true
//        openPanel.allowsMultipleSelection = false
//
//        openPanel.begin { result in
//            if result == .OK {
//                selectedFolderPath = openPanel.urls[0].path
//            }
//        }
//    }
//}
//
//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
