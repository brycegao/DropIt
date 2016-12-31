//
//  UIKitExtension.swift
//  DropIt
//
//  Created by brycegao on 2016/12/31.
//  Copyright © 2016年 brycegao. All rights reserved.
//

import UIKit

//注意：扩展在程序内有效， 跟定义的先后位置无关

extension CGFloat {
    
    /**
     *  返回范围内的随机数
     * @param max, 最大值
    */
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

extension UIColor {
    //随机得到5种颜色值之一
    class var random: UIColor {  //在类里使用class声明变量，是静态变量
        switch arc4random() % 5 {
        case 0:
            return UIColor.green
        case 1:
            return UIColor.blue
        case 2:
            return UIColor.orange
        case 3:
            return UIColor.red
        case 4:
            return UIColor.purple
        default:
            return UIColor.black
        }
    }
}

extension CGRect {
    var mid: CGPoint { return CGPoint(x: midX, y: midY) }
    var upperLeft: CGPoint { return CGPoint(x: minX, y: minY)}
    var lowerLeft: CGPoint { return CGPoint(x: minX, y: maxY)}
    var upperRight: CGPoint { return CGPoint(x: maxX, y: minY)}
    var lowerRight: CGPoint { return CGPoint(x: maxX, y: maxY) }
    
    init(center: CGPoint, size: CGSize) {
        let upperLeft = CGPoint(x: center.x-size.width/2, y: center.y-size.width/2)
        self.init(origin: upperLeft, size: size)
    }
}

extension UIView {
    //根据坐标判断对应的UIView
    func hitTest(p: CGPoint) -> UIView? {
        return hitTest(p, with: nil)
    }
}

extension UIBezierPath {
    //静态函数, 画直线
    class func lineFrom(from: CGPoint, to: CGPoint) -> UIBezierPath  {
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        return path
    }
}




