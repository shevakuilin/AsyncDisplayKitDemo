//
//  XTNewVoteTimelineCellNode.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/1/12.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import YYText
import YYImage
import AsyncDisplayKit

class XTNewVoteTimelineCellNode: ASCellNode {
    let userInfoNode = XTNewVoteUserInfoView()          // 用户信息
    let textContentNode = XTNewVoteTextContentNode()    // 文本内容
    let photoContenNode = XTNewVotePhotoContentNode()   // 图片内容
    let bottomNode = XTNewVoteBottomNode()              // 底部交互部分
    let bottomLintNode = ASImageNode()                  // 底部分割线
    let topSeparateNode = ASImageNode()                 // 顶部分隔区域
    
    struct ElementSize {
        static let userInfoHeight: CGFloat = 60
        static let userInfoWidth: CGFloat = UIScreenAttribute.width
        static let textContetWidth: CGFloat = UIScreenAttribute.width - 28  // 屏幕宽 - 文本内容两边距 [14 * 2]
        static let photoContenWidth: CGFloat = UIScreenAttribute.width - 28
        static let bottomWidth: CGFloat = UIScreenAttribute.width
        static let bottomHeight: CGFloat = 38
        static let bottomLineHeight: CGFloat = 1
        static let topSeparateWidth: CGFloat = UIScreenAttribute.width
        static let topSeparateHeight: CGFloat = 9
    }
    
    struct ElementSpacing {
        static let textContentSpacing: CGFloat = 14
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .white
        setUI()
    }
    
    override func didLoad() {
        super.didLoad()
        textContentNode.isUserInteractionEnabled = true
        bottomNode.isUserInteractionEnabled = true
    }
    
    private func setUI() {
        userInfoNode.style.height = ASDimensionMakeWithPoints(ElementSize.userInfoHeight)
        userInfoNode.style.width = ASDimensionMakeWithPoints(ElementSize.userInfoWidth)
        self.addSubnode(userInfoNode)
        
        textContentNode.style.width = ASDimensionMakeWithPoints(ElementSize.textContetWidth)
        let contentStr = "https://www.bilibili.com 研究人员开发的工具 BootStomp 能识别出两个 bootloader 的漏洞，😆😆攻击者可以在 root 权限下利用这两个漏洞解锁设备并打破信任链 ... 研究人员在华为 P8 的 Android bootloader 中发现了 5 个重要的漏洞，https://www.bilibili.com 分别是任意内存写和分析保存在 boot 分区的 Linux。 https://www.bilibili.com  Http://     Https"
        showAttributedStringLink(contentStr)
        self.addSubnode(textContentNode)
        
        photoContenNode.style.width = ASDimensionMakeWithPoints(ElementSize.photoContenWidth)
        photoContenNode.style.height = ASDimensionMakeWithPoints(360)
        self.addSubnode(photoContenNode)
        
        bottomNode.style.width = ASDimensionMakeWithPoints(ElementSize.bottomWidth)
        bottomNode.style.height = ASDimensionMakeWithPoints(ElementSize.bottomHeight)
        self.addSubnode(bottomNode)
        
        bottomLintNode.style.width = ASDimensionMakeWithPoints(ElementSize.bottomWidth)
        bottomLintNode.style.height = ASDimensionMakeWithPoints(ElementSize.bottomLineHeight)
        bottomLintNode.backgroundColor = kColor(186, 186, 186, 0.5)
        self.addSubnode(bottomLintNode)
        
        topSeparateNode.style.width = ASDimensionMakeWithPoints(ElementSize.topSeparateWidth)
        topSeparateNode.style.height = ASDimensionMakeWithPoints(ElementSize.topSeparateHeight)
        topSeparateNode.backgroundColor = kColor(239, 242, 245)
        self.addSubnode(topSeparateNode)
    }
    
    // MARK: 富文本超链接
    private func showAttributedStringLink(_ string: String) {
        let attributedStr:NSMutableAttributedString = NSMutableAttributedString.init(string: string)
        if string.contains("http") || string.contains("https") {
            // URL检测
            let types: UInt64 = NSTextCheckingResult.CheckingType.link.rawValue
            // 创建 NSDataDetector
            guard let detector: NSDataDetector = try? NSDataDetector(types: types) else { return }
            // 创建 NSTextCheckingResult 数组
            let matches: [NSTextCheckingResult] = detector.matches(in: attributedStr.string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: attributedStr.length))
            guard matches.count > 0 else {// 如果包含http或https，但是未检测到合法链接，仍然走非链接文本的逻辑
                attributedStr.yy_lineSpacing = 5;
                attributedStr.yy_font = kFont(15)
                textContentNode.richText = attributedStr
                return
            }
            // 遍历数组中的URL，并设置文本高亮与点击事件
            var curtailLength:Int = 0 // 替换URL为固定字符后的缩减长度
            var oldLenght:Int = 0 // URL替换前的文本长度
            var curtailLocation:Int = 0
            for i in 0..<matches.count {
                let match = matches[i]
                
                if match.resultType == .link, let url = match.url {
                    oldLenght = attributedStr.length// 获取替换前的文本长度
                    // URL高亮
                    let linkIcon:YYAnimatedImageView = YYAnimatedImageView(image:R.image.link())
                    linkIcon.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
                    let attributedIcom:NSMutableAttributedString = NSMutableAttributedString.yy_attachmentString(withContent: linkIcon, contentMode: .scaleAspectFit, attachmentSize: linkIcon.frame.size, alignTo: kFont(15), alignment: .center)
                    let linkStr:String = "网页链接"
                    curtailLocation = match.range.location + i - (i > 0 ? curtailLength : 0)
                    attributedStr.replaceCharacters(in: NSMakeRange(curtailLocation, match.range.length), with: linkStr)
                    curtailLength = (oldLenght - attributedStr.length) + curtailLength// 替换前的长度 - 替换后的长度 = 缩减长度
                    attributedStr.addAttributes([NSAttributedStringKey.link : url,
                                                 NSAttributedStringKey.foregroundColor : kColor(0, 118, 255),
                                                 NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleNone.rawValue],
                                                range: NSMakeRange(curtailLocation, linkStr.count))
                    
                    attributedStr.insert(attributedIcom, at: curtailLocation)
                    let highlightRange = NSMakeRange(curtailLocation, linkStr.count)
                    let highlight = YYTextHighlight(backgroundColor: nil)
                    highlight.setColor(kColor(0, 118, 255))
                    
//                    weak var weakSelf = self
//                    guard let wSelf = weakSelf else {
//                        return
//                    }
                    highlight.tapAction = {
                        _, _, _, _ in
                        printLog("tapped this link !!")
                        let host:String = url.host ?? ""
                        if host == "juejin.im" || host == "gold.xitu.io" {
                            // 应用内点击掘金链接跳转
//                            XTApplicationHandle.clickLinkJumpInApplication(with: url, parentView: self)
                        } else {
//                            if let pushUrlVc = R.storyboard.main.pushUrl() {
//                                pushUrlVc.urlStr = "\(url)"
//                                pushUrlVc.isPush = true
//                                pushUrlVc.hidesBottomBarWhenPushed = true
//                                wSelf.getCurrentViewController().show(pushUrlVc, sender: nil)
//                            }
                        }
                    }
                    attributedStr.yy_setTextHighlight(highlight, range: highlightRange)
                    attributedStr.yy_lineSpacing = 5;
                    attributedStr.yy_font = kFont(15)
                    textContentNode.richText = attributedStr
                }
            }
        } else {
            attributedStr.yy_lineSpacing = 5;
            attributedStr.yy_font = kFont(15)
            textContentNode.richText = attributedStr
        }
    }

    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                  spacing: 0,
                                                  justifyContent: .start,
                                                  alignItems: .center,
                                                  children: [topSeparateNode, userInfoNode, textContentNode, photoContenNode, bottomLintNode, bottomNode])
  
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 0, 0, 0), child: verticalStackSpec)
    }
}

