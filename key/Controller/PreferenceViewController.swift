//
//  PreferenceViewController.swift
//  key
//
//  Created by MissYasiky on 2023/11/9.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import UIKit

@objc public class PreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @objc public static let passwordGeneratorCellIdentifier = "passwordGeneratorCellIdentifier"
    @objc public static let exportCellIdentifier = "exportGeneratorCellIdentifier"
    
    var visionLabel: UILabel!
    var tableView: UITableView!
    
    @objc public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SETTING"
        self.view.backgroundColor = UIColor.white
        
        setupUI()
    }
    
    func setupUI() {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), style: .plain)
        tableView.separatorStyle = .none
        tableView.rowHeight = SimpleLabelCell.height
        tableView.tableFooterView = UIView()
        tableView.register(SimpleLabelCell.self, forCellReuseIdentifier: PreferenceViewController.passwordGeneratorCellIdentifier)
        tableView.register(SimpleLabelCell.self, forCellReuseIdentifier: PreferenceViewController.exportCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        visionLabel = UILabel(frame: CGRect(x: 0, y: screenHeight - 50 - 13, width: screenWidth, height: 13))
        visionLabel.textColor = UIColor.textColor(alpha: 0.5)
        visionLabel.font = UIFont.regularFont(size: 11)
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        visionLabel.text = "Version \(appVersion) Build \(buildVersion)"
        visionLabel.textAlignment = .center
        self.view.addSubview(visionLabel)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PreferenceViewController.passwordGeneratorCellIdentifier, for: indexPath) as! SimpleLabelCell
            cell.setStyle(style: .indicator)
            cell.setLabelText(text: "Password Generator")
            cell.setCellIconImageName(imageName: "setting_icon_password")
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PreferenceViewController.exportCellIdentifier, for: indexPath) as! SimpleLabelCell
            cell.setStyle(style: .onlyLabel)
            cell.setLabelText(text: "Export")
            cell.setCellIconImageName(imageName: "setting_icon_export")
            return cell
        }
        return SimpleLabelCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
