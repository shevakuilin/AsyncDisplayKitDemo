//
//  XTContextNode.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/2/28.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import AsyncDisplayKit

class XTContextNode: ASDisplayNode {
    private let imageNode = ASImageNode()

    required override init() {
        super.init()
        setContext()
    }
    

    private func setContext() {
        imageNode.image = UIImage(named: "zanMedium_sel")
        imageNode.willDisplayNodeContentWithRenderingContext = {(context, drawParameters) in
            print("执行willDisplayNodeContentWithRenderingContext")
        }
        self.willDisplayNodeContentWithRenderingContext = { (context, drawParameters) in
            print("执行willDisplayNodeContentWithRenderingContext")
        }

    }
}
