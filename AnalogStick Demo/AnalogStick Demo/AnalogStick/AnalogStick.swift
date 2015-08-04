//
//  AnalogStick.swift
//  Joystick
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//
//
import SpriteKit

@objc protocol AnalogStickProtocol {
    func moveAnalogStick(analogStick: AnalogStick, velocity: CGPoint, angularVelocity: Float)
}

class AnalogStick: SKNode {
    
    var velocityLoop: CADisplayLink?
    let thumbNode: SKSpriteNode, bgNode: SKSpriteNode
    
    func setThumbImage(image: UIImage?, sizeToFit: Bool) {
        var tImage: UIImage = image != nil ? image! : UIImage(named: "aSThumbImg")!
        self.thumbNode.texture = SKTexture(image: tImage)
        if sizeToFit {
            self.thumbNodeDiametr = min(tImage.size.width, tImage.size.height)
        }
    }
    func setBgImage(image: UIImage?, sizeToFit: Bool) {
        var tImage: UIImage = image != nil ? image! : UIImage(named: "aSBgImg")!
        self.bgNode.texture = SKTexture(image: tImage)
        if sizeToFit {
            self.bgNodeDiametr = min(tImage.size.width, tImage.size.height)
        }
    }
    var bgNodeDiametr: CGFloat {
        get { return self.bgNode.size.width }
        set { self.bgNode.size = CGSizeMake(newValue, newValue) }
    }
    var thumbNodeDiametr: CGFloat {
        get { return self.bgNode.size.width }
        set { self.thumbNode.size = CGSizeMake(newValue, newValue) }
    }
    var delegate: AnalogStickProtocol? {
        didSet {
            velocityLoop?.invalidate()
            velocityLoop = nil
            if delegate != nil {
                velocityLoop = CADisplayLink(target: self, selector: Selector("update"))
                velocityLoop?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
            }
        }
    }
    func update() {
        if isTracking {
           delegate?.moveAnalogStick(self, velocity: self.velocity, angularVelocity: self.angularVelocity)
        }
    }
    let kThumbSpringBackDuration: NSTimeInterval = 0.15 // action duration
    var isTracking = false
    var velocity = CGPointZero, anchorPointInPoints = CGPointZero
    var angularVelocity = Float()
    convenience init(thumbImage: UIImage?) {
        self.init(thumbImage: thumbImage, bgImage: nil)
    }
    convenience init(bgImage: UIImage?) {
        self.init(thumbImage: nil, bgImage: bgImage)
    }
    convenience override init() {
        self.init(thumbImage: nil, bgImage: nil)
    }
    init(thumbImage: UIImage?, bgImage: UIImage?) {
        self.thumbNode = SKSpriteNode()
        self.bgNode = SKSpriteNode()
        super.init()
        setThumbImage(thumbImage, sizeToFit: true)
        setBgImage(bgImage, sizeToFit: true)
        self.userInteractionEnabled = true;
        self.isTracking = false
        self.velocity = CGPointZero
        self.addChild(bgNode) // first bg
        self.addChild(thumbNode) // after thumb
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func reset() {
        self.isTracking = false
        self.velocity = CGPointZero
        let easeOut: SKAction = SKAction.moveTo(self.anchorPointInPoints, duration: kThumbSpringBackDuration)
        easeOut.timingMode = SKActionTimingMode.EaseOut
        self.thumbNode.runAction(easeOut)
    }
    // touch begin
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        for touch: AnyObject in touches {
            let location: CGPoint = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            if self.thumbNode == touchedNode && isTracking == false {
                isTracking = true
            }
        }
    }
    // touch move
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event);
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self);
            let xDistance: Float = Float(location.x - self.thumbNode.position.x)
            let yDistance: Float = Float(location.y - self.thumbNode.position.y)
            if self.isTracking == true && sqrtf(powf(xDistance, 2) + powf(yDistance, 2)) <= Float(self.bgNodeDiametr * 2) {
                let xAnchorDistance: CGFloat = (location.x - self.anchorPointInPoints.x)
                let yAnchorDistance: CGFloat = (location.y - self.anchorPointInPoints.y)
                if sqrt(pow(xAnchorDistance, 2) + pow(yAnchorDistance, 2)) <= self.thumbNode.size.width {
                    let moveDifference: CGPoint = CGPointMake(xAnchorDistance , yAnchorDistance)
                    self.thumbNode.position = CGPointMake(self.anchorPointInPoints.x + moveDifference.x, self.anchorPointInPoints.y + moveDifference.y)
                } else {
                    let magV = sqrt(xAnchorDistance * xAnchorDistance + yAnchorDistance * yAnchorDistance)
                    let aX = self.anchorPointInPoints.x + xAnchorDistance / magV * self.thumbNode.size.width
                    let aY = self.anchorPointInPoints.y + yAnchorDistance / magV * self.thumbNode.size.width
                    self.thumbNode.position = CGPointMake(aX, aY)
                }
                let tNAnchPoinXDiff: CGFloat = self.thumbNode.position.x - self.anchorPointInPoints.x;
                let tNAnchPoinYDiff: CGFloat = self.thumbNode.position.y - self.anchorPointInPoints.y
                self.velocity = CGPointMake(tNAnchPoinXDiff, tNAnchPoinYDiff)
                self.angularVelocity = -atan2f(Float(tNAnchPoinXDiff), Float(tNAnchPoinYDiff))
            }
        }
    }
    // touch end
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        reset()
    }
    // touch cancel
    override func touchesCancelled(touches: Set<NSObject>, withEvent event: UIEvent!) {
        reset()
    }
}
