//
//  TrialCupCollectionViewCell.swift
//  ChildrenAssPad
//
//  Created by 李雪 on 2019/2/19.
//  Copyright © 2019年 yitai. All rights reserved.
//

import UIKit

class TrialCupCollectionViewCell: UICollectionViewCell {


    var imageView: UIImageView!

    override init(frame: CGRect) {

        super.init(frame: frame)

        imageView = UIImageView()
        self.contentView.addSubview(imageView)

        imageView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.contentView)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
