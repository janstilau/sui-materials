//
//  AppState.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/09/04.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Combine
import Foundation

// Model 一个 Model 不可能, 存储所有的内容的.
// 使用不同的 Model, 按照业务进行了区分.
struct AppState {
    var settings = Settings()
    var pokemonList = PokemonList()
}

/*
 View 是数据的表现.
 对于硬编码的部分, 也不要写到 View 中.
 总之, 在声明式的环境里面, 一切的逻辑, 都应该写到 Model 中.
 ViewModel 中.
 View 只是做框架的搭建.
 */
extension AppState {
    struct Settings {
        enum Sorting: CaseIterable {
            case id, name, color, favorite
        }
        enum AccountBehavior: CaseIterable {
            case register, login
        }
        class AccountChecker {
            // @Published 里面, 存储了一个类似于 CurrentSubject 的东西.
            // 将, 可能会引起变化的地方, 使用 @Published 进行修饰.
            // 下面的各个属性, 都是在 View 中, 需要 Binding 的这种数据类型中使用了.
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""
            
            var isEmailValid: AnyPublisher<Bool, Never> {
                let remoteVerify = $email
                /*
                 Publishes elements only after a specified time interval elapses between events.
                 */
                    .debounce(
                        for: .milliseconds(500),
                           scheduler: DispatchQueue.main
                    )
                    .removeDuplicates()
                    .flatMap { email -> AnyPublisher<Bool, Never> in
                        // 在这里, 有了具体的业务逻辑.
                        // Just 是很好的, 将特定值包装成为 Publisher, 然后纳入 Combine 系统的基础.
                        
                        // 虽然, 看起来像是 validEmail, canSkip 和后面的逻辑重复了, 但是这是包装在了 remoteVerify 里面了.
                        // 它仅仅代表的就是, 网络请求失败了.
                        let validEmail = email.isValidEmailAddress
                        let canSkip = self.accountBehavior == .login
                        switch (validEmail, canSkip) {
                        case (false, _):
                            return Just(false).eraseToAnyPublisher()
                        case (true, false):
                            return EmailCheckingRequest(email: email)
                                .publisher
                                .eraseToAnyPublisher()
                        case (true, true):
                            return Just(true).eraseToAnyPublisher()
                        }
                    }
                
                /*
                 这两个的信号, 触发的是非常频繁的.
                 不断的在刷新 CombineLatest3 里面的值.
                 每次, CombineLatest3 中的值刷新了之后, 都会进行 map 操作, 然后发送给后面. 
                 */
                let emailLocalValid = $email.map { $0.isValidEmailAddress }
                let canSkipRemoteVerify = $accountBehavior.map { $0 == .login }
                
                return Publishers.CombineLatest3(
                    emailLocalValid, canSkipRemoteVerify, remoteVerify
                )
                    .map { $0 && ($1 || $2) }
                    .eraseToAnyPublisher()
            }
        }
        
        var checker = AccountChecker()
        
        var isEmailValid: Bool = false
        
        var showEnglishName = true
        var sorting = Sorting.id
        var showFavoriteOnly = false
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json") var loginUser: User?
        
        // 问题就在于, 明明是 ViewState 的东西, 现在都要装到了 ViewModel 里面了.
        var loginRequesting = false
        var loginError: AppError?
    }
}

extension AppState {
    struct PokemonList {
        @FileStorage(directory: .cachesDirectory, fileName: "pokemons.json")
        // 该值的改变, 会引起 View 的改变. 值语义的好处就在这里.
        var thePokemons: [Int: PokemonViewModel]?
        var loadingPokemons = false
        
        var allPokemonsByID: [PokemonViewModel] {
            guard let pokemons = thePokemons?.values else {
                return []
            }
            return pokemons.sorted { $0.id < $1.id }
        }
    }
}
