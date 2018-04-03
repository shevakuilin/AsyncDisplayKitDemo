//
//  XTNewVoteTimelineCellView.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/2/26.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class XTNewVoteTimelineCellView: UIView {
    
    let cellNode = XTNewVoteTimelineCellNode()
    let contextNode = XTContextNode()
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellNode.frame = CGRect(x: 0, y: 0, width: UIScreenAttribute.width, height: 500)
        self.addSubnode(cellNode)
        
        contextNode.frame = CGRect(x: 0, y: 500, width: UIScreenAttribute.width, height: 100)
        self.addSubnode(contextNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
