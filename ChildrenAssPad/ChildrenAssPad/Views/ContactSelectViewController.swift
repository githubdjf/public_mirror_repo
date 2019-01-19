//
//  ContactSelectViewController.swift
//  zp_chu
//
//  Created by Jaffer on 2018/8/19.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ContactPersonType {
    var name: String {get}
    var code: String {get}
    var isSelected: Bool {get set}
}


//MARK: Cell

class ContactSelectCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var codeLabel: UILabel!
    var selectionImageView : UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        //temp
        //titleLabel.textColor = UIColor.blackColor
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentView.addSubview(titleLabel)
        
        codeLabel = UILabel()
        codeLabel.font = UIFont.systemFont(ofSize: 13)
        //temp
        //codeLabel.textColor = UIColor.gray1
        codeLabel.setContentHuggingPriority(.required, for: .horizontal)
        codeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        contentView.addSubview(codeLabel)
        
        selectionImageView = UIImageView()
        self.contentView.addSubview(selectionImageView)
        
    }
    
    func layoutViews() {
        
        titleLabel.snp.remakeConstraints { (maker) in
            maker.centerY.equalTo(self.contentView)
            maker.height.equalTo(20)
            maker.width.greaterThanOrEqualTo(40)
            maker.left.equalTo(self.contentView).offset(13)
        }
        
        codeLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.right).offset(10)
            make.centerY.equalTo(self.titleLabel)
            make.right.lessThanOrEqualTo(self.selectionImageView.snp.left).offset(-10)
        }
        
        selectionImageView.snp.remakeConstraints { (maker) in
            maker.centerY.equalTo(titleLabel.snp.centerY)
            maker.width.height.equalTo(22)
//            maker.right.equalTo(self.contentView.snp.right).offset(-36 * iphoneWidthScale)
            maker.right.equalTo(self.contentView.snp.right).offset(-36)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class ContactSelectViewController: BaseViewController {
    
    var navView : UIView!
    var cancelButton : UIButton!
    var completeButton : UIButton!
    var mainTableView : UITableView!

    var loadingView: LoadDataView?
    var emptyView: PromptView?
    var errorView: PromptView?
    
    var sourcePersonArray = [ContactPersonType & Sortable]()
    var sortedPersonArray = [[Sortable]]()
    
    var cancelCallback: (()-> Void)?
    var confirmCallback: (([ContactPersonType & Sortable]?) -> Void)?
    
    //MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        layoutViews()
        bindViews()
        loadData()
    }
    
    //MARK: Bind views
    
    func bindViews() {
        
    }
    
    //MARK: Actions
    
    @objc func cancel() {
        
        if cancelCallback != nil {
            cancelCallback!()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func confirm() {
        if confirmCallback != nil {
            
            let selectedPerson = sourcePersonArray.filter{$0.isSelected}
            confirmCallback!(selectedPerson.count > 0 ? selectedPerson : nil)
            
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Load data
    
    func loadData() {
        
        //加载数据
        if sourcePersonArray.count > 0 {
            sortedPersonArray = ContactSorter.sort(contacts: sourcePersonArray as [Sortable])!
            
            //刷新
            updateViews()
        }
    }
    
    //MARK: Prompt view
    
    func showEmptyView(isShow: Bool, inset: UIEdgeInsets = .zero, text: String = "", type: PromptView.PromptType = PromptView.PromptType.emptyCommon) {
        if isShow {
            cleanViewHierarchy()
            self.emptyView = PromptView(superView: self.view, insets: inset, promptText: text, promptType: type)
            self.emptyView?.show()
        } else {
            self.emptyView?.hide()
        }
    }
    
    func showLoadingView(isShow: Bool, inset: UIEdgeInsets = .zero) {
        if isShow {
            cleanViewHierarchy()
            self.loadingView = LoadDataView(superView: self.view, insets: inset, title: localStringForKey(key: "message_data_loading"))
            self.loadingView?.show()
        } else {
            self.loadingView?.hide()
        }
    }
    
    func showErrorView(isShow: Bool, inset: UIEdgeInsets = .zero, text: String = "", type: PromptView.PromptType = .reTryError) {
        if isShow {
            cleanViewHierarchy()
            self.errorView = PromptView(superView: self.view, insets: inset, promptText: text, promptType: type)
            self.errorView?.show()
        } else {
            self.errorView?.hide()
        }
    }
    
    func cleanViewHierarchy() {
        self.loadingView?.hide()
        self.loadingView?.removeFromSuperview()
        self.emptyView?.hide()
        self.emptyView?.removeFromSuperview()
        self.errorView?.hide()
        self.errorView?.removeFromSuperview()
    }
    
    
    //MARK: Layout views
    
    func updateViews() {
        
        //查看当前选中的person
        let selectedPerson = sourcePersonArray.filter {$0.isSelected}.first
        completeButton.isEnabled = selectedPerson != nil
        
        //reload table
        mainTableView.reloadData()
    }
    
    func layoutViews() {
        
        cancelButton.snp.makeConstraints { (maker) in
            maker.left.bottom.equalTo(self.navView)
            maker.height.equalTo(64)
            maker.width.equalTo(64)
        }
        
        completeButton.snp.makeConstraints { (maker) in
            maker.right.bottom.equalTo(self.navView)
            maker.width.height.equalTo(cancelButton)
        }
        
        mainTableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(navView.snp.bottom)
            maker.left.width.equalTo(self.view)
            maker.bottom.equalTo(self.view).offset(-safeBottomPadding())
        }
    }
    
    //MARK:Init views
    
    func initViews() {
        
        //nav view
        navView = self.addNavByTitle(title: localStringForKey(key: "select_stu_title"))
        
        //cancel button
        cancelButton = UIButton()
        cancelButton.setTitle(localStringForKey(key: "select_stu_cancel"), for: .normal)
        cancelButton.titleEdgeInsets = UIEdgeInsets(top: 31, left: 13, bottom: 14, right: 17)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        navView.addSubview(cancelButton)
        
        //complete button
        completeButton = UIButton()
        completeButton.setTitle(localStringForKey(key: "select_stu_complete"), for: .normal)
        completeButton.titleEdgeInsets = UIEdgeInsets(top: 31, left: 17, bottom: 14, right: 13)
        completeButton.setTitleColor(UIColor.colorFromRGBA(255, 255, 155, alpha: 0.6), for: .disabled)
        completeButton.setTitleColor(UIColor.white, for: .normal)
        completeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        completeButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        completeButton.isEnabled = false
        navView.addSubview(completeButton)
        
        mainTableView = UITableView()
        mainTableView.tableFooterView = UIView()
        mainTableView.rowHeight = 55
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.sectionFooterHeight = 0.001
        //temp
        //mainTableView.sectionIndexColor = UIColor.blackColor
        mainTableView.sectionIndexBackgroundColor = UIColor.clear
        mainTableView.sectionIndexTrackingBackgroundColor = UIColor.clear
        view.addSubview(mainTableView)
    }
}

//MARK: Table Delegate

extension ContactSelectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedPersonArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sortedPersonArray[section]
        return section.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title: String?
        let sec = sortedPersonArray[section]
        if sec.count > 0 {
            let titles = UILocalizedIndexedCollation.current().sectionTitles
            title = titles[section]
        }
        return title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var height = CGFloat(0.0)
        let section = sortedPersonArray[section]
        if section.count > 0 {
            height = 22
        }
        return height
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return UILocalizedIndexedCollation.current().sectionTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "cellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = ContactSelectCell(style: .default, reuseIdentifier: cellId)
            cell?.selectionStyle = .none
        }
        
        if let contactCell = cell as? ContactSelectCell {
            
            let section = sortedPersonArray[indexPath.section]
            
            if let person = section[indexPath.row] as? ContactPersonType {
                
                contactCell.titleLabel.text = person.name
                contactCell.codeLabel.text = "\(person.code)"
                
                if person.isSelected {
                    contactCell.selectionImageView.image = UIImage.init(named: "login_checkbox_selected")
                }else{
                    contactCell.selectionImageView.image = UIImage.init(named: "login_checkbox_normal")
                }
                
                contactCell.layoutViews()
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sec = sortedPersonArray[indexPath.section]
        var person = sec[indexPath.row] as! ContactPersonType
        let sel = person.isSelected
        person.isSelected = !sel
        
        updateViews()
    }
}


