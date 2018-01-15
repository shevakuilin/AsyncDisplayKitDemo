//
//  XTGlobalFormatting.swift
//  JuejinVoteForRxSwiftDemo
//
//  Created by ShevaKuilin on 2018/1/8.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import UIKit
import Foundation


public func printLog<T>(_ message: T,
                        file: String = #file,
                        method: String = #function,
                        line: Int = #line) {
    #if DEBUG
        print("FILE POSTION => [\((file as NSString).lastPathComponent) \(method):] - [Line \(line)], OUTPUT INFO => 「 \(message) 」")
    #endif
}



public func kColor(_ r: CGFloat,
                   _ g: CGFloat,
                   _ b: CGFloat,
                   _ a: CGFloat = 1.0) -> UIColor {
    let denominatorRGB: CGFloat = 255.0
    return UIColor(red: r/denominatorRGB, green: g/denominatorRGB, blue: b/denominatorRGB, alpha: a)
}



public func kFont(_ x: CGFloat,
                  _ bold: Bool = false) -> UIFont {
    return bold ? UIFont.boldSystemFont(ofSize: x):UIFont.systemFont(ofSize: x)
}



public func kAttributedStyle(_ font: UIFont,
                             _ color: UIColor = .black) -> [NSAttributedStringKey: Any] {
    return [
        NSAttributedStringKey.font: font,
        NSAttributedStringKey.foregroundColor: color
    ]
}



public func kRandomInRange(_ start: Int,
                           _ end: Int) -> Int {
    let range = Range(start...end)
    return Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound))) + range.lowerBound
}



struct UIScreenAttribute {
    static let bounds = UIScreen.main.bounds
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
}


