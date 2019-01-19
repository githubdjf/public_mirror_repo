//
//  PromptView.swift
//  zp_chu
//
//  Created by 李雪 on 2018/7/19.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

class PromptView: UIView {

    enum PromptType : String {

        case normalError   //普通业务错误
        case reTryError  //网络错误
        case emptyCommon //普通页面没有数据
    }

    typealias RetryBlock = () -> Void

    private var tempSuperView: UIView!
    private var tempInsets: UIEdgeInsets!
    private var iconImageViwe: UIImageView!
    private var titleLabel: UILabel!
    private var tempView: UIView!
    private var retryButton: UIButton!
    private var containerView: UIView!
    private var errorType: PromptType?

    var retryBlock: RetryBlock?

    init(superView: UIView, insets: UIEdgeInsets, promptText: String, promptType: PromptType ) {

        super.init(frame: CGRect.zero)
        errorType = promptType

        self.backgroundColor = UIColor.white
        if superView.subviews.contains(self){
            self.removeFromSuperview()
        }

        for view in self.subviews {
            view.removeFromSuperview()
        }

        tempSuperView = superView
        tempInsets = insets

        containerView = UIView.init()
        self.addSubview(containerView)

        iconImageViwe = UIImageView.init()
        if errorType == .emptyCommon {

            iconImageViwe.image = UIImage.init(named: "common_empty")
        }else{

            iconImageViwe.image = UIImage.init(named: "common_net_unreachable")
        }
        containerView.addSubview(iconImageViwe)

        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.colorWithHexString(hex: "#c9c9c9")
        titleLabel.text = promptText
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        containerView.addSubview(titleLabel)

        retryButton = UIButton()
        retryButton.setTitle("刷新", for: .normal)
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        retryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        retryButton.setTitleColor(UIColor.colorWithHexString(hex: "#999999"), for: .normal)
        retryButton.layer.cornerRadius = 4
        retryButton.layer.masksToBounds = true
        retryButton.layer.borderColor = UIColor.colorWithHexString(hex: "#069479").cgColor
        retryButton.layer.borderWidth = 1
        containerView.addSubview(retryButton)
    }

    @objc func retryButtonTapped(){

        if let blcok = retryBlock {
            blcok()
        }
    }


    init(displayView: UIView, insets: UIEdgeInsets, promptText: String, promptType: PromptType ) {
        super.init(frame: CGRect.zero)

        errorType = promptType
        self.backgroundColor = UIColor.white

        if displayView.subviews.contains(self){
            self.removeFromSuperview()
        }
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        tempSuperView = displayView
        tempInsets = insets
        
        tempView = UIView()
        self.addSubview(tempView)
        
        iconImageViwe = UIImageView.init()

        if errorType == .emptyCommon {

            iconImageViwe.image = UIImage.init(named: "common_empty")
        }else{

            iconImageViwe.image = UIImage.init(named: "common_net_unreachable")
        }

        tempView.addSubview(iconImageViwe)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.colorWithHexString(hex: "#c9c9c9")
        titleLabel.text = promptText
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        tempView.addSubview(titleLabel)
    }


    func show() -> Void {

        if !tempSuperView.subviews.contains(self){
            tempSuperView.addSubview(self)
        }

        self.snp.makeConstraints { (maker) in
            maker.top.equalTo(tempSuperView.snp.top).offset(tempInsets.top)
            maker.left.equalTo(tempSuperView.snp.left).offset(tempInsets.left)
            maker.right.equalTo(tempSuperView.snp.right).offset(-tempInsets.right)
            maker.bottom.equalTo(tempSuperView.snp.bottom).offset(-tempInsets.bottom)
        }

        tempSuperView.layoutIfNeeded()

        containerView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self)
            maker.centerY.equalTo(self)
            maker.width.equalTo(300)
            maker.top.equalTo(iconImageViwe.snp.top)
            maker.bottom.equalTo(retryButton.snp.bottom)
        }

        iconImageViwe.snp.makeConstraints { (maker) in
            maker.top.equalTo(containerView.snp.top)
            maker.width.height.equalTo(160)
            maker.centerX.equalTo(containerView)
        }

        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(iconImageViwe.snp.bottom).offset(10)
            maker.centerX.equalTo(iconImageViwe)
            maker.width.equalTo(300)
        }

        retryButton.snp.makeConstraints { (maker) in

            maker.centerX.equalTo(titleLabel)
            maker.top.equalTo(titleLabel.snp.bottom).offset(20)
            if errorType == .reTryError {
                maker.height.equalTo(53)
            }else{
                maker.height.equalTo(0)
            }
            maker.width.equalTo(131)
        }


    }
    
    func interShow() -> Void {
        if !tempSuperView.subviews.contains(self){
            tempSuperView.addSubview(self)
        }
        
        self.snp.makeConstraints { (maker) in
            maker.top.equalTo(tempSuperView.snp.top).offset(tempInsets.top)
            maker.left.equalTo(tempSuperView.snp.left).offset(tempInsets.left)
            maker.right.equalTo(tempSuperView.snp.right).offset(-tempInsets.right)
            maker.bottom.equalTo(tempSuperView.snp.bottom).offset(-tempInsets.bottom)
        }
        self.layoutIfNeeded()
        
        iconImageViwe.snp.makeConstraints { (maker) in
            maker.top.equalTo(-40)
            maker.width.height.equalTo(126)
            maker.centerX.equalTo(self.tempView)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(iconImageViwe.snp.bottom).offset(18)
            //temp
//            maker.left.equalTo(tempView.snp.left).offset(60 * iphoneWidthScale)
//            maker.right.equalTo(tempView.snp.right).offset(-60 * iphoneWidthScale)
            maker.left.equalTo(tempView.snp.left).offset(60)
            maker.right.equalTo(tempView.snp.right).offset(-60)
            maker.bottom.equalTo(tempView)
        }
        
        tempView.snp.makeConstraints { (make) in
            make.center.equalTo(tempSuperView)
            make.left.right.equalTo(self)
        }
        
    }

    func hide() -> Void {

        if tempSuperView.subviews.contains(self){
            self.removeFromSuperview()
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
