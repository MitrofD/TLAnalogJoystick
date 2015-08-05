//
//  AnalogStick.swift
//  Joystick
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//
//
import SpriteKit

public typealias AnalogStickMoveHandler = (AnalogStick) -> ()

public struct AnalogStickData: CustomStringConvertible {
    
    var velocity: CGPoint = CGPointZero
    var angular: CGFloat = 0
    
    public var description: String {
        
        return "velocity: \(velocity), angular: \(angular)"
    }
}

let kStickOfSubstrateWidthPercent: CGFloat = 0.5 // [0..1]

public class AnalogStick: SKNode {
    
    let stickNode = SKSpriteNode()
    let substrateNode = SKSpriteNode()
    
    private var tracking = false
    private var velocityLoop: CADisplayLink?
    var data = AnalogStickData()
    var trackingHandler: AnalogStickMoveHandler?
    
    private var _stickColor = UIColor.lightGrayColor()
    private var _substrateColor = UIColor.darkGrayColor()
    
    var stickColor: UIColor {
        
        get { return _stickColor }
        
        set(newColor) {
            
            stickImage = UIImage.circleWithRadius(diametr * kStickOfSubstrateWidthPercent, color: newColor)
            _stickColor = newColor
        }
    }
    
    var substrateColor: UIColor {
        
        get { return _substrateColor }
        
        set(newColor) {
            
            substrateImage = UIImage.circleWithRadius(diametr, color: newColor, borderWidth: 5, borderColor: UIColor.blackColor())
            _substrateColor = newColor
        }
    }
    
    var stickImage: UIImage? {
        
        didSet {
            
            guard let newImage = stickImage else {
                
                stickColor = _stickColor
                return
            }
            
            stickNode.texture = SKTexture(image: newImage)
        }
    }
    
    var substrateImage: UIImage? {
        
        didSet {
            
            guard let newImage = substrateImage else {
                
                substrateColor = _substrateColor
                return
            }
            
            substrateNode.texture = SKTexture(image: newImage)
        }
    }
    
    var diametr: CGFloat {
        
        get { return max(substrateNode.size.width, substrateNode.size.height) }
        
        set {
            substrateNode.size = CGSizeMake(newValue, newValue)
            stickNode.size = CGSizeMake(newValue * kStickOfSubstrateWidthPercent, newValue * kStickOfSubstrateWidthPercent)
        }
    }
    
    func listen() {
        
        guard tracking else { return }
        trackingHandler?(self)
    }
    
    let kThumbSpringBackDuration: NSTimeInterval = 0.15 // action duration
    var anchorPointInPoints = CGPointZero
    
    init(diametr: CGFloat, substrateImage: UIImage? = nil, stickImage: UIImage? = nil) {
        
        super.init()
        userInteractionEnabled = true;
        
        self.diametr = diametr
        self.stickImage = stickImage
        self.substrateImage = substrateImage
        addChild(substrateNode)
        addChild(stickNode)
        
        velocityLoop = CADisplayLink(target: self, selector: Selector("listen"))
        velocityLoop!.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    convenience init(diametr: CGFloat, substrateImage: UIImage?) {
        
        self.init(diametr: diametr, substrateImage: substrateImage, stickImage: nil)
    }
    
    convenience init(diametr: CGFloat, stickImage: UIImage?) {
        
        self.init(diametr: diametr, substrateImage: nil, stickImage: stickImage)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func resetStick() {
        
        tracking = false
        data.velocity = CGPointZero
        data.angular = 0
        let easeOut = SKAction.moveTo(anchorPointInPoints, duration: kThumbSpringBackDuration)
        easeOut.timingMode = .EaseOut
        stickNode.runAction(easeOut)
    }
    
    //MARK: - Overrides
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesBegan(touches, withEvent: event)
        
        for touch in touches {
            
            let touchedNode = nodeAtPoint(touch.locationInNode(self))
            
            guard self.stickNode == touchedNode && !tracking else { return }
            
            tracking = true
        }
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesMoved(touches, withEvent: event);
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self);
            let xDistance: Float = Float(location.x - self.stickNode.position.x)
            let yDistance: Float = Float(location.y - self.stickNode.position.y)
            
            guard tracking && sqrtf(powf(xDistance, 2) + powf(yDistance, 2)) <= Float(diametr * 2) else { return }
            
            let xAnchorDistance: CGFloat = (location.x - anchorPointInPoints.x)
            let yAnchorDistance: CGFloat = (location.y - anchorPointInPoints.y)
            
            if sqrt(pow(xAnchorDistance, 2) + pow(yAnchorDistance, 2)) <= self.stickNode.size.width {
                
                let moveDifference: CGPoint = CGPointMake(xAnchorDistance , yAnchorDistance)
                stickNode.position = CGPointMake(anchorPointInPoints.x + moveDifference.x, anchorPointInPoints.y + moveDifference.y)
            } else {
                
                let magV = sqrt(xAnchorDistance * xAnchorDistance + yAnchorDistance * yAnchorDistance)
                let aX = anchorPointInPoints.x + xAnchorDistance / magV * stickNode.size.width
                let aY = anchorPointInPoints.y + yAnchorDistance / magV * stickNode.size.width
                stickNode.position = CGPointMake(aX, aY)
            }
            
            let tNAnchPoinXDiff = stickNode.position.x - anchorPointInPoints.x;
            let tNAnchPoinYDiff = stickNode.position.y - anchorPointInPoints.y
            
            data = AnalogStickData(velocity: CGPointMake(tNAnchPoinXDiff, tNAnchPoinYDiff), angular: CGFloat(-atan2f(Float(tNAnchPoinXDiff), Float(tNAnchPoinYDiff))))
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesEnded(touches, withEvent: event)
        resetStick()
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        super.touchesCancelled(touches, withEvent: event)
        resetStick()
    }
}

extension UIImage {
    
    static func circleWithRadius(radius: CGFloat, color: UIColor, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) -> UIImage {
        
        let diametr = radius * 2
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(diametr + borderWidth * 2, diametr + borderWidth * 2), false, 0)
        
        let bPath = UIBezierPath(ovalInRect: CGRect(origin: CGPoint(x: borderWidth, y: borderWidth), size: CGSizeMake(diametr, diametr)))
        
        if let bC = borderColor {
            
            bC.setStroke()
            bPath.lineWidth = borderWidth
            bPath.stroke()
        }
        
        color.setFill()
        bPath.fill()
        
        let rImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rImage
    }
}
