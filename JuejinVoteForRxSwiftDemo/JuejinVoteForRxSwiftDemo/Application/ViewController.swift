//
//  ViewController.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/1/15.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import AsyncDisplayKit

class ViewController: UIViewController {
    let pagerNode = ASPagerNode()
    let rowCount: Int = 20
    var headerView: UIView!
    var topicView: UIView!
    let HEADERVIEW_OFFSET_Y: CGFloat = IS_IPHONE_X ? 50:26
    let TOPICVIEW_OFFSET_Y: CGFloat = IS_IPHONE_X ? 150:174 // topicView高度 - HEADERVIEW_OFFSET_Y

    override func viewDidLoad() {
        super.viewDidLoad()
        pagerNode.setDataSource(self)
        self.pagerNode.frame = CGRect(x: 0, y: IPHONE_NORMAL_NAV_HEIGHT, width: UIScreenAttribute.width, height: UIScreenAttribute.height)
        self.view.addSubnode(pagerNode)
        self.title = "沸点"
        self.view.backgroundColor = kColor(239, 242, 245)
        initElements()
    }
    
    
    private func initElements() {
        topicView = UIView()
        topicView.backgroundColor = .red
        topicView.frame = CGRect(x: 0, y: IPHONE_NORMAL_NAV_HEIGHT, width: UIScreenAttribute.width, height: 200)
        self.view.addSubview(topicView)
        
        let introductionLable = UILabel()
        introductionLable.text = "Topic Introduction"
        introductionLable.textColor = .white
        introductionLable.font = kFont(22)
        introductionLable.textAlignment = .center
        introductionLable.frame = kFrame(UIScreenAttribute.halfScreenWidth - 100, 0, 200, 200)
        self.topicView.addSubview(introductionLable)
        
        headerView = UIView()
        headerView.backgroundColor = .orange
        headerView.frame = CGRect(x: 0, y: topicView.frame.origin.y + topicView.frame.size.height, width: UIScreenAttribute.width, height: 38)
        self.view.addSubview(headerView)
        
        let titleLabel = UILabel()
        titleLabel.text = "title"
        titleLabel.textColor = .white
        titleLabel.font = kFont(20)
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: UIScreenAttribute.width/2 - 50, y: 0, width: 100, height: 30)
        self.headerView.addSubview(titleLabel)
    }

//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        self.pagerNode.frame = CGRect(x: 0, y: IPHONE_NORMAL_NAV_HEIGHT, width: UIScreenAttribute.width, height: UIScreenAttribute.height)
//    }

    // NOTE: 隐藏状态栏
//    override var prefersStatusBarHidden : Bool {
//        return true
//    }
}

extension ViewController: ASPagerDataSource {
    func pagerNode(_ pagerNode: ASPagerNode, nodeAt index: Int) -> ASCellNode {
        if index == 0 {
            let node = ASCellNode(viewControllerBlock: { [weak self]() -> UIViewController in
                guard let strongSelf = self else {
                    return UIViewController()
                }
                let timelineVC = XTNewVoteTimelineViewController(rowCount: strongSelf.rowCount, strongSelf.topicView.frame.size.height + 38)
                timelineVC.scrollViewDidScrollDelegate.delegate(to: strongSelf, with: { (strongSelf, scrollView) in
                    let offsetY = scrollView.contentOffset.y
                    printLog("监听timeline开始滚动, \(offsetY)")
                    if offsetY >= -38 {
                        strongSelf.headerView.frame = kFrame(0, IPHONE_NORMAL_NAV_HEIGHT, UIScreenAttribute.width, 38)
                        strongSelf.topicView.frame = kFrame(0, -(strongSelf.topicView.frame.size.height - IPHONE_NORMAL_NAV_HEIGHT), UIScreenAttribute.width, 200)
                    } else {
                        strongSelf.headerView.frame = kFrame(0, -offsetY + strongSelf.HEADERVIEW_OFFSET_Y, UIScreenAttribute.width, 38)
                        strongSelf.topicView.frame = kFrame(0, -offsetY - strongSelf.TOPICVIEW_OFFSET_Y, UIScreenAttribute.width, 200)
                    }
                })
                timelineVC.scrollViewDidEndDraggingDelegate.delegate(to: strongSelf, with: { (strongSelf, scrollView) in
                    let offsetY = scrollView.contentOffset.y
                    printLog("监听timeline已经停止拖拽, \(offsetY)")
                    if offsetY >= 38 {
                        let tempFloat: CGFloat = IPHONE_NORMAL_NAV_HEIGHT + 38
                        NotificationCenter.default.post(name: kNotificationName(TOPIC_DETAILED_NEW_TIMELINE_LINKAGE), object: nil, userInfo: ["offsetY": tempFloat])
                    } else {
                        let tempFloat: CGFloat = offsetY
                        NotificationCenter.default.post(name: kNotificationName(TOPIC_DETAILED_NEW_TIMELINE_LINKAGE), object: nil, userInfo: ["offsetY": tempFloat])
                    }
                })
                return timelineVC
                }, didLoad: nil)
            
            return node
        } else {
            let node = ASCellNode(viewControllerBlock: { [weak self]() -> UIViewController in
                guard let strongSelf = self else {
                    return UIViewController()
                }
                let timelineVC = XTNewVoteOtherTimelineViewController(rowCount: strongSelf.rowCount, strongSelf.topicView.frame.size.height + 38)
                timelineVC.scrollViewDidScrollDelegate.delegate(to: strongSelf, with: { (strongSelf, scrollView) in
                    let offsetY = scrollView.contentOffset.y
                    printLog("监听timeline开始滚动, \(offsetY)")
                    if offsetY >= -38 {
                        strongSelf.headerView.frame = kFrame(0, IPHONE_NORMAL_NAV_HEIGHT, UIScreenAttribute.width, 38)
                        strongSelf.topicView.frame = kFrame(0, -(strongSelf.topicView.frame.size.height - IPHONE_NORMAL_NAV_HEIGHT), UIScreenAttribute.width, 200)
                    } else {
                        strongSelf.headerView.frame = kFrame(0, -offsetY + strongSelf.HEADERVIEW_OFFSET_Y, UIScreenAttribute.width, 38)
                        strongSelf.topicView.frame = kFrame(0, -offsetY - strongSelf.TOPICVIEW_OFFSET_Y, UIScreenAttribute.width, 200)
                    }
                })
                timelineVC.scrollViewDidEndDraggingDelegate.delegate(to: strongSelf, with: { (strongSelf, scrollView) in
                    let offsetY = scrollView.contentOffset.y
                    printLog("监听timeline已经停止拖拽, \(offsetY)")
                    if offsetY >= -38 {
                        let tempFloat: CGFloat = IPHONE_NORMAL_NAV_HEIGHT + 38
                        NotificationCenter.default.post(name: kNotificationName(TOPIC_DETAILED_HOT_TIMELINE_LINKAGE), object: nil, userInfo: ["offsetY": tempFloat])
                    } else {
                        let tempFloat: CGFloat = offsetY
                        NotificationCenter.default.post(name: kNotificationName(TOPIC_DETAILED_HOT_TIMELINE_LINKAGE), object: nil, userInfo: ["offsetY": tempFloat])
                    }
                })
                return timelineVC
                }, didLoad: nil)
            
            return node
        }
    }

    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return 2
    }
}

//extension ViewController: XTNewVoteTimelineDelegate {
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        printLog("监听timeline已经停止拖拽, \(offsetY)")
//        if offsetY >= 25 {
//            NotificationCenter.default.post(name: kNotificationName(TOPIC_DETAILED_TIMELINE_LINKAGE), object: nil, userInfo: ["offsetY": IPHONE_NORMAL_NAV_HEIGHT + 38])
//        } else {
//            NotificationCenter.default.post(name: kNotificationName(TOPIC_DETAILED_TIMELINE_LINKAGE), object: nil, userInfo: ["offsetY": offsetY])
//        }
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        printLog("监听timeline开始滚动, \(offsetY)")
//            if offsetY >= -25 {
//                headerView.frame = CGRect(x: 0, y: IPHONE_NORMAL_NAV_HEIGHT, width: UIScreenAttribute.width, height: 38)
//            } else {
//                headerView.frame = CGRect(x: 0, y: -offsetY + 38, width: UIScreenAttribute.width, height: 38)
//            }
//    }
//
//    func toNextVC() {
//        let vc = XTOtherViewController()
//        self.show(vc, sender: self)
//    }
//}

