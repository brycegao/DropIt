//
//  NamedBarrierPathView.swift
//  DropIt
//
//  Created by brycegao on 2016/12/31.
//  Copyright © 2016年 brycegao. All rights reserved.
//

import UIKit

class NamedBarrierPathView: UIView {

    var bezierPaths = [String:UIBezierPath]() {
        didSet {
            setNeedsDisplay()  //触发刷新
        }
    }

    override func draw(_ rect: CGRect) {
        for (_, path) in bezierPaths {
            path.stroke()  //画线
        }
    }
}
