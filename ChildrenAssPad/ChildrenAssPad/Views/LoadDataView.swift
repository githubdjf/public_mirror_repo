//
//  LoadDataView.swift
//  zp_chu
//
//  Created by 李雪 on 2018/7/19.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import Lottie

class LoadDataView: UIView {

    private var tempSuperView: UIView!
    private var tempInsets: UIEdgeInsets!

    private var animationView: LOTAnimationView!
    private var titleLabel: UILabel!


    init(superView: UIView, insets: UIEdgeInsets, title: String) {

        super.init(frame: CGRect.zero)

        self.backgroundColor = UIColor.white

        if superView.subviews.contains(self){
            self.removeFromSuperview()
        }

        for view in self.subviews {
            view.removeFromSuperview()
        }

        tempSuperView = superView
        tempInsets = insets

        animationView = LOTAnimationView.init(name: "loading")
        animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        animationView.contentMode = .scaleAspectFit
        animationView.clipsToBounds = true

        animationView.loopAnimation = true
        self.addSubview(animationView)

        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.colorWithHexString(hex: "#c9c9c9")
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        self.addSubview(titleLabel)

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

        animationView.snp.makeConstraints { (maker) in
            
            maker.centerX.equalTo(self.snp.centerX)
            maker.centerY.equalTo(self.snp.centerY).offset(-(navBarHeight()/2))
            maker.width.equalTo(260)
            maker.height.equalTo(260 * 11/10)
        }

        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(animationView.snp.bottom).offset(10)
            maker.centerX.equalTo(self.snp.centerX)
            maker.width.equalTo(300)
        }

        animationView.play{ (finished) in
            // Do Something
        }
    }

    func hide() -> Void {

        if tempSuperView.subviews.contains(self){
            self.removeFromSuperview()
        }

        animationView.stop()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
