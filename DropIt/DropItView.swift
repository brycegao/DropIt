//
//  DropItView.swift
//  DropIt
//
//  Created by brycegao on 2016/12/31.
//  Copyright © 2016年 brycegao. All rights reserved.
//

import UIKit

class DropItView: NamedBarrierPathView, UIDynamicAnimatorDelegate {
    /*
    private let gravity = UIGravityBehavior()   //重力行为
    private let collider: UICollisionBehavior = {
        //碰撞行为
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true  //在边界内移动

        return collider
    }()
    */
    
    private var attachment: UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment!)  //optional类型使用！取值
                bezierPaths["line"] = nil
            }
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment!)
                
                attachment!.action = { [unowned self] in
                    if let attachedrop = self.attachment!.items.first as? UIView {
                        self.bezierPaths["line"] = UIBezierPath.lineFrom(from: (self.attachment?.anchorPoint)!, to: attachedrop.center)
                    }
                }
            }
        }
    }
    
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        print("dynamicAnimatorPause")
        removeCompleteRow()
    }
    
    func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
        print("dynamicAnimatorWillresume")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(ovalIn:  CGRect(center: bounds.mid, size: dropSize))
        dropBehavior.addBarrier(path: path, named: "Middle Barrier") //添加碰撞的区域
        
        bezierPaths["circle"] = path   //添加一个控件
    }
    
    func grabDrop(recognizer: UIPanGestureRecognizer) {
        let gesturePoint = recognizer.location(in: self)
        switch recognizer.state {
        case .began:  //创建附着关系
            if let dropToAttachTo = lastDrop, dropToAttachTo.superview != nil {
                attachment = UIAttachmentBehavior(item: dropToAttachTo, attachedToAnchor: gesturePoint)
            }
            lastDrop = nil
        case .changed:  //移动
            attachment?.anchorPoint = gesturePoint
        default:
            attachment = nil
            
        }
    }
    
    private let dropBehavior = FallingObjectBehavior()
    
    var animating: Bool = false {
        didSet {
            if animating {
                animator.addBehavior(dropBehavior)
            } else {
                animator.removeBehavior(dropBehavior)
            }
        }
    }
    
    private let dropPerRow = 10   //每行10个
    private var dropSize: CGSize {
        let size = bounds.size.width / CGFloat(dropPerRow)  //计算宽度
        return CGSize(width: size, height: size)  //正方形
    }
    
    private func removeCompleteRow() {
        var dropsRemove = [UIView]()  //需要删除的view，如果一行包含dropPerRow个方块则需要删除
        var hitTestRect = CGRect(origin: bounds.lowerLeft, size: dropSize)
        repeat {
            hitTestRect.origin.x = bounds.minX
            hitTestRect.origin.y -= dropSize.height
            var dropTested = 0  //一行查到的方块数量
            var dropsFound = [UIView]()
            while dropTested < dropPerRow {
                //如果判断的位置有UIView而且父UIView是自己
                if let hitView = hitTest(p: hitTestRect.mid), hitView.superview == self{
                //if let hitView = hitTest(p: hitTestRect.mid), hitView.superview == self {
                    dropsFound.append(hitView)
                } else {
                    break
                }
                
                hitTestRect.origin.x += dropSize.width
                dropTested += 1
            }
            
            if dropTested == dropPerRow {
                dropsRemove += dropsFound   //准备删掉的view
            }
        } while dropsRemove.count == 0 && hitTestRect.origin.y > bounds.minY  //遍历纵向所有行
        
        for drop in dropsRemove {
            dropBehavior.removeItem(item: drop)
            drop.removeFromSuperview()   //从父View删除
        }
    }
    
    private var lastDrop: UIView?
    

    //添加方块
    func addDrop() {
        var frame = CGRect(origin: CGPoint.zero, size: dropSize)  //绘制区域初始值
        frame.origin.x = CGFloat.random(max: dropPerRow) * dropSize.width   //方块的横坐标
        
        let drop = UIView(frame: frame)  //创建一个UIView
        drop.backgroundColor = UIColor.random
        
        addSubview(drop)
        
        dropBehavior.addItem(item: drop)
        lastDrop = drop
    }
}
