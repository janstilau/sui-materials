//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/09/02.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonRootView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        NavigationView {
            if store.appState.pokemonList.thePokemons == nil {
                Text("Loading...").onAppear {
                    // 这应该是 ViewDidLoad 中的 ViewAction 的调用 .
                    self.store.dispatch(.loadPokemons)
                }
            } else {
                PokemonList()
                    .navigationBarTitle("宝可梦列表")
            }
        }
    }
}

