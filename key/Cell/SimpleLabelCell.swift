//
//  SimpleLabelCell.swift
//  key
//
//  Created by MissYasiky on 2023/11/8.
//  Copyright © 2023 netease. All rights reserved.
//

import UIKit
import Foundation

enum SimpleLabelCellStyle: Int {
    case indicator // 默认 style 带小箭头
    case check // 对勾模式
    case onlyLabel // 无小箭头
}

class SimpleLabelCell: UITableViewCell {
    static let height = 80.0
    private var style: SimpleLabelCellStyle = .indicator
    private let iconImageView = UIImageView()
    private let checkImageView = UIImageView(image: UIImage(named: "list_indicator_uncheck"))
    private let indicatorImageView = UIImageView(image: UIImage(named: "list_indicator_arrow"))
    private let label: UILabel = UILabel()
    private let seperatorView: UIView = UIView()
    
    // MARK: - Life Cycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        self.addSubview(iconImageView)
        self.addSubview(checkImageView)
        self.addSubview(indicatorImageView)
        
        label.textColor = UIColor.textColor
        label.font = UIFont.regularFont(size: 15)
        self.addSubview(label)
        
        seperatorView.backgroundColor = UIColor.lineColor
        self.addSubview(seperatorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = UIScreen.main.bounds.size.width
        let height = SimpleLabelCell.height
        let xPadding = 25.0
        
        iconImageView.frame = CGRect(x: xPadding, y: (height - 23) / 2.0, width: 23, height: 23)
        indicatorImageView.frame = CGRect(x: width - xPadding - 20, y: (height - 16) / 2.0, width: 20, height: 16)
        checkImageView.frame = CGRect(x: width - xPadding - 20, y: (height - 16) / 2.0, width: 20, height: 16)
        
        let originX = iconImageView.frame.origin.x + iconImageView.frame.size.width + 10
        let labelWidth = indicatorImageView.frame.origin.x - originX
        label.frame = CGRect(x: originX, y: (height - 17) / 2.0, width: labelWidth, height: 17)
        seperatorView.frame = CGRect(x: xPadding, y: height - 0.5, width: width - xPadding - xPadding, height: 0.5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if style != .check {
            return
        }
        
        let imageName = selected ? "list_indicator_checked" : "list_indicator_uncheck"
        checkImageView.image = UIImage(named: imageName)
    }
    
    // MARK: - Public Methods
    
    func setStyle(style: SimpleLabelCellStyle) {
        self.style = style
        switch style {
        case .indicator:
            indicatorImageView.isHidden = false
            checkImageView.isHidden = true
        case .check:
            indicatorImageView.isHidden = true
            checkImageView.isHidden = false
        case .onlyLabel:
            indicatorImageView.isHidden = true
            checkImageView.isHidden = true
        }
    }
    
    func setCellIconImageName(imageName: String) {
        iconImageView.image = UIImage(named: imageName)
    }
    
    func setLabelText(text: String) {
        label.text = text
    }
}
