//
//  LBFMMineSetController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/1.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit


// 所有 TableView 相关的类型, 都定义在 TableView 的内部.
/*
 public enum Style : Int {
 
 case plain = 0
 
 case grouped = 1
 
 @available(iOS 13.0, *)
 case insetGrouped = 2
 }
 
 
 public enum ScrollPosition : Int {
 
 
 case none = 0
 
 case top = 1
 
 case middle = 2
 
 case bottom = 3
 }
 
 // scroll so row of interest is completely visible at top/center/bottom of view
 
 public enum RowAnimation : Int {
 
 
 case fade = 0
 
 case right = 1 // slide in from right (or out to right)
 
 case left = 2
 
 case top = 3
 
 case bottom = 4
 
 case none = 5 // available in iOS 3.0
 
 case middle = 6 // available in iOS 3.2.  attempts to keep cell centered in the space it will/did occupy
 
 case automatic = 100 // available in iOS 5.0.  chooses an appropriate animation style for you
 }
 */

class LBFMMineSetController: UIViewController {
    private lazy var dataSource: Array = {
        return [[["title": "智能硬件"]],
                [["title": "特色闹铃"],
                 ["title": "定时关闭"]],
                [["title": "账号与安全"]],
                [["title": "推送设置"],
                 ["title": "收听偏好设置"],
                 ["title": "隐私设置"]],
                [["title": "断点续听"],
                 ["title": "2G/3G/4G播放和下载"],
                 ["title": "下载音质"],
                 ["title": "清理占用空间"]],
                [["title": "特色功能"],
                 ["title": "新版本介绍"],
                 ["title": "给喜马拉雅好评"],
                 ["title": "关于"]]]
    }()
    
    // 懒加载TableView
    private lazy var tableView : UITableView = {
        // 在创建的过程中, 引入了布局代码. 让逻辑显得混乱.
        let tableView = UITableView.init(frame:CGRect(x:0, y:0, width:LBFMScreenWidth, height:LBFMScreenHeight), style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = LBFMDownColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "设置"
        self.view.addSubview(self.tableView)
    }
}

extension LBFMMineSetController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        let sectionArray = dataSource[indexPath.section]
        let dict: [String: String] = sectionArray[indexPath.row]
        cell.textLabel?.text = dict["title"]
        if indexPath.section == 3 && indexPath.row == 1{
            /*
             If the value of this property is not nil, the UITableViewCell class uses the given view for the accessory view in the table view’s normal (default) state; it ignores the value of the accessoryType property. The provided accessory view can be a framework-provided control or label or a custom view. The accessory view appears in the right side of the cell.
             The accessory view cross-fades between normal and editing states if it set for both states; use the editingAccessoryView property to set the accessory view for the cell during editing mode. If this property is not set for both states, the cell is animated to slide in or out, as necessary.
             */
            /*
             // UITableView 的设计者, 在类型判断中, 使用了
             open var accessoryType: UITableViewCell.AccessoryType // default is UITableViewCellAccessoryNone. use to set standard type
             
             open var accessoryView: UIView? // if set, use custom view. ignore accessoryType. tracks if enabled can calls accessory action
             
             open var editingAccessoryType: UITableViewCell.AccessoryType // default is UITableViewCellAccessoryNone. use to set standard type
             */
            // 在特定的位置, 来进行了判断, Bad Smell
            // UITableViewCell 的设计者, 对 Cell 有了这种专门的设置.
            let cellSwitch = UISwitch.init()
            cell.accessoryView = cellSwitch
        }else {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = LBFMDownColor
        return footerView
    }
}
