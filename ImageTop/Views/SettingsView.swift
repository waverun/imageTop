import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @AppStorage("replaceImageAfter") private var replaceImageAfter: TimeInterval = 10
    @AppStorage("selectedFolderPath") private var storedFolderPath: String = ""
    @AppStorage("imageTopFolderBookmark") private var imageTopFolderBookmarkData: Data?
    @AppStorage("hotKeyString") private var keyString: String = "Escape"
    @AppStorage("modifierKeyString1") private var keyString1: String = "command"
    @AppStorage("modifierKeyString2") private var keyString2: String = "control"

    @State private var selectedFolderPath = ""
    
    private let allKeyNames = Keyboard.keyNames
    private let modKeyNames = Keyboard.modKeyNames

    private var filteredKeys: [String] {
//        guard keyString.count >= 2 else { return [] }
//        let searchString = keyString.prefix(2).lowercased()
        let searchString = ""
        return allKeyNames.filter { $0.lowercased().hasPrefix(searchString) }
    }

    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .padding()
            
            GeometryReader { geometry in
                Form {
                    VStack {
//                        HStack {
//                            Text("Hot key Name")
//                                .frame(width: geometry.size.width * 0.35, alignment: .leading)
//                            TextField("", text: $keyString)
//                                .frame(width: 120)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                            Spacer()
//                        }.padding(.leading)
                        HStack {
                            Text("Hot key")
                                .frame(width: geometry.size.width * 0.35, alignment: .leading)
                            
                            if !filteredKeys.isEmpty {
                                Menu {
                                    ForEach(filteredKeys, id: \.self) { key in
                                        Button(action: {
                                            keyString = key
                                        }, label: {
                                            Text(key)
                                        })
                                    }
                                } label: {
                                    Text("Keys")
//                                    Image(systemName: "chevron.down")
                              }.frame(width: 60)

                            }
                            TextField("", text: $keyString)
                                .frame(width: 120)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .allowsHitTesting(false)
                            Spacer()
                        }.padding(.leading)
                        HStack {
                            Text("Modifier key 1")
                                .frame(width: geometry.size.width * 0.35, alignment: .leading)
                                Menu {
                                    ForEach(modKeyNames, id: \.self) { mod in
                                        Button(action: {
                                            keyString1 = mod
                                        }, label: {
                                            Text(mod)
                                        })
                                    }
                                } label: {
                                      Text("Mods")
                                }.frame(width: 62)
                            TextField("", text: $keyString1)
                                .frame(width: 120)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .allowsHitTesting(false)
                            Spacer()
                        }.padding(.leading)
                        HStack {
                            Text("Modifier key 2")
                                .frame(width: geometry.size.width * 0.35, alignment: .leading)
                                Menu {
                                    ForEach(modKeyNames, id: \.self) { mod in
                                        Button(action: {
                                            keyString2 = mod
                                        }, label: {
                                            Text(mod)
                                        })
                                    }
                                } label: {
                                      Text("Mods")
                                }.frame(width: 62)
                            TextField("", text: $keyString2)
                                .frame(width: 120)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .allowsHitTesting(false)
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
        .frame(width: 350, height: 250)
        .onAppear {
            selectedFolderPath = storedFolderPath
        }
    }
    
//    private func openFolderPicker() {
//        let openPanel = NSOpenPanel()
//        openPanel.canChooseFiles = false
//        openPanel.canChooseDirectories = true
//        openPanel.allowsMultipleSelection = false
//
//        openPanel.begin { result in
//            if result == .OK {
//                selectedFolderPath = openPanel.urls[0].path
//                storedFolderPath = selectedFolderPath
//            }
//        }
//    }
    
    private func openFolderPicker() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.allowedContentTypes = [UTType.folder]
        openPanel.allowsOtherFileTypes = false

        openPanel.begin { result in
            if result == .OK, let url = openPanel.url {
                do {
                    let bookmarkData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                    imageTopFolderBookmarkData = bookmarkData
                    selectedFolderPath = url.path
                    storedFolderPath = selectedFolderPath
                } catch {
                    print("Error creating security-scoped bookmark: \(error)")
                }
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
