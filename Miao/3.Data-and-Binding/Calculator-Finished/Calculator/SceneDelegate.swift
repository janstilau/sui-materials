//
//  SceneDelegate.swift
//  Calculator
//
//  Created by Wang Wei on 2019/06/17.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Use a UIHostingController as window root view controller
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            // 在 ContentView 的构造的时候, 要将依赖的 environmentObject 进行注入的工作.
            // 是否是, environmentObject 值能是通过注入, 就算是在顶层的 View 中, 也不能够生成.
            // 但是这里没有指定属性名啊, 他怎么之后, 传入的参数, 要绑定到 @EnvironmentObject var model: CalculatorModel 这个属性上呢.
            window.rootViewController = UIHostingController(rootView: ContentView()
                                                                .environmentObject(CalculatorModel()))
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

