//
//  ViewModel.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 07/06/2019.
//

import Foundation
import Combine

/*
 ViewModel 的各种信号 Transform, 是一个非常必要的事情.
 最终的效果, 就是使得 ViewModel 在 VC 里面, 就像是信号槽一样被使用.
 */
final class LoginViewModel {
    
    @Published var login: String = ""
    @Published var password: String = ""
    @Published private(set) var isLoading = false
    
    var validationResult: AnyPublisher<Void, Error> {
        return _validationResult.eraseToAnyPublisher()
    }
    private let _validationResult = PassthroughSubject<Void, Error>()
    
    /*
     ViewModel 有一个很麻烦的地方, 就是他要进行信号的合并处理. 将单一的信号, 通过自己的业务逻辑, 变为一个 View 直接可以使用的信号源.
     
     好处就是, 之后的修改都是自动响应的了.
     .assign(to: \.login, on: viewModel)
     自动触发 isInputValid 相关信号的发射, 导致 UI 的变化.
     
     如果是之前命令式的, 就是
     修改 login, password 两个字符串属性的值.
     然后进行 isInputValid 判断.
     然后根据结果, 进行 View 的更新. 所有的逻辑, 都写到了 Controller 类里面.
     
     现在, 在 ViewModel 里面, 将所有的 UI 相关的绑定信号进行构建, Controller 里面, 仅仅是作为绑定, 上面的 Controller 逻辑, 利用响应式的框架自动完成. 
     */
    private(set) lazy var isInputValid: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest($login, $password)
            .map {
                $0.count > 0 && $1.count > 0
            }
            .eraseToAnyPublisher()
    }()
    
    private let credentialsValidator: CredentialsValidatorProtocol
    
    // 小小的 ViewModel, 居然还使用了依赖注入.
    init(credentialsValidator: CredentialsValidatorProtocol = CredentialsValidator()) {
        self.credentialsValidator = credentialsValidator
    }
    
    /*
     View Model 的 IntentAction, 里面触发对应的信号的发射.
     对于, 这种不能依靠 @Published 来合成出来的信号, 要专门定义一个 Subject 来发射信号.
     这其实和 Delegate 没有太大区别.
     */
    func validateCredentials() {
        isLoading = true
        
        // 触发控制层的逻辑操作, 然后发射出信号出去.
        credentialsValidator.validateCredentials(login: login, password: password) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success:
                self?._validationResult.send(())
            case let .failure(error):
                self?._validationResult.send(completion: .failure(error))
            }
        }
    }
}

// MARK: - CredentialsValidatorProtocol

protocol CredentialsValidatorProtocol {
    func validateCredentials(login: String, password: String, completion: @escaping (Result<(), Error>) -> Void)
}

/// This class acts as an example of asynchronous credentials validation
/// It's for demo purpose only. In the real world it would make an actual request or use other authentication method
final class CredentialsValidator: CredentialsValidatorProtocol {
    func validateCredentials(login: String, password: String, completion: @escaping (Result<(), Error>) -> Void) {
            let time: DispatchTime = .now() + .milliseconds(Int.random(in: 200 ... 1_000))
            DispatchQueue.main.asyncAfter(deadline: time) {
                completion(.success(()))
            }
        }
}
