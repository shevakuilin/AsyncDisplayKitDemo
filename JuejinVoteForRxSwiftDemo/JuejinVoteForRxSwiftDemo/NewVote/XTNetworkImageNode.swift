//
//  XTNetworkImageNode.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/1/15.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import PINCache
import AsyncDisplayKit

class XTNetworkImageNode: ASDisplayNode {
    private var networkImageNode = ASNetworkImageNode()
    private var imageNode = ASImageNode()
    
    var placeholderColor: UIColor? {
        didSet {
            networkImageNode.placeholderColor = placeholderColor
        }
    }
    
    var image: UIImage? {
        didSet {
            networkImageNode.image = image
        }
    }
    
    override var placeholderFadeDuration: TimeInterval {
        didSet {
            networkImageNode.placeholderFadeDuration = placeholderFadeDuration
        }
    }
    
    override var cornerRadius: CGFloat {
        didSet {
            networkImageNode.cornerRadius = cornerRadius
            imageNode.cornerRadius = cornerRadius
        }
    }
    
    var url: URL? {
        didSet {
            guard let u = url,
                
                let image = PINCache.shared.object(forKey: u.absoluteString) else {
                    networkImageNode.url = url
                    return
            }
            
            imageNode.image = image as? UIImage
        }
    }
    
    override init() {
        super.init()
        addSubnode(networkImageNode)
        addSubnode(imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero,
                                 child: networkImageNode.url == nil ? imageNode : networkImageNode)
    }
    
    func addTarget(_ target: Any?, action: Selector, forControlEvents controlEvents: ASControlNodeEvent) {
        networkImageNode.addTarget(target, action: action, forControlEvents: controlEvents)
        imageNode.addTarget(target, action: action, forControlEvents: controlEvents)
    }
}
