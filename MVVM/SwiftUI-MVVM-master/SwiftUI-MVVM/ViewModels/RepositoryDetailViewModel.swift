//
//  RepositoryDetailViewModel.swift
//  SwiftUI-MVVM
//
//  Created by Yusuke Kita on 6/5/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

// Detail 中, 并没有多少逻辑. 
final class RepositoryDetailViewModel: ObservableObject {
    let objectWillChange: AnyPublisher<RepositoryListViewModel, Never>
    private let objectWillChangeSubject = PassthroughSubject<RepositoryListViewModel, Never>()
    
    let repository: Repository
    
    init(repository: Repository) {
        objectWillChange = objectWillChangeSubject.eraseToAnyPublisher()
        self.repository = repository
    }
}
