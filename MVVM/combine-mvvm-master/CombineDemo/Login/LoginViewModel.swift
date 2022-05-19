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
    @Published var isLoading = false
    var validationResult: AnyPublisher<Void, Error> {
        return _validationResult.eraseToAnyPublisher()
    }
    private let _validationResult = PassthroughSubject<Void, Error>()
    
    /*
     ViewModel 有一个很麻烦的地方, 就是他要进行信号的合并处理. 将单一的信号, 通过自己的业务逻辑, 变为一个 View 直接可以使用的信号源.
     */
    /*
     对于 Subject 来说, 如果他里面有值, 如果下游节点 Request Demand 的话, 他就会把当前值输出出去.
     所以, Published Subject 和 Current Value Subject 一样, 是可以直接和 View 绑定在一起的.
     因为会有初值.
     */
    private(set) lazy var isInputValid: AnyPublisher<Bool, Never> = Publishers.CombineLatest($login, $password)
        .map {
            $0.count > 0 && $1.count > 0
        }
        .eraseToAnyPublisher()
    
    private let credentialsValidator: CredentialsValidatorProtocol
    
    // 小小的 ViewModel, 居然还使用了依赖注入.
    init(credentialsValidator: CredentialsValidatorProtocol = CredentialsValidator()) {
        self.credentialsValidator = credentialsValidator
    }
    
    /*
     View Model 的 IntentAction, 里面触发对应的信号的发射.
     */
    func validateCredentials() {
        isLoading = true
        
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
