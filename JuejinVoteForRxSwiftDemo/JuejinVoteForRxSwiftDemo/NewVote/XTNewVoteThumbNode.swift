//
//  XTNewVoteThumbNode.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/1/15.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import AsyncDisplayKit

class XTNewVoteThumbNode: ASDisplayNode {
    
    var thumbClickBlock:((Bool)->())?
    
    private var buttonNode: ASDisplayNode!
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        
        weak var weakSelf = self
        
        buttonNode = {
            let node = ASDisplayNode(viewBlock: { () -> UIView in
                let button = TTFaveButton(frame:CGRect.init(x: 0, y: 0, width: 29, height: 29), faveIconImage:R.image.zanMedium(), selectedFaveIconImage:R.image.zanMedium_sel())!

                button.normalColor = kColor(138, 147, 160)
                button.selectedColor = kColor(55, 199, 0)
                button.dotFirstColor = kColor(72, 206, 193)
                button.dotSecondColor = kColor(92, 158, 237)
                button.circleFromColor = kColor(92, 158, 237)
                button.circleToColor = kColor(72, 206, 193)
                button.addTarget(self, action: #selector(weakSelf?.touchFaveButton(sender:)), for: .touchUpInside)
                
                return button
            })
            
            addSubnode(node)
            
            return node
        }()
    }
    
    @objc private func touchFaveButton(sender: UIButton) {
        if let block = thumbClickBlock {
            block(sender.isSelected)
        }
    }
    
    override func layout() {
        super.layout()
        buttonNode.frame = bounds
    }
    
    override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
        let size = CGSize(width: 29, height: 29)
        return size
    }
}
