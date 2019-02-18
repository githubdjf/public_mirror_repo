//
//  Ass_Patten_Style1_View.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/11/27.
//  Copyright © 2018年 yitai. All rights reserved.
//

/*
 * 题干: 自适应文字，支持多行
 * 选项: (2列)，固定列宽，选项高度自适应，下一行的选项以上一列最高选项下线开始
 */

import UIKit

class Ass_Patten_Style1_View: Ass_Patten_View {

    var titleLabel: UILabel!
    var optionContainerView: ItemContainerView!
    
    let defaultContainerHeight: CGFloat = 50
    let defaultOptionHeight: CGFloat = 40
    
    var curCase: AssCase?
    var optionsDataArray = [AssCaseOption]()
    var optionsViewArray = [RectangleNormaItemView]()
    
    var didSelectOptionCallback: ((Int) -> Void)?
    
    deinit {
        print("")
    }
    
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
        
        //container view
        optionContainerView = ItemContainerView(frame: CGRect(x: 0, y: 0, width: frame.width, height: defaultContainerHeight))
        addSubview(optionContainerView)
    }
    
    override func layoutViews() {
        
        //title
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
        
        //options
        optionContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(self)
            make.height.equalTo(defaultContainerHeight)
        }

        self.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.titleLabel.snp.top)
            maker.bottom.equalTo(optionContainerView.snp.bottom)
        }
    }
    
    func reloadView(withData caseData: AssCase, columnCount: Int, containerInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat) {
        
        //save & clean
        curCase = caseData
        optionsViewArray.removeAll()
        optionContainerView.cleanSubViews()
        optionsDataArray.removeAll()
        optionsDataArray.append(contentsOf: caseData.optionsArray)
        
        //title
        titleLabel.text = caseData.caseTitle
        
        let colCount = columnCount > 0 ? columnCount : 1
        
        //options
        let contentWidth: CGFloat = frame.width - containerInset.left - containerInset.right
        let itemWidth: CGFloat = (contentWidth - (CGFloat(colCount - 1)) * spaceX) / CGFloat(colCount)
        let itemFont = UIFont.systemFont(ofSize: 16)
        let itemInset = UIEdgeInsets(top: 9, left: 5, bottom: 9, right: 5)
        
        for (idx, itemData) in optionsDataArray.enumerated() {
            
            let itemRect = CGRect(x: 0, y: 0, width: itemWidth, height: defaultOptionHeight)
            let itemView = RectangleNormaItemView(frame: itemRect, index: idx, maxWidth: contentWidth)
            let _ = itemView.initialize(withIndicatorTitle: "\(itemData.optionType). ", itemTitle: itemData.optionText, titleFont: itemFont, lineNumber: 0, breakMode: .byTruncatingTail, contentInset: itemInset, isFixWidth: true, fixedWidth: itemWidth, minWidth: 0, isFixHeight: false, fixedHeigth: defaultOptionHeight, minHeight: defaultOptionHeight)
            itemView.actionButton.addTarget(self, action: #selector(didSelectOption(button:)), for: .touchUpInside)
            optionsViewArray.append(itemView)
            
            //设置选项状态
            itemView.setItemSelectedStatus(isSelected: itemData.isSelected)
        }
        
        let containerSize = optionContainerView.loadGridItems(optionsViewArray, columnCount: colCount, containerInset: containerInset, spaceX: spaceX, spaceY: spaceY)
        optionContainerView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(self)
            make.height.equalTo(containerSize.height)
        }
    }
    
    @objc func didSelectOption(button: UIButton) {
        
        let idx = button.tag - RectangleNormaItemView.rectangleNormaItemBaseTag
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


class Ass_Patten_Style1_Cell: AssPatternStyleCell {
    
    var patternView: Ass_Patten_Style1_View!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, parentWidth: CGFloat) {
        super.init(style: style, reuseIdentifier: reuseIdentifier, parentWidth: parentWidth)
        initViews()
        layoutViews()
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
        patternView = Ass_Patten_Style1_View(frame: rect)
        patternView.didSelectOptionCallback = {[weak self] idx in
            
        }
        contentView.addSubview(patternView)
    }
    
    override func layoutViews() {


        patternView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView.snp.top).offset(20)
            maker.left.right.equalTo(self.contentView)
        }

        self.contentView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self)
            maker.top.equalTo(patternView.snp.top).offset(-20).priority(999)
            maker.bottom.equalTo(patternView.snp.bottom).priority(999)
        }
    }

    func reloadView(withData caseData: AssCase, columnCount: Int, containerInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat, atIndexPath indexPath: IndexPath) {
        
        curIndexPath = indexPath
        patternView.reloadView(withData: caseData, columnCount: columnCount, containerInset: containerInset, spaceX: spaceX, spaceY: spaceY)
    }
}
