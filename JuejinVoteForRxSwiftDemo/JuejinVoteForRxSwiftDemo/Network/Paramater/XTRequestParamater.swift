//
//  XTRequestParamater.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/1/8.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import Foundation

struct CommonParamater {
    static let userId = "uid"           // 用户id
    static let token = "token"          // token
    static let deviceId = "device_id"   // 设备id
    static let src = "src"              // 平台标识
    static let before = "before"        // 上次查询时间 [第一次/刷新 传0]
    static let limit = "limit"          // 每页返回
}

struct VoteRequestURL {
    static let timeLineHost = "https://short-msg-ms.juejin.im/v1"   // 沸点信息流Host
    static let queryTimelinePath = "getByTimeline"                  // 获取信息流数据Path
}
