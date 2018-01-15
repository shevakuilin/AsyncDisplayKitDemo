//
//  XTNewVotePhotoNode.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/1/13.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import AsyncDisplayKit

class XTNewVotePhotoNode: ASCellNode {
    let photoNode = ASNetworkImageNode()
    
    enum ElementScale {
        case photoScale         // 图片比例
        case specialPhotoScale  // 特殊图片比例 [2x2格式]
        case photoSpacing       // 图片间距
        case bottomSpacing      // 底部间距
        case photoMargin        // 图片边距
        
        static var value : CGFloat = 0.0
        var instanceConstraint : CGFloat {
            switch self {
            case .photoScale: UIScreenAttribute.width == 320 ? (ElementScale.value = 3.1):(ElementScale.value = 3.08)
            case .specialPhotoScale: UIScreenAttribute.width == 320 ? (ElementScale.value = 3.045
                ):(ElementScale.value = 3.038)
            case .photoSpacing: ElementScale.value = 4.0
            case .bottomSpacing: ElementScale.value = 12.0
            case .photoMargin: ElementScale.value = 14.0
            }
            
            return ElementScale.value
        }
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        setUI()
    }
    
    private func setUI() {
        photoNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        let scaleValue = ElementScale.photoScale.instanceConstraint
        let size = CGSize(width: (UIScreenAttribute.width - (ElementScale.photoMargin.instanceConstraint * 2)) / scaleValue, height: (UIScreenAttribute.width - (ElementScale.photoMargin.instanceConstraint * 2)) / scaleValue)
        photoNode.style.width = ASDimensionMakeWithPoints(size.width)
        photoNode.style.height = ASDimensionMakeWithPoints(size.height)
        photoNode.url = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1515918554383&di=c3a61639794097eb7dae1a3e95dfa012&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%253D580%2Fsign%3D9c6495a134d12f2ece05ae687fc3d5ff%2F3046ff36afc37931eddd725fe9c4b74542a91141.jpg")
        photoNode.placeholderFadeDuration = 0.15
        photoNode.shouldRenderProgressImages = true
        photoNode.contentMode = .scaleAspectFill
        self.addSubnode(photoNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                  spacing: 0,
                                                  justifyContent: .start,
                                                  alignItems: .start,
                                                  children: [photoNode])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 0, 0, 0), child: verticalStackSpec)
    }
}
