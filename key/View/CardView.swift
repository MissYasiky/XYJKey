//
//  CardView.swift
//  key
//
//  Created by MissYasiky on 2023/11/30.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import UIKit

private let cardTextColor: String = "0xC1D9F5"

@objc public class CardView: UIView {
    private let shadowImageView = UIImageView(image: UIImage(named: "card_bg_shadow"))
    private let bgImageView = UIImageView(image: UIImage(named: "card_bg"))
    private let leftLabel = UILabel()
    private let rightLabel = UILabel()
    private let numLabel = UILabel()
    private let typeLabel = UILabel()
    private let cvvLabel = UILabel()
    private let ownerLabel = UILabel()
    private let dateLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc public override func layoutSubviews() {
        super.layoutSubviews()
        
        let cardPadding = 25.0
        let cardWidth = self.bounds.size.width - cardPadding * 2
        let cardHeight = self.bounds.size.height - cardPadding * 2
        shadowImageView.frame = self.bounds
        bgImageView.frame = CGRect(x: cardPadding, y: cardPadding, width: cardWidth, height: cardHeight)
        
        let padding = 20.0
        numLabel.frame = CGRect(x: padding, y: 35, width: cardWidth - 2 * padding, height: 20)
        typeLabel.frame = CGRect(x: padding, y: 71, width: 80, height: 15)
        cvvLabel.frame = CGRect(x: cardWidth - padding - 80, y: 71, width: 80, height: 15)
        
        let littleLabelHeight = 11.0
        let middleLabelHeight = 14.0
        leftLabel.frame = CGRect(x: 40, y: cardHeight - 60 - littleLabelHeight, width: 80, height: littleLabelHeight)
        ownerLabel.frame = CGRect(x: 40, y: cardHeight - 40 - middleLabelHeight, width: 80, height: middleLabelHeight)
        
        rightLabel.frame = CGRect(x: cardWidth - padding - 65, y: cardHeight - 60 - littleLabelHeight, width: 65, height: littleLabelHeight)
        dateLabel.frame = CGRect(x: cardWidth - padding - 65, y: cardHeight - 40 - middleLabelHeight, width: 65, height: middleLabelHeight)
    }
    
    @objc public init(card: Card) {
        super.init(frame: CGRectZero)
        initUI()
        update(card: card)
    }
    
    @objc public func update(card: Card) {
        numLabel.text = card.accountNum?.scanAndSeperateEveryFour() ?? ""
        typeLabel.text = card.cardType
        cvvLabel.text = "CVV2/\(card.cvv2 ?? "")"
        ownerLabel.text = card.cardOwner
        dateLabel.text = card.formatedValidThru ?? ""
    }
    
    private func initUI() {
        self.addSubview(shadowImageView)
        self.addSubview(bgImageView)
        
        leftLabel.font = UIFont.regularFont(size: 9)
        leftLabel.textColor = UIColor.color(cardTextColor)
        leftLabel.text = "CARD HOLDER"
        bgImageView.addSubview(leftLabel)
        
        rightLabel.font = UIFont.regularFont(size: 9)
        rightLabel.textColor = UIColor.color(cardTextColor)
        rightLabel.text = "MONTH/YEAR"
        rightLabel.textAlignment = .right
        bgImageView.addSubview(rightLabel)
        
        numLabel.font = UIFont.boldFont(size: 19)
        numLabel.textColor = UIColor.color(cardTextColor)
        bgImageView.addSubview(numLabel)
        
        typeLabel.font = UIFont.boldFont(size: 12)
        typeLabel.textColor = UIColor.white
        bgImageView.addSubview(typeLabel)
        
        cvvLabel.font = UIFont.boldFont(size: 12)
        cvvLabel.textColor = UIColor.color(cardTextColor)
        cvvLabel.textAlignment = .right
        bgImageView.addSubview(cvvLabel)
        
        ownerLabel.font = UIFont.boldFont(size: 12)
        ownerLabel.textColor = UIColor.white
        bgImageView.addSubview(ownerLabel)
        
        dateLabel.font = UIFont.boldFont(size: 12)
        dateLabel.textColor = UIColor.white
        dateLabel.textAlignment = .center
        bgImageView.addSubview(dateLabel)
    }
}
