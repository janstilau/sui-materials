//
//  AppDelegate.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/1/31.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import SwiftMessages

/*
 @protocol UITabBarControllerDelegate <NSObject>
 @optional
 - (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController API_AVAILABLE(ios(3.0));
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

 - (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers API_AVAILABLE(ios(3.0)) API_UNAVAILABLE(tvos);
 - (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers changed:(BOOL)changed API_AVAILABLE(ios(3.0)) API_UNAVAILABLE(tvos);
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers changed:(BOOL)changed API_UNAVAILABLE(tvos);

 - (UIInterfaceOrientationMask)tabBarControllerSupportedInterfaceOrientations:(UITabBarController *)tabBarController API_AVAILABLE(ios(7.0)) API_UNAVAILABLE(tvos);
 - (UIInterfaceOrientation)tabBarControllerPreferredInterfaceOrientationForPresentation:(UITabBarController *)tabBarController API_AVAILABLE(ios(7.0)) API_UNAVAILABLE(tvos);

 - (nullable id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                       interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController API_AVAILABLE(ios(7.0));

 - (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
             animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                               toViewController:(UIViewController *)toVC  API_AVAILABLE(ios(7.0));

 @end
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 1.加载tabbar样式
        let tabbar = self.setupTabBarStyle(delegate: self as? UITabBarControllerDelegate)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = tabbar
        self.window?.makeKeyAndVisible()
        return true
    }
    
    /// 1.加载tabbar样式
    ///
    /// - Parameter delegate: 代理
    /// - Returns: ESTabBarController
    func setupTabBarStyle(delegate: UITabBarControllerDelegate?) -> ESTabBarController {
        let tabBarController = ESTabBarController()
        tabBarController.delegate = delegate
        tabBarController.title = "Irregularity"
        tabBarController.tabBar.shadowImage = UIImage(named: "transparent")
        tabBarController.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
            return false
        }
        tabBarController.didHijackHandler = {
            [weak tabBarController] tabbarController, viewController, index in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let warning = MessageView.viewFromNib(layout: .cardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()
                
                let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
                warning.configureContent(title: "Warning", body: "暂时没有此功能", iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
                SwiftMessages.show(config: warningConfig, view: warning)
            }
        }
        
        let home = LBFMHomeController()
        let listen = LBFMListenController()
        let palyVC = LBFMPlayController()
        let find = LBFMFindController()
        let mine = LBFMMineController()
        
        home.tabBarItem = ESTabBarItem.init(LBFMIrregularityBasicContentView(), title: "首页", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        listen.tabBarItem = ESTabBarItem.init(LBFMIrregularityBasicContentView(), title: "我听", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        palyVC.tabBarItem = ESTabBarItem.init(LBFMIrregularityContentView(), title: nil, image: UIImage(named: "tab_play"), selectedImage: UIImage(named: "tab_play"))
        find.tabBarItem = ESTabBarItem.init(LBFMIrregularityBasicContentView(), title: "发现", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        mine.tabBarItem = ESTabBarItem.init(LBFMIrregularityBasicContentView(), title: "我的", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        let homeNav = LBFMNavigationController.init(rootViewController: home)
        let listenNav = LBFMNavigationController.init(rootViewController: listen)
        let playNav = LBFMNavigationController.init(rootViewController: palyVC)
        let findNav = LBFMNavigationController.init(rootViewController: find)
        let mineNav = LBFMNavigationController.init(rootViewController: mine)
        home.title = "首页"
        listen.title = "我听"
        palyVC.title = "播放"
        find.title = "发现"
        mine.title = "我的"
        
        tabBarController.viewControllers = [homeNav, listenNav, playNav, findNav, mineNav]
        return tabBarController
    }
}

