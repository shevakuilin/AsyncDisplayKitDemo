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
    var extentButton: UIButton!
    
    let HEADERVIEW_OFFSET_Y: CGFloat = IS_IPHONE_X ? 50:26
    let TOPICVIEW_OFFSET_Y: CGFloat = IS_IPHONE_X ? 150:174 // topicView高度 - HEADERVIEW_OFFSET_Y
    var TOPICVIEW_HEIGHT: CGFloat = 200
    let HEADERVIEW_HEIGHT: CGFloat = 38

    override func viewDidLoad() {
        super.viewDidLoad()
        initConfig()
        initNode()
        initElements()
    }
    
    private func initConfig() {
        self.title = "沸点"
        self.view.backgroundColor = kColor(239, 242, 245)
    }
    
    private func initNode() {
        pagerNode.setDataSource(self)
        pagerNode.frame = kFrame(0, IPHONE_NORMAL_NAV_HEIGHT, UIScreenAttribute.width, UIScreenAttribute.height)
        self.view.addSubnode(pagerNode)
    }
    
    private func initElements() {
        topicView = UIView()
        topicView.backgroundColor = .red
        topicView.frame = kFrame(0, IPHONE_NORMAL_NAV_HEIGHT, UIScreenAttribute.width, TOPICVIEW_HEIGHT)
        self.view.addSubview(topicView)
        
        let introductionLable = UILabel()
        introductionLable.text = "Topic Introduction"
        introductionLable.textColor = .white
        introductionLable.font = kFont(22)
        introductionLable.textAlignment = .center
        introductionLable.frame = kFrame(UIScreenAttribute.halfScreenWidth - 100, 0, TOPICVIEW_HEIGHT, TOPICVIEW_HEIGHT)
        self.topicView.addSubview(introductionLable)
        
        headerView = UIView()
        headerView.backgroundColor = .orange
        headerView.frame = kFrame(0, topicView.frame.origin.y + topicView.frame.size.height, UIScreenAttribute.width, HEADERVIEW_HEIGHT)
        self.view.addSubview(headerView)
        
        let titleLabel = UILabel()
        titleLabel.text = "title"
        titleLabel.textColor = .white
        titleLabel.font = kFont(20)
        titleLabel.textAlignment = .center
        titleLabel.frame = kFrame(UIScreenAttribute.halfScreenWidth - 50, 0, 100, 30)
        self.headerView.addSubview(titleLabel)
        
        extentButton = UIButton()
        extentButton.setTitle("展开", for: .normal)
        extentButton.setTitle("收起", for: .selected)
        extentButton.setTitleColor(.black, for: .normal)
        extentButton.setTitleColor(.black, for: .selected)
        extentButton.titleLabel?.font = kFont(20)
        extentButton.frame = kFrame(UIScreenAttribute.halfScreenWidth - 100, 150, 200, 50)
        extentButton.isSelected = false
        extentButton.addTarget(self, action: #selector(clickExtentBtn), for: .touchUpInside)
        self.topicView.addSubview(extentButton)
    }

    
    @objc private func clickExtentBtn() {
        if extentButton.isSelected {
            TOPICVIEW_HEIGHT = 200
        } else {
            TOPICVIEW_HEIGHT = 300
        }
        topicView.frame = kFrame(0, IPHONE_NORMAL_NAV_HEIGHT, UIScreenAttribute.width, TOPICVIEW_HEIGHT)
        headerView.frame = kFrame(0, topicView.frame.origin.y + topicView.frame.size.height, UIScreenAttribute.width, HEADERVIEW_HEIGHT)
        extentButton.isSelected = !extentButton.isSelected
        pagerNode.reloadData()
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
                let timelineVC = XTNewVoteTimelineViewController(rowCount: strongSelf.rowCount, strongSelf.topicView.frame.size.height + strongSelf.HEADERVIEW_HEIGHT)
                
                timelineVC.scrollViewDidScrollDelegate.delegate(to: strongSelf, with: { (strongSelf, scrollView) in
                    var offsetY = scrollView.contentOffset.y
                    printLog("监听timeline开始滚动, \(offsetY)")
                    if offsetY >= -strongSelf.HEADERVIEW_HEIGHT {
                        strongSelf.headerView.frame = kFrame(0, IPHONE_NORMAL_NAV_HEIGHT, UIScreenAttribute.width, strongSelf.HEADERVIEW_HEIGHT)
                        strongSelf.topicView.frame = kFrame(0, -(strongSelf.topicView.frame.size.height - IPHONE_NORMAL_NAV_HEIGHT), UIScreenAttribute.width, strongSelf.TOPICVIEW_HEIGHT)
                    } else {
                        strongSelf.headerView.frame = kFrame(0, -offsetY + strongSelf.HEADERVIEW_OFFSET_Y, UIScreenAttribute.width, strongSelf.HEADERVIEW_HEIGHT)
                        if strongSelf.extentButton.isSelected {
                            offsetY = -offsetY - strongSelf.TOPICVIEW_OFFSET_Y - 100
                        } else {
                            offsetY = -offsetY - strongSelf.TOPICVIEW_OFFSET_Y
                        }
                        strongSelf.topicView.frame = kFrame(0, offsetY, UIScreenAttribute.width, strongSelf.TOPICVIEW_HEIGHT)
                    }
                })
                
                timelineVC.scrollViewDidEndDraggingDelegate.delegate(to: strongSelf, with: { (strongSelf, scrollView) in
                    let offsetY = scrollView.contentOffset.y
                    printLog("监听timeline已经停止拖拽, \(offsetY)")
                    // NOTE: 通知最新timeline同步联动
                    if offsetY >= strongSelf.HEADERVIEW_HEIGHT {
                        let tempFloat: CGFloat = IPHONE_NORMAL_NAV_HEIGHT + strongSelf.HEADERVIEW_HEIGHT
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
                let timelineVC = XTNewVoteOtherTimelineViewController(rowCount: strongSelf.rowCount, strongSelf.topicView.frame.size.height + strongSelf.HEADERVIEW_HEIGHT)
                
                timelineVC.scrollViewDidScrollDelegate.delegate(to: strongSelf, with: { (strongSelf, scrollView) in
                    var offsetY = scrollView.contentOffset.y
                    printLog("监听timeline开始滚动, \(offsetY)")
                    // NOTE: 通知最热timeline同步联动
                    if offsetY >= -strongSelf.HEADERVIEW_HEIGHT {
                        strongSelf.headerView.frame = kFrame(0, IPHONE_NORMAL_NAV_HEIGHT, UIScreenAttribute.width, strongSelf.HEADERVIEW_HEIGHT)
                        strongSelf.topicView.frame = kFrame(0, -(strongSelf.topicView.frame.size.height - IPHONE_NORMAL_NAV_HEIGHT), UIScreenAttribute.width, strongSelf.TOPICVIEW_HEIGHT)
                    } else {
                        strongSelf.headerView.frame = kFrame(0, -offsetY + strongSelf.HEADERVIEW_OFFSET_Y, UIScreenAttribute.width, strongSelf.HEADERVIEW_HEIGHT)
                        if strongSelf.extentButton.isSelected {
                            offsetY = -offsetY - strongSelf.TOPICVIEW_OFFSET_Y - 100
                        } else {
                            offsetY = -offsetY - strongSelf.TOPICVIEW_OFFSET_Y
                        }
                        strongSelf.topicView.frame = kFrame(0, offsetY, UIScreenAttribute.width, strongSelf.TOPICVIEW_HEIGHT)
                    }
                })
                
                timelineVC.scrollViewDidEndDraggingDelegate.delegate(to: strongSelf, with: { (strongSelf, scrollView) in
                    let offsetY = scrollView.contentOffset.y
                    printLog("监听timeline已经停止拖拽, \(offsetY)")
                    if offsetY >= -strongSelf.HEADERVIEW_HEIGHT {
                        let tempFloat: CGFloat = IPHONE_NORMAL_NAV_HEIGHT + strongSelf.HEADERVIEW_HEIGHT
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


