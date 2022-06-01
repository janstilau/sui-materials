//
//  Store.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/03.
//  Copyright © 2019 OneV's Den. All rights reserved.
//


import Combine

/*
 这是一个 ViewModel, AppState 则是 Model 对象 .
 */
class Store: ObservableObject {
    @Published var appState = AppState()
    
    // ViewModel 的 ModelAction .
    // 其实就是修改自己的内部状态, 不过的是, 这里使用了一个比较复杂的机制.
    func dispatch(_ action: AppAction) {
        let result = Store.reduce(state: appState, action: action)
        // 现将自身的状态改变, 然后触发异步任务.
        // 在异步任务中, 再次进行 dispatch, 触发 ModelAction.
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
