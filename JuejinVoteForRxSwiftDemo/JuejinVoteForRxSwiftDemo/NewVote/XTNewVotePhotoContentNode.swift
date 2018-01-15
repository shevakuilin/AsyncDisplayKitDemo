//
//  XTNewVotePhotoContentNode.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/1/13.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import AsyncDisplayKit

class XTNewVotePhotoContentNode: ASDisplayNode {
    var photosNode: ASCollectionNode!
//    var imagesCount: Int = 0
    
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
    
    struct ElementSize {
        static let photoNodeWidth: CGFloat = UIScreenAttribute.width - 28   // 屏幕宽 - 图片模块边距 * 2
        static let photoNodeHeightNone: CGFloat = 0
        static let photoNodeHeightOnce: CGFloat = (UIScreenAttribute.width - (ElementScale.photoMargin.instanceConstraint * 2)) / ElementScale.photoScale.instanceConstraint
        static let photoNodeHeightDouble: CGFloat = (ElementSize.photoNodeHeightOnce * 2) + 8
        static let photoNodeHeightTriplex: CGFloat = (ElementSize.photoNodeHeightOnce * 3) + 12
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
//        imagesCount = kRandomInRange(0, 9)

        setUI()
    }
    
    public var imagesCount = Int() {
        didSet {
            if imagesCount == 4 {
                photosNode.style.height = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightDouble + 23)
                photosNode.style.width = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightDouble - 2.2)
//                photosNode.style.alignSelf = .start
            } else {
                if imagesCount == 0 {
                    photosNode.style.height = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightNone + 13)
                } else if imagesCount < 4 && imagesCount > 0 {
                    photosNode.style.height = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightOnce + 23)
                } else if imagesCount > 3 && imagesCount < 7 {
                    photosNode.style.height = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightDouble + 23)
                } else if imagesCount <= 9 && imagesCount > 6 {
                    photosNode.style.height = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightTriplex + 23)
                }
            }
        }
    }
    
    
    private func setUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        photosNode = ASCollectionNode(collectionViewLayout: layout)
        photosNode.delegate = self
        photosNode.dataSource = self
        photosNode.backgroundColor = .white
        photosNode.style.width = ASDimensionMakeWithPoints(ElementSize.photoNodeWidth)
//        photosNode.style.height = ASDimensionMakeWithPoints(360)
        self.addSubnode(photosNode)
        
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                  spacing: 0,
                                                  justifyContent: .start,
                                                  alignItems: .start,
                                                  children: [photosNode])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, -10), child: verticalStackSpec)
    }
    
}

extension XTNewVotePhotoContentNode: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return imagesCount
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        return XTNewVotePhotoNode()
    }
}

extension XTNewVotePhotoContentNode: ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        printLog("点击了第" + "\(indexPath.row)" + "张图片")
    }
}

