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
        static let userInfoHeight: CGFloat = 60
        static let userInfoWidth: CGFloat = UIScreenAttribute.width
        static let textContetWidth: CGFloat = UIScreenAttribute.width - 28  // 屏幕宽 - 文本内容两边距 [14 * 2]
        static let photoContenWidth: CGFloat = UIScreenAttribute.width - 28
        static let bottomWidth: CGFloat = UIScreenAttribute.width
        static let bottomHeight: CGFloat = 38
        static let bottomLineHeight: CGFloat = 1
        static let topSeparateWidth: CGFloat = UIScreenAttribute.width
        static let topSeparateHeight: CGFloat = 9
        
        static let photoNodeHeightNone: CGFloat = 0
        static let photoNodeHeightOnce: CGFloat = (UIScreenAttribute.width - (ElementScale.photoMargin.instanceConstraint * 2)) / ElementScale.photoScale.instanceConstraint
        static let photoNodeHeightDouble: CGFloat = (ElementSize.photoNodeHeightOnce * 2) + 8
        static let photoNodeHeightTriplex: CGFloat = (ElementSize.photoNodeHeightOnce * 3) + 12
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
        let strArr = ["https://www.bilibili.com 研究人员开发的工具 BootStomp 能识别出两个 bootloader 的漏洞，😆😆攻击者可以在 root 权限下利用这两个漏洞解锁设备并打破信任链 ... 研究人员在华为 P8 的 Android bootloader 中发现了 5 个重要的漏洞，https://www.bilibili.com 分别是任意内存写和分析保存在 boot 分区的 Linux。 https://www.bilibili.com  Http://     Https", "苹果副总裁：Siri 并不是一个简单的游戏，苹果公司 Siri 办公环境曝光", "2017年9月1号礼拜五，西雅图bellevue 警方宣布西雅图历史上最大规模，为期一周的名为“Operation On Demand”中文译名《抓住欲望之狼》的钓鱼行动圆满结束。https://www.bilibili.com 超过一百一十名的嫖客在这次行动中被抓。", "能耐心看完的人不会参与到无谓的争执循环里去，历史长河里，人类的结构也一向如此。时代只让科技进步，文明都是从零开始。 ​", "前几日刷屏号称强过谷歌翻译的DeepL，经实测的结果是......"]
        let contentStr = strArr[kRandomInRange(0, strArr.count - 1)]
        showAttributedStringLink(contentStr)
        self.addSubnode(textContentNode)
        
        photoContenNode.style.width = ASDimensionMakeWithPoints(ElementSize.photoContenWidth)
        photoContenNode.imagesCount = kRandomInRange(0, 9)
        if photoContenNode.imagesCount == 0 {
            photoContenNode.style.height = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightNone + 13)
        } else if photoContenNode.imagesCount < 4 && photoContenNode.imagesCount > 0 {
            photoContenNode.style.height = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightOnce + 23)
        } else if photoContenNode.imagesCount > 3 && photoContenNode.imagesCount < 7 {
            photoContenNode.style.height = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightDouble + 23)
        } else if photoContenNode.imagesCount <= 9 && photoContenNode.imagesCount > 6 {
            photoContenNode.style.height = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightTriplex + 23)
        }
//        photoContenNode.style.height = ASDimensionMakeWithPoints(360)
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
    
    private func randomInRange(range: Range<Int>) -> Int {
        let count = UInt32(range.upperBound - range.lowerBound)
        return Int(arc4random_uniform(count)) + range.lowerBound
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

