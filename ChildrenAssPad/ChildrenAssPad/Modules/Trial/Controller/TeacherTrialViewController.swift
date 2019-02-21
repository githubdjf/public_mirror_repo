//
//  TeacherTrialViewController.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/11/30.
//  Copyright © 2018年 yitai. All rights reserved.
//

/*
 * 教师评价 & 教师观测测评
 */

import UIKit

class TeacherTrialViewController: BaseViewController {

    enum TrialMode {
        case teacherEval //教师评价
        case teacherObserve //教师观测
        
        var infoFormatter: String {
            switch self {
            case .teacherEval:
                return localStringForKey(key: "teacher_trial_nav_info_format_for_tec_eval")
            default:
                return localStringForKey(key: "teacher_trial_nav_info_format_for_tec_observe")
            }
        }
    }
    
    var backgroundView: UIImageView! //底层背景图
    
    var navBar: UIView!
    var backButton: UIButton!
    var infoLabel: UILabel!
    var infoBgView: UIView!
    
    var roundedContainerView: UIView!
    var calendarHeaderView: UIImageView!
    
    var trialTableView: UITableView!
    var submitButton: UIButton!
    
    let navTitle: String!
    let curMode: TrialMode!
    let curStudentArray: [String]!
    
    var curExamArray = [AssExam]() //考虑到多人同时作答，为每人持有一份exam对象
    var curBranchArray = [AssBranch]() //考虑到多人同时作答，为每人持有一份exam对象
    
    init(title: String, entryMode: TrialMode, students: [String]) {
        navTitle = title
        curMode = entryMode
        curStudentArray = students
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        layoutViews()
        loadData()
    }
    
    
    //MARK: Actions
    @objc func submitButtonAction() {
        
    }
    
    @objc func backButtonAction(button: UIButton) {
        
    }
    
    
    //MARK: Load data
    
    private func loadData() {
        
        if curMode == TrialMode.teacherEval {
            
            if let exam = FileLoader.loadExamData(fromFile: "first_trial_json3") {
                print("")
                curExamArray.append(exam)
                if exam.paperArray.count > 0 {
                    let paper = exam.paperArray[0]
                    if paper.branchArray.count > 0 {
                        let branch = paper.branchArray[0]
                        curBranchArray.append(branch)
                    }
                }
                trialTableView.reloadData()
                trialTableView.layoutIfNeeded()
            }
            
        } else {
            
            for i in 0..<curStudentArray.count {
                
                if let exam = FileLoader.loadExamData(fromFile: "first_trial_json2") {
                    
                    curExamArray.append(exam)
                    exam.examId = "id:::\(i)"
                    if exam.paperArray.count > 0 {
                        let paper = exam.paperArray[0]
                        if paper.branchArray.count > 0 {
                            let branch = paper.branchArray[0]
                            curBranchArray.append(branch)
                        }
                    }
                }
            }
            trialTableView.reloadData()
            trialTableView.layoutIfNeeded()
        }
    }
    
    
    //MARK: Prompt view
    
    
    //MARK: Layout views
    
    private func layoutViews() {
        
        //background view
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        //back button
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.navBar).offset(22)
            make.bottom.equalTo(self.navBar)
            make.width.equalTo(76)
            make.height.equalTo(63)
        }
        
        //info bg view
        if let titleLabel = navBar.viewWithTag(100) {
            infoBgView.snp.makeConstraints { (make) in
                make.centerY.equalTo(titleLabel)
                make.left.equalTo(titleLabel.snp.right).offset(10)
                make.right.lessThanOrEqualTo(self.navBar).offset(-20)
                make.height.equalTo(22)
            }
        } else {
            infoBgView.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.navBar).offset(10)
                make.centerX.equalTo(self.navBar)
                make.height.equalTo(22)
                make.left.greaterThanOrEqualTo(self.navBar).offset(60)
            }
        }
        
        //info label
        infoLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self.infoBgView).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
        
        //rounded container
        roundedContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(39)
            make.right.equalTo(self.view).offset(-39)
            make.top.equalTo(self.navBar.snp.bottom).offset(39)
            make.bottom.equalTo(self.view).offset(-39)
        }
        
        //calendar header
        calendarHeaderView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.navBar.snp.bottom).offset(23)
            make.width.equalTo(780)
            make.height.equalTo(47)
        }
        
        //trial table
        trialTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.roundedContainerView).offset(31)
            make.left.width.bottom.equalTo(self.roundedContainerView)
        }
        
//        roundedContainerView.layoutIfNeeded()
//        trialTableView.layer.mask = generateRoundedPathLayer(withBounds: trialTableView.bounds, radius: 20)
    }
    
    
    //MARK:Init views
    
    private func initViews() {
        
        //background view
        backgroundView = UIImageView(image: UIImage(named: "common_full_screen_bg"))
        view.addSubview(backgroundView)
        
        //nav bar
        navBar = addNavByTitle(title: navTitle)
        navBar.layer.shadowColor = UIColor.colorFromRGBA(255, 178, 68, alpha: 0.4).cgColor
        navBar.layer.shadowOpacity = 1
        navBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navBar.backgroundColor = UIColor.colorFromRGBA(254, 228, 98)
        
        //title label
        if let label = navBar.viewWithTag(100) as? UILabel {
            label.textColor = UIColor.colorFromRGBA(34, 34, 34)
            label.font = UIFont.systemFont(ofSize: 20)
        }
        
        //back button
        backButton = UIButton()
        backButton.setImage(UIImage(named: "common_back"), for: .normal)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 7, right: 20)
        backButton.addTarget(self, action: #selector(backButtonAction(button:)), for: .touchUpInside)
        navBar.addSubview(backButton)
        
        //info bg
        infoBgView = UIView()
        infoBgView.backgroundColor = UIColor.colorFromRGBA(85, 85, 85, alpha: 0.4)
        infoBgView.layer.cornerRadius = 11
        infoBgView.layer.masksToBounds = true
        navBar.addSubview(infoBgView)
        
        //info label
        infoLabel = UILabel()
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.textColor = UIColor.colorFromRGBA(255, 255, 255)
        infoLabel.lineBreakMode = .byTruncatingTail
        infoLabel.numberOfLines = 1
        infoLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        infoLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        let infoText = curStudentArray.joined(separator: "、")
        infoLabel.text = String(format: curMode.infoFormatter, infoText)
        infoBgView.addSubview(infoLabel)
        
        //rounded container
        roundedContainerView = UIView()
        roundedContainerView.backgroundColor = UIColor.white
        roundedContainerView.layer.cornerRadius = 20
        roundedContainerView.layer.shadowOpacity = 1
        roundedContainerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        roundedContainerView.layer.shadowColor = UIColor.colorFromRGBA(255, 173, 0, alpha: 0.5).cgColor
        view.addSubview(roundedContainerView)
        
        //calendar header
        calendarHeaderView = UIImageView(image: UIImage(named: "trial_calendar_header"))
        view.addSubview(calendarHeaderView)
        
        //trial table
        trialTableView = UITableView()
        trialTableView.tableFooterView = UIView()
        trialTableView.layer.cornerRadius = 20 //因为上角留白所以这种处理不影响效果
        trialTableView.delegate = self
        trialTableView.dataSource = self
        trialTableView.separatorStyle = .none
        trialTableView.estimatedRowHeight = 100
        trialTableView.rowHeight = UITableView.automaticDimension
        trialTableView.showsVerticalScrollIndicator = false
        trialTableView.showsHorizontalScrollIndicator = false
        trialTableView.tableFooterView = createTabelFooterView()
        roundedContainerView.addSubview(trialTableView)
    }
    
    private func createTabelFooterView() -> UIView {
        let footView = UIView()
        
        submitButton = UIButton()
        submitButton.backgroundColor = UIColor.colorFromRGBA(254, 228, 98)
        submitButton.layer.cornerRadius = 28
        submitButton.layer.masksToBounds = true
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        submitButton.setTitleColor(UIColor.colorFromRGBA(34, 34, 34), for: .normal)
        submitButton.setTitle(localStringForKey(key: "teacher_trial_submit_button_title"), for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        footView.addSubview(submitButton)
        
        submitButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(footView)
            make.top.equalTo(footView).offset(10)
            make.width.equalTo(620)
            make.height.equalTo(56)
            make.bottom.equalTo(footView).offset(-10).priority(999)
        }
        
        let size = footView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        footView.frame.size = size
        
        return footView
    }
    
    //MARK: Utility
    
    func generateRoundedPathLayer(withBounds bounds: CGRect, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: radius, height: radius))
        let pathLayer = CAShapeLayer()
        pathLayer.frame = bounds
        pathLayer.path = path.cgPath
        return pathLayer
    }
}



//MARK: UITableViewDelegate && DataSource

extension TeacherTrialViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = 0
        if curBranchArray.count > 0 {
            num = curBranchArray[0].caseListArray.count
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let style1CellId = NSStringFromClass(Ass_Patten_Style1_Cell.self)
        let style2CellId = NSStringFromClass(Ass_Patten_Style2_Cell.self)
        let style9CellId = NSStringFromClass(Ass_Patten_Style9_Cell.self)
        let style10CellId = NSStringFromClass(Ass_Patten_Style10_Cell.self)
        
        var cell: UITableViewCell?
        
        if curBranchArray.count > 0 {
            
            if curMode == TrialMode.teacherEval {
                //教师评价
                let eachCase = curBranchArray[0].caseListArray[indexPath.row]
                
                if eachCase.caseType == .normalSingleSelection || eachCase.caseType == .normalMultiSelection {
                    
                    switch eachCase.casePattern {
                    case .selectionPatten1:
                        var style1Cell = tableView.dequeueReusableCell(withIdentifier: style1CellId) as? Ass_Patten_Style1_Cell
                        if style1Cell == nil {
                            style1Cell = Ass_Patten_Style1_Cell(style: .default, reuseIdentifier: style1CellId, parentWidth: screenWidth - 39 * 2)
                        }
                        let colCount: Int = 2, spaceX: CGFloat = 20, spaceY: CGFloat = 10
                        let inset = UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 30)
                        
                        style1Cell!.reloadView(withData: eachCase, columnCount: colCount, containerInset: inset, spaceX: spaceX, spaceY: spaceY, atIndexPath: indexPath)
                        cell = style1Cell!
                        
                    case .selectionPatten2:
                        var style2Cell = tableView.dequeueReusableCell(withIdentifier: style2CellId) as? Ass_Patten_Style2_Cell
                        if style2Cell == nil {
                            style2Cell = Ass_Patten_Style2_Cell(style: .default, reuseIdentifier: style2CellId, parentWidth: screenWidth - 39 * 2)
                        }
                        let colCount: Int = 5, spaceX: CGFloat = 20, spaceY: CGFloat = 10
                        let inset = UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 30)
                        style2Cell!.reloadView(withData: eachCase, columnCount: colCount, containerInset: inset, spaceX: spaceX, spaceY: spaceY, atIndexPath: indexPath)
                        cell = style2Cell!
                        
                    default:
                        print("unsupported pattern!")
                    }
                    
                } else if eachCase.caseType == .combinedSelection {
                    
                    var style9Cell = tableView.dequeueReusableCell(withIdentifier: style9CellId) as? Ass_Patten_Style9_Cell
                    if style9Cell == nil {
                        style9Cell = Ass_Patten_Style9_Cell(style: .default, reuseIdentifier: style9CellId, parentWidth: screenWidth - 39 * 2)
                        style9Cell!.fetchStyle1CellLayoutParameterCallback = {
                            let colCount: Int = 2, spaceX: CGFloat = 20, spaceY: CGFloat = 10
                            let inset = UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 30)
                            return (colCount, inset, spaceX, spaceY)
                        }
                        style9Cell!.fetchStyle2CellLayoutParameterCallback = {
                            let colCount: Int = 5, spaceX: CGFloat = 20, spaceY: CGFloat = 10
                            let inset = UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 30)
                            return (colCount, inset, spaceX, spaceY)
                        }
                    }
                    style9Cell?.reloadView(withData: eachCase, atIndexPath: indexPath)
                    cell = style9Cell!
                    
                } else {
                    print("unsupported case type!")
                }
            } else {
                //教师观测
                var style10Cell = tableView.dequeueReusableCell(withIdentifier: style10CellId) as? Ass_Patten_Style10_Cell
                if style10Cell == nil {
                    style10Cell = Ass_Patten_Style10_Cell(style: .default, reuseIdentifier: style10CellId, parentWidth: screenWidth - 39 * 2)
                }
                let caseArray = curBranchArray.map{$0.caseListArray[indexPath.row]}
                let personArray = curStudentArray
                let titleInset = UIEdgeInsets(top: 0, left: 30, bottom: 5, right: 30)
                let personOptionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                style10Cell?.reloadView(withDataArray: caseArray, persons: personArray!, titleViewContainerInset: titleInset, titleSpaceX: 20, titleSpaceY: 10, personColumnCount: 4, personContainerInset: personOptionInset, personSpaceX: 20, personSpaceY: 10, atIndexPath: indexPath)
                cell = style10Cell!
            }
        } else {
            
            print("data invalid!")
        }
        
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: style1CellId, for: indexPath)
        }
        
        cell?.selectionStyle = .none

        cell?.updateConstraints()
        cell?.layoutIfNeeded()

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
