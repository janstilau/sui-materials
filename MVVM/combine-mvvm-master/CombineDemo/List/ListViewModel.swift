//
//  ListViewModel.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//

import Foundation
import Combine

enum ListViewModelError: Error, Equatable {
    case playersFetch
}

enum ListViewModelState: Equatable {
    case loading
    case finishedLoading
    case error(ListViewModelError)
}

final class ListViewModel {
    enum Section { case players }
    
    @Published private(set) var players: [Player] = []
    @Published private(set) var state: ListViewModelState = .loading
    private var currentSearchQuery: String = ""
    
    // 面向抽象接口, 依赖注入.
    private let playersService: PlayersServiceProtocol
    private var bindings = Set<AnyCancellable>()
    
    // 依赖注入, 将网络请求的部分, 抽象成为接口.
    // 这样, 外界可以进行配置.
    // 但是, 提供了默认值.
    // 所以, 这里并不是为了减少依赖, 而已提供灵活性.
    init(playersService: PlayersServiceProtocol = PlayersService()) {
        self.playersService = playersService
    }
    
    /*
     IntentAction
     */
    func search(query: String) {
        currentSearchQuery = query
        fetchPlayers(with: query)
    }
    
    /*
     IntentAction
     */
    func retrySearch() {
        fetchPlayers(with: currentSearchQuery)
    }
}

extension ListViewModel {
    /*
     Intent Action, 在里面进行真正的网络请求.
     在请求之前, 修改 state 的信号源.
     在请求之后, 修改 players, 和 state 的信号源.
     
     网络解析的部分, 被转移到了 ViewModel 里面, 因为实际上, View 层并不需要知道这个解析过程, MVVM 中, Controller 类中也不应该知道这个解析过程.
     一切都是在 ViewModel 这个类的内部处理完毕之后, 暴露 players 的信号修改给外界, 外界直接使用处理完毕的结果 .
     
     网络请求, 也不再是原来的闭包传递的方式, 而是信号的发射.
     触发网络请求的逻辑, 放到了 Service 层.
     网络请求的后续逻辑, 通过 Subscriber 进行业务上的挂钩.
     使得异步操作注册这件事, 变得统一了.
     */
    private func fetchPlayers(with searchTerm: String?) {
        state = .loading
        
        let searchTermCompletionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure:
                self?.state = .error(.playersFetch)
            case .finished:
                self?.state = .finishedLoading
            }
        }
        
        let searchTermValueHandler: ([Player]) -> Void = { [weak self] players in
            self?.players = players
        }
        
        playersService
            .get(searchTerm: searchTerm)
            .sink(receiveCompletion: searchTermCompletionHandler, receiveValue: searchTermValueHandler)
            .store(in: &bindings)
    }
}
