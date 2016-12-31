//
//  DropItViewController.swift
//  DropIt
//
//  Created by brycegao on 2016/12/31.
//  Copyright © 2016年 brycegao. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController {

    @IBOutlet weak var gameView: DropItView! {
        didSet {
            gameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addDrop(recognizer:))))
            gameView.addGestureRecognizer(UIPanGestureRecognizer(target: gameView, action: #selector(DropItView.grabDrop(recognizer:))))
        }
    }
  

    //
    func addDrop(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            gameView.addDrop()
        }
    }
    
    //界面已经显示
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        gameView.animating = true
    }
    
    //界面即将关闭
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        gameView.animating = false
    }
}
