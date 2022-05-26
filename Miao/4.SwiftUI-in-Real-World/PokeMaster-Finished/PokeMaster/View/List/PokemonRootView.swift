//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/09/02.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

/*
 NavigationView
 
 Summary

 A view for presenting a stack of views that represents a visible path in a navigation hierarchy.
 Declaration

 struct NavigationView<Content> where Content : View
 Discussion

 Use a NavigationView to create a navigation-based app in which the user can traverse a collection of views. Users navigate to a destination view by selecting a NavigationLink that you provide. On iPadOS and macOS, the destination content appears in the next column. Other platforms push a new view onto the stack, and enable removing items from the stack with platform-specific controls, like a Back button or a swipe gesture.
 Use the init(content:) initializer to create a navigation view that directly associates navigation links and their destination views:
 NavigationView {
     List(model.notes) { note in
         NavigationLink(note.title, destination: NoteEditor(id: note.id))
     }
     Text("Select a Note")
 }
 Style a navigation view by modifying it with the navigationViewStyle(_:) view modifier. Use other modifiers, like navigationTitle(_:), on views presented by the navigation view to customize the navigation interface for the presented view.

 */

struct PokemonRootView: View {
    var body: some View {
        // public init(@ViewBuilder content: () -> Content)
        // 所以, 传入的其实是 RootView
        NavigationView {
            // ScrollView.
            PokemonList().navigationBarTitle("宝可梦列表")
        }
    }
}

//struct PokemonListRoot_Previews: PreviewProvider {
//    static var previews: some View {
//        PokemonRootView()
//    }
//}
