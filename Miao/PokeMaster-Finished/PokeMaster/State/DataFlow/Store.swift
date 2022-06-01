//
//  Store.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/08/21.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Combine

class Store: ObservableObject {
    // 真正的 Model 部分. 是在 AppState 里面, 把所有的状态, 都放到了 AppState 的内部了.
    @Published var appState = AppState()
    
    private var disposeBag = Set<AnyCancellable>()
    
    init() {
        setupObservers()
    }
    
    func setupObservers() {
        appState.settings.checker.isValid.sink { isValid in
            // appState.settings.isValid = isValid
            self.dispatch(.accountBehaviorButton(enabled: isValid))
        }.store(in: &disposeBag)
        
        appState.settings.checker.isEmailValid.sink { isValid in
            // appState.settings.isEmailValid = isValid
            self.dispatch(.emailValid(valid: isValid))
        }.store(in: &disposeBag)
    }
    
    func dispatch(_ action: AppAction) {
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        if let command = result.1 {
            command.execute(in: self)
        }
    }
    
    // Reduce 其实就是 Model Action, 做了真正的 Model 的修改动作. 因为, 整个 model 是 @Published, 所以他的修改, 会引起 UI 的改变.
    // 在 Model 改变的时候, 会触发异步任务. 在这些异步任务的结束位置, 也会触发新的一轮 ModelAction, 来进行对应状态的修改.
    
    // 其实, 我觉得这个 Reduce 的设计有点问题. 一点也不清晰.
    // 还不如 Model Action 使用更加清晰的方法, 来面对对于 ViewAction 的相应.
    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand? = nil
        
        switch action {
        case .accountBehaviorButton(let isValid):
            appState.settings.isValid = isValid
            
        case .emailValid(let isValid):
            appState.settings.isEmailValid = isValid
            
        case .register(let email, let password):
            appState.settings.registerRequesting = true
            // 在, 改变了状态之后, 触发了异步操作.
            appCommand = RegisterAppCommand(email: email, password: password)
            
        case .login(let email, let password):
            appState.settings.loginRequesting = true
            // 在, 改变了状态之后, 触发了异步操作.
            appCommand = LoginAppCommand(email: email, password: password)
            
        case .logout:
            appState.settings.loginUser = nil
            
        case .accountBehaviorDone(let result):
            appState.settings.registerRequesting = false
            appState.settings.loginRequesting = false
            switch result {
            case .success(let user):
                appState.settings.loginUser = user
            case .failure(let error):
                appState.settings.loginError = error
            }
            
        case .toggleListSelection(let index):
            let expanding = appState.pokemonList.selectionState.expandingIndex
            if expanding == index {
                appState.pokemonList.selectionState.expandingIndex = nil
                appState.pokemonList.selectionState.panelPresented = false
                appState.pokemonList.selectionState.radarProgress = 0
            } else {
                appState.pokemonList.selectionState.expandingIndex = index
                appState.pokemonList.selectionState.panelIndex = index
                appState.pokemonList.selectionState.radarShouldAnimate =
                appState.pokemonList.selectionState.radarProgress == 1 ? false : true
            }
            
        case .togglePanelPresenting(let presenting):
            appState.pokemonList.selectionState.panelPresented = presenting
            appState.pokemonList.selectionState.radarProgress = presenting ? 1 : 0
            
        case .toggleFavorite(let index):
            guard let loginUser = appState.settings.loginUser else {
                appState.pokemonList.favoriteError = .requiresLogin
                break
            }
            
            var newFavorites = loginUser.favoritePokemonIDs
            if newFavorites.contains(index) {
                newFavorites.remove(index)
            } else {
                newFavorites.insert(index)
            }
            appState.settings.loginUser!.favoritePokemonIDs = newFavorites
            
        case .closeSafariView:
            appState.pokemonList.isSFViewActive = false
            
        case .switchTab(let index):
            appState.pokemonList.selectionState.panelPresented = false
            appState.mainTab.selection = index
            
        case .loadPokemons:
            if appState.pokemonList.loadingPokemons {
                break
            }
            appState.pokemonList.pokemonsLoadingError = nil
            appState.pokemonList.loadingPokemons = true
            // 在, 改变了状态之后, 触发了异步操作.
            appCommand = LoadPokemonsCommand()
            
        case .loadPokemonsDone(let result):
            appState.pokemonList.loadingPokemons = false
            
            switch result {
            case .success(let models):
                appState.pokemonList.pokemons =
                Dictionary(uniqueKeysWithValues: models.map { ($0.id, $0) })
            case .failure(let error):
                appState.pokemonList.pokemonsLoadingError = error
            }
            
        case .loadAbilities(let pokemon):
            // 在, 改变了状态之后, 触发了异步操作.
            appCommand = LoadAbilitiesCommand(pokemon: pokemon)
            
        case .loadAbilitiesDone(let result):
            switch result {
            case .success(let loadedAbilities):
                var abilities = appState.pokemonList.abilities ?? [:]
                for ability in loadedAbilities {
                    abilities[ability.id] = ability
                }
                appState.pokemonList.abilities = abilities
            case .failure(let error):
                print(error)
            }
            
        case .clearCache:
            appState.pokemonList.pokemons = nil
            appState.pokemonList.abilities = nil
            // 在, 改变了状态之后, 触发了异步操作. 
            appCommand = ClearCacheCommand()
        }
        
        return (appState, appCommand)
    }
}
