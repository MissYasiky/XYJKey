//
//  CustomKeyCell.swift
//  key
//
//  Created by MissYasiky on 2023/12/5.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import UIKit

@objc public enum CustomKeyCellStyle: Int {
    case keyValue // 默认 style，key-value输入框模式
    case addKey
}

class CustomKeyCell: UITableViewCell, UITextFieldDelegate {
    @objc public static let height = 67.0
    
    @objc public  var row: Int = -1
    private let button: UIButton = UIButton(type: .custom)
    private let label: UILabel = UILabel()
    private let seperatorLine: UIView = UIView()
    private let seperatorView: UIView = UIView()
    private let keyTextField: UITextField = UITextField()
    private let valueTextField: UITextField = UITextField()
    private var style: CustomKeyCellStyle = .keyValue
    
    @objc public var didTapDeleteButton: ((_ row: Int) -> Void)?
    @objc public var didTextFieldBeginEditing: ((_ row: Int) -> Void)?
    @objc public var didTextFieldChanged: ((_ row: Int, _ key: String, _ value: String) -> Void)?
    
    // MARK: - Life Cycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        initUI()
        updateStyle(style:.keyValue)
    }
    
    @objc public override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = UIScreen.main.bounds.size.width
        let height = CustomKeyCell.height
        let xPadding = 25.0
        let contentWidth = width - xPadding * 2.0
        
        button.frame = CGRect(x: xPadding, y: (height - 23) / 2.0, width: 23, height: 23)
        label.frame = CGRect(x: button.frame.origin.x + button.frame.size.width + 10.0, y: (height - 22) / 2.0, width: 120, height: 22)
        seperatorLine.frame = CGRect(x: 0, y: 0, width: 1, height: 23)
        seperatorLine.center = self.contentView.center
        seperatorView.frame = CGRect(x: xPadding, y: height - 0.5, width: contentWidth, height: 0.5)
        
        var textFieldOriginX = xPadding + button.frame.size.width + 10
        var textFieldWidth = width / 2 - textFieldOriginX - 10
        let textFieldHeight = 18.0
        let textFieldOriginY = (height - textFieldHeight) / 2
        keyTextField.frame = CGRect(x: textFieldOriginX, y: textFieldOriginY, width: textFieldWidth, height: textFieldHeight)
        
        textFieldOriginX = width / 2 + 10
        textFieldWidth = width / 2 - 10 - 25
        valueTextField.frame = CGRect(x: textFieldOriginX, y: textFieldOriginY, width: textFieldWidth, height: textFieldHeight)
    }
    
    // MARK: - Public Methods
    @objc public func updateStyle(style: CustomKeyCellStyle) {
        self.style = style
        switch style {
        case .keyValue:
            button.isUserInteractionEnabled = true
            button.setImage(UIImage(named: "list_btn_delete"), for: .normal)
            label.isHidden = true
            seperatorLine.isHidden = false
            keyTextField.isHidden = false
            valueTextField.isHidden = false
        case .addKey:
            button.isUserInteractionEnabled = false
            button.setImage(UIImage(named: "list_btn_add"), for: .normal)
            label.isHidden = false
            seperatorLine.isHidden = true
            keyTextField.isHidden = true
            valueTextField.isHidden = true
        }
    }
    
    @objc public func setKeyValue(key: String?, value: String?) {
        keyTextField.text = key
        valueTextField.text = value
    }
    
    // MARK: - Private Methods
    
    private func initUI() {
        button.addTarget(self, action: #selector(CustomKeyCell.buttonAction), for: .touchUpInside)
        self.contentView.addSubview(button)
        
        label.text = "添加自定义字段"
        label.font = UIFont.regularFont(size: 15)
        label.textColor = UIColor.textColor
        self.contentView.addSubview(label)
        
        seperatorLine.backgroundColor = UIColor.lineColor
        self.contentView.addSubview(seperatorLine)
        
        seperatorView.backgroundColor = UIColor.lineColor
        self.contentView.addSubview(seperatorView)
        
        keyTextField.font = UIFont.regularFont(size: 15)
        keyTextField.textColor = UIColor.textColor
        keyTextField.delegate = self
        keyTextField.addTarget(self, action: #selector(CustomKeyCell.textFieldDidChange), for: .editingChanged)
        self.contentView.addSubview(keyTextField)
        
        valueTextField.font = UIFont.regularFont(size: 15)
        valueTextField.textColor = UIColor.textColor
        valueTextField.delegate = self
        valueTextField.addTarget(self, action: #selector(CustomKeyCell.textFieldDidChange), for: .editingChanged)
        self.contentView.addSubview(valueTextField)
    }
    
    // MARK: - Action
    
    @objc func buttonAction() {
        guard row >= 0 else {
            return
        }
        didTapDeleteButton?(row)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard row >= 0 else {
            return
        }
        didTextFieldChanged?(row, keyTextField.text ?? "", valueTextField.text ?? "")
    }
    
    // MARK: - Delegate
    // MARK: UITextField Delegate
    
    @objc public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard row >= 0 else {
            return
        }
        didTextFieldBeginEditing?(row)
    }
}
