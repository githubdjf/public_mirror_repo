//
//  HomepageFunctionViewController.swift
//  FirstEducation
//
//  Created by 译泰视觉 on 2018/9/29.
//  Copyright © 2018 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift
import RxCocoa
import Moya


class HomepageFunctionViewController: BaseViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
        
    var navi: UIView!
    
    var dataArray = [HomePageFunctionModel]()
    private let iconArray = ["home_recruit_evaluation", "home_children_overall_development", "home_critical_thinking", "home_clarifying_question"]
    
    lazy var listCollect: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 336, height: 266)
        layout.minimumInteritemSpacing = 50
        layout.minimumLineSpacing = 50
        let collect = UICollectionView(frame: CGRect(x: 0, y: navBarHeight(), width: screenWidth, height: screenHeight-navBarHeight()-safeBottomPadding()), collectionViewLayout: layout)
        self.view.addSubview(collect)
        collect.delegate = self
        collect.dataSource = self
        collect.bounces = false
        collect.isScrollEnabled = false
        collect.contentInset = UIEdgeInsets(top: 51, left: 151, bottom: 65, right: 145)
        collect.register(HomePageFunctionCollectionViewCell.self, forCellWithReuseIdentifier: "HomePageFunctionCollectionViewCell")
        collect.backgroundColor = UIColor.colorWithHexString(hex: "f7f9fa")
        return collect
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        navi = self.addNavByTitle(title: "欢迎进入第一教育成长中心")
        self.createRightBtn()
        self.loadData()
    }
    
    private func createRightBtn() -> Void {
        let rightItem = UIButton(type: .custom)
        navi.addSubview(rightItem)
        rightItem.setImage(UIImage.init(named: "icon_user"), for: .normal)
        rightItem.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        let optUser = LoginManager.default.curUser
        if let user = optUser {
            rightItem.setTitle(user.userName, for: .normal)
        }
        rightItem.setTitleColor(UIColor.white, for: .normal)
        rightItem.addTarget(self, action: #selector(userBtnClick), for: .touchUpInside)
        rightItem.snp.makeConstraints { (make) in
            make.centerY.equalTo(navi.snp.centerY).offset(10)
            make.right.equalTo(navi.snp.right).offset(-20)
        }
    }
    
    func loadData() -> Void {
        showLoadingView(inView: nil, isShow: true, text: nil)
        HomeService.displayHomeFunction()
            .catchError { [weak self] (error) -> Observable<[HomePageFunctionModel]> in
                if let ws = self {
                    ws.showErrorView(inView: nil, isShow: true, inset: UIEdgeInsets(top: navBarHeight(), left: 0, bottom: 0, right: 0), text: APPErrorFactory.unboxAndExtractErrorMessage(from: error), type: .reTryError)
                    ws.errorView?.retryBlock = { () in
                        ws.loadData()
                    }
                }
                return Observable.empty()
        }
        .asSingle()
            .subscribe(onSuccess: { [weak self] (funcList) in
                if let ws = self {
                    ws.cleanViewHierarchy()
                    guard funcList.count > 0 else {
                        ws.showEmptyView(inView: nil, isShow: true, inset: UIEdgeInsets(top: navBarHeight(), left: 0, bottom: 0, right: 0), text: localStringForKey(key: "message_no_data"), type: .emptyCommon)                        
                        return
                    }
                    ws.dataArray = funcList
                    ws.listCollect.reloadData()
                }
            }) { (error) in
                print("\(#function)  \(error)")
        }
        .disposed(by: self.rx.disposeBag)
        
//        let json = JSON([
//            [            "id": 1,
//            "name": "招生测试",
//            "isCan": 1
//            ],
//            [
//            "id": 2,
//            "name": "幼儿全面发展",
//            "isCan": 0
//            ],
//            [
//            "id": 3,
//            "name": "重点能力",
//            "isCan": 0
//            ],
//            [
//            "id": 4,
//            "name": "问题澄清",
//            "isCan": 0
//            ]
//            ])
//
//        let arr = try? Mapper.mapToObjectArray(data: json.rawData(), type: HomePageFunctionModel.self)
//        if let array = arr {
//            dataArray = array
//            self.listCollect.reloadData()
//        }
        
    }
    
    func createUI() -> Void {
        
    }
    
    @objc func userBtnClick() -> Void {
        let vc = PersonalCenterController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageFunctionCollectionViewCell", for: indexPath) as! HomePageFunctionCollectionViewCell
        
        let model = dataArray[indexPath.item]
        
        cell.configureCell(model: model, iconArray: iconArray, index: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArray[indexPath.item]
        if model.isCan == 1 {
            let vc = RecruitEvaluationInfoViewController()
            vc.curExamId = model.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
