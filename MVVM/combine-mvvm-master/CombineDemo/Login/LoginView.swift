//
//  LoginView.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 07/06/2019.
//

import UIKit

// 将, View 的构建工作完全的交给了 View 层. VC 里面, 不在进行 View 的整体搭建. 
final class LoginView: UIView {
    
    lazy var loginTextField = UITextField()
    lazy var passwordTextField = UITextField()
    lazy var loginButton = UIButton()
    lazy var activityIndicator = ActivityIndicatorView(style: .medium)
    
    var isLoading: Bool = false {
        didSet { isLoading ? startLoading() : finishLoading() }
    }
    
    init() {
        super.init(frame: .zero)
        
        setupViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func startLoading() {
        isUserInteractionEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func finishLoading() {
        isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
    
    private func setupViews() {
        backgroundColor = .background
        
        [loginTextField, passwordTextField, loginButton, activityIndicator].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        loginTextField.backgroundColor = .systemBackground
        loginTextField.placeholder = "login"
        
        passwordTextField.backgroundColor = .systemBackground
        passwordTextField.placeholder = "password"
        
        loginButton.setTitle("Log in", for: UIControl.State())
        loginButton.setTitleColor(.white, for: UIControl.State())
        loginButton.backgroundColor = .nonValid
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            loginTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30.0),
            loginTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40.0),
            loginTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40.0),
            loginTextField.heightAnchor.constraint(equalToConstant: 30.0),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 10.0),
            passwordTextField.centerXAnchor.constraint(equalTo: loginTextField.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: loginTextField.widthAnchor, multiplier: 1.0),
            passwordTextField.heightAnchor.constraint(equalTo: loginTextField.heightAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20.0),
            loginButton.centerXAnchor.constraint(equalTo: loginTextField.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 120.0),
            loginButton.heightAnchor.constraint(equalToConstant: 30.0),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50.0)
        ])
    }
}
