//
//  ViewController.swift
//  UIXRangeSlider
//
//  Created by Guy Umbright on 2/12/15.
//  Copyright (c) 2015 Umbright Consulting, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var mySlider:UIXRangeSlider?
    @IBOutlet var stockSlider:UIXRangeSlider?
    
    @IBOutlet var recogView:UIView?
    @IBOutlet var leftValue:UILabel?
    @IBOutlet var rightValue:UILabel?
    
    var recog:UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let inactiveBarImage = UIImage(named: "inactivebar")
        let ibi2 = inactiveBarImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 5, 0, 5))
        self.mySlider?.setInactiveBarImage(ibi2!)
        
        let activeBarImage = UIImage(named: "activebar")
        let abi = activeBarImage?.resizableImageWithCapInsets(UIEdgeInsetsZero)
        self.mySlider?.setActiveBarImage(abi!)
        
        self.mySlider?.setLeftThumbImage(UIImage(named: "leftthumb")!)
        self.mySlider?.setRightThumbImage(UIImage(named: "rightthumb")!)
        self.mySlider?.setMiddleThumbImage(UIImage(named: "middlethumb")!.resizableImageWithCapInsets(UIEdgeInsetsZero))
        
        self.recog = UIPanGestureRecognizer(target: self, action: "tapped:")
        recogView?.addGestureRecognizer(self.recog!)
    }
    
    func tapped(recog:UIPanGestureRecognizer)
    {
        println("tapped")
        recogView?.removeGestureRecognizer(self.recog!)
        recogView?.addGestureRecognizer(self.recog!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderChanged(slider:UIXRangeSlider)
    {
        self.leftValue?.text = "\(slider.leftValue)"
        self.rightValue?.text = "\(slider.rightValue)"
    }
}

