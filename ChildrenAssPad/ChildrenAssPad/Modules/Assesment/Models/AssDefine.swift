//
//  AssDefine.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/11/27.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation

enum AssCaseType: Int {
    case unknow = 0
    
    //一期：招生测评
    case singleSelection = 1 //单选，必选
    case multiSelection = 2 //多选，可以不选
    case passThrough = 3 //单选，必选
    
    //二期：扩展更多题型（题型 + 模板 -> 具体样式）
    case normalSingleSelection = 4 //单选选择题，除以上选择题型
    case combinedSelection = 5 //组合题
    case normalMultiSelection = 6 //多选选择题
}


enum AssCasePattern: Int {
    case unknow = -1
    
    /*
     * 题干: 自适应文字，支持多行
     * 选项: 2列，固定列宽，选项高度自适应，下一行的选项以上一列最高选项下线开始
     */
    case selectionPatten1 = 1
    
    /*
     * 题干: 自适应文字，支持多行
     * 选项: 5列，固定列宽，固定行高
     */
    case selectionPatten2 = 2
    
    /*
     * 题干: 自适应文字，支持多行
     * 选项: 不可点击、左对齐、高度固定、宽动态计算、当前行剩余位置显示不开，直接换到下一行开始（如果整行显示不开，则tail）
     */
    case selectionPatten3 = 3
    
    /*
     题干： 文字：
           图片：
     选项： 单选（文字）
     音频：进来就自动播放，点击暂停，暂停状态下点击重新播放
     */
    case selectionPatten4 = 4
    
    /*
     题干： 文字
     选项： 单选（图片）
     音频：进来就自动播放，点击暂停，暂停状态下点击重新播放
     */
    case selectionPatten5 = 5
    
    /*
     题干： 文字
     选项： 单选（图片）
     音频：进来就自动播放，点击暂停，暂停状态下点击重新播放
     */
    case selectionPatten6 = 6
    
    /*
     题干： 文字
     选项： 单选（图片）
     音频：进来就自动播放，点击暂停，暂停状态下点击重新播放
     */
    case selectionPatten7 = 7
    
    /*
     题干： 文字
     选项： 单选（图片,gif不可以循环播放）
     音频：进来自动播放，没有点击播放，播放按钮置灰
     */
    case selectionPatten8 = 8
    
    
    /*
     * 题干: 自适应文字，支持多行
     * 子题: 其他样式的题
     */
    case combinedPatten1 = 21
}
