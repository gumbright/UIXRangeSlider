//
//  UIXRangeSlider.swift
//  UIXRangeSlider
//
//  Created by Guy Umbright on 2/12/15.
//  Copyright (c) 2015 Umbright Consulting, Inc. All rights reserved.
//

import UIKit
import QuartzCore
import Darwin

class UIXRangeSlider: UIControl
{
    //Config
    var leftThumbImage:UIImage = UIImage()
    var rightThumbImage:UIImage = UIImage()
    var thumbActiveBarInset = 0.0
    
    var middleThumbImage:UIImage = UIImage()
    
    var inactiveBarImage:UIImage?
    //var inactiveBarImageCapInsets:UIEdgeInsets = UIEdgeInsetsZero
    
    var activeBarImage:UIImage = UIImage()
    //var activeBarImageCapInsets:UIEdgeInsets = UIEdgeInsetsZero
    
    //State
    var minimumValue:Double = 0.0
    var maximumValue:Double = 100.0
    var leftValue:Double = 30.0
    var rightValue:Double = 70.0
    
    //component views
    var inactiveBarView:UIView = UIView()
    var activeBarView:UIView = UIView()
    var leftThumbView:UIView = UIView()
    var rightThumbView:UIView = UIView()
    var middleThumbView:UIView = UIView()
    
    var leftPanGestureRecognizer:UIPanGestureRecognizer?
    var rightPanGestureRecognizer:UIPanGestureRecognizer?
    var middlePanGestureRecognizer:UIPanGestureRecognizer?
    
    //min ht = 31
    //respect view width, height is centered on view y
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func commonInit()
    {
        self.leftPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handleLeftPan:"))
        self.rightPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handleRightPan:"))
        self.middlePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handleMiddlePan:"))
        
        self.allocateDefaultViews()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func allocateDefaultViews()
    {
        self.inactiveBarView = UIView(frame: CGRectMake(0, 0, 2, 2))
        self.inactiveBarView.backgroundColor = UIColor.lightGrayColor()
        
        self.activeBarView = UIView(frame: CGRectMake(0, 0, 2, 2))
        self.activeBarView.backgroundColor = UIColor.blueColor()
        
        self.middleThumbView = UIView(frame: CGRectMake(0, 0, 1, 27))
        self.middleThumbView.backgroundColor = UIColor.lightGrayColor()
        self.middleThumbView.layer.opacity = 0.5
        self.middleThumbView.layer.shadowOpacity = 0.25
        self.middleThumbView.layer.shadowOffset = CGSizeMake(0.0, 4.0)
        self.middleThumbView.layer.shadowColor = UIColor.grayColor().CGColor
        self.middleThumbView.layer.shadowRadius = 2.0
        self.middleThumbView.addGestureRecognizer(self.middlePanGestureRecognizer!)
        
        self.leftThumbView = UIView(frame: CGRectMake(0, 0, 14, 27))
        self.leftThumbView.addGestureRecognizer(self.leftPanGestureRecognizer!)
        var path = UIBezierPath(arcCenter: CGPointMake(14.0, 13.5), radius: CGFloat(13.5), startAngle: CGFloat(M_PI/2.0), endAngle: CGFloat(M_PI*1.5), clockwise: true)
        path.closePath()
        var layer = CAShapeLayer()
        layer.path = path.CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.strokeColor = UIColor.lightGrayColor().CGColor
        layer.lineWidth = 0.25
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSizeMake(-3.0, 4.0)
        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowRadius = 2.0
        self.leftThumbView.layer.addSublayer(layer)
        
        self.rightThumbView = UIView(frame: CGRectMake(0, 0, 14, 27))
        self.rightThumbView.addGestureRecognizer(self.rightPanGestureRecognizer!)
        path = UIBezierPath(arcCenter: CGPointMake(0.0, 13.5), radius: CGFloat(13.5), startAngle: CGFloat(M_PI/2.0), endAngle: CGFloat(M_PI*1.5), clockwise: false)
        path.closePath()
        layer = CAShapeLayer()
        layer.path = path.CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.strokeColor = UIColor.lightGrayColor().CGColor
        layer.lineWidth = 0.25
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSizeMake(3.0, 4.0)
        layer.shadowColor = UIColor.grayColor().CGColor
        self.rightThumbView.layer.addSublayer(layer)
        
        self.orderSubviews()
        
        self.setNeedsLayout()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.commonInit()
    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    required init(coder: NSCoder)
    {
        super.init(coder: coder)
        self.commonInit()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    override func awakeFromNib()
    {
        self.commonInit()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    override func layoutSubviews()
    {
        let viewCenter = self.convertPoint(self.center, fromView: self.superview)
        self.inactiveBarView.center.y = viewCenter.y
        var frame = self.inactiveBarView.frame
        frame.origin.x = self.leftThumbView.frame.width
        frame.size.width = self.bounds.width - (self.leftThumbView.bounds.width + self.rightThumbView.bounds.width)
        self.inactiveBarView.frame = frame
        
        self.leftThumbView.center.y = viewCenter.y
        self.positionLeftThumb()
        self.rightThumbView.center.y = viewCenter.y
        self.positionRightThumb()
        
        self.middleThumbView.center.y = viewCenter.y
        frame = self.middleThumbView.frame
        frame.origin.x = CGRectGetMaxX(self.leftThumbView.frame)
        frame.size.width = CGRectGetMinX(self.rightThumbView.frame) - frame.origin.x
        self.middleThumbView.frame = frame
        
        self.activeBarView.center.y = viewCenter.y
        frame = self.activeBarView.frame
        frame.origin.x = CGRectGetMaxX(self.leftThumbView.frame)
        frame.size.width = CGRectGetMinX(self.rightThumbView.frame) - frame.origin.x
        self.activeBarView.frame = frame
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func positionLeftThumb()
    {
        let pos = CGFloat(positionForValue(self.leftValue))
        var frame = self.leftThumbView.frame
        frame.origin.x = CGFloat(pos - self.leftThumbView.bounds.width)
        self.leftThumbView.frame = frame;
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func positionRightThumb()
    {
        let pos = CGFloat(positionForValue(self.rightValue))
        var frame = self.rightThumbView.frame
        frame.origin.x = CGFloat(pos)
        self.rightThumbView.frame = frame;
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func positionForValue(value:Double) -> Double
    {
        return (Double(self.inactiveBarView.frame.width) * (value - self.minimumValue) / (self.maximumValue - self.minimumValue)) +  Double(self.inactiveBarView.frame.origin.x)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func setInactiveBarImage(inactiveBarImage:UIImage)
    {
        self.inactiveBarImage = inactiveBarImage
        
        let newView = UIImageView(image: self.inactiveBarImage)
        self.inactiveBarView.removeFromSuperview()
        self.inactiveBarView = UIImageView(image: self.inactiveBarImage)
        self.addSubview(self.inactiveBarView)
        self.orderSubviews()
        self.setNeedsLayout()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func setActiveBarImage(activeBarImage:UIImage)
    {
        self.activeBarImage = activeBarImage
        self.activeBarView.removeFromSuperview()
        self.activeBarView = UIImageView(image: self.activeBarImage)
        self.addSubview(self.activeBarView)
        self.orderSubviews()
        self.setNeedsLayout()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func setLeftThumbImage(leftThumbImage:UIImage)
    {
        self.leftThumbImage = leftThumbImage
        self.leftThumbView.removeGestureRecognizer(self.leftPanGestureRecognizer!)
        self.leftThumbView.removeFromSuperview()
        self.leftThumbView = UIImageView(image: self.leftThumbImage)
        self.leftThumbView.userInteractionEnabled = true
        self.leftThumbView.addGestureRecognizer(self.leftPanGestureRecognizer!)
        self.addSubview(self.leftThumbView)
        self.orderSubviews()
        self.setNeedsLayout()
    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func setRightThumbImage(rightThumbImage:UIImage)
    {
        self.rightThumbImage = rightThumbImage
        self.rightThumbView.removeGestureRecognizer(self.rightPanGestureRecognizer!)
        self.rightThumbView.removeFromSuperview()
        self.rightThumbView = UIImageView(image: self.rightThumbImage)
        self.rightThumbView.userInteractionEnabled = true
        self.rightThumbView.addGestureRecognizer(self.rightPanGestureRecognizer!)
        self.addSubview(self.rightThumbView)
        self.orderSubviews()
        self.setNeedsLayout()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func setMiddleThumbImage(middleThumbImage:UIImage)
    {
        self.middleThumbImage = middleThumbImage
        self.middleThumbView.removeGestureRecognizer(self.middlePanGestureRecognizer!)
        self.middleThumbView.removeFromSuperview()
        self.middleThumbView = UIImageView(image: self.middleThumbImage)
        self.middleThumbView.userInteractionEnabled = true
        self.middleThumbView.addGestureRecognizer(self.middlePanGestureRecognizer!)
        self.addSubview(self.middleThumbView)
        self.orderSubviews()
        self.setNeedsLayout()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func orderSubviews()
    {
        for view in self.subviews as [UIView]
        {
            view.removeFromSuperview()
        }
        
        self.addSubview(self.inactiveBarView)
        self.addSubview(self.leftThumbView)
        self.addSubview(self.middleThumbView)
        self.addSubview(self.rightThumbView)
        self.addSubview(self.activeBarView)
    }
    
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func handleLeftPan(gestureRecognizer: UIPanGestureRecognizer)
    {
        if (gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed)
        {
            let translation = gestureRecognizer.translationInView(self)
            let range = self.maximumValue - self.minimumValue
            let availableWidth = self.inactiveBarView.frame.width
            
            let newValue = self.leftValue + Double(translation.x) / Double(availableWidth) * range
           
            self.leftValue = newValue
            
            if (self.leftValue < minimumValue)
            {
                self.leftValue = minimumValue
            }
            
            if (self.leftValue > self.rightValue)
            {
                self.leftValue = self.rightValue
            }
            
            gestureRecognizer.setTranslation(CGPointZero, inView: self)
            self.setNeedsLayout()
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
    }
    
     /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func handleRightPan(gestureRecognizer: UIPanGestureRecognizer)
    {
        if (gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed)
        {
            let translation = gestureRecognizer.translationInView(self)
            let range = self.maximumValue - self.minimumValue
            let availableWidth = self.inactiveBarView.frame.width
            let newValue = self.rightValue + Double(translation.x) / Double(availableWidth) * range

            self.rightValue = newValue

            if (self.rightValue > self.maximumValue)
            {
                self.rightValue = self.maximumValue
            }
            
            if (self.rightValue < self.leftValue)
            {
                self.rightValue = self.leftValue
            }

            gestureRecognizer.setTranslation(CGPointZero, inView: self)
            self.setNeedsLayout()
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func handleMiddlePan(gestureRecognizer: UIPanGestureRecognizer)
    {
        if (gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed)
        {
            let translation = gestureRecognizer.translationInView(self)
            let range = self.maximumValue - self.minimumValue
            let availableWidth = self.inactiveBarView.frame.width
            let diff = self.rightValue - self.leftValue
            
            let newLeftValue = self.leftValue + Double(translation.x) / Double(availableWidth) * range
            if (newLeftValue < minimumValue)
            {
                self.leftValue = self.minimumValue
                self.rightValue = self.leftValue + diff
            }
            else
            {
                let newRightValue = self.rightValue + Double(translation.x) / Double(availableWidth) * range
                if (newRightValue > self.maximumValue)
                {
                    self.rightValue = self.maximumValue
                    self.leftValue = self.rightValue - diff
                }
                else
                {
                    self.leftValue = newLeftValue
                    self.rightValue = self.leftValue + diff
                }
            }
            gestureRecognizer.setTranslation(CGPointZero, inView: self)
            self.setNeedsLayout()
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
    }
}
