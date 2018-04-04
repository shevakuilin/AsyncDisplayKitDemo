//
//  XTNewVoteOtherTimelineViewController.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/4/2.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import AsyncDisplayKit

class XTNewVoteOtherTimelineViewController: ASViewController<ASDisplayNode> {
    
    var rowCount: Int = 0

    private var timeline = ASTableNode()
    
    public var scrollViewDidScrollDelegate = Delegated<UIScrollView, Void>()
    public var scrollViewDidEndDraggingDelegate = Delegated<UIScrollView, Void>()
    
    init(rowCount: Int, _ originY: CGFloat) {
        self.rowCount = rowCount
        super.init(node: timeline)
        timeline.delegate = self
        timeline.dataSource = self
        timeline.backgroundColor = kColor(239, 242, 245)
        timeline.view.separatorStyle = .none
        timeline.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        timeline.contentInset = UIEdgeInsetsMake(originY, 0, 0, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setTimelineLinkage(noti:)), name: kNotificationName(TOPIC_DETAILED_NEW_TIMELINE_LINKAGE), object: nil)
    }
    
    @objc private func setTimelineLinkage(noti: Notification) {
        guard let userInfo = noti.userInfo else {
            return
        }
        guard let offsetY: CGFloat = userInfo["offsetY"] as? CGFloat else {
            return
        }
        
        timeline.contentOffset = CGPoint(x: timeline.frame.origin.x, y: offsetY)
    }

}

extension XTNewVoteOtherTimelineViewController {
    func nextPageWithCompletion(_ block: @escaping (_ results: Int) -> ()) {
        DispatchQueue.main.async {
            block(self.rowCount)
        }
    }
    
    func insertNewRows(_ newRowCount: Int) {
        let section = 0
        var indexPaths = [IndexPath]()
        
        let count = self.rowCount + newRowCount
        
        for row in self.rowCount ..< count {
            let path = IndexPath(row: row, section: section)
            indexPaths.append(path)
        }
        
        self.rowCount = self.rowCount + newRowCount
        if let tableNode = node as? ASTableNode {
            tableNode.insertRows(at: indexPaths, with: .none)
        }
    }
}

extension XTNewVoteOtherTimelineViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.rowCount
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cellNode = XTNewVoteTimelineCellNode()
        cellNode.selectionStyle = .none
        return cellNode
    }
}

extension XTNewVoteOtherTimelineViewController: ASTableDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollViewDidScrollDelegate.isDelegateSet {
            scrollViewDidScrollDelegate.call(scrollView)
        }
    }
 
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollViewDidEndDraggingDelegate.isDelegateSet {
            scrollViewDidEndDraggingDelegate.call(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollViewDidEndDraggingDelegate.isDelegateSet {
            scrollViewDidEndDraggingDelegate.call(scrollView)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        //        printLog("减速动画被调用")
        if scrollViewDidEndDraggingDelegate.isDelegateSet {
            scrollViewDidEndDraggingDelegate.call(scrollView)
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        weak var weakSelf = self
        nextPageWithCompletion { (results) in
            weakSelf?.insertNewRows(results)
            context.completeBatchFetching(true)
        }
    }
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return true
    }
}

