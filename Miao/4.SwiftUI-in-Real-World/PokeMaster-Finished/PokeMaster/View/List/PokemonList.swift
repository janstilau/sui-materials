
import SwiftUI

struct PokemonList: View {
    
    // 仅仅是界面相关的内容, 使用 State, 是一个好的策略. 
    @State var expandingIndex: Int?
    @State var searchText: String = ""
    
    var body: some View {
        ScrollView {
            LazyVStack {
                // 这个 TextField 没有起到作用啊.
                TextField("搜索", text: $searchText)
                    .frame(height: 40)
                    .padding(.horizontal, 25)
                ForEach(PokemonViewModel.all) { pokemon in
                    PokemonInfoRow(rowViewModel: pokemon,
                                   expanded: self.expandingIndex == pokemon.id )
                        .onTapGesture {
                            // 在这里, 进行了 expandingIndex 的更改, 而这个更改, 会直接影响到 View 的显示.
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.425, blendDuration: 0)) {
                                if self.expandingIndex == pokemon.id {
                                    self.expandingIndex = nil
                                } else {
                                    self.expandingIndex = pokemon.id
                                }
                            }
                        }
                }
            }
        }.overlay(
            // 这里使用的是 overlay. 怪不得没有办法消失.
            VStack {
                Spacer()
//                PokemonInfoPanel(model: .sample(id: 1))
            }.edgesIgnoringSafeArea(.bottom)
        )
    }
}

//struct PokemonList_Previews: PreviewProvider {
//    static var previews: some View {
//        PokemonList()
//    }
//}
