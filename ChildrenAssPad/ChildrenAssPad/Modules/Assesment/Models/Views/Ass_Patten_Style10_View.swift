//
//  Ass_Patten_Style10_View.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/11/28.
//  Copyright © 2018年 yitai. All rights reserved.
//

/*
 * 题干: 自适应文字，支持多行
 * 题干选项: 不可点击、左对齐、高度固定、宽动态计算、当前行剩余位置显示不开，直接换到下一行开始（如果整行显示不开，则tail）
 * 人员选项：姓名、边框选项
 */

import UIKit


//MARK: 人员选项的cell

class PersonOptionsCell: AssPatternStyleCell {
    
    var personLabel: UILabel!
    var optionContainerView: ItemContainerView!
    
    let defaultContainerHeight: CGFloat = 50
    let defaultOptionHeight: CGFloat = 40
    
    var curCase: AssCase?
    var optionsDataArray = [AssCaseOption]()
    var optionsViewArray = [RectangleNormaItemView]()
    var curPerson: String?

    var didSelectOptionCallback: ((Int) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, parentWidth: CGFloat) {
        super.init(style: style, reuseIdentifier: reuseIdentifier, parentWidth: parentWidth)
        initViews()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var defaultPatternHeight: CGFloat {
        get {return 50}
        set {super.defaultPatternHeight = newValue}
    }
    
    override func initViews() {
        
        //person label
        personLabel = UILabel()
        personLabel.font = UIFont.systemFont(ofSize: 16)
        personLabel.textColor = UIColor.colorFromRGBA(85, 85, 85)
        personLabel.lineBreakMode = .byTruncatingTail
        personLabel.numberOfLines = 1
        contentView.addSubview(personLabel)
        
        //options view
        let width = parentWidth - 20 - 60 - 20 - 20
        optionContainerView = ItemContainerView(frame: CGRect(x: 0, y: 0, width: width, height: defaultContainerHeight))
        contentView.addSubview(optionContainerView)
    }
    
    override func layoutViews() {
        
        //person label
        personLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(15)
            make.left.equalTo(self.contentView).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(22)
        }
        
        //options view
        let width = parentWidth - 20 - 60 - 20 - 20
        optionContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(5)
            make.height.equalTo(defaultContainerHeight)
            make.bottom.equalTo(self.contentView).offset(-5)
            make.left.equalTo(self.personLabel.snp.right).offset(20)
            make.width.equalTo(width)
        }
    }
    
    
    func reloadView(withData caseData: AssCase, person: String, columnCount: Int, containerInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat, atIndexPath indexPath: IndexPath) {
        
        curIndexPath = indexPath
        curPerson = person
        curCase = caseData
        optionsViewArray.removeAll()
        optionContainerView.cleanSubViews()
        optionsDataArray.removeAll()
        optionsDataArray.append(contentsOf: caseData.optionsArray)
        
        let colCount = columnCount > 0 ? columnCount : 1
        
        let width = parentWidth - 20 - 60 - 20 - 20
        
        //person
        personLabel.text = "\(person)："

        //options
        let contentWidth: CGFloat = width - containerInset.left - containerInset.right
        let itemWidth: CGFloat = (contentWidth - (CGFloat(colCount - 1)) * spaceX) / CGFloat(colCount)
        let itemFont = UIFont.systemFont(ofSize: 16)
        let itemInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        for (idx, itemData) in optionsDataArray.enumerated() {
            
            let itemRect = CGRect(x: 0, y: 0, width: itemWidth, height: defaultOptionHeight)
            let itemView = RectangleNormaItemView(frame: itemRect, index: idx, maxWidth: contentWidth)
            let _ = itemView.initialize(withIndicatorTitle: "\(itemData.optionType). ", itemTitle: "", titleFont: itemFont, lineNumber: 1, breakMode: .byTruncatingTail, contentInset: itemInset, isFixWidth: true, fixedWidth: itemWidth, minWidth: 0, isFixHeight: true, fixedHeigth: defaultOptionHeight, minHeight: defaultOptionHeight)
            itemView.actionButton.addTarget(self, action: #selector(didSelectOption(button:)), for: .touchUpInside)
            optionsViewArray.append(itemView)
            
            //设置选项状态
            itemView.setItemSelectedStatus(isSelected: itemData.isSelected)
        }
        
        let containerSize = optionContainerView.loadGridItems(optionsViewArray, columnCount: colCount, containerInset: containerInset, spaceX: spaceX, spaceY: spaceY)
        optionContainerView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(5)
            make.height.equalTo(containerSize.height)
            make.bottom.equalTo(self.contentView).offset(-5)
            make.left.equalTo(self.personLabel.snp.right).offset(20)
            make.width.equalTo(width)
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


class Ass_Patten_Style10_View: Ass_Patten_View {

    var questionView: Ass_Patten_Style3_View! //题干：title + option -> pattern3
    var personTableView: UITableView! //person的选项
    
    let defaultQuestionHeight: CGFloat = 90
    
    var curCaseArray: [AssCase]? //多个人同时作答时，case数据每人1份
    var personsArray: [String] = [String]()
    
    //person option layout
    var personColumnCount = 4
    var personContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    var personSpaceX: CGFloat = 20
    var personSpaceY: CGFloat = 10
    
    deinit {
        removeObserver(self, forKeyPath: "contentSize")
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
        
        //question view
        let questionRect = CGRect(x: 0, y: 0, width: frame.width, height: defaultQuestionHeight)
        questionView = Ass_Patten_Style3_View(frame: questionRect)
        addSubview(questionView)
        
        //person view
        personTableView = UITableView()
        personTableView.tableFooterView = UIView()
        personTableView.delegate = self
        personTableView.dataSource = self
        personTableView.separatorStyle = .none
        personTableView.estimatedRowHeight = 50
        personTableView.rowHeight = UITableView.automaticDimension
        personTableView.showsVerticalScrollIndicator = false
        personTableView.showsHorizontalScrollIndicator = false
        personTableView.isScrollEnabled = false
        personTableView.addObserver(self, forKeyPath: "contentSize", options: [NSKeyValueObservingOptions.new], context: nil)
        addSubview(personTableView)
    }
    
    override func layoutViews() {
        
        //question view
        questionView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self)
            make.width.equalTo(frame.width)
        }
        
        //persons
        personTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.questionView.snp.bottom).offset(10)
            make.width.left.equalTo(self.questionView)
            make.height.equalTo(100)
        }
        
        //self
        self.snp.makeConstraints { (make) in
            make.top.equalTo(self.questionView)
            make.bottom.equalTo(self.personTableView)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let path = keyPath, let result = change, let size = (result[NSKeyValueChangeKey.newKey] as? NSValue)?.cgSizeValue else {
            return
        }
        
        if path == "contentSize" {
            
            //update table constraints
            personTableView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.questionView.snp.bottom).offset(10)
                make.left.right.equalTo(self)
                make.height.equalTo(size.height)
            }
        }
    }
    
    func reloadView(withDataArray caseDataArray: [AssCase], persons: [String], titleViewContainerInset: UIEdgeInsets, titleSpaceX: CGFloat, titleSpaceY: CGFloat , personColumnCount: Int, personContainerInset: UIEdgeInsets, personSpaceX: CGFloat, personSpaceY: CGFloat) {
        
        curCaseArray = caseDataArray
        personsArray.removeAll()
        personsArray.append(contentsOf: persons)
        
        //person option layout
        self.personColumnCount = personColumnCount
        self.personContainerInset = personContainerInset
        self.personSpaceX = personSpaceX
        self.personSpaceY = personSpaceY
        
        guard caseDataArray.count > 0, persons.count > 0, caseDataArray.count == persons.count else {
            return
        }
        
        //title view
        questionView.reloadView(withData: caseDataArray[0], containerInset: titleViewContainerInset, spaceX: titleSpaceX, spaceY: titleSpaceY)
        
        //person
        personTableView.reloadData()
    }
}


//MARK: UITableViewDelegate && DataSource

extension Ass_Patten_Style10_View: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return personsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = NSStringFromClass(PersonOptionsCell.self)
        var personCell: PersonOptionsCell?
        personCell = tableView.dequeueReusableCell(withIdentifier: cellId) as? PersonOptionsCell
        if personCell == nil {
            personCell = PersonOptionsCell(style: .default, reuseIdentifier: cellId, parentWidth: frame.width)
        }
        
        if let caseArray = curCaseArray {
            let personCase = caseArray[indexPath.row]
            let person = personsArray[indexPath.row]
            personCell?.reloadView(withData: personCase, person:person, columnCount: self.personColumnCount, containerInset: self.personContainerInset, spaceX: self.personSpaceX, spaceY: self.personSpaceY, atIndexPath: indexPath)
        }
        
        personCell!.selectionStyle = .none
        return personCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}



class Ass_Patten_Style10_Cell: AssPatternStyleCell {
    
    var patternView: Ass_Patten_Style10_View!
    var containerView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, parentWidth: CGFloat) {
        super.init(style: style, reuseIdentifier: reuseIdentifier, parentWidth: parentWidth)
        initViews()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var defaultPatternHeight: CGFloat {
        get {return 250.0}
        set {super.defaultPatternHeight = newValue}
    }
    
    override func initViews() {
        containerView = UIView()
        self.contentView.addSubview(containerView)
        
        let rect = CGRect(x: 0, y: 0, width: parentWidth, height: defaultPatternHeight)
        patternView = Ass_Patten_Style10_View(frame: rect)
        containerView.addSubview(patternView)
    }
    
    override func layoutViews() {
        
        containerView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.contentView)
            maker.top.equalTo(patternView.snp.top).offset(-20).priority(999)
            maker.bottom.equalTo(patternView.snp.bottom).priority(999)
        }
        
        patternView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.top).offset(20)
            make.left.width.equalTo(containerView)
        }
    }
    
    func reloadView(withDataArray caseDataArray: [AssCase], persons: [String], titleViewContainerInset: UIEdgeInsets, titleSpaceX: CGFloat, titleSpaceY: CGFloat , personColumnCount: Int, personContainerInset: UIEdgeInsets, personSpaceX: CGFloat, personSpaceY: CGFloat, atIndexPath indexPath: IndexPath) {
        
        curIndexPath = indexPath
        
        patternView.reloadView(withDataArray: caseDataArray, persons: persons, titleViewContainerInset: titleViewContainerInset, titleSpaceX: titleSpaceX, titleSpaceY: titleSpaceY, personColumnCount: personColumnCount, personContainerInset: personContainerInset, personSpaceX: personSpaceX, personSpaceY: personSpaceY)        
    }
}

