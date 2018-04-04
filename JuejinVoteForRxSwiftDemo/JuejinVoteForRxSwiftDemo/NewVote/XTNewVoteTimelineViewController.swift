//
//  XTNewVoteTimelineViewController.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/1/8.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import MJRefresh
import AsyncDisplayKit

class XTNewVoteTimelineViewController: ASViewController<ASDisplayNode>  {
    
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
        self.title = "沸点"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefresh()
        registerNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        printLog("页面通知已全部清除!!")
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setTimelineLinkage(noti:)), name: kNotificationName(TOPIC_DETAILED_HOT_TIMELINE_LINKAGE), object: nil)
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
    
    // NOTE: 设置刷新加载
    private func setRefresh() {
//        timeline.view.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
//            wself.timeline.view.mj_header.beginRefreshing()
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//                wself.timeline.view.mj_header.endRefreshing()
//                wself.timeline.reloadData()
//            }
//        })
        
        timeline.view.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock:{ [weak self] () in
            guard let strongSelf = self else {
                return
            }
            strongSelf.timeline.view.mj_footer.beginRefreshing()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                strongSelf.timeline.view.mj_footer.endRefreshing()
                strongSelf.timeline.reloadData()
            })
        })
    }
}

extension XTNewVoteTimelineViewController {
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

extension XTNewVoteTimelineViewController: ASTableDataSource {
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
    
//    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
//        let cellNodeBlock = { () -> ASCellNode in
//            let cellNode = XTNewVoteTimelineCellNode()
//            cellNode.selectionStyle = .none
//            return cellNode
//        }
//        return cellNodeBlock
//    }
}

extension XTNewVoteTimelineViewController: ASTableDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        delegate?.scrollViewDidScroll(scrollView)
        if scrollViewDidScrollDelegate.isDelegateSet {
            scrollViewDidScrollDelegate.call(scrollView)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        delegate?.scrollViewDidEndDragging(scrollView)
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
    
    
//    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
//        delegate?.toNextVC()
//    }
    
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
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 38
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = .orange
//        return view
//    }
}
