import SwiftUI

struct DigitalWatchView: View {
    let backgroundColor = Color.black.opacity(0.8)
    let timeFont = Font.system(size: 80, weight: .bold, design: .rounded)
    @State private var watchPosition = CGPoint(x: 0, y: 0)
    @State private var timeString = ""

    var body: some View {
        Text(timeString)
            .font(timeFont)
            .foregroundColor(.white)
            .frame(width: 200, height: 100)
            .background(backgroundColor)
            .cornerRadius(10)
            .position(watchPosition)
            .onAppear {
                updateTime()
                let screenWidth = NSScreen.main?.visibleFrame.width ?? 0
                let screenHeight = NSScreen.main?.visibleFrame.height ?? 0
                let x = CGFloat.random(in: screenWidth * 0.2 ..< screenWidth * 0.8)
                let y = CGFloat.random(in: screenHeight * 0.2 ..< screenHeight * 0.8)
                watchPosition = CGPoint(x: x, y: y)
            }
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                updateTime()
            }
    }
    
    private func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeString = formatter.string(from: Date())
    }
}

//struct ContentView: View {
//    var body: some View {
//        ZStack {
//            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
//            DigitalWatchView()
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
