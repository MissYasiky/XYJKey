//
//  DetailLabelCell.swift
//  key
//
//  Created by MissYasiky on 2023/11/30.
//  Copyright © 2023 netease. All rights reserved.
//

import UIKit
import Foundation

enum DetailLabelCellStyle: Int {
    case onlyLabel // 默认，纯文本
    case textField // 带输入框
}

enum DetailLabelCellTextFieldStyle: Int {
    case Chinese // 默认，中文键盘
    case number // 银行卡类型
    case date // 日期类型
    case CVV // 三位安全码类型
}

protocol DetailLabelCellDelegate {
    func longPress(message: String)
}

class DetailLabelCell: UITableViewCell, UITextFieldDelegate {
    static let height = 102.0
    var delegate: DetailLabelCellDelegate?
    
    private let topLabel = UILabel()
    private let bottomLabel = UILabel()
    private let seperatorView = UIView()
    private let textField = UITextField()
    private var style: DetailLabelCellStyle = .onlyLabel
    private var textFieldStyle: DetailLabelCellTextFieldStyle = .Chinese
    
    var content: String? {
        get {
            return textField.text
        }
    }
    
    // MARK: - Life Cycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        initUI()
        updateStyle(style:.onlyLabel)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(DetailLabelCell.longPressAction))
        contentView.addGestureRecognizer(gesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = UIScreen.main.bounds.size.width
        let height = DetailLabelCell.height
        let xPadding = 25.0
        let labelWidth = width - xPadding * 2.0
        
        topLabel.frame = CGRect(x: xPadding, y: xPadding, width: labelWidth, height: 13)
        bottomLabel.frame = CGRect(x: xPadding, y: height - xPadding - 17, width: labelWidth, height: 17)
        seperatorView.frame = CGRect(x: xPadding, y: height - 0.5, width: labelWidth, height: 0.5)
        textField.frame = CGRect(x: xPadding, y: 63, width: labelWidth, height: 28)
    }
    
    // MARK: - Public Methods
    
    func setText(lineOneText: String, lineTwoText: String) {
        updateStyle(style: .onlyLabel)
        topLabel.text = lineOneText
        bottomLabel.text = lineTwoText
    }
    
    func setText(title: String, content: String?, placeholder: String) {
        updateStyle(style: .textField)
        topLabel.text = title
        textField.text = content
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font: UIFont.regularFont(size: 15)!,.foregroundColor:UIColor.textColor(alpha: 0.5)])
    }
    
    func updateStyle(style: DetailLabelCellStyle) {
        self.style = style
        switch style {
        case .onlyLabel:
            bottomLabel.isHidden = false
            textField.isHidden = true
        case .textField:
            bottomLabel.isHidden = true
            textField.isHidden = false
        }
    }
    
    func updateTextFieldStyle(style: DetailLabelCellTextFieldStyle) {
        self.textFieldStyle = style
        switch style {
        case .Chinese:
            textField.keyboardType = .asciiCapable
        case .number, .date, .CVV:
            textField.keyboardType = .numberPad
        }
    }
    
    // MARK: - Private Methods
    
    private func initUI() {
        topLabel.font = UIFont.regularFont(size: 11)
        topLabel.textColor = UIColor.textColor(alpha: 0.5)
        contentView.addSubview(topLabel)
        
        bottomLabel.font = UIFont.regularFont(size: 15)
        bottomLabel.textColor = UIColor.textColor
        contentView.addSubview(bottomLabel)
        
        seperatorView.backgroundColor = UIColor.lineColor
        contentView.addSubview(seperatorView)
        
        textField.font = UIFont.regularFont(size: 15)
        textField.textColor = UIColor.textColor
        textField.delegate = self
        textField.addTarget(self, action: #selector(DetailLabelCell.textFieldDidEndEditing), for: .editingChanged)
        contentView.addSubview(textField)
    }
    
    private func correctEnter(text: String?) -> String? {
        if textFieldStyle == .Chinese {
            return text
        }
        
        var correctedText = text?.scanNumber()
        if let temp = correctedText {
            if textFieldStyle == .number {
                if temp.count > 21 {
                    let endIndex = temp.index(temp.startIndex, offsetBy: 21)
                    correctedText = String(temp[..<endIndex])
                }
                correctedText = correctedText?.scanAndSeperateEveryFour()
            } else if textFieldStyle == .date {
                if temp.count > 4 {
                    let endIndex = temp.index(temp.startIndex, offsetBy: 4)
                    correctedText = String(temp[..<endIndex])
                }
            } else if textFieldStyle == .CVV {
                if temp.count > 3 {
                    let endIndex = temp.index(temp.startIndex, offsetBy: 3)
                    correctedText = String(temp[..<endIndex])
                }
            }
        }
        return correctedText
    }
    
    // MARK: - Action
    
    @objc func longPressAction(gesture: UILongPressGestureRecognizer) {
        guard style == .onlyLabel else {
            return
        }
        
        if let text = bottomLabel.text {
            delegate?.longPress(message: text)
        }
    }
    
    // MARK: - Delegate
    // MARK: UITextFile delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textField.text = correctEnter(text: textField.text)
    }
}
