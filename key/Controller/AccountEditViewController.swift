//
//  AccountEditViewController.swift
//  key
//
//  Created by MissYasiky on 2023/12/19.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import UIKit

class AccountEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let dataAddNoti = "accountDataAddNotification"
    // MARK: 数据
    private let editMode: Bool // 是否编辑模式，默认为NO
    private let editedCreateTime: TimeInterval? // editMode为YES时不为0，原数据创建时间，数据库关键字段
    private let account: Account // 核心数据，编辑模式时通过页面初始化带进来
    private var customKeyArray: [(String?, String?)] // 核心数据，编辑模式时通过页面初始化带进来
    // MARK: UI
    private var headerView: UIView!
    private var tableView: UITableView!
    private var tableViewCells: [UITableViewCell]!
    // MARK: 状态
    private var showKeyboard: Bool = false // 键盘是否显示
    private var keyboardOriginY: CGFloat = 0.0 // 键盘 frame 的 origin 的 y 值
    private var dragBeginPoint: CGPoint = CGPointZero // 键盘 frame 的 origin 的 y 值
    private var dragEndPoing: CGPoint = CGPointZero // 显示键盘时，拖动手势的拖动结束点
    
    // MARK: - Init & Deinit
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(account: Account?) {
        editMode = account != nil ? true : false
        editedCreateTime = account?.createTime
        self.account = account ?? Account()
        customKeyArray = []
        
        super.init(nibName: nil, bundle: nil)
        
        if let account {
            account.createTime = floor(NSDate().timeIntervalSince1970 * 1000)
        }
    }
    
    convenience init() {
        self.init(account: nil)
    }
    
    deinit {
        tableView.delegate = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = editMode ? "EDIT ACCOUNT" : "ADD ACCOUNT"
        self.view.backgroundColor = UIColor.white
        
        initData()
        initUI()
        addNotification()
    }
    
    // MARK: - Private Methods
    
    private func initData() {
        if let externDict = self.account.externDict {
            for key in externDict.keys {
                self.customKeyArray.append((key, externDict[key]))
            }
        }
    }
    
    private func initUI() {
        initCellWithData()
        
        let screenSize = UIScreen.main.bounds.size
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 35))
        let label = UILabel(frame: CGRect(x: 25, y: 35 - 14, width: screenSize.width - 25 * 2, height: 14))
        label.text = "Custom Key"
        label.font = UIFont.regularFont(size: 11)
        label.textColor = UIColor.textColor(alpha: 0.5)
        headerView.addSubview(label)
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let originY = statusBarHeight + (self.navigationController?.navigationBar.frame.size.height ?? 0)
        tableView = UITableView(frame: CGRect(x: 0, y: originY, width: screenSize.width, height: screenSize.height - originY - 88), style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        let saveButton: UIButton = UIButton(type: .roundedRect)
        saveButton.addTarget(self, action: #selector(self.saveButtonAction), for: .touchUpInside)
        saveButton.frame = CGRect(x: 0, y: screenSize.height - 88, width: screenSize.width, height: 88)
        saveButton.backgroundColor = UIColor.themeBlue
        saveButton.layer.shadowColor = UIColor.themeBlue.cgColor
        saveButton.layer.shadowOffset = CGSize(width: 0, height: -6)
        saveButton.layer.shadowOpacity = 0.2
        saveButton.layer.shadowRadius = 10
        saveButton.setTitle("SAVE", for: .normal)
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "icon_save")!
        attachment.bounds = CGRect(x: 0, y: -4, width: 24, height: 20)
        let text = NSAttributedString(string: "   SAVE", attributes: [.font: UIFont.boldFont(size: 16)!,.foregroundColor:UIColor.white, .kern:3])
        let string = NSMutableAttributedString()
        string.append(NSAttributedString(attachment: attachment))
        string.append(text)
        saveButton.setAttributedTitle(string, for: .normal)
        saveButton.titleEdgeInsets = UIEdgeInsets(top: -16, left: 0, bottom: 16, right: 0)
        self.view.addSubview(saveButton)
        
        let closeButton = UIButton(type: .custom)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        closeButton.setImage(UIImage(named: "nav_btn_close"), for: .normal)
        closeButton.setImage(UIImage(named: "nav_btn_close_highlight"), for: .highlighted)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    private func initCellWithData() {
        let cell1 = DetailLabelCell()
        cell1.setText(title: "Name", content: account.accountName, placeholder: "请输入账户名称")
        cell1.updateTextFieldStyle(style: .Chinese)
                           
        self.tableViewCells = [cell1]
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    private func addCustomKey() {
        self.customKeyArray.append((nil, nil))
        let addIndexPath = IndexPath(row: self.customKeyArray.count - 1, section: 1)
        self.tableView.insertRows(at: [addIndexPath], with: .left)
    }
    
    private func removeCustomKeyAtIndex(row: Int) {
        guard self.customKeyArray.count > row else {
            return
        }
        self.customKeyArray.remove(at: row)
        let addIndexPath = IndexPath(row: row, section: 1)
        self.tableView.deleteRows(at: [addIndexPath], with: .right)
    }
    
    private func tableViewScrollForIndex(row: Int) {
        self.tableView.setContentOffset(CGPoint(x: 0, y: 44+102*3+row*67), animated: true)
    }
    
    private func updateAccount() {
        for i in 0..<self.tableViewCells.count {
            let cell = self.tableViewCells[i] as! DetailLabelCell
            if i == 0 {
                self.account.accountName = cell.content
            }
        }
        
        var dict:[String : String] = [:]
        for item in self.customKeyArray {
            if item.0 != nil && item.1 != nil {
                dict[item.0!] = item.1!
            }
        }
        self.account.externDict = dict.count > 0 ? dict : nil
    }
    
    // MARK: - Event
    // MARK: Action
    
    @objc func closeButtonAction() {
        self.dismiss(animated: true)
    }
    
    @objc func saveButtonAction() {
        updateAccount()
        
        if (self.account.accountName == nil ? true : self.account.accountName!.count == 0) {
            Toast.showToast(message: "账户名称不可为空", inView: self.view)
            return
        }
        
        let success = AccountDataBase.shared.insertData(data: self.account)
        if success {
            if self.editMode {
                let deleteSuccess = AccountDataBase.shared.deleteData(createTime: self.editedCreateTime!)
                if !deleteSuccess {
                    Toast.showToast(message: "删除旧数据失败", inView: self.view)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AccountEditViewController.dataAddNoti), object: self.account)
            self.dismiss(animated: true)
        } else {
            Toast.showToast(message: "保存数据失败", inView: self.view)
        }
    }
    
    // MARK: Notification
    
    @objc func keyboardWillShow(_ notif: Notification) {
        showKeyboard = true
    }
    
    @objc func keyboardWillHide(_ notif: Notification) {
        showKeyboard = false
    }
    
    @objc func keyboardDidChangeFrame(_ notif: Notification) {
        let keyboardRect = (notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        keyboardOriginY = keyboardRect?.origin.y ?? UIScreen.main.bounds.size.height
    }
    
    // MARK: - Delegate
    // MARK: UIScrollView Delegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard showKeyboard == true else {
            return
        }
        
        let dragBeginPoint = scrollView.panGestureRecognizer.location(in: self.view)
        let velocity = scrollView.panGestureRecognizer.velocity(in: self.view)
        if dragBeginPoint.y < keyboardOriginY && velocity.y > 0 {
            self.dragBeginPoint = dragBeginPoint
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard showKeyboard == true && self.dragBeginPoint.y > 0 else {
            return
        }
        
        let dragEndPoint = scrollView.panGestureRecognizer.location(in: self.view)
        if dragEndPoint.y < keyboardOriginY {
            self.dragBeginPoint = CGPointZero
        } else {
            self.view.endEditing(true)
        }
    }
    
    // MARK: UITableView DataSource & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.tableViewCells.count
        } else {
            return self.customKeyArray.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return DetailLabelCell.height
        } else {
            return CustomKeyCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0001
        } else {
            return 35
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0001
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return self.tableViewCells[indexPath.row]
        } else {
            let cellIdentifier = "cellIdentifier"
            let cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CustomKeyCell) ?? CustomKeyCell(style: .default, reuseIdentifier: cellIdentifier)
            cell.row = indexPath.row
            if indexPath.row < self.customKeyArray.count {
                cell.updateStyle(style: .keyValue)
                let object = self.customKeyArray[indexPath.row]
                cell.setKeyValue(key: object.0, value: object.1)
                cell.didTapDeleteButton = { [unowned self] row in
                    self.removeCustomKeyAtIndex(row: row)
                }
                cell.didTextFieldBeginEditing = { [unowned self] row in
                    self.tableViewScrollForIndex(row: row)
                }
                cell.didTextFieldChanged = { [unowned self] row, key, value in
                    self.customKeyArray[row] = (key, value)
                }
            } else {
                cell.updateStyle(style: .addKey)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == self.customKeyArray.count {
            addCustomKey()
            tableViewScrollForIndex(row: indexPath.row)
        }
    }
}
