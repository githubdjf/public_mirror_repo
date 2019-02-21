//
//  RecruitEvaluationRecordController.swift
//  FirstEducation
//
//  Created by 黄逸诚 on 2018/9/29.
//  Copyright © 2018年 yitai. All rights reserved.
//  招生测评记录页面
//

import UIKit
import SnapKit
import RxSwift
import NSObject_Rx
import RxCocoa
import MJRefresh

class RecruitEvaluationRecordController: BaseViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    private var nameField :UITextField!
    private var startField :UITextField!
    private var endField :UITextField!
    private var countContentView: UIView!
    private var totalCountLabel: UILabel!
    private var titleLabel: UILabel!

    var pageNo = 1   //后台定义的初始值为1
    let pageSize = 20
    var emptyView: PromptView?
    var loadDataView: LoadDataView?
    var errorView: PromptView?
    var recordArray = [TrialRecordModel]()
    var tableview: UITableView!
    let footer = MJRefreshAutoNormalFooter()
    let mjHeader = MJRefreshNormalHeader()

    deinit {

        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorFromRGBA(247, 249, 250)
        let navi = addNavByTitle(title: localStringForKey(key: "recruit_eval_record_nav_title"))
        if let title = navi.viewWithTag(100) as? UILabel {
            //title
            titleLabel = title
            
            //content label
            countContentView = UIView()
            countContentView.backgroundColor = UIColor.colorFromRGBA(85, 85, 85, alpha: 0.4)
            countContentView.layer.cornerRadius = 11
            countContentView.layer.masksToBounds = true
            navi.addSubview(countContentView)
            
            //total label
            totalCountLabel = UILabel()
            totalCountLabel.font = UIFont.systemFont(ofSize: 14)
            totalCountLabel.textColor = UIColor.white
            totalCountLabel.numberOfLines = 1
            totalCountLabel.text = String(format: localStringForKey(key: "recruit_eval_record_total_count_format"), recordArray.count)
            totalCountLabel.setContentHuggingPriority(.required, for: .horizontal)
            totalCountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
            countContentView.addSubview(totalCountLabel)
            
            countContentView.snp.makeConstraints { (make) in
                make.centerY.equalTo(titleLabel)
                make.left.equalTo(self.titleLabel.snp.right).offset(15)
                make.height.equalTo(22)
                make.right.lessThanOrEqualTo(navi).offset(-20)
            }
            
            totalCountLabel.snp.makeConstraints { (make) in
                make.edges.equalTo(countContentView).inset(UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 11))
            }
        }
        
        addBackButtonForNavigationBar()
//        addRightButton(navi: navi)
        addBottomLayout(navi: navi)
        loadNewData()

        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange(notify:)), name: UITextField.textDidChangeNotification, object: nameField)
    }

    @objc func loadData() -> Void {


        Prompter.showLottieIndicator(inView: self.view)

        UserCenterService.fetchTrialRecord(pageNo: pageNo, pageSize: pageSize, babyName: nameField.text, startDate: startField.text, endDate: endField.text)
            .catchError {[weak self] (error) -> Observable<(Int, [TrialRecordModel])> in

            if let weakSelf = self {

                Prompter.hideIndicator(inView: weakSelf.view)
                weakSelf.removePromptView()
                let eMsg = APPErrorFactory.unboxAndExtractErrorMessage(from: error)
                weakSelf.showErrorView(errorMsg: eMsg)
            }

            return Observable.empty()

            }
            .asSingle()
            .subscribe(onSuccess: {[weak self] (dataTuple) in

                if let weakSelf = self {

                    Prompter.hideIndicator(inView: weakSelf.view)
                    weakSelf.removePromptView()

                    if dataTuple.1.count == 0 && weakSelf.pageNo == 1 {

                        weakSelf.mjHeader.endRefreshing()
                        weakSelf.showEmptyView(insets:UIEdgeInsets(top: 155 + navBarHeight(), left: 30, bottom: 30, right: 30))
                        weakSelf.recordArray = dataTuple.1
                        weakSelf.tableview.reloadData()
                        
                    }else{

                        weakSelf.mjHeader.endRefreshing()
                        weakSelf.footer.endRefreshing()

                        if dataTuple.1.count != 0 {
                            
                            weakSelf.recordArray = weakSelf.recordArray + dataTuple.1
                            weakSelf.tableview.reloadData()
                            weakSelf.pageNo += 1
                        }
                    }
                    
                    //count
                    if weakSelf.totalCountLabel != nil {
                        weakSelf.totalCountLabel.text = String(format: localStringForKey(key: "recruit_eval_record_total_count_format"), dataTuple.0)
                    }
                }

            }) { (error) in

            }
            .disposed(by: self.rx.disposeBag)
    }


    @objc func loadNewData(){

        pageNo = 1
        self.recordArray.removeAll()
        loadData()
    }

    //MARK:展示错误页面

    func showErrorView(errorMsg: String){

        removePromptView()

        errorView = PromptView.init(superView: self.view, insets: UIEdgeInsets(top: 155 + navBarHeight(), left: 30, bottom: 30, right: 30), promptText: errorMsg, promptType: .reTryError)

        errorView?.retryBlock = {[weak self] in

            if let weakSelf = self {
                weakSelf.loadNewData()
            }
        }

        errorView?.show()
    }

    //MARK:展示加载页面

    func showLoadView(){

        removePromptView()

        loadDataView = LoadDataView.init(superView: self.view, insets:UIEdgeInsets(top: 155 + navBarHeight(), left: 30, bottom: 30, right: 30),  title: localStringForKey(key: "message_data_loading"))

        loadDataView?.show()

    }

    //MARK:展示空数据页面
    func showEmptyView(insets: UIEdgeInsets){

        removePromptView()

        emptyView = PromptView.init(superView: self.view, insets: UIEdgeInsets(top: 155 + navBarHeight(), left: 30, bottom: 30, right: 30), promptText: "暂无数据", promptType: .emptyCommon)

        emptyView?.show()
    }


    //移除提示页面
    func removePromptView(){

        if let view = loadDataView {
            view.removeFromSuperview()
        }

        if let view = errorView {
            view.removeFromSuperview()
        }

        if let view = emptyView {
            view.removeFromSuperview()
        }
    }
    
    
    func addBottomLayout(navi:UIView) -> Void {
        let layout = UIView.init()
        layout.layer.shadowRadius = 8
        layout.layer.shadowOpacity = 0.2
        layout.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        self.view.addSubview(layout)
        layout.snp.makeConstraints{ (maker) in
            maker.top.equalTo(navi.snp.bottom)
            maker.width.equalTo(screenWidth)
            maker.bottom.equalTo(self.view.snp.bottom)
            maker.centerX.equalToSuperview()
        }
        
        let card = UIView.init()
        card.backgroundColor = UIColor.white
        card.layer.cornerRadius = 8
        layout.addSubview(card)
        card.snp.makeConstraints{ (maker) in
            maker.left.equalTo(layout.snp.left).offset(30)
            maker.right.equalTo(layout.snp.right).offset(-30)
            maker.top.equalTo(layout.snp.top).offset(20)
            maker.bottom.equalTo(layout.snp.bottom).offset(-30)
        }
        
        let header = createTableHeader()
        card.addSubview(header)
        header.snp.makeConstraints{ (maker) in
            maker.left.equalToSuperview()
            maker.top.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalTo(135)
        }
        tableview = UITableView.init()
        tableview.layer.cornerRadius = 8
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 50
        tableview.separatorStyle = .none

        footer.setRefreshingTarget(self, refreshingAction: #selector(loadData))
        footer.isAutomaticallyRefresh = false
        tableview.mj_footer = footer

        mjHeader.setRefreshingTarget(self, refreshingAction: #selector(loadNewData))
        tableview.mj_header = mjHeader


        tableview.register(RecruitEvaluationRecordCell.self, forCellReuseIdentifier: "RecruitEvaluationRecordCell")
        card.addSubview(tableview)
        tableview.snp.makeConstraints{ (maker) in
            maker.left.equalToSuperview()
            maker.width.equalToSuperview()
            maker.top.equalTo(header.snp.bottom)
            maker.bottom.equalToSuperview()
        }
    }
    
    
    
    private func addRightButton(navi:UIView) -> Void {

        let username = LoginManager.default.curUser?.userName

        let info  = UIButton.init()
        info.setImage(UIImage.init(named: "icon_user"), for: .normal)
        info.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        info.setTitle(username, for: .normal)
        info.setTitleColor(UIColor.white, for: .normal)
        info.isUserInteractionEnabled = false
        
        navi.addSubview(info)
        
        info.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(navi.snp.centerY).offset(10)
            maker.right.equalTo(navi.snp.right).offset(-20)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "RecruitEvaluationRecordCell") as! RecruitEvaluationRecordCell
        cell.selectionStyle = .none

        let model = recordArray[indexPath.row]
        cell.report.setTitleColor(model.isFinish ? UIColor.colorWithHexString(hex: "#0a6fa9") : UIColor.darkGray , for: .normal)

        cell.name.text = model.babyName
        cell.sex.text = model.babySex == .male ? "男" : "女"
        cell.birthday.text = model.babyBirthday
        cell.parentName.text = model.parentName
        cell.parentPhone.text = model.parentPhone
        cell.evaluationDate.text = model.trialDate

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = recordArray[indexPath.row]

        if model.isFinish {

            let vc = CheckReportViewController()
            vc.urlStr = model.reportHtml
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func createTableHeader() -> UIView {
        let allHeader = UIView.init()
        let header = UIView.init()
        let nameLable = UILabel.init()
        nameLable.font = UIFont.systemFont(ofSize: 16)
        nameLable.text = "宝贝姓名:"
        nameLable.textColor = UIColor.colorWithHexString(hex: "#222222")
        header.addSubview(nameLable)
        
        nameLable.snp.makeConstraints{ (maker) in
            maker.left.equalTo(header.snp.left).offset(20)
            maker.centerY.equalTo(header.snp.centerY)
        }
        let placeHoldAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(hex: "#999999")]
        
        nameField = UITextField.init()
        nameField.attributedPlaceholder = NSAttributedString(string: "   请输入宝贝姓名", attributes: placeHoldAttr)
        nameField.delegate = self
        nameField.font = UIFont.systemFont(ofSize: 16)
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.colorWithHexString(hex: "#d8d8d8").cgColor
        nameField.layer.cornerRadius = 22.5
        nameField.textColor = UIColor.black
        nameField.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        nameField.leftViewMode = .always
        header.addSubview(nameField)
        nameField.snp.makeConstraints{ (maker) in
            maker.left.equalTo(nameLable.snp.right).offset(10)
            maker.centerY.equalTo(header.snp.centerY)
            maker.height.equalTo(45)
            maker.width.equalTo(200)
        }
        
        let timeLable = UILabel.init()
        timeLable.font = UIFont.systemFont(ofSize: 16)
        timeLable.text = "测评时间:"
        timeLable.textColor = UIColor.colorWithHexString(hex: "#222222")
        header.addSubview(timeLable)
        timeLable.snp.makeConstraints{ (maker) in
            maker.left.equalTo(nameField.snp.right).offset(20)
            maker.centerY.equalTo(header.snp.centerY)
        }
        
        startField = UITextField.init()
        startField.attributedPlaceholder = NSAttributedString(string: "   起始时间", attributes: placeHoldAttr)
        startField.delegate = self
        startField.font = UIFont.systemFont(ofSize: 16)
        startField.layer.borderWidth = 1
        startField.layer.borderColor = UIColor.colorWithHexString(hex: "#d8d8d8").cgColor
        startField.layer.cornerRadius = 22.5
        startField.textColor = UIColor.black
        startField.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        startField.leftViewMode = .always
        startField.rightView = getDateIconView(clearTag: 101, iconButtonTag: 201)
        startField.rightViewMode = .always
        startField.clearButtonMode = .always
        header.addSubview(startField)
        startField.snp.makeConstraints{ (maker) in
            maker.left.equalTo(timeLable.snp.right).offset(10)
            maker.centerY.equalTo(header.snp.centerY)
            maker.height.equalTo(45)
            maker.width.equalTo(200)
        }
        
        let lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHexString(hex: "#999999")
        header.addSubview(lineView)
        lineView.snp.makeConstraints{ (maker) in
            maker.size.equalTo(CGSize(width: 5, height: 2))
            maker.centerY.equalTo(header.snp.centerY)
            maker.left.equalTo(startField.snp.right).offset(4)
        }
        
        endField = UITextField.init()
        endField.attributedPlaceholder = NSAttributedString(string: "   结束时间", attributes: placeHoldAttr)
        endField.delegate = self
        endField.font = UIFont.systemFont(ofSize: 16)
        endField.layer.borderWidth = 1
        endField.layer.borderColor = UIColor.colorWithHexString(hex: "#d8d8d8").cgColor
        endField.layer.cornerRadius = 22.5
        endField.textColor = UIColor.black
        endField.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        endField.leftViewMode = .always
        endField.rightView = getDateIconView(clearTag: 102, iconButtonTag: 202)
        endField.rightViewMode = .always
        endField.clearButtonMode = .always
        header.addSubview(endField)
        endField.snp.makeConstraints{ (maker) in
            maker.left.equalTo(lineView.snp.right).offset(4)
            maker.centerY.equalTo(header.snp.centerY)
            maker.height.equalTo(45)
            maker.width.equalTo(200)
        }
        
        let queryButton = UIButton.init()
        queryButton.backgroundColor = UIColor.mainColor
        queryButton.setTitle("查询", for: .normal)
        queryButton.setTitleColor(UIColor.colorFromRGBA(34, 34, 34), for: .normal)
        queryButton.layer.cornerRadius = 22
        queryButton.addTarget(self, action: #selector(queryClicked), for: .touchUpInside)
        header.addSubview(queryButton)
        queryButton.snp.makeConstraints{ (maker) in
            maker.left.equalTo(endField.snp.right).offset(20)
            maker.centerY.equalTo(header.snp.centerY)
            maker.size.equalTo(CGSize(width: 110, height: 44))
        }
        
        allHeader.addSubview(header)
        header.snp.makeConstraints{ (maker) in
            maker.top.equalTo(allHeader.snp.top)
            maker.height.equalTo(85)
            maker.left.equalTo(allHeader.snp.left)
            maker.right.equalTo(allHeader.snp.right)
        }
        let subHeader = UIView.init()
        subHeader.backgroundColor  = UIColor.colorWithHexString(hex: "#f7f9fa")
        let nameIndexLabel = getIndexView(title: "宝贝姓名")
        subHeader.addSubview(nameIndexLabel)
        nameIndexLabel.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(subHeader.snp.centerY)
            maker.left.equalTo(subHeader.snp.left)
            maker.width.equalTo(subHeader).dividedBy(7)
        }
        
        let sexIndexLabel = getIndexView(title: "性别")
        subHeader.addSubview(sexIndexLabel)
        sexIndexLabel.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(subHeader.snp.centerY)
            maker.left.equalTo(nameIndexLabel.snp.right)
            maker.width.equalTo(subHeader).dividedBy(7)
        }
        
        let birthdayIndexLabel = getIndexView(title: "宝贝生日")
        subHeader.addSubview(birthdayIndexLabel)
        birthdayIndexLabel.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(subHeader.snp.centerY)
            maker.left.equalTo(sexIndexLabel.snp.right)
            maker.width.equalTo(subHeader).dividedBy(7)
        }
        
        let parentNameIndexLabel = getIndexView(title: "家长姓名")
        subHeader.addSubview(parentNameIndexLabel)
        parentNameIndexLabel.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(subHeader.snp.centerY)
            maker.left.equalTo(birthdayIndexLabel.snp.right)
            maker.width.equalTo(subHeader).dividedBy(7)
        }
        
        let parentPhoneIndexLabel = getIndexView(title: "家长电话")
        subHeader.addSubview(parentPhoneIndexLabel)
        parentPhoneIndexLabel.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(subHeader.snp.centerY)
            maker.left.equalTo(parentNameIndexLabel.snp.right)
            maker.width.equalTo(subHeader).dividedBy(7)
        }
        
        let evaluationDateIndexLabel = getIndexView(title: "测评时间")
        subHeader.addSubview(evaluationDateIndexLabel)
        evaluationDateIndexLabel.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(subHeader.snp.centerY)
            maker.left.equalTo(parentPhoneIndexLabel.snp.right)
            maker.width.equalTo(subHeader).dividedBy(7)
        }
        
        let reportIndexLabel = getIndexView(title: "查看报告")
        subHeader.addSubview(reportIndexLabel)
        reportIndexLabel.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(subHeader.snp.centerY)
            maker.left.equalTo(evaluationDateIndexLabel.snp.right)
            maker.width.equalTo(subHeader).dividedBy(7)
        }
        
        allHeader.addSubview(subHeader)
        subHeader.snp.makeConstraints{ (maker) in
            maker.height.equalTo(50)
            maker.left.equalTo(allHeader.snp.left)
            maker.right.equalTo(allHeader.snp.right)
            maker.top.equalTo(header.snp.bottom)
        }
        return allHeader
    }
    
    func getIndexView(title:String) -> UILabel {
        let label = UILabel.init()
        label.textColor = UIColor.colorWithHexString(hex: "#999999")
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = title
        label.textAlignment = .center
        return label
        
    }
    
    
    @objc func queryClicked(button:UIButton){
        loadNewData()
    }
    
    private func getDateIconView(clearTag: Int, iconButtonTag: Int) ->UIView{
        let date = UIView.init()

        let iconButton = UIButton()
        iconButton.addTarget(self, action: #selector(iconButtonTapped(sender:)), for: .touchUpInside)
        iconButton.setImage(UIImage.init(named: "icon_date"), for: .normal)
        iconButton.tag = iconButtonTag
        date.addSubview(iconButton)


        let clearButton = UIButton.init()
        clearButton.addTarget(self, action: #selector(clearButtonTapped(sender:)), for: .touchUpInside)
        clearButton.setImage(UIImage.init(named: "clear_icon"), for: .normal)
        date.addSubview(clearButton)
        clearButton.tag = clearTag
        clearButton.isHidden = true
        iconButton.snp.makeConstraints{ (maker) in
            maker.right.equalToSuperview().offset(-20)
            maker.centerY.equalToSuperview()
        }

        clearButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(iconButton.snp.left).offset(-10)
            maker.width.height.equalTo(20)
            maker.centerY.equalTo(iconButton)
        }

        date.frame = CGRect.init(x: 0, y: 0, width: 70, height: 30)


        return date
    }

    @objc func clearButtonTapped(sender: UIButton) -> Void {

        if sender.tag == 101 {
            startField.text = ""
        }else{
            endField.text = ""
        }

        sender.isHidden = true
    }

    @objc func iconButtonTapped(sender:UIButton) -> Void {

        nameField.resignFirstResponder()
            startField.resignFirstResponder()
            let datePicker = DatePickerViewController()
            datePicker.modalPresentationStyle = .overCurrentContext
            datePicker.dateBlock = {[weak self] (dateStr : String) in

                if let weakSelf = self {

                    if sender.tag == 201{

                        weakSelf.startField.text = dateStr

                        let rightView = weakSelf.startField.rightView

                        for sub in rightView?.subviews ?? [UIView]() {

                            if sub.tag == 101 {

                                sub.isHidden = false
                            }
                        }
                    }else if sender.tag == 202 {

                        weakSelf.endField.text = dateStr

                        let rightView = weakSelf.endField.rightView

                        for sub in rightView?.subviews ?? [UIView]() {

                            if sub.tag == 102 {

                                sub.isHidden = false
                            }
                        }

                    }


                    weakSelf.dismiss(animated: false, completion: nil)
                }
            }
            self.present(datePicker, animated: false, completion: nil)


    }


    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField == startField {
            nameField.resignFirstResponder()
            startField.resignFirstResponder()
            let datePicker = DatePickerViewController()
            datePicker.modalPresentationStyle = .overCurrentContext
            datePicker.dateBlock = {[weak self] (dateStr : String) in

                if let weakSelf = self {

                    weakSelf.startField.text = dateStr

                    let rightView = weakSelf.startField.rightView

                    for sub in rightView?.subviews ?? [UIView]() {

                        if sub.tag == 101 {

                            sub.isHidden = false
                        }
                    }
                    weakSelf.dismiss(animated: false, completion: nil)
                }
            }
            self.present(datePicker, animated: false, completion: nil)

            return false

        }


        if textField == endField {

            nameField.resignFirstResponder()
            endField.resignFirstResponder()
            let datePicker = DatePickerViewController()
            datePicker.modalPresentationStyle = .overCurrentContext
            datePicker.dateBlock = {[weak self] (dateStr : String) in

                if let weakSelf = self {

                    weakSelf.endField.text = dateStr

                    let rightView = weakSelf.endField.rightView

                    for sub in rightView?.subviews ?? [UIView]() {

                        if sub.tag == 102 {

                            sub.isHidden = false
                        }
                    }

                    weakSelf.dismiss(animated: false, completion: nil)
                }
            }
            self.present(datePicker, animated: false, completion: nil)

            return false

        }

        return true

    }

   //MARK: 字数限制
    @objc func textFieldTextDidChange(notify: Notification) {

        if let field = notify.object as? UITextField {

            let curText = field.text ?? ""

            let selectedRange = field.markedTextRange

            var pos: UITextPosition?
            if let selectedStartPosition = selectedRange?.start {
                pos = field.position(from: selectedStartPosition, offset: 0)
            }

            if (pos == nil) {
                //截取处理
                if curText.count > 50 - 1 {
                    let maxIndex = curText.index(curText.startIndex, offsetBy: 50)
                    //let maxText = curText.substring(to: maxIndex)
                    let fullText = String(curText[..<maxIndex])
                    field.text = fullText
                }
            }
        }
    }


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //系统表情键盘
        if let lau = nameField.textInputMode?.primaryLanguage {

            if lau == "emoji" {
                return false
            }
        } else {
            return false
        }

        //是否在使用系统九宫格输入拼音
        if FormatChecker.isNineKeyBoard(string) {
            return true
        }

        //是否含有表情
        let hasEmoji = FormatChecker.hasEmoji(string) || FormatChecker.stringContainsEmoji(string)

        return !hasEmoji
    }

}
