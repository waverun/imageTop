import SwiftUI

struct SettingsView: View {
    @AppStorage("inactivityDuration") private var inactivityDuration: TimeInterval = 0
    @AppStorage("replaceImageAfter") private var replaceImageAfter: TimeInterval = 0
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
                            Text("Inactivity Duration")
                                .frame(width: geometry.size.width * 0.5, alignment: .leading)
                            TextField("", value: $inactivityDuration, formatter: NumberFormatter())
                                .multilineTextAlignment(.trailing)
                                .frame(width: 50)
                            Spacer()
                        }.padding(.leading)
                        HStack {
                            Text("Replace Image After")
                                .frame(width: geometry.size.width * 0.5, alignment: .leading)
                            TextField("", value: $replaceImageAfter, formatter: NumberFormatter())
                                .multilineTextAlignment(.trailing)
                                .frame(width: 50)
                            Spacer()
                        }.padding(.leading)
                        HStack {
                            Text("Image Folder")
                                .frame(width: geometry.size.width * 0.5, alignment: .leading)
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
        .frame(width: 235, height: 200)
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
