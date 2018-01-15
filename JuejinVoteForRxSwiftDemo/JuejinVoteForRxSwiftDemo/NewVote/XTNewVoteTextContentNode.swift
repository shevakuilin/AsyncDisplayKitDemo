//
//  XTNewVoteTextContentNode.swift
//  JuejinVoteForRxSwiftDemo
//
//  将YYLabel封装成Node
//
//  Created by ShevaKuilin on 2018/1/13.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import YYText
import AsyncDisplayKit

class XTNewVoteTextContentNode: ASDisplayNode {
    var richText: NSAttributedString?
    var numberOfLines: UInt = 0
    
    private var labelNode: ASDisplayNode!
    override init() {
        super.init()
        labelNode = {
            let node = ASDisplayNode(viewBlock: { [weak self] () -> UIView in
                let lable = YYLabel()
                guard let strongSelf = self else {
                    return lable
                }
                lable.numberOfLines = strongSelf.numberOfLines
                lable.attributedText = strongSelf.richText
                return lable
            })
            
            addSubnode(node)
            
            return node
        }()
    }
    
    override func layout() {
        super.layout()
        labelNode.frame = bounds
    }
    
    override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
        guard let richText = richText else {
            return CGSize(width: 0, height: 0)
        }
        let size = YYTextLayout(containerSize: constrainedSize, text: richText)?.textBoundingSize
        return size ?? CGSize(width: 0, height: 0)
    }
}
