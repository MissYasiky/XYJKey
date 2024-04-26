//
//  Toast.swift
//  key
//
//  Created by MissYasiky on 2023/11/12.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import UIKit

private let fontSize: CGFloat = 14.0
private let hideDelay: CGFloat = 2.0
private let labelMaxWidth: CGFloat = 200.0

class Toast: UIView {
    private static var showing:Bool = false
    private var label: UILabel!
    private var timer: Timer?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0x1b/255.0, green: 0x20/255.0, blue: 0x2d/255.0, alpha: 0.6)
        self.layer.cornerRadius = 8.0
        
        label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = UIColor(red: 0xf0/255.0, green: 0xf1/255.0, blue: 0xf5/255.0, alpha: 1.0)
        label.textAlignment = .center
        self.addSubview(label)
    }
    
    class func showToast(message:String, inView superView: UIView) {
        guard !Toast.showing && !message.isEmpty else {
            return
        }
        
        Toast.showing = true
        let toast = Toast()
        superView.addSubview(toast)
        
        let msgWidth = message.boundingRect(with: CGSizeMake(labelMaxWidth, 20),
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [.font: UIFont.systemFont(ofSize: fontSize)],
                                            context: nil).size.width
        toast.label.text = message
        toast.label.frame = CGRectMake(0, 10, msgWidth + 24 * 2, 20)
        toast.frame = CGRectMake(0, 0, msgWidth + 24 * 2, 40)
        toast.center = CGPoint(x: superView.bounds.size.width / 2.0, y: superView.bounds.size.height / 2.0)
        toast.hide(delay: hideDelay)
    }
    
    func hide(delay: CGFloat) {
        if let _ = timer {
            timer!.invalidate()
        }
        
        timer = Timer.init(timeInterval: delay, target: self, selector: #selector(Toast.handleHideTimer), userInfo: nil, repeats: false)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    @objc private func handleHideTimer() {
        self.removeFromSuperview()
        if let _ = timer {
            timer!.invalidate()
            timer = nil
        }
        Toast.showing = false
    }
}
