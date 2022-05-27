//
//  Store.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/03.
//  Copyright © 2019 OneV's Den. All rights reserved.
//


import Combine

class Store: ObservableObject {
    @Published var appState = AppState()
    
    func dispatch(_ action: AppAction) {
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        if let command = result.1 {
            command.execute(in: self)
        }
    }
    
    // 这里的逻辑, 和之前的 Calculate 是一致的.
    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
        
        switch action {
        case .login(let email, let password):
            guard !appState.settings.loginRequesting else { break }
            appState.settings.loginRequesting = true
            appCommand = LoginAppCommand(email: email, password: password)
        case .accountBehaviorDone(let result):
            appState.settings.loginRequesting = false
            switch result {
            case .success(let user):
                appState.settings.loginUser = user
            case .failure(let error):
                appState.settings.loginError = error
            }
        }
        
        return (appState, appCommand)
    }
}
