//
//  PageView.swift
//  ChildrenAssPad
//
//  Created by 李雪 on 2019/2/19.
//  Copyright © 2019年 yitai. All rights reserved.
//

import UIKit

class PageView: UIView {

    var itemArray: Array<UIView> = [UIView]()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }


    func reloadViews(curIndex: Int, count: Int) {

        for view in self.subviews {
            view.removeFromSuperview()
        }

        var leftView: UIView? = nil

        for i in 0 ..< count {

            let view = UIView()
            view.backgroundColor = UIColor.colorFromRGBA(255, 219, 59)
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
            self.addSubview(view)

            if let temp = leftView {

                view.snp.makeConstraints { (maker) in
                    maker.left.equalTo(temp.snp.right).offset(10)
                    maker.height.equalTo(10)
                    if i == curIndex {
                        maker.width.equalTo(50)
                    }else{
                        maker.width.equalTo(10)
                    }

                    maker.centerY.equalTo(self)
                }

            } else {

                view.snp.makeConstraints { (maker) in
                    maker.left.equalTo(self)
                    maker.height.equalTo(10)
                    maker.centerY.equalTo(self)
                    if i == curIndex {
                        maker.width.equalTo(50)
                    }else{
                        maker.width.equalTo(10)
                    }
                }

            }

            leftView = view

        }

    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
