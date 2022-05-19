//
//  PlayersService.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//

import Foundation
import Combine

// 专门定义了, NetwrokService 相关的错误.
enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case decode
}

protocol PlayersServiceProtocol {
    func get(searchTerm: String?) -> AnyPublisher<[Player], Error>
}

let apiKey: String = "" // use your rapidapi

final class PlayersService: PlayersServiceProtocol {
    
    func get(searchTerm: String?) -> AnyPublisher<[Player], Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = {
            _ in dataTask?.resume()
        }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        // promise type is Result<[Player], Error>
        return Future<[Player], Error> { [weak self] promise in
            /*
             在 Promise 的构造函数里面, 使用指令式的方式, 进行信号的生产逻辑.
             */
            guard let urlRequest = self?.getUrlRequest(searchTerm: searchTerm) else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let players = try JSONDecoder().decode(PlayerData.self, from: data)
                    promise(.success(players.data))
                } catch {
                    promise(.failure(ServiceError.decode))
                }
            }
        }
        // 非常优秀的做法, 在真正的接收到了
        /*
         receiveSubscription
         An optional closure that executes when the publisher receives the subscription from the upstream publisher. This value defaults to nil.
         
         public func receive<Downstream: Subscriber>(subscriber: Downstream)
         where Output == Downstream.Input, Failure == Downstream.Failure
         {
             let conduit = Conduit(parent: self, downstream: subscriber)
             lock.lock()
             // 如果, 已经有了 Result 了, 那么直接是使用 result 来进行数据传递.
             if let result = self.result {
                 downstreams.insert(conduit)
                 lock.unlock()
                 subscriber.receive(subscription: conduit)
                 // conduit.fulfill 会做相关的 DispatchTable 的管理工作.
                 conduit.fulfill(result)
             } else {
                 // 否则, 就是记录回调. 等待异步操作的结果.
                 downstreams.insert(conduit)
                 lock.unlock()
                 subscriber.receive(subscription: conduit)
             }
         }
         在 Future 里面, Future 类似于 Subject, 在其中会生成 Future.Conduit 对象.
         然后这个对象 ,是后面的响应链路的起点, 后面连接的是 handleEvents 的 Inner 节点.
         所以, onSubscription 就在上面的 subscriber.receive(subscription: conduit) 中被触发.
         
         还是在, receive<Downstream: Subscriber>(subscriber: Downstream) 的时候, 才会触发.
         所以这里的效果就是, 在有后续节点注册的时候, 才进行了网络的请求. 在 cancel 的时候, 就进行了相应的 dataTask 的取消. 
         */
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func getUrlRequest(searchTerm: String?) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "free-nba.p.rapidapi.com"
        components.path = "/players"
        if let searchTerm = searchTerm, !searchTerm.isEmpty {
            components.queryItems = [
                URLQueryItem(name: "search", value: searchTerm)
            ]
        }
        
        guard let url = components.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10.0
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "X-RapidAPI-Host": "free-nba.p.rapidapi.com",
            "X-RapidAPI-Key": apiKey
        ]
        return urlRequest
    }
}
