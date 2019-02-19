//
//  Ass_Patten_SingleSelectionView.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/9/30.
//  Copyright © 2018年 yitai. All rights reserved.
//

/*
 * 单选，必选
 */

fileprivate let singleSelectionItemBaseTag = 1000

class SingleSelectionItemView: UIView {
    
    let itemIndex: Int
    let maxWidth: CGFloat
    var curAssCaseOption: AssCaseOption?
    
    var optionTitleLabel: UILabel!
    var actionButton: UIButton!
    
    init(frame: CGRect, index: Int, maxWidth: CGFloat) {
        self.itemIndex = index
        self.maxWidth = maxWidth
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(withItemOption option: AssCaseOption, titleFont font: UIFont, titleColor textColor: UIColor, contentInset inset: UIEdgeInsets, fixedWidth: CGFloat, fixedHeight: CGFloat, compactable compact: Bool) -> CGSize {
        
        self.curAssCaseOption = option
        var itemSize = CGSize.zero
        let title = option.optionText
        if title.isEmpty {return itemSize}
        
        //如果compact是yes，此时根据fixedwidth 和 fixedheight来决定哪个方向是紧包裹（值<＝0 认为是紧包裹）
        //如果compact是no，此时忽略inset，直接使用fixedwidth 和 fixedheight
        if compact == false {
            itemSize.width = min(self.maxWidth, fixedWidth)
            itemSize.height = fixedHeight
        } else {
            let titleSize = title.textSize(byFont: font, breakMode: .byWordWrapping, inSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.frame.height))
            itemSize.width = min(titleSize.width + inset.left + inset.right, self.maxWidth)
            itemSize.height = self.frame.height
        }
        
        let titleX = inset.left
        let titleW = itemSize.width - inset.left - inset.right
        let titleRect = CGRect(x: titleX, y: 0, width: titleW, height: itemSize.height)
        optionTitleLabel = UILabel()
        optionTitleLabel.frame = titleRect
        optionTitleLabel.font = UIFont.systemFont(ofSize: 16)
        optionTitleLabel.textColor = UIColor.colorFromRGBA(34, 34, 34)
        optionTitleLabel.textAlignment = .center
        optionTitleLabel.numberOfLines = 1
        optionTitleLabel.text = title
        addSubview(optionTitleLabel)
        
        let buttonRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
        actionButton = UIButton(type: .custom)
        actionButton.frame = buttonRect
        actionButton.tag = singleSelectionItemBaseTag + itemIndex
        addSubview(actionButton)
        
        self.frame.size = itemSize
        
        return itemSize
    }
    
    func setItemSelectedStatus(isSelected: Bool) {
        
        //actionButton.isSelected = isSelected
        curAssCaseOption?.isSelected = isSelected
        
        if isSelected {
            optionTitleLabel.textColor = UIColor.colorFromRGBA(34, 34, 34)
            backgroundColor = UIColor.colorFromRGBA(254, 228, 98)
            layer.borderColor = nil
            layer.borderWidth = 0
        } else {
            optionTitleLabel.textColor = UIColor.colorFromRGBA(85, 85, 85)
            backgroundColor = UIColor.colorFromRGBA(254, 252, 235)
            layer.borderColor = UIColor.colorFromRGBA(187, 185, 174).cgColor
            layer.borderWidth = 1
        }
    }
}


class SingleSelectionContainerView: UIView {
    
    var curAssCase: AssCase?
    var curCaseOptions = [AssCaseOption]()
    
    var itemViewsArray = [SingleSelectionItemView]()
    
    func initialize(withAssCase assCase: AssCase, titleFont font: UIFont, titleColor textColor: UIColor, fixedHeight itemHeight: CGFloat, fixedWidth itemWidth: CGFloat, containerInset: UIEdgeInsets, itemInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat, borderColor: UIColor?, borderWidth: CGFloat,radius: CGFloat, compactable compact: Bool) -> CGSize {
        
        itemViewsArray.removeAll()
        curCaseOptions.removeAll()
        self.subviews.forEach{$0.removeFromSuperview()}
        
        curAssCase = assCase
        curCaseOptions.append(contentsOf: assCase.optionsArray)
        
        if curCaseOptions.isEmpty {return self.frame.size}
        
        var lastRect = CGRect.zero
        var x = containerInset.left
        var y = containerInset.top
        let maxWidth = self.frame.width
        let availableWidth = self.frame.width - containerInset.left - containerInset.right
        let itemWidthDefault: CGFloat = 100.0
        var itemTitle = ""
        
        for i in 0..<curCaseOptions.count {
            
            let caseOption = curCaseOptions[i]
            itemTitle = caseOption.optionText
            if itemTitle.isEmpty {continue}
            
            let itemView = SingleSelectionItemView(frame: CGRect(x: 0, y: 0, width: itemWidthDefault, height: itemHeight), index: i, maxWidth: availableWidth)
            
            let itemSize = itemView.initialize(withItemOption: caseOption, titleFont: font, titleColor: textColor, contentInset: itemInset, fixedWidth: itemWidth, fixedHeight: itemHeight, compactable: compact)
            
            itemView.setItemSelectedStatus(isSelected: caseOption.isSelected)
            itemView.actionButton.addTarget(self, action: #selector(clickOptionItem(button:)), for: .touchUpInside)
            
            if (x + itemSize.width + containerInset.right <= maxWidth) {
                //当前行可以放下item
                lastRect = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
                //修改x y值
                x += (itemSize.width + spaceX)
            } else {
                //当前行放不下该item,需要换行
                //此时分情况：该行目前是不是只有这个item，如果该item是此行的第一个，那么该tag的最大宽度即为改行最大宽度；如果不是第一个，认为该行放不下该item，此时应该换行
                if x == containerInset.left {
                    //强制放在此行
                    lastRect = CGRect(x: x, y: y, width: availableWidth, height: itemSize.height)
                    //直接跳到下一行，修改x,y值
                    x = containerInset.left
                    y = lastRect.maxY + spaceY
                } else {
                    //换到下一行
                    x = containerInset.left
                    y += (itemSize.height + spaceY)
                    let w: CGFloat = (itemSize.width > availableWidth ? availableWidth : itemSize.width)
                    lastRect = CGRect(x: x, y: y, width: w, height: itemSize.height)
                    //修改x,y值
                    x += (w + spaceX)
                }
            }
            
            itemView.frame = lastRect
            itemView.layer.borderColor = borderColor?.cgColor
            itemView.layer.borderWidth = borderWidth
            itemView.layer.cornerRadius = radius
            itemView.layer.masksToBounds = true
            
            addSubview(itemView)
            itemViewsArray.append(itemView)
        }
        
        let finalHeight: CGFloat = lastRect.maxY + containerInset.bottom
        self.frame.size.height = finalHeight
        
        return self.frame.size
    }
    
    func initialize(withAssCase assCase: AssCase, titleFont font: UIFont, titleColor textColor: UIColor, fixedHeight itemHeight: CGFloat, fixedWidth itemWidth: CGFloat, containerInset: UIEdgeInsets, itemInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat, compactable compact: Bool) -> CGSize {
        
        return self.initialize(withAssCase: assCase, titleFont: font, titleColor: textColor, fixedHeight: itemHeight, fixedWidth: itemWidth, containerInset: containerInset, itemInset: itemInset, spaceX: spaceX, spaceY: spaceY, borderColor: nil, borderWidth: 0, radius: 0, compactable: compact)
    }
    
    @objc func clickOptionItem(button: UIButton) {
        
        //reset
        itemViewsArray.forEach {$0.setItemSelectedStatus(isSelected: false)}
        
        //set
        //button.isSelected = !button.isSelected
        let index = button.tag - singleSelectionItemBaseTag
        let itemView = itemViewsArray[index]
        itemView.setItemSelectedStatus(isSelected: true)
    }
}


import UIKit

class Ass_Patten_SingleSelectionView: Ass_Patten_View {
    
    var contentBgView: UIView!
    var headerView: UIView!
    var titleLabel: UILabel!
    let containerDefaultHeight: CGFloat = 44
    var caseOptionContainerView: SingleSelectionContainerView!
    var containerSize = CGSize.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initViews() {
        
        //bg view
        contentBgView = UIView()
        contentBgView.backgroundColor = UIColor.colorFromRGBA(254, 252, 235)
        contentBgView.layer.cornerRadius = 16
        contentBgView.layer.masksToBounds = true
        addSubview(contentBgView)
        
        //header view
        headerView = UIView()
        headerView.backgroundColor = UIColor.colorFromRGBA(255, 244, 198)
        contentBgView.addSubview(headerView)
        
        //title label
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.colorFromRGBA(34, 34, 34)
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        headerView.addSubview(titleLabel)
        
        //option view
        caseOptionContainerView = SingleSelectionContainerView(frame: CGRect(x: 0, y: 0, width: self.frame.width - 20 * 2, height: containerDefaultHeight))
        addSubview(caseOptionContainerView)
    }
    
    override func layoutViews() {
        
        //content bg view
        contentBgView.snp.remakeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.bottom.equalTo(self)
        }
        
        //header view
        headerView.snp.remakeConstraints { (make) in
            make.top.left.right.equalTo(self.contentBgView)
        }

        //title label
        titleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.headerView).offset(30)
            make.right.equalTo(self.headerView).offset(-30)
            make.top.equalTo(self.headerView).offset(12)
            make.bottom.equalTo(self.headerView).offset(-12)
        }
        
        //option view
        caseOptionContainerView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self.contentBgView)
            make.top.equalTo(self.headerView.snp.bottom).offset(10)
            make.height.equalTo(containerSize.height > 0 ? containerSize.height : containerDefaultHeight)
            make.bottom.equalTo(self.contentBgView).offset(-10)
        }
    }
    
    override func reloadView(withData caseData: AssCase) {
        
        //save
        assCase = caseData
        
        //title
        titleLabel.text = caseData.caseTitle
        
        //options
        //固定列宽方式排版
        let titleFont = UIFont.systemFont(ofSize: 16)
        let textColor = UIColor.colorFromRGBA(85, 85, 85)
        let containerInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        let itemInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        let spaceX: CGFloat = 20.0
        let spaceY: CGFloat = 10.0
        
        let colCount = 4
        let fixedWidth = (self.frame.width - 20 * 2 - containerInset.left - containerInset.right - CGFloat(colCount - 1) * spaceX) / CGFloat(colCount)
        let fixedHeight: CGFloat = 44
        
        let tempSize = caseOptionContainerView.initialize(withAssCase: caseData, titleFont: titleFont, titleColor: textColor, fixedHeight: fixedHeight, fixedWidth: fixedWidth, containerInset: containerInset, itemInset: itemInset, spaceX: spaceX, spaceY: spaceY, borderColor: UIColor.colorFromRGBA(187, 185, 174), borderWidth: 1, radius: 22, compactable: false)
        
        let emptySize = CGSize(width: tempSize.width, height: containerDefaultHeight)
        
        containerSize = caseData.optionsArray.count == 0 ? emptySize : tempSize
        
        layoutViews()
    }
}


class AssPattenSingleSelectionCell: AssPattenCell {
    
    var caseView: Ass_Patten_SingleSelectionView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initViews() {
        
        caseView = Ass_Patten_SingleSelectionView(frame: CGRect(x: 0, y: 0, width: screenWidth - 39 * 2, height: 0))
        contentView.addSubview(caseView)
    }
    
    override func layoutViews() {
        
        caseView.snp.remakeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        }
    }
    
    override func reloadView(withData caseData: AssCase) {
        
        caseView.reloadView(withData: caseData)
        
        layoutViews()
    }
}
