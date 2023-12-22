//
//  HomeViewController.swift
//  key
//
//  Created by MissYasiky on 2023/12/19.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import UIKit

@objc public class HomeViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, HomeTabBarDelegate {
    // MARK: UI
    private var tabBar: HomeTabBar = HomeTabBar()
    private var pageViewController: UIPageViewController! // 翻页控制器
    private var vctrlArray: [UIViewController]! // 子视图控制器数组
    // MARK: 状态
    private var selectedIndex = 0 // 选中 tab 索引
    
    // MARK: - Life Cycle
    
    @objc public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MY KEY";
        self.view.backgroundColor = UIColor.white
        
        initNavigationBar()
        initTabBar()
        initViewControllers()
        initPageViewControllers()
        initAddButton()
    }
    
    @objc public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let screenSize = UIScreen.main.bounds.size
        let navigationBarRect = self.navigationController != nil ? self.navigationController!.navigationBar.frame : CGRectZero
        self.tabBar.frame = CGRectMake(0, navigationBarRect.origin.y + navigationBarRect.size.height, screenSize.width, 35)
        
        let originY = self.tabBar.frame.origin.y + self.tabBar.frame.size.height
        self.pageViewController.view.frame = CGRectMake(0, originY, screenSize.width, screenSize.height - originY)
    }
    
    // MARK: - Private Methods
    private func initNavigationBar() {
        // 菜单页按钮
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(self.settingButtonAction), for: .touchUpInside)
        button.setImage(UIImage(named: "nav_btn_setting"), for: .normal)
        button.setImage(UIImage(named: "nav_btn_setting_highlight"), for: .highlighted)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        // 返回按钮统一配置
        let backItem = UIBarButtonItem.init(title: nil, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        
        let backImage = UIImage(named: "nav_btn_back")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        // 设置手势返回上一页
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func initTabBar() {
        tabBar.delegate = self
        self.view.addSubview(tabBar)
    }
    
    private func initViewControllers() {
        self.vctrlArray = [CardListViewController(), AccountListViewController()]
    }
    
    private func initPageViewControllers() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageViewController.setViewControllers([self.vctrlArray.first!], direction: .forward, animated: false)
        self.addChild(self.pageViewController)
        self.pageViewController.didMove(toParent: self)
        self.view.addSubview(self.pageViewController.view)
        
        self.pageViewController.view.clipsToBounds = false
        for subView in self.pageViewController.view.subviews {
            subView.clipsToBounds = false
        }
    }
    
    private func initAddButton() {
        let addButton = UIButton(type: .custom)
        addButton.addTarget(self, action: #selector(self.addButtonAction), for: .touchUpInside)
        addButton.setImage(UIImage(named: "home_btn_add"), for: .normal)
        addButton.setImage(UIImage(named: "home_btn_add_highlight"), for: .highlighted)
        addButton.layer.shadowColor = UIColor.themeBlue.cgColor
        addButton.layer.shadowOffset = CGSizeMake(0, 6)
        addButton.layer.shadowOpacity = 0.2
        addButton.layer.shadowRadius = 10.0
        
        let width = 55.0
        let delta = 25.0 + width
        let screenSize = UIScreen.main.bounds.size
        addButton.frame = CGRectMake(screenSize.width - delta, screenSize.height - delta, width, width)
    }
    
    private func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        guard index >= 0 && index < self.vctrlArray.count else {
            return nil
        }
        
        return self.vctrlArray[index]
    }
    
    private func indexOfViewController(_ vctrl: UIViewController) -> Int? {
        return self.vctrlArray.firstIndex(of: vctrl)
    }
    
    // MARK: - Event
    // MARK: Action
    
    @objc public func settingButtonAction() {
        self.navigationController?.pushViewController(PreferenceViewController(), animated: true)
    }
    
    @objc public func addButtonAction() {
        let vctrl = self.selectedIndex == 0 ? CardEditViewController() : AccountEditViewController()
        let nav = UINavigationController.init(rootViewController: vctrl)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true)
    }
    
    // MARK: - Delegate
    // MARK: HomeTabBar Delegate
    
    public func selectTabBar(index: Int) {
        guard index >= 0 && index < self.vctrlArray.count else {
            return
        }
        self.selectedIndex = index
        // 跳转到指定页面
        self.pageViewController.setViewControllers([self.vctrlArray[index]], direction: .forward, animated: false)
    }
    
    // MARK: UIPageViewController DataSource & Delegate
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = self.indexOfViewController(viewController) {
            return self.viewControllerAtIndex(index-1)
        } else {
            return nil
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = self.indexOfViewController(viewController) {
            return self.viewControllerAtIndex(index+1)
        } else {
            return nil
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let index = self.indexOfViewController(pendingViewControllers.first!) {
            self.selectedIndex = index
        } else {
            self.selectedIndex = 0
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.tabBar.select(index: self.selectedIndex)
        }
    }
}
