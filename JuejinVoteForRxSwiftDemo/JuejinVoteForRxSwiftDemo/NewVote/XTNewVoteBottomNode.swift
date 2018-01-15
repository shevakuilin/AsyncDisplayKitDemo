//
//  XTNewVoteBottomNode.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/1/15.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import AsyncDisplayKit

class XTNewVoteBottomNode: ASDisplayNode {
    let thumbNode = XTNewVoteThumbNode()    // 点赞按钮
    let thumbCountNode = ASTextNode()       // 点赞数量
    let commentNode = ASButtonNode()        // 回复按钮
    let commentCountNode = ASTextNode()     // 回复数量
    let shareNode = ASButtonNode()          // 分享按钮
    
    struct ElementSize {
        static let thumbNodeWidth: CGFloat = 20
        static let thumbNodeHeight: CGFloat = 20
        static let thumbCountMaxWidth: CGFloat = 80
        static let commentNodeWidth: CGFloat = 20
        static let commentNodeHeight: CGFloat = 20
        static let commentCountMaxWidth: CGFloat = 80
        static let shareNodeWidth: CGFloat = 20
        static let shareNodeHeight: CGFloat = 20
    }
    
    struct ElementSpacing {
        static let bottomItemSpacing: CGFloat = ((UIScreenAttribute.width / 2) - 20) - (40 + 104)   // 回复按钮位置距点赞评论的位置距离
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        setUI()
    }
    
    override func didLoad() {
        super.didLoad()
        
        weak var weakSelf = self
        guard let wself = weakSelf else{
            return
        }
        
        thumbNode.thumbClickBlock = { (isSelected) in
            // TODO: 点击点赞按钮
            print("点击了点赞按钮!!")
            if isSelected {
                wself.thumbCountNode.attributedText = NSAttributedString(string: "13", attributes: kAttributedStyle(kFont(15), kColor(55, 199, 0)))
            } else {
                wself.thumbCountNode.attributedText = NSAttributedString(string: "12", attributes: kAttributedStyle(kFont(15), kColor(138, 147, 160)))
            }
        }
        
        commentNode.addTarget(self, action: #selector(clickCommentNode), forControlEvents: .touchUpInside)
        shareNode.addTarget(self, action: #selector(clickShareNode), forControlEvents: .touchUpInside)
    }
    
    private func setUI() {
        thumbNode.style.width = ASDimensionMakeWithPoints(ElementSize.thumbNodeWidth)
        thumbNode.style.height = ASDimensionMakeWithPoints(ElementSize.thumbNodeHeight)
        self.addSubnode(thumbNode)
        
        thumbCountNode.style.width = ASDimensionMakeWithPoints(ElementSize.thumbCountMaxWidth)
        thumbCountNode.attributedText = NSAttributedString(string: "12", attributes: kAttributedStyle(kFont(15), kColor(138, 147, 160)))
        self.addSubnode(thumbCountNode)
        
        commentNode.style.width = ASDimensionMakeWithPoints(ElementSize.commentNodeWidth)
        commentNode.style.height = ASDimensionMakeWithPoints(ElementSize.commentNodeHeight)
        commentNode.setImage(R.image.talkMedium(), for: .normal)
        
        self.addSubnode(commentNode)
        
        commentCountNode.style.width = ASDimensionMakeWithPoints(ElementSize.commentCountMaxWidth)
        commentCountNode.attributedText = NSAttributedString(string: "399", attributes: kAttributedStyle(kFont(15), kColor(138, 147, 160)))
        self.addSubnode(commentCountNode)
        
        shareNode.style.width = ASDimensionMakeWithPoints(ElementSize.shareNodeWidth)
        shareNode.style.height = ASDimensionMakeWithPoints(ElementSize.shareNodeHeight)
        shareNode.setImage(R.image.shareMedium(), for: .normal)
        self.addSubnode(shareNode)
    }
    
    @objc private func clickCommentNode() {
        printLog("点击了回复按钮 !!")
    }
    
    @objc private func clickShareNode() {
        printLog("点击了分享按钮 !!")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let leftHorizontalStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                        spacing: 4,
                                                        justifyContent: .start,
                                                        alignItems: .center,
                                                        children: [thumbNode, thumbCountNode])
        
        let centerHorizontalStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                          spacing: 4,
                                                          justifyContent: .center,
                                                          alignItems: .center,
                                                          children: [commentNode, commentCountNode])
        
        
        let rightHorizontalStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                         spacing: 4,
                                                         justifyContent: .end,
                                                         alignItems: .center,
                                                         children: [shareNode])
        
        let groupStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                               spacing: ElementSpacing.bottomItemSpacing,
                                               justifyContent: .start,
                                               alignItems: .center,
                                               children: [leftHorizontalStackSpec, centerHorizontalStackSpec, rightHorizontalStackSpec])
        
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(9, 40, 9, 40), child: groupStackSpec)
    }
}
