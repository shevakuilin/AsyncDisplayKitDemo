//
//  XTGlobalVariable.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/4/3.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import Foundation

let IS_IPHONE_X: Bool = UIScreenAttribute.height == 812 ? true:false
let IPHONE_X_NAV_HEIGHT: CGFloat = 88
let IPHONE_DEFALUT_NAV_HEIGHT: CGFloat = 64
let IPHONE_NORMAL_NAV_HEIGHT: CGFloat = IS_IPHONE_X ? 88:64
