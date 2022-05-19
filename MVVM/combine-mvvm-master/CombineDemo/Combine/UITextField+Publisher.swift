//
//  UITextField+Publisher.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 03/07/2019.
//

import UIKit
import Combine

extension UITextField {
    // 使用, UITextField 的 Notification, 可以很方便的将 UITextFiled 进行 信号化.
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField } // receiving notifications with objects which are instances of UITextFields
            .compactMap(\.text) // extracting text and removing optional values (even though the text cannot be nil)
            .eraseToAnyPublisher()
    }
}
