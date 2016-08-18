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
        self.mySlider?.inactiveBarImage = ibi2!
        
        let activeBarImage = UIImage(named: "activebar")
        let abi = activeBarImage?.resizableImageWithCapInsets(UIEdgeInsetsZero)
        self.mySlider?.activeBarImage = abi!
        
        self.mySlider?.leftThumbImage = UIImage(named: "leftthumb")!
        self.mySlider?.rightThumbImage = UIImage(named: "rightthumb")!
        self.mySlider?.middleThumbImage = UIImage(named: "middlethumb")!.resizableImageWithCapInsets(UIEdgeInsetsZero)
        
        stockSlider?.leftValue = 0.0
        stockSlider?.rightValue = 100.0
        
    }
    
    func tapped(recog:UIPanGestureRecognizer)
    {
        print("tapped")
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

