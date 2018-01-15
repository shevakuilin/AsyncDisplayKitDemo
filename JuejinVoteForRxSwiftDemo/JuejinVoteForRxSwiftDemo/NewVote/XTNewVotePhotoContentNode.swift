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
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        setUI()
    }
    
    struct ElementSize {
        static let photoNodeWidth: CGFloat = UIScreenAttribute.width - 28   // 屏幕宽 - 图片模块边距 * 2
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
        photosNode.style.height = ASDimensionMakeWithPoints(360)
        self.addSubnode(photosNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                  spacing: 0,
                                                  justifyContent: .start,
                                                  alignItems: .start,
                                                  children: [photosNode])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 0, 10, 0), child: verticalStackSpec)
    }
    
}

extension XTNewVotePhotoContentNode: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        return XTNewVotePhotoNode()
    }
}

extension XTNewVotePhotoContentNode: ASCollectionDelegate {
    
}

