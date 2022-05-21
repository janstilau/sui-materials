//
//  RepositoryListViewModelTests.swift
//  SwiftUI-MVVMTests
//
//  Created by Yusuke Kita on 6/7/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation
import Combine
import XCTest
@testable import SwiftUI_MVVM

/*
 ViewModel 的可测试性.
 */
// Controller 层, 是提供了
final class RepositoryListViewModelTests: XCTestCase {
    
    func test_updateRepositoriesWhenOnAppear() {
        let apiService = MockAPIService()
        apiService.stub(for: SearchRepositoryRequest.self) { _ in
            Result.Publisher(
                SearchRepositoryResponse(
                    items: [
                        .init(
                            id: 1,
                            fullName: "foo",
                            owner: .init(id: 1, login: "bar", avatarUrl: URL(string: "http://baz.com")!)
                        )
                    ]
                )
            ).eraseToAnyPublisher()
        }
        // 注入可测试的 Service 实现. 验证结果.
        // 验证结果, 就是检测输出的信号值.
        // 使用 Subject 来充当信号源. 既保持了属性的可读性, 也是信号发送的一种机制.
        let viewModel = makeViewModel(apiService: apiService)
        viewModel.apply(.onAppear)
        XCTAssertTrue(!viewModel.repositories.isEmpty)
    }
    
    func test_serviceErrorWhenOnAppear() {
        let apiService = MockAPIService()
        // Mock 网络错误的情况.
        apiService.stub(for: SearchRepositoryRequest.self) { _ in
            Result.Publisher(
                APIServiceError.responseError
            ).eraseToAnyPublisher()
        }
        let viewModel = makeViewModel(apiService: apiService)
        viewModel.apply(.onAppear)
        XCTAssertTrue(viewModel.isErrorShown)
    }
    
    func test_logListViewWhenOnAppear() {
        let trackerService = MockTrackerService()
        let viewModel = makeViewModel(trackerService: trackerService)
        
        viewModel.apply(.onAppear)
        XCTAssertTrue(trackerService.loggedTypes.contains(.listView))
    }
    
    func test_showIconEnabledWhenOnAppear() {
        let experimentService = MockExperimentService()
        experimentService.stubs[.showIcon] = true
        let viewModel = makeViewModel(experimentService: experimentService)
        
        viewModel.apply(.onAppear)
        XCTAssertTrue(viewModel.shouldShowIcon)
    }
    
    func test_showIconDisabledWhenOnAppear() {
        let experimentService = MockExperimentService()
        experimentService.stubs[.showIcon] = false
        let viewModel = makeViewModel(experimentService: experimentService)
        
        viewModel.apply(.onAppear)
        XCTAssertFalse(viewModel.shouldShowIcon)
    }
    
    private func makeViewModel(
        apiService: APIServiceType = MockAPIService(),
        trackerService: TrackerType = MockTrackerService(),
        experimentService: ExperimentServiceType = MockExperimentService()
    ) -> RepositoryListViewModel {
        return RepositoryListViewModel(
            apiService: apiService,
            trackerService: trackerService,
            experimentService: experimentService
        )
    }
}
