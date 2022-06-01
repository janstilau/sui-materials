//
//  MainTab.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/08/11.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct MainTab: View {
    
    @EnvironmentObject var store: Store
    
    // 如果, 仅仅是纯显示, 那么使用 Struct 语义的对象就可以了.
    private var pokemonList: AppState.PokemonList {
        store.appState.pokemonList
    }
    // 如果, 还要包含 UI 的双向绑定, 那就要传递一个 Binding 值了.
    // 可以类比如 RX 里面的 Property 类型. 该类型就是 Publisher 和 Subscriber 的封装.
    private var pokemonListBinding: Binding<AppState.PokemonList> {
        $store.appState.pokemonList
    }
    
    private var selectedPanelIndex: Int? {
        pokemonList.selectionState.panelIndex
    }
    
    var body: some View {
        // appState.mainTab.selection 本身都是 Struct 的值语义的.
        // 但是, 因为 $store 是 obserable 对象, 所以, 可以进行监听.
        TabView(selection: $store.appState.mainTab.selection) {
            PokemonRootView().tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("列表")
            }.tag(AppState.MainTab.Index.list)
            
            SettingRootView().tabItem {
                Image(systemName: "gear")
                Text("设置")
            }.tag(AppState.MainTab.Index.settings)
        }
        .edgesIgnoringSafeArea(.top)
        // isPresented 传入进去的, 是一个 Binding 值.
        .overlaySheet(isPresented: pokemonListBinding.selectionState.panelPresented) {
            if self.selectedPanelIndex != nil && self.pokemonList.pokemons != nil {
                PokemonInfoPanel(
                    model: self.pokemonList.pokemons![self.selectedPanelIndex!]!
                )
            }
        }
    }
}

/*
 Sets the unique tag value of this view.
 Declaration

 func tag<V>(_ tag: V) -> some View where V : Hashable
 Discussion

 Use tag(_:) to differentiate between a number of views for the purpose of selecting controls like pickers and lists. Tag values can be of any type that conforms to the Hashable protocol.
 In the example below, the ForEach loop in the Picker view builder iterates over the Flavor enumeration. It extracts the text raw value of each enumeration element for use as the row item label and uses the enumeration item itself as input to the tag(_:) modifier. The tag identifier can be any value that conforms to the Hashable protocol:
 struct FlavorPicker: View {
     enum Flavor: String, CaseIterable, Identifiable {
         var id: String { self.rawValue }
         case vanilla, chocolate, strawberry
     }

     @State private var selectedFlavor: Flavor? = nil
     var body: some View {
         Picker("Flavor", selection: $selectedFlavor) {
             ForEach(Flavor.allCases) {
                 Text($0.rawValue).tag($0)
             }
         }
     }
 }
 Parameters

 tag
 A Hashable value to use as the view’s tag.
 Returns

 A view with the specified tag set.

 */
