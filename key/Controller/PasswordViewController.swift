//
//  PasswordViewController.swift
//  key
//
//  Created by MissYasiky on 2023/11/11.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol PasswordViewControllerDelegate {
    @objc func dismiss(passwordViewController: PasswordViewController)
}

@objc public class PasswordViewController: UIViewController, UITextViewDelegate {
    private var textView: UITextView!
    private var labelArray: Array<UILabel>!
    @objc public var delegate: PasswordViewControllerDelegate?
    
    @objc public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        textView.isHidden = true
        textView.delegate = self
        self.view.addSubview(textView)
        
        let screenWidth = UIScreen.main.bounds.size.width
        let width = 30.0
        let span = 30.0
        let originX = (screenWidth - width * 4 - span * 3) / 2.0
        
        labelArray = Array()
        for i in 0...3 {
            let label = UILabel(frame: CGRectMake(originX + Double(i) * (width + span), 260, width, 35))
            label.frame = CGRectMake(originX + Double(i) * (width + span), 260, width, 35)
            label.font = FontUtil.regularFont(size: 45)
            label.textAlignment = .center
            label.textColor = ColorUtil.color("0x696969")
            label.text = "-"
            self.view.addSubview(label)
            
            self.labelArray.append(label)
        }
    }

    @objc public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    @objc public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return text.count == 0 || (text >= "0" && text <= "9");
    }
    
    @objc public func textViewDidChange(_ textView: UITextView) {
        guard let _ = textView.text else {
            return
        }
        
        let content = textView.text!
        if content.count > 4 {
            textView.text = String(content[content.startIndex...content.index(content.startIndex, offsetBy: 3)])
        }
        
        for i in 0..<4 {
            let label = labelArray[i]
            if i < content.count {
                let index = content.index(content.startIndex, offsetBy: i)
                label.text = String(content[index..<content.index(index, offsetBy: 1)])
            } else {
                label.text = "-"
            }
        }
        
        if content.count == 4 && SecurityManager.shared.isPasswordCorrect(content) {
            textView.resignFirstResponder()
            delegate?.dismiss(passwordViewController: self)
        }
    }
}
