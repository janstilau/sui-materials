//
//  LoginViewController.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 07/06/2019.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private lazy var contentView = LoginView()
    private let viewModel: LoginViewModel
    private var bindings = Set<AnyCancellable>()
    
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        setUpTargets()
        setUpBindings()
    }
    
    private func setUpTargets() {
        contentView.loginButton.addTarget(self, action: #selector(loginBtnDidClicked), for: .touchUpInside)
    }
    
    private func setUpBindings() {
        /*
         View Acrtion 触发 IntentAction.
         这里直接就是进行了 ViewModel 里面的数据改变.
         因为是 @Published, 数据的改变, 会触发内部的信号处理, 就是 validationResult.
         下面的 validationResult 和 Btn 的绑定, 使得 View 可以自动的进行更新.
         */
        
        /*
         所有的绑定, 都要添加到 bindings 里面去.
         信号, 只有在 Complete 事件, 和 主动 cancel 的时候, 才会引起整个响应链条的消亡.
         为了能够让响应链随着 VC 的生命周期消失, 使用了 Bag 的机制.
         */
        func bindViewToViewModel() {
            contentView.loginTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.login, on: viewModel)
                .store(in: &bindings)
            
            contentView.passwordTextField.textPublisher
                .receive(on: RunLoop.main)
                .assign(to: \.password, on: viewModel)
                .store(in: &bindings)
        }

        /*
         ViewModel 中的处理好的信号, 直接绑定到 View 上.
         ViewModel 有责任, 进行相关 View 的显示逻辑, 和 Model 逻辑之间的转化.
         */
        func bindViewModelToView() {
            viewModel.isInputValid
                .receive(on: RunLoop.main)
                .assign(to: \.isValid, on: contentView.loginButton)
                .store(in: &bindings)
            contentView.loginButton.isValid = true
            
            viewModel.$isLoading
                .assign(to: \.isLoading, on: contentView)
                .store(in: &bindings)
            
            viewModel.validationResult
                .sink { completion in
                    switch completion {
                    case .failure:
                        // Error can be handled here (e.g. alert)
                        return
                    case .finished:
                        return
                    }
                } receiveValue: { [weak self] _ in
                    self?.navigateToList()
                }
                .store(in: &bindings)
            
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    @objc private func loginBtnDidClicked() {
        viewModel.validateCredentials()
    }
    
    private func navigateToList() {
        let listViewController = ListViewController()
        navigationController?.pushViewController(listViewController, animated: true)
    }
}
