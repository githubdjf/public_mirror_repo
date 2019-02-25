//
//  RecruitStudentAssesmentViewController.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/9/29.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxCocoa
import RxSwift
import NSObject_Rx
import CocoaLumberjack

class RecruitStudentAssesmentViewController: BaseViewController {

    enum TabType {
        case base
        case observer
    }
    
    enum AssRole: Int {
        case `default` = 0
        case teacher
        case parent
        
        var roleName: String {
            switch self {
            case .teacher:
                return localStringForKey(key: "recruit_student_switch_role_teacher")
            case .parent:
                return localStringForKey(key: "recruit_student_switch_role_parent")
            default:
                return localStringForKey(key: "recruit_student_switch_role_student")
            }
        }
    }
    
    enum CaseValidateResult {
        case valid
        case invalid(Int?, String?)
    }
    
    //bg view
    var bgImageView: UIImageView!
    
    //header
    var headerView: UIView!
    var backButton: UIButton!
    var studentNameLabel: UILabel!
    var baseInfoTabButton: UIButton!
    var observeInfoTabButton: UIButton!
    var disclosureInfoButton: UIButton!
    
    //rounded bg container view
    var roundedBgView: UIView!
    
    //content
    var assesmentScrollView: UIScrollView!
    var assesmentContainerView: UIView!
    
    //基础信息
    var baseInfoBgView: UIView!
    var baseInfoTableView: UITableView!
    
    //观测信息
    var observerBgView: UIView!
    var observerInfoTableView: UITableView!
    var commitFooterView: UIView!
    var switchRoleButton: ReverseButton!
    var commitButton: UIButton!
    
    var loadingDataView: LoadDataView?
    var baseEmptyView: PromptView?
    var observeEmptyView: PromptView?
    var errorPromptView: PromptView?
    
    //switch
    var maskView: UIView!
    var switchOptionBgImageView: UIImageView!
    var switchArrowImageView: UIImageView!
    var parentRoleButton: UIButton!
    var switchSepLine: UIView!
    var teacherRoleButton: UIButton!
    
    //Input
    var curStudentName: String? = "发放富"
    var curStudentId: String?
    var curExamId: String?
    
    //Data
    var tabPaperArray = [AssPaper]()
    
    var baseBranch: AssBranch?
    var baseCaseArray = [AssCase]()
    
    var teacherBranch: AssBranch?
    var teacherCaseArray = [AssCase]()
    
    var parentBranch: AssBranch?
    var parentCaseArray = [AssCase]()
    
    //当前进行基础信息测试的‘角色‘
    var curBaseAssRole: AssRole = .default
    
    //当前进行的观测信息测试的‘角色’
    var curObserveAssRole: AssRole = .teacher
    
    //MARK: Life cycle
    
    deinit {
        print("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        layoutViews()
        bindViews()
        
//        loadData()
        loadFakeData()
    }
    
    //MARK: Bind views
    
    func bindViews() {
        
    }
    
    //MARK: Actions
    
    @objc func baseInfoTabClicked(button: UIButton) {
        
        switchTabTo(tabType: .base)
        scrollTo(infoView: 0)
    }
    
    @objc func observeInfoTabClicked(button: UIButton) {
        
        switchTabTo(tabType: .observer)
        scrollTo(infoView: screenWidth - 39 * 2)
    }
    
    @objc func disclosureInfoButtonClicked(button: UIButton) {
        
        let infoVC = RecruitStudentAssesmentInfoViewController()
        infoVC.curAssUserId = curStudentId
        infoVC.didCloseCallback = {[weak self] in
            if let weakSelf = self {
                weakSelf.dismiss(animated: false, completion: nil)
            }
        }
        infoVC.modalPresentationStyle = .overCurrentContext
        present(infoVC, animated: false, completion: nil)
    }
    
    @objc func switchObserveRoleButtonClicked(button: UIButton) {
        
        switchRoleButton.isSelected = true
        maskView.isHidden = false
    }
    
    @objc func parentRoleSwitcherClicked(button: UIButton) {
        
        switchRoleButton.isSelected = false
        switchRoleButton.setTitle(AssRole.parent.roleName, for: .normal)
        
        curObserveAssRole = .parent
        refreshObserveInfoData()
        
        parentRoleButton.isSelected = true
        teacherRoleButton.isSelected = false
        maskView.isHidden = true
    }
    
    @objc func teacherRoleSwitcherClicked(button: UIButton) {
        
        switchRoleButton.isSelected = false
        switchRoleButton.setTitle(AssRole.teacher.roleName, for: .normal)
        
        curObserveAssRole = .teacher
        refreshObserveInfoData()
        
        teacherRoleButton.isSelected = true
        parentRoleButton.isSelected = false
        maskView.isHidden = true
    }
    
    override func backbuttonTapped() {
        
        //直接返回至根视图
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func commitButtonClicked(button: UIButton) {
        
        //校验答题完整性
        let result = validateAssCaseAnswer()
        if case let CaseValidateResult.invalid(_, err) = result {
            if let err = err {
                Prompter.showTextToast(err, inView: self.view)
                return
            } else {
                DDLogError("if let err = err, error msg not exist")
            }
        }
        
        //拼接答案
        let assembleResult = assembleAssCaseAnswer()
        
        //提交
        submitAssAnswer(assembleResult)
    }
    
    func validateAssCaseAnswer() -> CaseValidateResult {

        //基础信息
        if baseCaseArray.count <= 0 {
            return  .invalid(nil, localStringForKey(key: "recruit_student_submit_invalid_base_case_empty"))
        }
        
        let baseResult = validate(withinCaseArray: baseCaseArray)
        if case let CaseValidateResult.invalid(idx, _) = baseResult {
            if let caseIndex = idx {
                let paperName = tabPaperArray[0].paperName
                return .invalid(idx, "\(paperName)\(String(format: localStringForKey(key: "recruit_student_submit_invalid_case_invalid"), caseIndex + 1))")
            } else {
                DDLogError("if let caseIndex = idx error!")
            }
        }
        
        //观测信息
        let dataSource = getObverseCaseDataSource()
        let obverseResult = validate(withinCaseArray: dataSource)
        if case let CaseValidateResult.invalid(idx, _) = obverseResult {
            if let caseIndex = idx {
                let paperName = tabPaperArray[1].paperName
                return .invalid(idx, "\(paperName)\(String(format: localStringForKey(key: "recruit_student_submit_invalid_case_invalid"), caseIndex + 1))")
            } else {
                DDLogError("if let caseIndex = idx error!")
            }
        }
        
        return .valid
    }
    
    
    func validate(withinCaseArray caseArray: [AssCase]) -> CaseValidateResult {
        
        for (idx, eachCase) in caseArray.enumerated() {
            let caseType = eachCase.caseType
            let selectedOptions = eachCase.curSelectedOptions
            var caseInvalid = true
            if caseType != .unknow {
                
                switch caseType {
                case .singleSelection:
                    caseInvalid = selectedOptions.count == 1
                case .multiSelection:
                    caseInvalid = selectedOptions.count >= 0
                case .passThrough:
                    caseInvalid = selectedOptions.count == 1
                default:
                    caseInvalid = true
                }
            } else {
                DDLogError("if caseType != .unknow, error")
            }
            if !caseInvalid {
                return .invalid(idx, nil)
            }
        }
        return .valid
    }
    

    func assembleAssCaseAnswer() -> [String : Any] {
        
        var answerList = [[String: Any]]()
        
        //基础信息 + 观测信息
        let totalCaseArr = baseCaseArray + getObverseCaseDataSource()
        
        for eachCase in totalCaseArr {
            
            let userId = curStudentId ?? ""
            let branchId = eachCase.branchId
            let caseType = eachCase.caseType
            let selectedOptions = eachCase.curSelectedOptions
            if caseType != .unknow {
                
                switch caseType {
                case .singleSelection, .passThrough:
                    if let selOption = selectedOptions.first {
                        let answer = assemble(withSelectedOption: selOption, branchId: branchId, userId: userId)
                        answerList.append(answer)
                    }
                case .multiSelection:
                    if selectedOptions.count > 0 {
                        for selOption in selectedOptions {
                            let answer = assemble(withSelectedOption: selOption, branchId: branchId, userId: userId)
                            answerList.append(answer)
                        }
                    }
                default:
                    print("DO NOTHING")
                }
            }
        }
        
        var assembleDict = [String : Any]()
        assembleDict["isLast"] = 1
        assembleDict["roleType"] = curObserveAssRole.rawValue
        let answersStr = JSON(answerList).rawString() ?? ""
        assembleDict["answerRecordList"] = answersStr
        
        return assembleDict
    }
    
    func assemble(withSelectedOption option: AssCaseOption, branchId: String, userId: String) -> [String : Any] {
        var answer = [String : Any]()
        answer["selId"] = option.optionId
        answer["dimen"] = option.dimension
        answer["score"] = option.score
        answer["caseId"] = option.caseId
        answer["userId"] = userId
        answer["branchId"] = branchId
        return answer
    }
    
    func getObverseCaseDataSource() -> [AssCase] {
        return curObserveAssRole == .teacher ? teacherCaseArray : parentCaseArray
    }
    
    func scrollTo(infoView offset: CGFloat) {
        let point = CGPoint(x: offset, y: 0)
        assesmentScrollView.setContentOffset(point, animated: true)
    }
    
    func switchTabTo(tabType type: TabType) {
        
        if type == .base {
            guard !baseInfoTabButton.isSelected else {return}
            baseInfoTabButton.isSelected = true
            observeInfoTabButton.isSelected = false
        } else {
            guard !observeInfoTabButton.isSelected else {return}
            observeInfoTabButton.isSelected = true
            baseInfoTabButton.isSelected = false
        }
    }
    
    
    
    //MARK: Load data
    
    func loadData() {
                
        guard let userId = curStudentId, let examId = curExamId else {
            return
        }
        
        loadBranchData(withUserId: userId, examId: examId)
    }
    
    func loadFakeData() {
        
        let paperArr = FileLoader.loadRecuritStuPapersData(fromFile: "recruit_student_papers")!
        tabPaperArray.removeAll()
        tabPaperArray.append(contentsOf: paperArr)

        let baseBranchArr = FileLoader.loadRecuritStudentPaperBranchesData(fromFile: "recruit_student_base_trial")!
        let teacherBranchArr = FileLoader.loadRecuritStudentPaperBranchesData(fromFile: "recruit_student_observe_trial_teacher")!
        let parentBranchArr = FileLoader.loadRecuritStudentPaperBranchesData(fromFile: "recruit_student_observe_trial_parent")!
        
        //清空数据
        cleanBranchData()
        
        //保存数据
        saveBranchData(base: baseBranchArr, teacher: teacherBranchArr, parent: parentBranchArr)
        
        //刷新数据
        
        //tab 页签
        updateViews()
        
        refreshBaseInfoData()
        refreshObserveInfoData()
    }
    
    
    //获取页签列表 && 量表列表
    func loadBranchData(withUserId userId: String, examId: String) {
        
        showLoadingView(isShow: true, inset: UIEdgeInsets(top: navBarHeight(), left: 0, bottom: safeBottomPadding(), right: 0))

        RecruitStudentService.fetchRecruitStudentPaperList(withUserId: userId, examId: examId)
            .flatMapLatest {[weak self] (papers) -> Observable<([AssBranch], [AssBranch], [AssBranch])> in
                
                //这里只会返回两个paper页签：基本信息、观测信息
                if let weakSelf = self {
                    
                    if papers.count == 2 {
                        
                        weakSelf.tabPaperArray.removeAll()
                        weakSelf.tabPaperArray.append(contentsOf: papers)
                        
                        //默认第一个为基本信息、第二个为观测信息
                        let baseO = RecruitStudentService.fetchRecruitStudentBranchListUnderlyingPaper(withUserId: userId, paperId: papers[0].paperId, type: 0)
                        let observeTeacherO = RecruitStudentService.fetchRecruitStudentBranchListUnderlyingPaper(withUserId: userId, paperId: papers[1].paperId, type: 1)
                        let observeParentO = RecruitStudentService.fetchRecruitStudentBranchListUnderlyingPaper(withUserId: userId, paperId: papers[1].paperId, type: 2)
                        
                        return Observable.zip(baseO, observeTeacherO, observeParentO)
                    } else {
                        
                        throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
                    }
                }
                return Observable.empty()
            }
            .catchError {[weak self] (error) -> Observable<([AssBranch], [AssBranch], [AssBranch])> in
                
                //TODO
                //全屏错误页面
                if let weakSelf = self {
                    weakSelf.loadingView?.hide()
                    let eMsg = APPErrorFactory.unboxAndExtractErrorMessage(from: error)
                    weakSelf.showErrorView(isShow: true, inset: UIEdgeInsets(top: navBarHeight(), left: 0, bottom: safeBottomPadding(), right: 0), text: eMsg, type: .reTryError) { [weak self] in
                        if let wkSelf = self {
                            wkSelf.loadData()
                        }
                    }
                }
                return Observable.empty()
            }
            .asSingle()
            .subscribe(onSuccess: {[weak self] (base, teacher, parent) in
                
                if let weakSelf = self {
                    weakSelf.loadingView?.hide()
                    
                    //清空数据
                    weakSelf.cleanBranchData()
                    
                    //保存数据
                    weakSelf.saveBranchData(base: base, teacher: teacher, parent: parent)
                    
                    //刷新数据
                    
                    //tab 页签
                    weakSelf.updateViews()
                    
                    weakSelf.refreshBaseInfoData()
                    weakSelf.refreshObserveInfoData()
                }
                
            }) { (error) in
                
                print("\(#function) error = \(error)!");
            }
            .disposed(by: self.rx.disposeBag)
    }
    
    
    func refreshBaseInfoData() {
        
        //无基础信息
        loadingView?.hide()
        loadingView?.removeFromSuperview()
        baseEmptyView?.hide()
        baseEmptyView?.removeFromSuperview()
        errorView?.hide()
        errorView?.removeFromSuperview()
        
        if baseCaseArray.count <= 0 {
            showBaseEmptyView(isShow: true, inset: .zero, text: localStringForKey(key: "message_no_data"), type: PromptView.PromptType.emptyCommon)
        } else {
            UIView.animate(withDuration: 0.01, animations: { [weak self] in
                self?.baseInfoTableView.reloadData()
            }) { [weak self] _ in
                self?.baseInfoTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            }
        }
    }
    
    func refreshObserveInfoData() {
        
        loadingView?.hide()
        loadingView?.removeFromSuperview()
        observeEmptyView?.hide()
        observeEmptyView?.removeFromSuperview()
        errorView?.hide()
        errorView?.removeFromSuperview()

        if curObserveAssRole == .teacher {
            //无教师观测信息
            if teacherCaseArray.count <= 0 {
                showObserveEmptyView(isShow: true, inset: .zero, text: localStringForKey(key: "message_no_data"), type: PromptView.PromptType.emptyCommon)
            } else {
                UIView.animate(withDuration: 0.01, animations: { [weak self] in
                    self?.observerInfoTableView.reloadData()
                }) { [weak self] _ in
                    self?.observerInfoTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                }
            }
        } else {
            //无家长观测信息
            if parentCaseArray.count <= 0 {
                showObserveEmptyView(isShow: true, inset: .zero, text: localStringForKey(key: "message_no_data"), type: PromptView.PromptType.emptyCommon)
            } else {
                UIView.animate(withDuration: 0.01, animations: { [weak self] in
                    self?.observerInfoTableView.reloadData()
                }) { [weak self] _ in
                    self?.observerInfoTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                }
            }
        }
    }
    
    func cleanBranchData() {
        
        baseBranch = nil
        baseCaseArray.removeAll()
        
        teacherBranch = nil
        teacherCaseArray.removeAll()
        
        parentBranch = nil
        parentCaseArray.removeAll()
    }
    
    func saveBranchData(base: [AssBranch], teacher: [AssBranch], parent: [AssBranch]) {
        
        //默认只取用第一个branch
        if base.count > 0 {
            baseBranch = base.first
            baseCaseArray.append(contentsOf: base.first!.caseListArray)            
        }
        
        if teacher.count > 0 {
            teacherBranch = teacher.first
            teacherCaseArray.append(contentsOf: teacher.first!.caseListArray)
        }

        if parent.count > 0 {
            parentBranch = parent.first
            parentCaseArray.append(contentsOf: parent.first!.caseListArray)
        }
    }
    
    func submitAssAnswer(_ answer: [String : Any]) {
        
        Prompter.showLottieIndicator(inView: self.view)
        
        RecruitStudentService.saveRecruitStudentAssAnswer(answer)
            .catchError {[weak self] (error) -> Observable<StudentInfo>in
                if let weakSelf = self {
                    //TODO
                    //全屏错误页面
                    Prompter.hideIndicator(inView: weakSelf.view)
                    let eMsg = APPErrorFactory.unboxAndExtractErrorMessage(from: error)
                    weakSelf.showErrorView(isShow: true, inset: UIEdgeInsets(top: navBarHeight() + 40, left: 0, bottom: safeBottomPadding(), right: 0), text: eMsg, type: .reTryError) { [weak self] in
                        if let wkSelf = self {
                            wkSelf.cleanViewHierarchy()
                            wkSelf.submitAssAnswer(answer)
                        }
                    }
                }
                return Observable.empty()
            }
            .asSingle()
            .subscribe(onSuccess: {[weak self] (info) in
                
                if let weakSelf = self {
                    Prompter.hideIndicator(inView: weakSelf.view)
                    let reportVC = CheckReportViewController()
                    reportVC.urlStr = info.reportHtml
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                        Prompter.showOperationSucceed(inView: weakSelf.view, toast: localStringForKey(key: "recruit_student_submit_success"))
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                            weakSelf.navigationController?.pushViewController(reportVC, animated: true)
                        })
                    }
                }
                
            }) { (error) in
                
                print("\(#function) error = \(error)!");
            }
            .disposed(by: self.rx.disposeBag)
    }

    
    //MARK: Prompt view
    
    func showBaseEmptyView(isShow: Bool, inset: UIEdgeInsets = .zero, text: String = "", type: PromptView.PromptType = PromptView.PromptType.emptyCommon) {
        if isShow {
            baseEmptyView?.hide()
            baseEmptyView?.removeFromSuperview()
            
            baseEmptyView = PromptView(superView: self.baseInfoBgView, insets: inset, promptText: text, promptType: type)
            baseEmptyView?.show()
        } else {
            baseEmptyView?.hide()
        }
    }
    
    func showObserveEmptyView(isShow: Bool, inset: UIEdgeInsets = .zero, text: String = "", type: PromptView.PromptType = PromptView.PromptType.emptyCommon) {
        if isShow {
            observeEmptyView?.hide()
            observeEmptyView?.removeFromSuperview()
            
            observeEmptyView = PromptView(superView: self.observerBgView, insets: inset, promptText: text, promptType: type)
            observeEmptyView?.show()
        } else {
            observeEmptyView?.hide()
        }
    }
    
    func showLoadingView(isShow: Bool, inset: UIEdgeInsets = .zero) {
        if isShow {
            cleanViewHierarchys()
            loadingDataView = LoadDataView(superView: self.view, insets: inset, title: localStringForKey(key: "message_data_loading"))
            loadingDataView?.show()
        } else {
            loadingDataView?.hide()
        }
    }
    
    func showErrorView(isShow: Bool, inset: UIEdgeInsets = .zero, text: String = "", type: PromptView.PromptType = .reTryError, retryCallback: (() -> Void)? = nil) {
        if isShow {
            cleanViewHierarchys()
            errorPromptView = PromptView(superView: self.view, insets: inset, promptText: text, promptType: type)
            errorPromptView?.retryBlock = retryCallback
            errorPromptView?.show()
        } else {
            errorPromptView?.hide()
        }
    }
    
    func cleanViewHierarchys() {
        loadingDataView?.hide()
        loadingDataView?.removeFromSuperview()
        baseEmptyView?.hide()
        baseEmptyView?.removeFromSuperview()
        observeEmptyView?.hide()
        observeEmptyView?.removeFromSuperview()
        errorPromptView?.hide()
        errorPromptView?.removeFromSuperview()
    }
    
    //MARK: Layout views
    
    func updateViews() {
        
        if tabPaperArray.count == 2 {
            baseInfoTabButton.setTitle(tabPaperArray[0].paperName, for: .normal)
            observeInfoTabButton.setTitle(tabPaperArray[1].paperName, for: .normal)
        }
    }
    
    func layoutViews() {
        
        //bg view
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        //header view
        headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(110)
        }
        
        //back button
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(76)
            make.centerY.equalTo(self.headerView).offset(20)
            make.left.equalTo(self.view).offset(22)
        }
        
        //student name
        studentNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.backButton.snp.right)
            make.height.equalTo(22)
            make.centerY.equalTo(self.backButton)
        }
        
        let tabWidth: CGFloat = 236
        let tabHeight: CGFloat = 70
        let tabSpace: CGFloat = 20
        //base info tab
        baseInfoTabButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.headerView)
            make.height.equalTo(tabHeight)
            make.centerX.equalTo(self.headerView).offset(-(tabWidth + tabSpace)/2)
            make.width.equalTo(tabWidth)
        }
        
        //observe info tab
        observeInfoTabButton.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(self.baseInfoTabButton)
            make.centerX.equalTo(self.headerView).offset((tabWidth + tabSpace)/2)
        }
        
        //disclosure info button
        disclosureInfoButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(76)
            make.centerY.equalTo(self.backButton)
            make.right.equalTo(self.view).offset(-22)
        }
        
        headerView.layoutIfNeeded()
        baseInfoTabButton.layer.mask = generateRoundedPathLayer(withBounds: baseInfoTabButton.bounds, radius: 7)
        observeInfoTabButton.layer.mask = generateRoundedPathLayer(withBounds: baseInfoTabButton.bounds, radius: 7)
        
        //rounded bg view
        roundedBgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.view).offset(-38)
            make.left.equalTo(self.view).offset(39)
            make.right.equalTo(self.view).offset(-39)
        }
        
        //scroll view
        assesmentScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.assesmentContainerView)
            make.top.equalTo(self.roundedBgView)
            make.left.equalTo(self.roundedBgView)
            make.width.equalTo(screenWidth - 39 * 2)
            make.bottom.equalTo(self.roundedBgView)
        }
        
        //container view
        assesmentContainerView.snp.makeConstraints { (make) in
            make.height.equalTo(screenHeight - 110 - 38)
            make.left.equalTo(self.baseInfoBgView)
            make.right.equalTo(self.observerBgView)
        }
        
        //base info bg view
        baseInfoBgView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(self.assesmentContainerView)
            make.width.equalTo(screenWidth - 39 * 2)
        }
        
        //base info table view
        baseInfoTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.baseInfoBgView).inset(UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        }
        
        //observe info bg view
        observerBgView.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(self.baseInfoBgView)
            make.left.equalTo(self.baseInfoBgView.snp.right)
            make.right.equalTo(self.assesmentContainerView)
        }
        
        //observe info table view
        observerInfoTableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.observerBgView)
            make.bottom.equalTo(self.commitFooterView.snp.top)
        }
        
        //observe footer view
        commitFooterView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.observerInfoTableView)
            make.height.equalTo(90)
            make.bottom.equalTo(self.observerBgView).offset(10)
        }
        
        //observe switch button
        switchRoleButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.commitFooterView).offset(20)
            make.top.equalTo(self.commitFooterView).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(45)
        }
        
        //observe commit button
        commitButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.commitFooterView)
            make.top.equalTo(self.switchRoleButton)
            make.width.equalTo(620)
            make.height.equalTo(56)
        }
        
        //switch
        
        //mask view
        maskView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        
        //switchOptionBgImageView
        switchOptionBgImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.maskView).offset(50)
            make.bottom.equalTo(self.maskView).offset(-100)
            make.width.equalTo(120)
            make.height.equalTo(110)
        }
       
        //switchArrowImageView
        switchArrowImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.switchOptionBgImageView)
            make.bottom.equalTo(self.maskView).offset(-101)
            make.width.equalTo(20)
            make.height.equalTo(10)
        }
        
        //parentRoleButton
        parentRoleButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.switchOptionBgImageView).offset(10)
            make.left.equalTo(self.switchOptionBgImageView).offset(10)
            make.right.equalTo(self.switchOptionBgImageView).offset(-10)
            make.height.equalTo(self.switchOptionBgImageView).dividedBy(2).offset(-((2.0 + 24) / 2))
        }
        
        //switchSepLine
        switchSepLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.parentRoleButton)
            make.top.equalTo(self.parentRoleButton.snp.bottom)
            make.height.equalTo(2)
        }

        //teacherRoleButton
        teacherRoleButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.parentRoleButton)
            make.top.equalTo(self.switchSepLine.snp.bottom)
            make.height.equalTo(parentRoleButton)
        }
    }
    
    
    //MARK:Init views
    
    func initViews() {
        
        //bg view
        bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "common_full_screen_bg")
        view.addSubview(bgImageView)

        //header view
        headerView = UIView()
        view.addSubview(headerView)
        
        //back button
        backButton = UIButton()
        backButton.setImage(UIImage(named: "common_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        headerView.addSubview(backButton)
        
        //student name
        studentNameLabel = UILabel()
        studentNameLabel.font = UIFont.systemFont(ofSize: 16)
        studentNameLabel.textColor = UIColor.colorFromRGBA(85, 85, 85)
        studentNameLabel.numberOfLines = 1
        let student = "\(localStringForKey(key: "recruit_student_underlying_ass_prefix"))\(curStudentName ?? "")"
        studentNameLabel.text = student
        studentNameLabel.setContentHuggingPriority(.required, for: .horizontal)
        studentNameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        headerView.addSubview(studentNameLabel)
        
        let tabSize = CGSize(width: 236, height: 70)
        
        //base info tab
        baseInfoTabButton = UIButton()
        baseInfoTabButton.setBackgroundImage(UIImage.imageFromColor(fillColor: .white, imageSize: tabSize), for: .selected)
        baseInfoTabButton.setBackgroundImage(UIImage.imageFromColor(fillColor: UIColor.colorFromRGBA(255, 238, 159), imageSize: tabSize), for: .normal)
        baseInfoTabButton.setBackgroundImage(UIImage.imageFromColor(fillColor: .white, imageSize: tabSize), for: [.selected, .highlighted])
        baseInfoTabButton.setImage(UIImage(named: "recruit_student_base_info_unselected"), for: .normal)
        baseInfoTabButton.setImage(UIImage(named: "recruit_student_base_info_selected"), for: .selected)
        baseInfoTabButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        baseInfoTabButton.setTitleColor(UIColor.colorFromRGBA(153, 153, 153), for: .normal)
        baseInfoTabButton.setTitleColor(UIColor.colorFromRGBA(34, 34, 34), for: .selected)
        baseInfoTabButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        baseInfoTabButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        baseInfoTabButton.addTarget(self, action: #selector(baseInfoTabClicked(button:)), for: .touchUpInside)
        baseInfoTabButton.isSelected = true
        headerView.addSubview(baseInfoTabButton)
        
        //observe info tab
        observeInfoTabButton = UIButton()
        observeInfoTabButton.setBackgroundImage(UIImage.imageFromColor(fillColor: .white, imageSize: tabSize), for: .selected)
        observeInfoTabButton.setBackgroundImage(UIImage.imageFromColor(fillColor: UIColor.colorFromRGBA(255, 238, 159), imageSize: tabSize), for: .normal)
        observeInfoTabButton.setBackgroundImage(UIImage.imageFromColor(fillColor: .white, imageSize: tabSize), for: [.selected, .highlighted])
        observeInfoTabButton.setImage(UIImage(named: "recruit_student_observe_info_unselected"), for: .normal)
        observeInfoTabButton.setImage(UIImage(named: "recruit_student_observe_info_selected"), for: .selected)
        observeInfoTabButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        observeInfoTabButton.setTitleColor(UIColor.colorFromRGBA(153, 153, 153), for: .normal)
        observeInfoTabButton.setTitleColor(UIColor.colorFromRGBA(34, 34, 34), for: .selected)
        observeInfoTabButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        observeInfoTabButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        observeInfoTabButton.addTarget(self, action: #selector(observeInfoTabClicked(button:)), for: .touchUpInside)
        observeInfoTabButton.isSelected = false
        headerView.addSubview(observeInfoTabButton)

        //disclosure
        disclosureInfoButton = UIButton()
        disclosureInfoButton.setImage(UIImage(named: "common_question_icon"), for: .normal)
        disclosureInfoButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        disclosureInfoButton.addTarget(self, action: #selector(disclosureInfoButtonClicked(button:)), for: .touchUpInside)
        headerView.addSubview(disclosureInfoButton)
        
        //rounded bg view
        roundedBgView = UIView()
        roundedBgView.backgroundColor = UIColor.white
        roundedBgView.layer.cornerRadius = 20
        roundedBgView.layer.shadowOpacity = 1
        roundedBgView.layer.shadowOffset = CGSize(width: 0, height: 10)
        roundedBgView.layer.shadowColor = UIColor.colorFromRGBA(255, 173, 0, alpha: 0.5).cgColor
        view.addSubview(roundedBgView)
        
        //scroll view
        assesmentScrollView = UIScrollView()
        assesmentScrollView.layer.cornerRadius = 20
        assesmentScrollView.layer.masksToBounds = true
        assesmentScrollView.bounces = true
        assesmentScrollView.delegate = self
        assesmentScrollView.isPagingEnabled = true
        if #available(iOS 11.0, *) {
            assesmentScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        roundedBgView.addSubview(assesmentScrollView)
        
        //container view
        assesmentContainerView = UIView()
        assesmentScrollView.addSubview(assesmentContainerView)
        
        //base bg view
        baseInfoBgView = UIView()
        baseInfoBgView.backgroundColor = UIColor.white
        assesmentContainerView.addSubview(baseInfoBgView)
        
        //base table view
        baseInfoTableView = UITableView()
        baseInfoTableView.tableFooterView = UIView()
        baseInfoTableView.delegate = self
        baseInfoTableView.dataSource = self
        baseInfoTableView.register(AssPattenMultiSelectionCell.self, forCellReuseIdentifier: NSStringFromClass(AssPattenMultiSelectionCell.self))
        baseInfoTableView.register(AssPattenSingleSelectionCell.self, forCellReuseIdentifier: NSStringFromClass(AssPattenSingleSelectionCell.self))
        baseInfoTableView.register(AssPattenPassThroughCell.self, forCellReuseIdentifier: NSStringFromClass(AssPattenPassThroughCell.self))
        baseInfoTableView.separatorStyle = .none
        baseInfoTableView.estimatedRowHeight = 80
        baseInfoTableView.rowHeight = UITableView.automaticDimension
        baseInfoTableView.showsVerticalScrollIndicator = false
        baseInfoTableView.showsHorizontalScrollIndicator = false
        baseInfoBgView.addSubview(baseInfoTableView)
        
        //observe bg view
        observerBgView = UIView()
        observerBgView.backgroundColor = UIColor.white
        assesmentContainerView.addSubview(observerBgView)
        
        //observe table view
        observerInfoTableView = UITableView()
        observerInfoTableView.tableFooterView = UIView()
        observerInfoTableView.delegate = self
        observerInfoTableView.dataSource = self
        observerInfoTableView.register(AssPattenMultiSelectionCell.self, forCellReuseIdentifier: NSStringFromClass(AssPattenMultiSelectionCell.self))
        observerInfoTableView.register(AssPattenSingleSelectionCell.self, forCellReuseIdentifier: NSStringFromClass(AssPattenSingleSelectionCell.self))
        observerInfoTableView.register(AssPattenPassThroughCell.self, forCellReuseIdentifier: NSStringFromClass(AssPattenPassThroughCell.self))
        observerInfoTableView.separatorStyle = .none
        observerInfoTableView.estimatedRowHeight = 60
        observerInfoTableView.rowHeight = UITableView.automaticDimension
        observerInfoTableView.showsVerticalScrollIndicator = false
        observerInfoTableView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            observerInfoTableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        observerBgView.addSubview(observerInfoTableView)
        
        //observe footer view
        commitFooterView = UIView()
        commitFooterView.backgroundColor = UIColor.white
        observerBgView.addSubview(commitFooterView)
        
        //switch button
        switchRoleButton = ReverseButton(frame: .zero, spaceX: 5)
        switchRoleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        switchRoleButton.setTitleColor(UIColor.colorFromRGBA(85, 85, 85), for: .normal)
        switchRoleButton.setTitle(AssRole.teacher.roleName, for: .normal)
        switchRoleButton.setImage(UIImage(named: "recruit_student_switch_arrow_up"), for: .normal)
        switchRoleButton.setImage(UIImage(named: "recruit_student_switch_arrow_down"), for: .selected)
        switchRoleButton.addTarget(self, action: #selector(switchObserveRoleButtonClicked(button:)), for: .touchUpInside)
        switchRoleButton.isSelected = false
        commitFooterView.addSubview(switchRoleButton)
        
        //commit button
        commitButton = UIButton()
        commitButton.backgroundColor = UIColor.colorFromRGBA(254, 228, 98)
        commitButton.layer.cornerRadius = 28
        commitButton.layer.masksToBounds = true
        commitButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        commitButton.setTitleColor(UIColor.colorFromRGBA(34, 34, 34), for: .normal)
        commitButton.setTitle(localStringForKey(key: "recruit_student_ass_commit_button_title"), for: .normal)
        commitButton.addTarget(self, action: #selector(commitButtonClicked(button:)), for: .touchUpInside)
        commitFooterView.addSubview(commitButton)
        
        //switch
        
        //mask view
        maskView = UIView()
        maskView.isHidden = true
        view.addSubview(maskView)
        
        //switchOptionBgImageView
        switchOptionBgImageView = UIImageView(image: UIImage(named: "recruit_student_switch_role_bubble"))
        switchOptionBgImageView.isUserInteractionEnabled = true
        maskView.addSubview(switchOptionBgImageView)
        
        //switchArrowImageView
        switchArrowImageView = UIImageView(image: UIImage(named: "recruit_student_switch_role_bubble_arrow"))
        maskView.addSubview(switchArrowImageView)
        
        //parentRoleButton
        parentRoleButton = UIButton()
        parentRoleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        parentRoleButton.setTitle(AssRole.parent.roleName, for: .normal)
        parentRoleButton.setTitleColor(UIColor.colorFromRGBA(85, 85, 85), for: .normal)
        parentRoleButton.setTitleColor(UIColor.colorFromRGBA(255, 162, 0), for: .selected)
        parentRoleButton.addTarget(self, action: #selector(parentRoleSwitcherClicked(button:)), for: .touchUpInside)
        parentRoleButton.isSelected = false
        switchOptionBgImageView.addSubview(parentRoleButton)
        
        //switchSepLine
        switchSepLine = UIView()
        switchSepLine.backgroundColor = UIColor.colorFromRGBA(240, 240, 240)
        switchOptionBgImageView.addSubview(switchSepLine)

        //teacherRoleButton
        teacherRoleButton = UIButton()
        teacherRoleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        teacherRoleButton.setTitle(AssRole.teacher.roleName, for: .normal)
        teacherRoleButton.setTitleColor(UIColor.colorFromRGBA(85, 85, 85), for: .normal)
        teacherRoleButton.setTitleColor(UIColor.colorFromRGBA(255, 162, 0), for: .selected)
        teacherRoleButton.addTarget(self, action: #selector(teacherRoleSwitcherClicked(button:)), for: .touchUpInside)
        teacherRoleButton.isSelected = true
        switchOptionBgImageView.addSubview(teacherRoleButton)
    }
    
    //MARK: Utility
    
    func generateRoundedPathLayer(withBounds bounds: CGRect, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: CGSize(width: radius, height: radius))
        let pathLayer = CAShapeLayer()
        pathLayer.frame = baseInfoTabButton.bounds
        pathLayer.path = path.cgPath
        return pathLayer
    }
}


extension RecruitStudentAssesmentViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView == assesmentScrollView {
            let targetOffsetX = targetContentOffset.pointee.x
            let syncTabType: TabType = targetOffsetX > 0 ? .observer : .base
            switchTabTo(tabType: syncTabType)
        }
    }
}


extension RecruitStudentAssesmentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if tableView == baseInfoTableView {
            rowCount = baseCaseArray.count
        } else {
            if curObserveAssRole == .teacher {
                rowCount = teacherCaseArray.count
            } else {
                rowCount = parentCaseArray.count
            }
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(AssPattenSingleSelectionCell.self), for: indexPath) //默认单选
        var dataSource = baseCaseArray
        if tableView == observerInfoTableView {
            dataSource = curObserveAssRole == .teacher ? teacherCaseArray : parentCaseArray
        }
        
        if indexPath.row < dataSource.count {
            let assCase = dataSource[indexPath.row]
            let caseType = assCase.caseType
            if caseType == .multiSelection {
                
                cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(AssPattenMultiSelectionCell.self), for: indexPath) as! AssPattenMultiSelectionCell
            } else if caseType == .singleSelection {
                
                cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(AssPattenSingleSelectionCell.self), for: indexPath) as!AssPattenSingleSelectionCell
                
            } else {
               
                cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(AssPattenPassThroughCell.self), for: indexPath) as! AssPattenPassThroughCell
            }
            
            //刷新数据
            if let cell = cell as? AssPattenCell {
                cell.reloadView(withData: assCase)
            }
            
        } else {
            DDLogError("indexPath.row < dataSource.count 越界！")
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}
