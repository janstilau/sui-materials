import SwiftUI

struct ContentView: View {
    @State var game = Game()
    @State var guess: RGB
    var target = RGB.random()
    
    var body: some View {
        VStack {
            Color(red: 0.5, green: 0.5, blue: 0.5)
            Text("R: ??? G: ??? B: ???")
                .padding()
            Color(red: 0.5, green: 0.5, blue: 0.5)
            Text("R: 204 G: 76 B: 178")
                .padding()
            Slider(value: .constant(0.5))
            Button("Hit Me") {
                print("Hit me")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
