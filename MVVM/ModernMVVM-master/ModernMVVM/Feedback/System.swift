//
//  System.swift
//  ModernMVVMList
//
//  Created by Vadim Bulavin on 3/17/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Combine
import Foundation

extension Publishers {
    
    static func system<State, Event>(
        initial: State,
        reduce: @escaping (State, Event) -> State,
        feedbacks: [Feedback<State, Event>]
    ) -> AnyPublisher<State, Never> {
        
        let stateSubject = CurrentValueSubject<State, Never>(initial)
        // 狗一样的写法.
        let events = feedbacks.map { feedback in feedback.run(stateSubject.eraseToAnyPublisher()) }
        
        return Deferred {
            Publishers.MergeMany(events)
                .receive(on: RunLoop.main)
                .scan(initial, reduce)
            // 又使用了副作用在这里.
                .handleEvents(receiveOutput: stateSubject.send)
                .receive(on: RunLoop.main)
                .prepend(initial)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

/*
 Scan
 
 Summary

 Transforms elements from the upstream publisher by providing the current element to a closure along with the last value returned by the closure.
 
 Declaration

 func scan<T>(_ initialResult: T, _ nextPartialResult: @escaping (T, Self.Output) -> T) -> Publishers.Scan<Self, T>
 Discussion

 Use scan(_:_:) to accumulate all previously-published values into a single value, which you then combine with each newly-published value.
 The following example logs a running total of all values received from the sequence publisher.
 let range = (0...5)
 cancellable = range.publisher
     .scan(0) { return $0 + $1 }
     .sink { print ("\($0)", terminator: " ") }
  // Prints: "0 1 3 6 10 15 ".
 Parameters

 initialResult
 The previous result returned by the nextPartialResult closure.
 nextPartialResult
 A closure that takes as its arguments the previous value returned by the closure and the next element emitted from the upstream publisher.
 Returns

 A publisher that transforms elements by applying a closure that receives its previous return value and the next element from the upstream publisher.

 */
