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

@IBDesignable class UIXRangeSlider: UIControl
{
    //Config
    var thumbActiveBarInset = 0.0
    
    var leftThumbImage:UIImage = UIImage()
    {
        didSet {
            self.leftThumbView.removeFromSuperview()
            self.leftThumbView = UIImageView(image: self.leftThumbImage)
            self.leftThumbView.userInteractionEnabled = false
            self.addSubview(self.leftThumbView)
            self.orderSubviews()
            self.setNeedsLayout()
        }
    }
    
    var rightThumbImage:UIImage = UIImage()
    {
        didSet {
            self.rightThumbView.removeFromSuperview()
            self.rightThumbView = UIImageView(image: self.rightThumbImage)
            self.rightThumbView.userInteractionEnabled = false
            self.addSubview(self.rightThumbView)
            self.orderSubviews()
            self.setNeedsLayout()
        }
    }
    
    var middleThumbImage:UIImage = UIImage()
    {
        didSet {
            self.middleThumbView.removeFromSuperview()
            self.middleThumbView = UIImageView(image: self.middleThumbImage)
            self.middleThumbView.userInteractionEnabled = false
            self.addSubview(self.middleThumbView)
            self.orderSubviews()
            self.setNeedsLayout()
        }
    }
    
    var inactiveBarImage:UIImage?
    {
        didSet {
            let newView = UIImageView(image: self.inactiveBarImage)
            self.inactiveBarView.removeFromSuperview()
            self.inactiveBarView = UIImageView(image: self.inactiveBarImage)
            self.inactiveBarView.userInteractionEnabled = false
            self.addSubview(self.inactiveBarView)
            self.orderSubviews()
            self.setNeedsLayout()
        }
    }
    
    var activeBarImage:UIImage = UIImage()
    {
        didSet {
            self.activeBarView.removeFromSuperview()
            self.activeBarView = UIImageView(image: self.activeBarImage)
            self.activeBarView.userInteractionEnabled = false
            self.addSubview(self.activeBarView)
            self.orderSubviews()
            self.setNeedsLayout()
        }
    }
    
    var previousLocation : CGPoint!
    
    enum ElementTracked
    {
        case None
        case LeftThumb
        case MiddleThumb
        case RightThumb
    }
    var trackedElement = ElementTracked.None
    
    var movingLeftThumb : Bool = false
    var movingMiddleThumb : Bool = false
    var movingRightThumb : Bool = false
    
    //State
    @IBInspectable var minimumValue:Float = 0.0
    {
        didSet {
            if (minimumValue > maximumValue)
            {
                minimumValue = maximumValue
            }
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var maximumValue:Float = 1.0
    {
        didSet {
            if (maximumValue < minimumValue)
            {
                maximumValue = minimumValue
            }
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var leftValue:Float = 0.3
        {
        didSet {
            if (leftValue <= self.minimumValue)
            {
                leftValue = self.minimumValue
            }
            
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var rightValue:Float = 0.7
    {
        didSet {
            if (rightValue >= self.maximumValue)
            {
                rightValue = self.maximumValue
            }
            
            self.setNeedsLayout()
        }
    }
    
    //component views
    var inactiveBarView:UIView = UIView()
    var activeBarView:UIView = UIView()
    var leftThumbView:UIView = UIView()
    var rightThumbView:UIView = UIView()
    var middleThumbView:UIView = UIView()
    
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
        self.allocateDefaultViews()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func allocateDefaultViews()
    {
        self.inactiveBarView = UIView(frame: CGRectMake(0, 0, 2, 2))
        self.inactiveBarView.backgroundColor = UIColor.lightGrayColor()
        self.inactiveBarView.userInteractionEnabled = false
        
        self.activeBarView = UIView(frame: CGRectMake(0, 0, 2, 2))
        self.activeBarView.backgroundColor = UIColor.blueColor()
        self.activeBarView.userInteractionEnabled = false
        
        self.middleThumbView = UIView(frame: CGRectMake(0, 0, 1, 27))
        self.middleThumbView.backgroundColor = UIColor.lightGrayColor()
        self.middleThumbView.layer.opacity = 0.5
        self.middleThumbView.layer.shadowOpacity = 0.25
        self.middleThumbView.layer.shadowOffset = CGSizeMake(0.0, 4.0)
        self.middleThumbView.layer.shadowColor = UIColor.grayColor().CGColor
        self.middleThumbView.layer.shadowRadius = 2.0
        self.middleThumbView.userInteractionEnabled = false
        
        self.leftThumbView = UIView(frame: CGRectMake(0, 0, 27, 27))
        var path = UIBezierPath(arcCenter: CGPointMake(27.0, 13.5), radius: CGFloat(13.5), startAngle: CGFloat(M_PI/2.0), endAngle: CGFloat(M_PI*1.5), clockwise: true)
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
        self.leftThumbView.userInteractionEnabled = false
        
        self.rightThumbView = UIView(frame: CGRectMake(0, 0, 27, 27))
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
        self.rightThumbView.userInteractionEnabled = false
        
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
    required init?(coder: NSCoder)
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
        let pos = positionForValue(self.leftValue)
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
    func positionForValue(value:Float) -> CGFloat
    {
        let pos = Float(self.inactiveBarView.frame.width) * (value - self.minimumValue) / (self.maximumValue - self.minimumValue) +  Float(self.inactiveBarView.frame.origin.x)
        return CGFloat(pos)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
//    func setInactiveBarImage(inactiveBarImage:UIImage)
//    {
//        self.inactiveBarImage = inactiveBarImage
//        
//        let newView = UIImageView(image: self.inactiveBarImage)
//        self.inactiveBarView.removeFromSuperview()
//        self.inactiveBarView = UIImageView(image: self.inactiveBarImage)
//        self.inactiveBarView.userInteractionEnabled = false
//        self.addSubview(self.inactiveBarView)
//        self.orderSubviews()
//        self.setNeedsLayout()
//    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
//    func setActiveBarImage(activeBarImage:UIImage)
//    {
//        self.activeBarImage = activeBarImage
//        self.activeBarView.removeFromSuperview()
//        self.activeBarView = UIImageView(image: self.activeBarImage)
//        self.activeBarView.userInteractionEnabled = false
//        self.addSubview(self.activeBarView)
//        self.orderSubviews()
//        self.setNeedsLayout()
//    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
//    func setLeftThumbImage(leftThumbImage:UIImage)
//    {
//        self.leftThumbImage = leftThumbImage
//        self.leftThumbView.removeFromSuperview()
//        self.leftThumbView = UIImageView(image: self.leftThumbImage)
//        self.leftThumbView.userInteractionEnabled = false
//        self.addSubview(self.leftThumbView)
//        self.orderSubviews()
//        self.setNeedsLayout()
//    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
//    func setRightThumbImage(rightThumbImage:UIImage)
//    {
//        self.rightThumbImage = rightThumbImage
//        self.rightThumbView.removeFromSuperview()
//        self.rightThumbView = UIImageView(image: self.rightThumbImage)
//        self.rightThumbView.userInteractionEnabled = false
//        self.addSubview(self.rightThumbView)
//        self.orderSubviews()
//        self.setNeedsLayout()
//    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
//    func setMiddleThumbImage(middleThumbImage:UIImage)
//    {
//        self.middleThumbImage = middleThumbImage
//        self.middleThumbView.removeFromSuperview()
//        self.middleThumbView = UIImageView(image: self.middleThumbImage)
//        self.middleThumbView.userInteractionEnabled = false
//        self.addSubview(self.middleThumbView)
//        self.orderSubviews()
//        self.setNeedsLayout()
//    }
    
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
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool
    {
        previousLocation = touch.locationInView(self)
        
        // Hit test the thumb layers
        if leftThumbView.frame.contains(previousLocation)
        {
            trackedElement = .LeftThumb
        }
        else if rightThumbView.frame.contains(previousLocation)
        {
            trackedElement = .RightThumb
        }
        else if middleThumbView.frame.contains(previousLocation)
        {
            trackedElement = .MiddleThumb
        }
        
        return trackedElement != .None
    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool
    {
        let location = touch.locationInView(self)
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (Double(maximumValue) - Double(minimumValue)) * deltaLocation / Double(bounds.width /*- thumbWidth*/)
        
        switch trackedElement
        {
        case .LeftThumb:
            handleLeftThumbMove(location, delta: deltaValue)
        case .MiddleThumb:
            handleMiddleThumbMove(location, delta: deltaValue)
        case .RightThumb:
            handleRightThumbMove(location, delta: deltaValue)
        default:
            break
        }
        
        previousLocation = location
        
        return true
    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func handleLeftThumbMove(location:CGPoint, delta:Double)
    {
        let translation = CGPointMake(location.x - previousLocation.x,location.y - previousLocation.y)
        let range = self.maximumValue - self.minimumValue
        let availableWidth = self.inactiveBarView.frame.width
        
        let newValue = self.leftValue + Float(translation.x) / Float(availableWidth) * range
        
        self.leftValue = newValue
        
        if (self.leftValue < minimumValue)
        {
            self.leftValue = minimumValue
        }
        
        if (self.leftValue > self.rightValue)
        {
            self.leftValue = self.rightValue
        }
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        self.setNeedsLayout()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func handleMiddleThumbMove(location:CGPoint, delta:Double)
    {
        let translation = CGPointMake(location.x - previousLocation.x,location.y - previousLocation.y)
        let range = self.maximumValue - self.minimumValue
        let availableWidth = self.inactiveBarView.frame.width
        let diff = self.rightValue - self.leftValue
        
        let newLeftValue = self.leftValue + Float(translation.x) / Float(availableWidth) * range
        if (newLeftValue < minimumValue)
        {
            self.leftValue = self.minimumValue
            self.rightValue = self.leftValue + diff
        }
        else
        {
            let newRightValue = self.rightValue + Float(translation.x) / Float(availableWidth) * range
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
        
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        self.setNeedsLayout()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func handleRightThumbMove(location:CGPoint, delta:Double)
    {
        let translation = CGPointMake(location.x - previousLocation.x,location.y - previousLocation.y)
        let range = self.maximumValue - self.minimumValue
        let availableWidth = self.inactiveBarView.frame.width
        let newValue = self.rightValue + Float(translation.x) / Float(availableWidth) * range
        
        self.rightValue = newValue
        
        if (self.rightValue > self.maximumValue)
        {
            self.rightValue = self.maximumValue
        }
        
        if (self.rightValue < self.leftValue)
        {
            self.rightValue = self.leftValue
        }
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        self.setNeedsLayout()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?)
    {
        trackedElement = .None
    }

}
