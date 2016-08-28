//
//  UIXRangeSlider.swift
//  UIXRangeSlider
//
//  Created by Guy Umbright on 8/18/16.
//  Copyright © 2016 Umbright Consulting, Inc. All rights reserved.
//

import UIKit

@IBDesignable class UIXRangeSlider: UIControl
{
    override var enabled : Bool
        {
        didSet {
            updateAllElements()
        }
    }
    
    var barHeight : CGFloat = 2.0
        {
        didSet {
            self.updateImageForElement(.InactiveBar)
            self.updateImageForElement(.ActiveBar)
        }
    }
    
    /////////////////////////////////////////////////////
    // Component views
    /////////////////////////////////////////////////////
    var inactiveBarView:UIImageView = UIImageView()
    var activeBarView:UIImageView = UIImageView()
    var leftThumbView:UIImageView = UIImageView()
    var rightThumbView:UIImageView = UIImageView()
    var middleThumbView:UIImageView = UIImageView()

    
    /////////////////////////////////////////////////////
    // Values
    /////////////////////////////////////////////////////
    @IBInspectable var leftValue:Float = 0.3
        {
        didSet {
            if (leftValue <= 0.0)
            {
                leftValue = 0.0
            }
            
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var rightValue:Float = 0.7
        {
        didSet {
            if (rightValue >= 1.0)
            {
                rightValue = 1.0
            }
            
            self.setNeedsLayout()
        }
    }

    /////////////////////////////////////////////////////
    // Tracking
    /////////////////////////////////////////////////////
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
    
    var previousLocation : CGPoint!

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
    func commonInit()
    {
        setTint(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), forElement: .ActiveBar, forControlState: .Normal)
        self.configureDefaultLeftThumbView(self.leftThumbView)
        self.configureDefaultRightThumbView(self.rightThumbView)
        self.configureDefaultActiveBarView(self.activeBarView)
        self.configureDefaultInactiveBarView(self.inactiveBarView)
        self.configureDefaultMiddleThumbView(self.middleThumbView)
        self.allocateDefaultViews()
    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func allocateDefaultViews()
    {
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

    enum UIXRangeSliderElement : UInt {
        case LeftThumb = 0
        case RightThumb
        case MiddleThumb
        case ActiveBar
        case InactiveBar
    }
    
    typealias stateImageDictionary = [UInt : UIImage]
    var elementImages : [UInt : stateImageDictionary] = [:]
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func stateImageDictionaryForElement(element : UIXRangeSliderElement) -> stateImageDictionary?
    {
        return elementImages[element.rawValue]
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func setImage(image : UIImage?, forElement element : UIXRangeSliderElement, forControlState state :UIControlState)
    {
        var dict = self.stateImageDictionaryForElement(element)
        if (dict == nil)
        {
            dict = stateImageDictionary()
            elementImages[element.rawValue] = dict
        }
        elementImages[element.rawValue]![state.rawValue] = image
        self.updateImageForElement(element)
    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func image(forElement element: UIXRangeSliderElement, forState state :UIControlState) -> UIImage?
    {
        var result : UIImage? = nil
        if let imageDict = self.stateImageDictionaryForElement(element)
        {
            result = imageDict[state.rawValue]
        }
        return result
    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func imageForCurrentState(element : UIXRangeSliderElement) -> UIImage?
    {
        let image : UIImage? = self.image(forElement: element, forState: self.state) ?? self.image(forElement: element, forState: .Normal)
        return image
    }

    typealias stateTintDictionary = [UInt : UIColor]
    var elementTints : [UInt : stateTintDictionary] = [:]
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func stateTintDictionaryForElement(element : UIXRangeSliderElement) -> stateTintDictionary?
    {
        return elementTints[element.rawValue]
    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func setTint(tint : UIColor, forElement element : UIXRangeSliderElement, forControlState state :UIControlState)
    {
        var dict = self.stateTintDictionaryForElement(element)
        if (dict == nil)
        {
            dict = stateTintDictionary()
            elementTints[element.rawValue] = dict
        }
        elementTints[element.rawValue]![state.rawValue] = tint
        self.updateImageForElement(element)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func tint(forElement element: UIXRangeSliderElement, forState state :UIControlState) -> UIColor?
    {
        var result : UIColor? = nil
        if let tintDict = self.stateTintDictionaryForElement(element)
        {
            result = tintDict[state.rawValue]
        }
        return result
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func tintForCurrentState(element : UIXRangeSliderElement) -> UIColor
    {
        let color = self.tint(forElement: element, forState: self.state) ?? self.tint(forElement: element, forState: .Normal)
        return color ?? UIColor.grayColor()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func updateAllElements()
    {
        updateImageForElement(.LeftThumb)
        updateImageForElement(.RightThumb)
        updateImageForElement(.MiddleThumb)
        updateImageForElement(.ActiveBar)
        updateImageForElement(.InactiveBar)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func updateImageForElement(element : UIXRangeSliderElement)
    {
        let state = self.enabled ? UIControlState.Normal : UIControlState.Disabled
        
        switch element
        {
        case .LeftThumb:
            self.leftThumbView.image = imageForCurrentState(element)
            if self.leftThumbView.image == nil
            {
                self.configureDefaultLeftThumbView(self.leftThumbView)
            }
            else
            {
                if let sublayers = self.leftThumbView.layer.sublayers
                {
                    for layer in sublayers
                    {
                        layer.removeFromSuperlayer()
                    }
                }
            }
            self.leftThumbView.tintColor = tint(forElement: element, forState: state)
            self.setNeedsLayout()
            
        case .RightThumb:
            self.rightThumbView.image = imageForCurrentState(element)
            if self.rightThumbView.image == nil
            {
                self.configureDefaultRightThumbView(self.rightThumbView)
            }
            else
            {
                if let sublayers = self.rightThumbView.layer.sublayers
                {
                    for layer in sublayers
                    {
                        layer.removeFromSuperlayer()
                    }
                }
            }
            self.rightThumbView.tintColor = tint(forElement: element, forState: state)
            self.setNeedsLayout()
            
        case .MiddleThumb:
            self.middleThumbView.image = imageForCurrentState(element)
            if self.middleThumbView.image == nil
            {
                self.configureDefaultMiddleThumbView(self.middleThumbView)
            }
            else
            {
                self.middleThumbView.backgroundColor = UIColor.clearColor()
                self.middleThumbView.frame = CGRectMake(0,0, self.middleThumbView.image!.size.width, self.middleThumbView.image!.size.height)
            }
            self.middleThumbView.tintColor = tint(forElement: element, forState: state)
            self.setNeedsLayout()
            
        case .ActiveBar:
            self.activeBarView.image = imageForCurrentState(element)
            if self.activeBarView.image == nil
            {
                self.configureDefaultActiveBarView(self.activeBarView)
            }
            else
            {
                self.activeBarView.backgroundColor = UIColor.clearColor()
                self.activeBarView.frame = CGRectMake(0,0, self.activeBarView.image!.size.width, self.activeBarView.image!.size.height)
            }
            self.activeBarView.tintColor = tint(forElement: element, forState: state)
            self.setNeedsLayout()
            
        case .InactiveBar:
            self.inactiveBarView.image = imageForCurrentState(element)
            if self.inactiveBarView.image == nil
            {
                self.configureDefaultInactiveBarView(self.inactiveBarView)
            }
            else
            {
                self.inactiveBarView.backgroundColor = UIColor.clearColor()
                self.inactiveBarView.frame = CGRectMake(0,0, self.inactiveBarView.image!.size.width, self.inactiveBarView.image!.size.height)
            }
            self.inactiveBarView.tintColor = tint(forElement: element, forState: state)
            self.setNeedsLayout()
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func currentLeftThumbImage() -> UIImage?
    {
        return leftThumbView.image!;
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func currentRightThumbImage() -> UIImage?
    {
        return rightThumbView.image!;
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func currentMiddleThumbImage() -> UIImage?
    {
        return middleThumbView.image!;
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func currentActiveBarImage() -> UIImage?
    {
        return activeBarView.image!;
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func currentInactiveBarImage() -> UIImage?
    {
        return inactiveBarView.image!;
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
        let pos = (Float(self.inactiveBarView.frame.width) * value)  +  Float(self.inactiveBarView.frame.origin.x)
        return CGFloat(pos)
    }
}

// MARK: -- Tracking --
extension UIXRangeSlider
{
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
        
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = deltaLocation / Double(bounds.width)
        
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
        let availableWidth = self.inactiveBarView.frame.width
        
        let newValue = self.leftValue + Float(translation.x) / Float(availableWidth)
        
        self.leftValue = newValue
        
        if (self.leftValue < 0)
        {
            self.leftValue = 0
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
        let availableWidth = self.inactiveBarView.frame.width
        let diff = self.rightValue - self.leftValue
        
        let newLeftValue = self.leftValue + Float(translation.x) / Float(availableWidth)
        if (newLeftValue < 0)
        {
            self.leftValue = 0
            self.rightValue = self.leftValue + diff
        }
        else
        {
            let newRightValue = self.rightValue + Float(translation.x) / Float(availableWidth)
            if (newRightValue > 1)
            {
                self.rightValue = 1
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
        let availableWidth = self.inactiveBarView.frame.width
        let newValue = self.rightValue + Float(translation.x) / Float(availableWidth)
        
        self.rightValue = newValue
        
        if (self.rightValue > 1)
        {
            self.rightValue = 1
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

// MARK: -- DefaultViews --
extension UIXRangeSlider
{
    func configureDefaultLeftThumbView(view : UIImageView)
    {
        view.image = nil
        view.frame = CGRectMake(0, 0, 27, 27)
        let path = UIBezierPath(arcCenter: CGPointMake(27.0, 13.5), radius: CGFloat(13.5), startAngle: CGFloat(M_PI/2.0), endAngle: CGFloat(M_PI*1.5), clockwise: true)
        path.closePath()
        let layer = CAShapeLayer()
        layer.path = path.CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.strokeColor = UIColor.lightGrayColor().CGColor
        layer.lineWidth = 0.25
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSizeMake(-3.0, 4.0)
        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowRadius = 2.0
        view.layer.addSublayer(layer)
        view.userInteractionEnabled = false
        view.tintColor = UIColor.grayColor()
    }
    
    func configureDefaultRightThumbView(view : UIImageView)
    {
        view.image = nil
        view.frame = CGRectMake(0, 0, 27, 27)
        let path = UIBezierPath(arcCenter: CGPointMake(0.0, 13.5), radius: CGFloat(13.5), startAngle: CGFloat(M_PI/2.0), endAngle: CGFloat(M_PI*1.5), clockwise: false)
        path.closePath()
        let layer = CAShapeLayer()
        layer.path = path.CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.strokeColor = UIColor.lightGrayColor().CGColor
        layer.lineWidth = 0.25
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSizeMake(3.0, 4.0)
        layer.shadowColor = UIColor.grayColor().CGColor
        view.layer.addSublayer(layer)
        view.userInteractionEnabled = false
    }
    
    func configureDefaultMiddleThumbView(view : UIImageView)
    {
        view.image = nil
        view.frame = CGRectMake(0, 0, 1, 27)
        view.backgroundColor = self.tintForCurrentState(.MiddleThumb)
        view.layer.opacity = 0.5
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSizeMake(0.0, 4.0)
        view.layer.shadowColor = UIColor.grayColor().CGColor
        view.layer.shadowRadius = 2.0
        view.userInteractionEnabled = false
    }
    
    func configureDefaultActiveBarView(view : UIImageView)
    {
        view.image = nil
        view.frame = CGRectMake(0, 0, 2, self.barHeight)
        view.backgroundColor = self.tintForCurrentState(.ActiveBar)
        view.userInteractionEnabled = false
    }
    
    func configureDefaultInactiveBarView(view : UIImageView)
    {
        view.image = nil
        view.frame = CGRectMake(0, 0, 2, self.barHeight)
        view.backgroundColor = self.tintForCurrentState(.InactiveBar)
        view.userInteractionEnabled = false
    }
}
