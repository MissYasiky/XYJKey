//
//  HomeListCell.swift
//  key
//
//  Created by MissYasiky on 2023/12/5.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import UIKit

class HomeListCell: UITableViewCell {
    static let height = 90.0
    
    private let indicatorImageView: UIImageView = UIImageView(image: UIImage(named: "list_indicator_arrow"))
    private let topLabel: UILabel = UILabel()
    private let midLabel: UILabel = UILabel()
    private let bottomLabel: UILabel = UILabel()
    private let taLabel: UILabel = UILabel()
    private let seperatorView: UIView = UIView()
    
    // MARK: - Life Cycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        initUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = UIScreen.main.bounds.size.width
        let height = HomeListCell.height
        let xPadding = 25.0
        indicatorImageView.frame = CGRect(x: width - xPadding - 20, y: (height - 16) / 2, width: 20, height: 16)
        
        let labelWidth = indicatorImageView.frame.origin.x - xPadding
        topLabel.frame = CGRect(x: xPadding, y: 13, width: labelWidth, height: 17)
        midLabel.frame = CGRect(x: xPadding, y: 33, width: labelWidth, height: 13)
        bottomLabel.frame = CGRect(x: xPadding, y: 60, width: labelWidth, height: 17)
        seperatorView.frame = CGRect(x: xPadding, y: height - 0.5, width: width - xPadding * 2, height: 0.5)
        
        let taLabelWidth = indicatorImageView.frame.origin.x - 22.0
        taLabel.frame = CGRect(x: taLabelWidth, y: (height - 25) / 2, width: 22, height: 25)
    }
    
    // MARK: - Public Methods
    
    func setText(lineOneText: String, lineTwoText: String?, lineThreeText: String) {
        setText(lineOneText: lineOneText, lineTwoText: lineTwoText, lineThreeText: lineThreeText, other: false)
    }
    
    func setText(lineOneText: String, lineTwoText: String?, lineThreeText: String, other: Bool) {
        topLabel.text = lineOneText
        midLabel.text = lineTwoText
        bottomLabel.text = lineThreeText
        taLabel.isHidden = !other
    }
    
    // MARK: - Private Methods
    
    private func initUI() {
        contentView.addSubview(indicatorImageView)
        
        topLabel.font = UIFont.regularFont(size: 15)
        topLabel.textColor = UIColor.textColor
        contentView.addSubview(topLabel)
        
        midLabel.font = UIFont.regularFont(size: 11)
        midLabel.textColor = UIColor.textColor(alpha: 0.5)
        contentView.addSubview(midLabel)
        
        bottomLabel.font = UIFont.regularFont(size: 15)
        bottomLabel.textColor = UIColor.textColor
        contentView.addSubview(bottomLabel)
        
        seperatorView.backgroundColor = UIColor.lineColor
        contentView.addSubview(seperatorView)
        
        taLabel.text = "TA"
        taLabel.font = UIFont.boldFont(size: 13)
        taLabel.textAlignment = .center
        taLabel.layer.cornerRadius = 4
        taLabel.layer.masksToBounds = true
        taLabel.backgroundColor = UIColor.color("0xdd5757", alpha: 0.2)
        taLabel.textColor = UIColor.color("0xdd5757")
        contentView.addSubview(taLabel)
    }
}
