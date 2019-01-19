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
    
    var navBar: UIView!
    var infoLabel: UILabel!
    var infoBgView: UIView!
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
        
        //trial table
        trialTableView.snp.makeConstraints { (make) in
            make.left.width.equalTo(self.view)
            make.top.equalTo(self.navBar.snp.bottom)
            make.bottom.equalTo(self.submitButton.snp.top).offset(-30)
        }
        
        //submit
        submitButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-30)
            make.width.equalTo(440)
            make.height.equalTo(50)
        }
    }
    
    
    //MARK:Init views
    
    private func initViews() {
        
        view.backgroundColor = UIColor.white
        
        //nav bar
        navBar = addNavByTitle(title: navTitle)
        addBackButtonForNavigationBar()
        
        //info bg
        infoBgView = UIView()
        infoBgView.backgroundColor = UIColor.colorFromRGBA(255, 255, 255, alpha: 0.2)
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
        
        //trial table
        trialTableView = UITableView()
        trialTableView.tableFooterView = UIView()
        trialTableView.delegate = self
        trialTableView.dataSource = self
//        trialTableView.register(Ass_Patten_Style1_Cell.self, forCellReuseIdentifier: NSStringFromClass(Ass_Patten_Style1_Cell.self))
//        trialTableView.register(Ass_Patten_Style2_Cell.self, forCellReuseIdentifier: NSStringFromClass(Ass_Patten_Style2_Cell.self))
//        trialTableView.register(Ass_Patten_Style9_Cell.self, forCellReuseIdentifier: NSStringFromClass(Ass_Patten_Style9_Cell.self))
        trialTableView.separatorStyle = .none
        trialTableView.estimatedRowHeight = 100
        trialTableView.rowHeight = UITableView.automaticDimension
        trialTableView.showsVerticalScrollIndicator = false
        trialTableView.showsHorizontalScrollIndicator = false
        view.addSubview(trialTableView)
        
        //submit
        submitButton = UIButton()
        submitButton.backgroundColor = UIColor.colorFromRGBA(6, 148, 121)
        submitButton.layer.cornerRadius = 4
        submitButton.layer.masksToBounds = true
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        submitButton.setTitle(localStringForKey(key: "teacher_trial_submit_button_title"), for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        view.addSubview(submitButton)
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
                            style1Cell = Ass_Patten_Style1_Cell(style: .default, reuseIdentifier: style1CellId, parentWidth: screenWidth)
                        }
                        let colCount: Int = 2, spaceX: CGFloat = 20, spaceY: CGFloat = 10
                        let inset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
                        
                        style1Cell!.reloadView(withData: eachCase, columnCount: colCount, containerInset: inset, spaceX: spaceX, spaceY: spaceY, atIndexPath: indexPath)
                        cell = style1Cell!
                        
                    case .selectionPatten2:
                        var style2Cell = tableView.dequeueReusableCell(withIdentifier: style2CellId) as? Ass_Patten_Style2_Cell
                        if style2Cell == nil {
                            style2Cell = Ass_Patten_Style2_Cell(style: .default, reuseIdentifier: style2CellId, parentWidth: screenWidth)
                        }
                        let colCount: Int = 5, spaceX: CGFloat = 20, spaceY: CGFloat = 10
                        let inset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
                        style2Cell!.reloadView(withData: eachCase, columnCount: colCount, containerInset: inset, spaceX: spaceX, spaceY: spaceY, atIndexPath: indexPath)
                        cell = style2Cell!
                        
                    default:
                        print("unsupported pattern!")
                    }
                    
                } else if eachCase.caseType == .combinedSelection {
                    
                    var style9Cell = tableView.dequeueReusableCell(withIdentifier: style9CellId) as? Ass_Patten_Style9_Cell
                    if style9Cell == nil {
                        style9Cell = Ass_Patten_Style9_Cell(style: .default, reuseIdentifier: style9CellId, parentWidth: screenWidth)
                        style9Cell!.fetchStyle1CellLayoutParameterCallback = {
                            let colCount: Int = 2, spaceX: CGFloat = 20, spaceY: CGFloat = 10
                            let inset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
                            return (colCount, inset, spaceX, spaceY)
                        }
                        style9Cell!.fetchStyle2CellLayoutParameterCallback = {
                            let colCount: Int = 5, spaceX: CGFloat = 20, spaceY: CGFloat = 10
                            let inset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
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
                    style10Cell = Ass_Patten_Style10_Cell(style: .default, reuseIdentifier: style10CellId, parentWidth: screenWidth)
                }
                let caseArray = curBranchArray.map{$0.caseListArray[indexPath.row]}
                let personArray = curStudentArray
                let titleInset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
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
