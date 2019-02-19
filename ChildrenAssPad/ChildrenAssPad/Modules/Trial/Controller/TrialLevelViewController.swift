//
//  TrialLevelViewController.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/11/23.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

class TrialLevelViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var bgImageView: UIImageView!
    var titleLabel: UILabel!
    var levelCountLabel: UILabel!
    var cardCollectionView: UICollectionView!
    var pageControl: UIPageControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        initViews()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrialLevelCollectionViewCell", for: indexPath) as! TrialLevelCollectionViewCell
        cell.imageView.image = UIImage.init(named: "trial_curLevel")
        cell.curLevelLable.text = "第\(indexPath.row)关"

        return cell

    }


    func initViews() {

        bgImageView = UIImageView.init()
        bgImageView.isUserInteractionEnabled = true
        bgImageView.image = UIImage.init(named: "trial_bg")
        self.view.addSubview(bgImageView)

        titleLabel = UILabel.init()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        titleLabel.text = "儿童自测"
        titleLabel.textColor = UIColor.white
        bgImageView.addSubview(titleLabel)

        levelCountLabel = UILabel()
        levelCountLabel.text = "12关"
        levelCountLabel.font = UIFont.boldSystemFont(ofSize: 20)
        levelCountLabel.textColor = UIColor.colorWithHexString(hex: "#ffe33d")
        bgImageView.addSubview(levelCountLabel)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.init(top:0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize.init(width: 306, height:420)
        cardCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        cardCollectionView.isScrollEnabled = true
        cardCollectionView.register(TrialLevelCollectionViewCell.self, forCellWithReuseIdentifier: "TrialLevelCollectionViewCell")
        cardCollectionView.backgroundColor = UIColor.clear
        bgImageView.addSubview(cardCollectionView)


        bgImageView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.view)
        }

        cardCollectionView.snp.makeConstraints { (maker) in
            maker.left.equalTo(bgImageView.snp.left).offset(53)
            maker.right.equalTo(bgImageView.snp.right).offset(-53)
            maker.height.equalTo(420)
            maker.top.equalTo(bgImageView.snp.top).offset(158)
        }


        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(bgImageView.snp.left).offset(420)
            maker.height.equalTo(40)
            maker.top.equalTo(bgImageView.snp.top).offset(56)
        }

        levelCountLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp.right).offset(10)
            maker.height.equalTo(40)
            maker.centerY.equalTo(titleLabel)
        }

    }



}
