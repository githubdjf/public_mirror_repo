//
//  RecruitStudentAssesmentInfoViewController.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/10/11.
//  Copyright © 2018年 yitai. All rights reserved.
//

/*
 * 招生测评 info 解读 alert
 */

import UIKit
import SwiftyJSON
import RxCocoa
import RxSwift
import NSObject_Rx

class RecruitStudentAssesmentInfoViewController: BaseViewController {

    var infoContainerView: UIView!
    var headerView: UIView!
    var titleLabel: UILabel!
    var iconImageView: UIImageView!
    var closeButton: UIButton!
    var answerTableView: UITableView!
    
    var loadingView: LoadDataView?
    var emptyView: PromptView?
    var errorView: PromptView?
    
    var answerArray = [AssQuestionAnswer]()
    
    var didCloseCallback: (() -> Void)?
    var curAssUserId: String?
    
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
    
    @objc func close() {
        
        didCloseCallback?()
    }
    
    
    //MARK: Load data
    
    func loadData() {
        
        showLoadingView(isShow: true, inset: UIEdgeInsets(top: 45, left: 0, bottom: 0, right: 0))
        
        RecruitStudentService.fetchRecruitStudentGetAssQuestionAnswerList(withUserId: curAssUserId ?? "")
            .catchError {[weak self] (error) -> Observable<[AssQuestionAnswer]> in
                if let weakSelf = self {
                    //TODO
                    //全屏错误页面
                    weakSelf.loadingView?.hide()
                    let eMsg = APPErrorFactory.unboxAndExtractErrorMessage(from: error)
                    self?.showErrorView(isShow: true, inset: UIEdgeInsets(top: 45, left: 0, bottom: 0, right: 0), text: eMsg, type: .reTryError)
                }
                return Observable.empty()
            }
            .asSingle()
            .subscribe(onSuccess: {[weak self] (answers) in
                
                if let weakSelf = self {
                    weakSelf.loadingView?.hide()
                    
                    weakSelf.answerArray.removeAll()

                    //TODO
                    //显示空页面
                    if answers.count <= 0 {
                        weakSelf.showEmptyView(isShow: true, inset: UIEdgeInsets(top: 45, left: 0, bottom: 0, right: 0), text: localStringForKey(key: "message_no_data"), type: PromptView.PromptType.emptyCommon)
                    } else {
                        weakSelf.answerArray.append(contentsOf: answers)
                        weakSelf.answerTableView.reloadData()
                    }
                }
                
            }) { (error) in
                
                print("\(#function) error = \(error)!");
            }
            .disposed(by: self.rx.disposeBag)
    }
    
    
    //MARK: Prompt view
    
    func showEmptyView(isShow: Bool, inset: UIEdgeInsets = .zero, text: String = "", type: PromptView.PromptType = PromptView.PromptType.emptyCommon) {
        if isShow {
            cleanViewHierarchy()
            self.emptyView = PromptView(superView: self.infoContainerView, insets: inset, promptText: text, promptType: type)
            self.emptyView?.show()
        } else {
            self.emptyView?.hide()
        }
    }
    
    func showLoadingView(isShow: Bool, inset: UIEdgeInsets = .zero) {
        if isShow {
            cleanViewHierarchy()
            self.loadingView = LoadDataView(superView: self.infoContainerView, insets: inset, title: localStringForKey(key: "message_data_loading"))
            self.loadingView?.show()
        } else {
            self.loadingView?.hide()
        }
    }
    
    func showErrorView(isShow: Bool, inset: UIEdgeInsets = .zero, text: String = "", type: PromptView.PromptType = .reTryError) {
        
        if isShow {
            cleanViewHierarchy()
            let errView = PromptView(superView: self.infoContainerView, insets: inset, promptText: text, promptType: type)
            errView.retryBlock = {[weak self] in
                if let weakSelf = self {
                    weakSelf.cleanViewHierarchy()
                    weakSelf.loadData()
                }
            }
            self.errorView = errView
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
    
    func layoutViews() {
        
        //container
        infoContainerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60))
        }
        
        //header view
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.infoContainerView)
            make.height.equalTo(45)
        }
      
        //title label
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.headerView).offset(20)
            make.top.bottom.equalTo(self.headerView)
            make.right.lessThanOrEqualTo(self.iconImageView.snp.left).offset(-20)
        }
       
        //icon
        iconImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.closeButton.snp.left).offset(-10)
            make.top.equalTo(self.headerView)
            make.width.equalTo(140)
            make.height.equalTo(45)
        }
        
        //close
        closeButton.snp.makeConstraints { (make) in
            make.top.right.equalTo(self.headerView)
            make.height.equalTo(45)
            make.width.equalTo(60)
        }
        
        //info table
        answerTableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.infoContainerView)
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.infoContainerView)
        }
    }
    
    
    //MARK:Init views
    
    func initViews() {
        
        //bg
        view.backgroundColor = UIColor.colorFromRGBA(0, 0, 0).withAlphaComponent(0.5)
        
        //container
        infoContainerView = UIView()
        infoContainerView.backgroundColor = UIColor.white
        infoContainerView.layer.cornerRadius = 5
        infoContainerView.layer.masksToBounds = true
        view.addSubview(infoContainerView)
        
        //header view
        headerView = UIView()
        headerView.backgroundColor = UIColor.mainColor
        infoContainerView.addSubview(headerView)
        
        //title label
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 1
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.text = localStringForKey(key: "recurit_student_ass_info_title")
        headerView.addSubview(titleLabel)
        
        //icon
        iconImageView = UIImageView(image: UIImage(named: "recruit_student_ass_info_icon"))
        headerView.addSubview(iconImageView)
        
        //close
        closeButton = UIButton()
        closeButton.setImage(UIImage(named: "recruit_student_ass_info_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        headerView.addSubview(closeButton)
        
        //info table
        answerTableView = UITableView()
        answerTableView.tableFooterView = UIView()
        answerTableView.delegate = self
        answerTableView.dataSource = self
        answerTableView.register(RecruitStudentAssAnswerCell.self, forCellReuseIdentifier: NSStringFromClass(RecruitStudentAssAnswerCell.self))
        answerTableView.separatorStyle = .none
        answerTableView.estimatedRowHeight = 60
        answerTableView.rowHeight = UITableView.automaticDimension
        answerTableView.showsVerticalScrollIndicator = false
        answerTableView.showsHorizontalScrollIndicator = false
        infoContainerView.addSubview(answerTableView)
    }
}



//MARK: Table Delegate

extension RecruitStudentAssesmentInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return answerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(RecruitStudentAssAnswerCell.self), for: indexPath) as! RecruitStudentAssAnswerCell
        
        let answer = answerArray[indexPath.row]
        cell.answerLabel.text = answer.content
        
        cell.selectionStyle = .none
        
        return cell
    }
}
