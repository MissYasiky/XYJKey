//
//  CardDetailViewController.swift
//  key
//
//  Created by MissYasiky on 2023/12/19.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import UIKit

class CardDetailViewController: UIViewController, UITableViewDataSource, DetailLabelCellDelegate {
    static let dataDeleteNoti = "cardDataDeleteNotification"
    // MARK: 数据
    private var card: Card // 核心数据
    private var externDict: [String : String] {
        return self.card.externDict ?? [:]
    }
    // MARK: UI
    private var cardView: CardView!
    private var tableView: UITableView!
    
    // MARK: - Init & Deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(card: Card) {
        self.card = card
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.card.bankName
        self.view.backgroundColor = UIColor.white
        
        initUI()
        addNotification()
        
        let gesture = UILongPressGestureRecognizer.init(target: self, action: #selector(self.longPressAction))
        self.cardView.addGestureRecognizer(gesture)
    }
    
    // MARK: - Private Methods
    private func initUI() {
        let screenSize = UIScreen.main.bounds.size
        
        let padding = 25.0
        let cardBgHeight = (screenSize.width - padding * 2) * 210 / 325
        let height = cardBgHeight + padding * 2
        cardView = CardView.init(card: self.card)
        cardView.frame = CGRectMake(0, 0, screenSize.width, height)
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let originY = statusBarHeight + (self.navigationController?.navigationBar.frame.size.height ?? 0)
        tableView = UITableView(frame: CGRectMake(0, originY, screenSize.width, screenSize.height - originY - 88), style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = DetailLabelCell.height
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.tableFooterView = cardView
        self.view.addSubview(tableView)
        
        let menuButton = UIButton(type: .custom)
        menuButton.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
        menuButton.setImage(UIImage(named: "nav_btn_menu"), for: .normal)
        menuButton.setImage(UIImage(named: "nav_btn_menu_highlight"), for: .highlighted)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.cardDataAdd), name: NSNotification.Name(CardEditViewController.dataAddNoti), object: nil)
    }
    
    // MARK: - Event
    // MARK: Action
    
    @objc func longPressAction() {
        guard self.card.accountNum != nil else {
            return
        }
        UIPasteboard.general.string = self.card.accountNum!
        let tips = UIPasteboard.general.string != nil ? "拷贝成功" : "拷贝失败"
        Toast.showToast(message: tips, inView: self.view)
    }
    
    @objc func menuButtonAction() {
        let editAction = UIAlertAction(title: "编辑", style: .default) { [unowned self] _ in
            self.editCardAction()
        }
        editAction.setValue(UIColor.themeBlue, forKey: "titleTextColor")
        
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { [unowned self] _ in
            self.showDeleteAlert()
        }
        deleteAction.setValue(UIColor.themeRed, forKey: "titleTextColor")
        
        let cancleAction = UIAlertAction(title: "取消", style: .cancel)
        cancleAction.setValue(UIColor.themeBlue, forKey: "titleTextColor")
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancleAction)
        self.present(alert, animated: true)
    }
    
    private func editCardAction() {
        let vctrl = CardEditViewController(card: self.card)
        let nav = UINavigationController.init(rootViewController: vctrl)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true)
    }
    
    private func deleteCardAction() {
        let success = CardDataBase.shared.deleteData(accountNum: self.card.accountNum!)
        if success {
            NotificationCenter.default.post(name: Notification.Name(CardDetailViewController.dataDeleteNoti), object: nil)
            self.navigationController?.popViewController(animated: true)
        } else {
            Toast.showToast(message: "删除失败", inView: self.view)
        }
    }
    
    private func showDeleteAlert() {
        let deleteAction = UIAlertAction(title: "确定", style: .destructive) { [unowned self] _ in
            self.deleteCardAction()
        }
        deleteAction.setValue(UIColor.themeRed, forKey: "titleTextColor")
        
        let cancleAction = UIAlertAction(title: "取消", style: .cancel)
        cancleAction.setValue(UIColor.themeBlue, forKey: "titleTextColor")
        
        let alert = UIAlertController(title: nil, message: "确定要删除该银行卡信息？", preferredStyle: .actionSheet)
        alert.addAction(deleteAction)
        alert.addAction(cancleAction)
        self.present(alert, animated: true)
    }
    
    // MARK: Notification
    
    @objc func cardDataAdd(_ notif: Notification) {
        let card = notif.object != nil ? (notif.object! as! Card) : nil
        if let card {
            self.card = card
        }
        self.title = self.card.bankName
        self.tableView.reloadData()
        self.cardView.update(card: self.card)
    }
    
    // MARK: - Delegate
    // MARK: UITableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.externDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < self.externDict.count else {
            return UITableViewCell()
        }
        let cellIdentifier = "cellIdentifier"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DetailLabelCell) ?? DetailLabelCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.delegate = self
        
        let startIndex = self.externDict.keys.startIndex
        let index = self.externDict.keys.index(startIndex, offsetBy: indexPath.row)
        let title = self.externDict.keys[index]
        let content = self.externDict.values[index]
        cell.setText(lineOneText: title, lineTwoText: content)
        return cell
    }
    
    // MARK: DetailLabelCell Delegate
    func longPress(message: String) {
        UIPasteboard.general.string = message
        let tips = UIPasteboard.general.string != nil ? "拷贝成功" : "拷贝失败"
        Toast.showToast(message: tips, inView: self.view)
    }
}
