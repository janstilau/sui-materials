//
//  PokemonList.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/08/30.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonList: View {

    @State var expandingIndex: Int?
    @State var searchText: String = ""

    @EnvironmentObject var store: Store

    var body: some View {
        ScrollView {
            LazyVStack {
                TextField("搜索", text: $searchText)
                    .frame(height: 40)
                    .padding(.horizontal, 25)
                ForEach(store.appState.pokemonList.allPokemonsByID) { pokemon in
                    PokemonInfoRow(
                        model: pokemon,
                        expanded: self.expandingIndex == pokemon.id
                    )
                    .onTapGesture {
                        // 这种
                        withAnimation(
                            .spring(
                                response: 0.55,
                                dampingFraction: 0.425,
                                blendDuration: 0
                            )
                        )
                        {
                            if self.expandingIndex == pokemon.id {
                                self.expandingIndex = nil
                            } else {
                                self.expandingIndex = pokemon.id
                            }
                        }
                    }
                }
            }
        }
//        .overlay(
//            VStack {
//                Spacer()
//                PokemonInfoPanel(model: .sample(id: 1))
//            }.edgesIgnoringSafeArea(.bottom)
//        )
    }
}

