//
//  MockAPISearvice.swift
//  SwiftUI-MVVMTests
//
//  Created by Yusuke Kita on 6/7/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation
import Combine
@testable import SwiftUI_MVVM

// 提供了一个, 录入假数据的方式 .
final class MockAPIService: APIServiceType {
    var stubs: [Any] = []
    
    func stub<Request>(for type: Request.Type,
                       response: @escaping ((Request) -> AnyPublisher<Request.Response, APIServiceError>)) where Request: APIRequestType {
        stubs.append(response)
    }
    
    /*
     传入的 Block, 是一个 Publisher 的生成器, 这样, 就能够根据传入的 Block, 生成一个自定义的 Publisher 了.
     */
    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType {
        
        let response = stubs.compactMap { stub -> AnyPublisher<Request.Response, APIServiceError>? in
            let stub = stub as? ((Request) -> AnyPublisher<Request.Response, APIServiceError>)
            return stub?(request)
        }.last
        
        return response ?? Empty<Request.Response, APIServiceError>()
            .eraseToAnyPublisher()
    }
}
