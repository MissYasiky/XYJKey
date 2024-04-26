//
//  AppDelegate.swift
//  key
//
//  Created by MissYasiky on 2023/12/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, PasswordViewControllerDelegate {
    static let passWordNecessary = 1
    var window: UIWindow?
    var shieldView: UIImageView?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        if AppDelegate.passWordNecessary == 1 {
            let vctrl = PasswordViewController()
            vctrl.delegate = self
            window?.rootViewController = vctrl
        } else {
            let nav = UINavigationController(rootViewController: HomeViewController())
            window?.rootViewController = nav
        }
        
        window?.makeKeyAndVisible()
        customNavigationBar()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        shield()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        lockApp()
        unshield()
    }
    
    // MARK: - Private Method
    
    private func lockApp() {
        guard AppDelegate.passWordNecessary == 1 else {
            return
        }
        let rootVctrl = window?.rootViewController
        if let rootVctrl, rootVctrl.isKind(of: PasswordViewController.self) { // 已加密
            return
        }
        if !SecurityManager.shared.isLock() { // 在 1min 解密期限内
            return
        }
        // 恢复加密状态
        let vctrl = PasswordViewController()
        vctrl.delegate = self
        window?.rootViewController = vctrl
    }
    
    private func shield() {
        if shieldView == nil {
            shieldView = UIImageView(frame: UIScreen.main.bounds)
            shieldView?.image = UIImage(named: "shield_bg")
        }
        window?.addSubview(shieldView!)
    }
    
    private func unshield() {
        if let shieldView {
            shieldView.removeFromSuperview()
        }
    }
    
    private func customNavigationBar() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = UIColor.textColor
        navigationBar.titleTextAttributes = [.font: UIFont.boldFont(size: 13)!,.foregroundColor:UIColor.textColor, .kern:3]
    }
    
    // MARK: - PasswordViewControllerDelegate
    func dismiss(passwordViewController: PasswordViewController) {
        SecurityManager.shared.unlockForSeconds()
        
        let nav = UINavigationController(rootViewController: HomeViewController())
        window?.rootViewController = nav
    }
}

