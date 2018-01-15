//
//  XTNewVoteModel.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/1/8.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import Foundation

struct XTNewVoteModel {
    let objectId: String
    let uid: String
    let content: String
    let pictures: [String]
    let commentCount: NSNumber
    let likedCount: NSNumber
    let isLiked: Bool
    let createdAt: String
    let updatedAt: String
}
