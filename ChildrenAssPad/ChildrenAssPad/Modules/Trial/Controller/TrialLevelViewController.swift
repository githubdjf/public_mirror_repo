//
//  TrialLevelViewController.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/11/23.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

class TrialLevelViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    typealias StartBlock = ()->Void

    var bgImageView: UIImageView!
    var titleLabel: UILabel!
    var levelCountLabel: UILabel!
    var cardCollectionView: UICollectionView!
    var cupCollectionView: UICollectionView!
    var pageControl: UIPageControl!
    var pageView: PageView!
    var startBlock: StartBlock?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        initViews()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {


        if collectionView == cardCollectionView {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrialLevelCollectionViewCell", for: indexPath) as! TrialLevelCollectionViewCell
            cell.imageView.image = UIImage.init(named: "trial_curLevel")
            cell.curLevelLable.text = "第\(indexPath.row)关"

            cell.startTappedBlock = {[weak self] in
                
                if let weakSelf = self {

                    if let block = weakSelf.startBlock {
                        block()
                    }
                }


            }

            return cell

        } else {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrialCupCollectionViewCell", for: indexPath) as! TrialCupCollectionViewCell

            cell.imageView.image = UIImage.init(named: "trial_cup_normal")

            return cell

        }




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


        let flowLayout1 = UICollectionViewFlowLayout()
        flowLayout1.scrollDirection = .horizontal
        flowLayout1.minimumInteritemSpacing = 0
        flowLayout1.minimumLineSpacing = 6
        flowLayout1.sectionInset = UIEdgeInsets.init(top:0, left: 0, bottom: 0, right: 0)
        flowLayout1.itemSize = CGSize.init(width: 55, height:52)
        cupCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout1)
        cupCollectionView.delegate = self
        cupCollectionView.dataSource = self
        cupCollectionView.isScrollEnabled = false
        cupCollectionView.register(TrialCupCollectionViewCell.self, forCellWithReuseIdentifier: "TrialCupCollectionViewCell")
        cupCollectionView.backgroundColor = UIColor.clear
        bgImageView.addSubview(cupCollectionView)


        pageView = PageView()

        pageView.reloadViews(curIndex: 0, count: 3)
        bgImageView.addSubview(pageView)


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

        cupCollectionView.snp.makeConstraints { (maker) in
            maker.left.equalTo(bgImageView.snp.left).offset(59)
            maker.height.equalTo(52)
            maker.right.equalTo(bgImageView.snp.right).offset(-350)
            maker.bottom.equalTo(bgImageView.snp.bottom).offset(-32)
        }

        pageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(cardCollectionView.snp.bottom).offset(16)
            maker.height.equalTo(10)
            maker.centerX.equalTo(bgImageView)
        }
    }


}
