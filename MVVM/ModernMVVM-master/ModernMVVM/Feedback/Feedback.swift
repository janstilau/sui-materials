//
//  Feedback.swift
//  ModernMVVMList
//
//  Created by Vadim Bulavin on 3/17/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
import Combine

struct Feedback<State, Event> {
    let run: (AnyPublisher<State, Never>) -> AnyPublisher<Event, Never>
}

extension Feedback {
    init<Effect: Publisher>(effects: @escaping (State) -> Effect)
    where Effect.Output == Event, Effect.Failure == Never {
        self.run = { statePublisher -> AnyPublisher<Event, Never> in
            statePublisher
                .map { effects($0) }
                .switchToLatest()
                .eraseToAnyPublisher()
        }
    }
}
