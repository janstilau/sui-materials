
import SwiftUI
import MapKit

// MapKit 里面, 专门对于 SwiftUI 的适配. 应该在后续教程中, UIKit 适配 SwiftUI 里面会有相关的内容.
/*
 When you import SwiftUI and certain other frameworks in the same file, you gain access to SwiftUI-specific functionality provided by that framework.
 */

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    var body: some View {
        VStack {
            Spacer.init(minLength: 44)
            Text(location())
            Map(coordinateRegion: $region)
        }
        
    }
    
    func location() -> String {
        return "\(region.center.latitude.description)"
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
