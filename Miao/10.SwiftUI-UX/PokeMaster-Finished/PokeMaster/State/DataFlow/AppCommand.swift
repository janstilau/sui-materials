//
//  AppCommand.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/10.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation
import Combine

protocol AppCommand {
    func execute(in store: Store)
}

struct LoginAppCommand: AppCommand {
    let email: String
    let password: String
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoginRequest(
            email: email,
            password: password
        ).publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(
                            .accountBehaviorDone(result: .failure(error))
                        )
                    }
                    token.unseal()
                },
                receiveValue: { user in
                    store.dispatch(
                        .accountBehaviorDone(result: .success(user))
                    )
                }
            )
            .seal(in: token)
    }
}

struct LoadPokemonsCommand: AppCommand {
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoadPokemonRequest.all
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.loadPokemonsDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(.loadPokemonsDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}

struct LoadAbilitiesCommand: AppCommand {
    
    let pokemon: Pokemon
    
    func load(pokemonAbility: Pokemon.AbilityEntry, in store: Store)
    -> AnyPublisher<AbilityViewModel, AppError>
    {
        // 缓存策略, 可以看到, 中途安插的缓存, 也要纳入到 Combine 的体系里面.
        // Just 是个好东西
        if let value = store.appState.pokemonList.abilities?[pokemonAbility.id.extractedID!] {
            return Just(value)
            // 要保持, 返回值的类型是统一的.
            // setFailureType 只使用到, Fail 为 Never 的情况下.
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        } else {
            return LoadAbilityRequest(pokemonAbility: pokemonAbility).publisher
        }
    }
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        pokemon.abilities
            .map { load(pokemonAbility: $0, in: store) }
            .zipAll
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.loadAbilitiesDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(.loadAbilitiesDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}

class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
