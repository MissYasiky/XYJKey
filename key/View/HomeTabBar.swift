//
//  HomeTabBar.swift
//  key
//
//  Created by MissYasiky on 2023/11/15.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import UIKit

protocol HomeTabBarDelegate {
    func selectTabBar(index: Int)
}

class HomeTabBar: UIView {
    private let height = 35.0
    private let buttonTag = 101
    private let tabTitleArray: [String] = ["CARD", "ACCOUNT"]
    private var buttonArray: [UIButton] = []
    private var selectedLine: UIView!
    private var selectedIndex = -1
    var delegate: HomeTabBarDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let buttonWidth = UIScreen.main.bounds.size.width / CGFloat(tabTitleArray.count)
        let buttonHeight = height
        for i in 0..<tabTitleArray.count {
            let button = UIButton(type: .custom)
            button.frame = CGRectMake(CGFloat(i) * buttonWidth, 0, buttonWidth, buttonHeight)
            button.setTitle(tabTitleArray[i], for: .normal)
            button.setTitleColor(UIColor.textColor, for: .selected)
            button.setTitleColor(UIColor.textColor(alpha: 0.5), for: .normal)
            button.titleEdgeInsets = UIEdgeInsets(top: -2, left: 0, bottom: 2, right: 0)
            button.titleLabel?.attributedText = NSAttributedString(string: tabTitleArray[i], attributes: [.font: UIFont.boldFont(size: 13)!, .kern:3])
            button.tag = i + buttonTag
            button.addTarget(self, action: #selector(HomeTabBar.buttonAction), for: .touchUpInside)
            self.addSubview(button)
            
            buttonArray.append(button)
            
            if i == 0 {
                button.isSelected = true
            }
        }
        
        selectedLine = UIView(frame: CGRectMake(0, height - 2.5, 25.0, 2.5))
        selectedLine.backgroundColor = UIColor.textColor
        self.addSubview(selectedLine)
        
        self.select(index: 0)
    }
    
    func select(index:Int) {
        guard index >= 0 && index < tabTitleArray.count && index != selectedIndex else {
            return
        }
        
        for i in 0..<tabTitleArray.count {
            buttonArray[i].isSelected = (i==index)
        }
        
        var rect = selectedLine.frame
        let width = UIScreen.main.bounds.size.width / CGFloat(tabTitleArray.count)
        rect.origin.x = CGFloat(index) * width + (width - 25.0) / 2.0
        selectedLine.frame = rect
        
        selectedIndex = index
    }
    
    @objc private func buttonAction(sender: UIButton) {
        let index = sender.tag - buttonTag
        delegate?.selectTabBar(index: index)
        
        self.select(index: index)
    }
}
