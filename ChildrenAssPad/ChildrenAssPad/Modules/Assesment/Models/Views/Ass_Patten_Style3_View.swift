//
//  Ass_Patten_Style3_View.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/11/27.
//  Copyright © 2018年 yitai. All rights reserved.
//

/*
 * 题干: 自适应文字，支持多行
 * 选项: 不可点击、左对齐、高度固定、宽动态计算、当前行剩余位置显示不开，直接换到下一行开始（如果整行显示不开，则tail）
 */

import UIKit

class Ass_Patten_Style3_View: Ass_Patten_View {

    var titleLabel: UILabel!
    var backView: UIView!
    var optionContainerView: ItemContainerView!
    
    let defaultContainerHeight: CGFloat = 50
    let defaultOptionHeight: CGFloat = 40
    
    var curCase: AssCase?
    var optionsDataArray = [AssCaseOption]()
    var optionsViewArray = [FlatNormalItemView]()
    
    var didSelectOptionCallback: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initViews() {
        
        //title label
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.colorFromRGBA(34, 34, 34)
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        addSubview(titleLabel)
        
        //back view
        backView = UIView()
        backView.backgroundColor = UIColor.colorFromRGBA(247, 249, 250)
        addSubview(backView)
        
        //container view
        optionContainerView = ItemContainerView(frame: CGRect(x: 0, y: 0, width: frame.width, height: defaultContainerHeight))
        backView.addSubview(optionContainerView)
    }
    
    override func layoutViews() {
        
        //title
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            
        }
        
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.bottom.equalTo(self.optionContainerView)
        }
        
        optionContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.backView).offset(5)
            make.left.equalTo(self.backView).offset(5)
            make.right.equalTo(self.backView).offset(-5)
            make.height.equalTo(defaultContainerHeight)
        }
        
        self.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel)
            make.bottom.equalTo(self.backView)
        }
    }
    
    func reloadView(withData caseData: AssCase, containerInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat) {
        
        //save & clean
        curCase = caseData
        optionsViewArray.removeAll()
        optionContainerView.cleanSubViews()
        optionsDataArray.removeAll()
        optionsDataArray.append(contentsOf: caseData.optionsArray)
        
        //title
        titleLabel.text = caseData.caseTitle
        
        //options
        let contentWidth: CGFloat = frame.width - containerInset.left - containerInset.right
        let itemFont = UIFont.systemFont(ofSize: 16)
        let itemInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        for (idx, itemData) in optionsDataArray.enumerated() {
            
            let itemTitle = "\(itemData.optionType). \(itemData.optionText)"
            let itemRect = CGRect(x: 0, y: 0, width: 0, height: defaultOptionHeight)
            let itemView = FlatNormalItemView(frame: itemRect, index: idx, maxWidth: contentWidth)
            let _ = itemView.initialize(withItemTitle: itemTitle, titleFont: itemFont, lineNumber: 1, breakMode: .byTruncatingTail, contentInset: itemInset, fixWidth: false, fixedWidth: 0, fixHeight: true, fixedHeigth: defaultOptionHeight)
            itemView.actionButton.addTarget(self, action: #selector(didSelectOption(button:)), for: .touchUpInside)
            optionsViewArray.append(itemView)
        }
        
        let containerSize = optionContainerView.loadLeftAlignedItems(optionsViewArray, containerInset: containerInset, spaceX: spaceX, spaceY: spaceY)
        optionContainerView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.backView).offset(5)
            make.left.equalTo(self.backView).offset(5)
            make.right.equalTo(self.backView).offset(-5)
            make.height.equalTo(containerSize.height)
        }
    }
    
    @objc func didSelectOption(button: UIButton) {
        
        let idx = button.tag - FlatNormalItemView.flatNormalItemViewBaseTag
        let selectedOptionView = optionsViewArray[idx]
        let selectedOption = optionsDataArray[idx]
        
        if let curCase = curCase {
            let caseType = curCase.caseType
            if caseType == .normalSingleSelection {
                //单选
                if !selectedOptionView.isItemSelected {
                    optionsViewArray.forEach{$0.setItemSelectedStatus(isSelected: false)}
                    optionsDataArray.forEach{$0.isSelected = false}
                    selectedOptionView.setItemSelectedStatus(isSelected: true)
                    selectedOption.isSelected = true
                }
            } else if caseType == .normalMultiSelection {
                //多选
                selectedOptionView.setItemSelectedStatus(isSelected: !selectedOptionView.isItemSelected)
                selectedOption.isSelected = selectedOptionView.isItemSelected
            }
        }
        didSelectOptionCallback?(idx)
    }
}


class Ass_Patten_Style3_Cell: AssPatternStyleCell {
    
    var patternView: Ass_Patten_Style3_View!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, parentWidth: CGFloat) {
        super.init(style: style, reuseIdentifier: reuseIdentifier, parentWidth: parentWidth)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var defaultPatternHeight: CGFloat {
        get {
            return 70.0
        }
        set {
            super.defaultPatternHeight = newValue
        }
    }
    
    override func initViews() {
        
        let rect = CGRect(x: 0, y: 0, width: parentWidth, height: defaultPatternHeight)
        patternView = Ass_Patten_Style3_View(frame: rect)
        patternView.didSelectOptionCallback = {[weak self] idx in
            
        }
        contentView.addSubview(patternView)
    }
    
    override func layoutViews() {
        
        patternView.snp.remakeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        }
    }
    
    func reloadView(withData caseData: AssCase, containerInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat, atIndexPath indexPath: IndexPath) {
        
        curIndexPath = indexPath
        patternView.reloadView(withData: caseData, containerInset: containerInset, spaceX: spaceY, spaceY: spaceY)
    }
}
