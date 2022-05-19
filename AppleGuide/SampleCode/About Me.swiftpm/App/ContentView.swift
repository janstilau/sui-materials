/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI

/*
 TabView
 
 A view that switches between multiple child views using interactive user interface elements.
 Declaration

 struct TabView<SelectionValue, Content> where SelectionValue : Hashable, Content : View
 Discussion

 To create a user interface with tabs, place views in a TabView and apply the tabItem(_:) modifier to the contents of each tab. On iOS, you can also use one of the badge modifiers, like badge(_:), to assign a badge to each of the tabs. The following creates a tab view with three tabs, the first of which has a badge:
 TabView {
     Text("The First Tab")
         .badge(10)
         .tabItem {
             Image(systemName: "1.square.fill")
             Text("First")
         }
     Text("Another Tab")
         .tabItem {
             Image(systemName: "2.square.fill")
             Text("Second")
         }
     Text("The Last Tab")
         .tabItem {
             Image(systemName: "3.square.fill")
             Text("Third")
         }
 }
 .font(.headline)
 Tab views only support tab items of type Text, Image, or an image followed by text. Passing any other type of view results in a visible but empty tab item.
 */

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "person")
                }
            
            StoryView()
                .tabItem {
                    Label("Story", systemImage: "book")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
            
            FunFactsView()
                .tabItem {
                    Label("Fun Facts", systemImage: "hand.thumbsup")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
