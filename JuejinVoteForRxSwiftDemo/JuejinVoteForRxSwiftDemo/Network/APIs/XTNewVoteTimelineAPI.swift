//
//  XTNewVoteTimelineAPI.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/1/8.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import Moya
import Foundation

let NewVoteProvider = MoyaProvider<NewVote>()

enum NewVote {
    case queryTimelineInfoWith(before: String, limit: Int)
}

extension NewVote: TargetType {
    var baseURL: URL {
        return URL(string: VoteRequestURL.timeLineHost)!
    }
    
    var path: String {
        switch self {
        case .queryTimelineInfoWith:
            return VoteRequestURL.queryTimelinePath
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        // NOTE: Unit Testing
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .queryTimelineInfoWith(before: let before, limit: let limit):
            var paramaters: [String: Any] = [:]
            paramaters[CommonParamater.userId] = ""
            paramaters[CommonParamater.token] = ""
            paramaters[CommonParamater.deviceId] = ""
            paramaters[CommonParamater.src] = ""
            paramaters[CommonParamater.before] = before
            paramaters[CommonParamater.limit] = limit
            
            return .requestParameters(parameters: paramaters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
