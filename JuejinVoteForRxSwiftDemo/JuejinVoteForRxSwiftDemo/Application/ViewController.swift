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

    override func viewDidLoad() {
        super.viewDidLoad()
        pagerNode.setDataSource(self)
        self.view.addSubnode(pagerNode)
        self.title = "沸点"
        self.view.backgroundColor = kColor(239, 242, 245)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.pagerNode.frame = CGRect(x: 0, y: 64, width: UIScreenAttribute.width, height: UIScreenAttribute.height)
    }

    // NOTE: 隐藏状态栏
//    override var prefersStatusBarHidden : Bool {
//        return true
//    }
}

extension ViewController: ASPagerDataSource {
    func pagerNode(_ pagerNode: ASPagerNode, nodeAt index: Int) -> ASCellNode {
        let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
            return XTNewVoteTimelineViewController(rowCount: self.rowCount)
        }, didLoad: nil)

        return node
    }

    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return 1
    }
}

