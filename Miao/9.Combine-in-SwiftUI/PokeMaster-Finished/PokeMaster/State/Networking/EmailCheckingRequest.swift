//
//  EmailCheckingRequest.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/21.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation
import Combine

/*
 这里, 如果是真正的业务处理, 应该是判断 email 有没有注册过的相关逻辑. 
 */
struct EmailCheckingRequest {
    let email: String

    var publisher: AnyPublisher<Bool, Never> {
        Future<Bool, Never> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                if self.email.lowercased() == "onevcat@gmail.com" {
                    promise(.success(false))
                } else {
                    promise(.success(true))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
