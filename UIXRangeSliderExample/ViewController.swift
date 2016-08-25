//
//  ViewController.swift
//  UIXRangeSlider
//
//  Created by Guy Umbright on 2/12/15.
//  Copyright (c) 2015 Umbright Consulting, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var stockSlider:UIXRangeSlider?
    @IBOutlet var slider2:UIXRangeSlider?
    
    @IBOutlet var recogView:UIView?
    @IBOutlet var leftValue:UILabel?
    @IBOutlet var rightValue:UILabel?
    
    var toggled : Bool = false
    var recog:UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        stockSlider?.leftValue = 0.0
        stockSlider?.rightValue = 100.0
        
        var image = UIImage(named: "roundedLeftThumb")!.imageWithRenderingMode(.AlwaysTemplate)
        self.slider2?.setImage(image, forElement: .LeftThumb, forControlState: .Normal)
        self.slider2?.setTint(UIColor.redColor(), forElement: .LeftThumb, forControlState: .Normal)
        self.slider2?.setTint(UIColor.grayColor(), forElement: .LeftThumb, forControlState: .Disabled)
        
        image = UIImage(named: "roundedRightThumb")!.imageWithRenderingMode(.AlwaysTemplate)
        self.slider2?.setImage(image, forElement: .RightThumb, forControlState: .Normal)
        self.slider2?.setTint(UIColor.redColor(), forElement: .RightThumb, forControlState: .Normal)
        self.slider2?.setTint(UIColor.grayColor(), forElement: .RightThumb, forControlState: .Disabled)
        
        self.slider2?.setTint(UIColor.redColor(), forElement: .ActiveBar, forControlState: .Normal)
        self.slider2?.setTint(UIColor.grayColor(), forElement: .ActiveBar, forControlState: .Disabled)
        
        self.slider2?.setTint(UIColor.clearColor(), forElement: .MiddleThumb, forControlState: .Normal)
        
        self.slider2?.setTint(UIColor.lightGrayColor(), forElement: .InactiveBar, forControlState: .Disabled)

        self.slider2!.barHeight = 10.0
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
    
    @IBAction func buttonPressed(sender: AnyObject)
    {
        if (toggled)
        {
            stockSlider?.setImage(nil, forElement: .LeftThumb, forControlState: .Normal)
            stockSlider?.setImage(nil, forElement: .RightThumb, forControlState: .Normal)
            stockSlider?.setImage(nil, forElement: .ActiveBar, forControlState: .Normal)
            stockSlider?.setImage(nil, forElement: .MiddleThumb, forControlState: .Normal)
            stockSlider?.setImage(nil, forElement: .InactiveBar, forControlState: .Normal)
        }
        else
        {
            var image = UIImage(named: "leftthumb")
            stockSlider?.setImage(image, forElement: .LeftThumb, forControlState: .Normal)
            
            image = UIImage(named: "rightthumb")
            image = image?.imageWithRenderingMode(.AlwaysTemplate)
            stockSlider?.setImage(image, forElement: .RightThumb, forControlState: .Normal)
            stockSlider?.setTint(UIColor.blueColor(), forElement: .RightThumb, forControlState: .Normal)
            
            image = UIImage(named: "Active")
            image = image?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 3, 0, 3), resizingMode: .Tile)
            stockSlider?.setImage(image, forElement: .ActiveBar, forControlState: .Normal)
            
            image = UIImage(named: "Middle")
            stockSlider?.setImage(image, forElement: .MiddleThumb, forControlState: .Normal)

            image = UIImage(named: "inactive")
            stockSlider?.setImage(image, forElement: .InactiveBar, forControlState: .Normal)

        }
        toggled = !toggled
    }
    
    @IBAction func toggleEnabledPressed(sender: AnyObject)
    {
        slider2!.enabled = !(slider2!.enabled)
    }
}

