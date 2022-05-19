//
//  UIColor+Colors.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 03/07/2019.
//

import UIKit

/*
 将, 常用的 Color, 使用表意的常量进行代替.
 然后定义成为 UIColor 的 static 的变量, 是一个绝对正确且常用的设计方案. 
 */
extension UIColor {
    static let background = UIColor(named: "mainBackground")
    static let valid = UIColor(named: "valid")
    static let nonValid = UIColor(named: "nonValid")
}
