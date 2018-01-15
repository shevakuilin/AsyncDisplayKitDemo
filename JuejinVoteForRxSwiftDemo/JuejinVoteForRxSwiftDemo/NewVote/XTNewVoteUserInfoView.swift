//
//  XTNewVoteUserInfoView.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/1/11.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import AsyncDisplayKit

class XTNewVoteUserInfoView: ASDisplayNode {
    let avatarImage = ASNetworkImageNode()      // 用户头像
    let userNameNode =  ASTextNode()            // 用户名
    let userIntroNode = ASTextNode()            // 用户简介 [职位 @公司 ·时间]
    let followButton = ASButtonNode()           // 关注按钮
    
    struct ElementSize {
        static let avatarHeight: CGFloat = 38
        static let avatarWidth: CGFloat = 38
        static let followHeight: CGFloat = 25
        static let followWidth: CGFloat = 51
        static let userNameWidth: CGFloat = UIScreenAttribute.width - 128   // 屏幕宽 - 用户名两边距[58 + 70]
        static let userIntroWidth: CGFloat = UIScreenAttribute.width - 128
    }
    
    struct ElementRadius {
        static let avatarRadius: CGFloat = 19
    }
    
    struct ElementSpacing {
        static let avatarSpacing: CGFloat = 14
        static let userIntroSpacing: CGFloat = 5
        static let followSpacing: CGFloat = 14
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        setUI()
    }
    
    override func didLoad() {
        super.didLoad()
        avatarImage.isUserInteractionEnabled = true
        avatarImage.addTarget(self, action: #selector(clickAvatarImage), forControlEvents: .touchUpInside)
        
        userNameNode.isUserInteractionEnabled = true
        userNameNode.addTarget(self, action: #selector(clickUserName), forControlEvents: .touchUpInside)
        
        followButton.addTarget(self, action: #selector(clickFollowBtn), forControlEvents: .touchUpInside)
    }
    
    private func setUI() {
        avatarImage.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        avatarImage.style.width = ASDimensionMakeWithPoints(ElementSize.avatarWidth)
        avatarImage.style.height = ASDimensionMakeWithPoints(ElementSize.avatarHeight)
        avatarImage.cornerRadius = ElementRadius.avatarRadius
        avatarImage.url = URL(string: "https://avatars0.githubusercontent.com/u/724423?v=3&s=96")
        self.addSubnode(avatarImage)
        
        userNameNode.style.width = ASDimensionMakeWithPoints(ElementSize.userNameWidth)
        userNameNode.attributedText = NSAttributedString(string: "Andry Shevchenko", attributes: kAttributedStyle(kFont(15, true), kColor(39, 91, 140)))
        self.addSubnode(userNameNode)
        
        userIntroNode.style.width = ASDimensionMakeWithPoints(ElementSize.userIntroWidth)
        userIntroNode.attributedText = NSAttributedString(string: "Ruby工程师 @网易 · 13小时前", attributes: kAttributedStyle(kFont(12), kColor(138, 154, 169)))
        self.addSubnode(userIntroNode)
        
        followButton.setImage(R.image.follow(), for: .normal)
        followButton.setImage(R.image.follow_sel(), for: .selected)
        followButton.style.height = ASDimensionMakeWithPoints(ElementSize.followHeight)
        followButton.style.width = ASDimensionMakeWithPoints(ElementSize.followWidth)
        self.addSubnode(followButton)
    }
    
    @objc private func clickAvatarImage() {
        printLog("点击用户头像 !!")
    }
    
    @objc private func clickUserName() {
        printLog("点击用户名称 !!")
    }
    
    @objc private func clickFollowBtn() {
        followButton.isSelected = followButton.isSelected ? false:true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // NOTE: 布局思路：[水平]用户头像 + [垂直]用户名 & 用户简介 + [水平]关注按钮 + [水平]点赞/回复
        // NOTE: 左侧水平方向布局
        let leftHorizontalStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                    spacing: ElementSpacing.avatarSpacing,
                                                    justifyContent: .start,
                                                    alignItems: .start,
                                                    children: [avatarImage])
        // NOTE: 垂直方向布局
        let verticalStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                  spacing: ElementSpacing.userIntroSpacing,
                                                  justifyContent: .start,
                                                  alignItems: .start,
                                                  children: [userNameNode, userIntroNode])
        // NOTE: 右侧水平方向布局
        let rightHorizontalStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                         spacing: ElementSpacing.followSpacing,
                                                         justifyContent: .end,
                                                         alignItems: .end,
                                                         children: [followButton])
        // NOTO: 组合布局
        let stackSpec = ASStackLayoutSpec(direction: .horizontal,
                                          spacing: 10,
                                          justifyContent: .start,
                                          alignItems: .center,
                                          children: [leftHorizontalStackSpec,
                                                     verticalStackSpec,
                                                     rightHorizontalStackSpec])

        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: stackSpec)
    }
}
