//
//  ContentView.swift
//  Shared
//
//  Created by Meng To on 2021-06-16.
//

import SwiftUI

extension View {
    func debug() -> Self {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
    
    func size() -> Self {
        let _ = debug()
        print("Size is \(MemoryLayout<Self>.size)")
        return self
    }
}

struct ContentView: View {
    @EnvironmentObject var model: Model
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @AppStorage("showAccount") var showAccount = false
    
    init() {
        showAccount = false
    }
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .explore:
                    ExploreView()
                case .notifications:
                    NotificationsView()
                case .library:
                    LibraryView()
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack {}.frame(height: 44)
            }
            
            TabBar()
            
            if model.showModal {
                ModalView()
                    .accessibilityIdentifier("Identifier")
            }
        }
        .dynamicTypeSize(.large ... .xxLarge)
        .sheet(isPresented: $showAccount) {
            AccountView()
        }.size()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Model())
    }
}
