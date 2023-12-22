//
//  AccountListViewController.swift
//  key
//
//  Created by MissYasiky on 2023/12/19.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import UIKit

@objc public class AccountListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: 数据
    private var datas: [Account] = []
    // MARK: UI
    private var tableView: UITableView!
    
    // MARK: - Init & Deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public init() {
        super.init(nibName: nil, bundle: nil)
        getDataFromDataBase()
    }
    
    @objc deinit {
        tableView.delegate = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Life Cycle
    
    @objc public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        initUI()
        addNotification()
    }
    
    @objc public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
    }
    
    // MARK: - Private Methods
    private func getDataFromDataBase() {
        self.datas = AccountDataBase.shared.getAllData()
    }
    
    private func initUI() {
        tableView = UITableView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = HomeListCell.height
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.accountDataChange), name: NSNotification.Name(AccountEditViewController.dataAddNoti), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.accountDataChange), name: NSNotification.Name(AccountDetailViewController.dataDeleteNoti), object: nil)
    }
    
    // MARK: - Event
    // MARK: Notification
    
    @objc func accountDataChange(_ notif: Notification) {
        getDataFromDataBase()
        self.tableView.reloadData()
    }
    
    // MARK: - Delegate
    // MARK: UITableView DataSource & Delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < self.datas.count else {
            return UITableViewCell()
        }
        let cellIdentifier = "cellIdentifier"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? HomeListCell) ?? HomeListCell(style: .default, reuseIdentifier: cellIdentifier)
        let account = self.datas[indexPath.row]
        
        var content = ""
        if let dict = account.externDict {
            let index = dict.keys.startIndex
            let key = dict.keys[index]
            if let value = dict[key] {
                content = key + ": " + value
            }
        }
        cell.setText(lineOneText: account.accountName!, lineTwoText: nil, lineThreeText: content)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let account = self.datas[indexPath.row]
        let vctrl = AccountDetailViewController(account: account)
        self.navigationController?.pushViewController(vctrl, animated: true)
    }
}
