//
//  AnalogStick.swift
//  Joystick
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//
//
import SpriteKit

//MARK: AnalogJoystickData
public struct AnalogJoystickData: CustomStringConvertible {
    
    var velocity = CGPointZero
    var angular = CGFloat(0)
    
    mutating func reset() {
        
        velocity = CGPointZero
        angular = 0
    }
    
    public var description: String {
        
        return "AnalogStickData(velocity: \(velocity), angular: \(angular))"
    }
}

//MARK: - AnalogJoystickComponent
public class AnalogJoystickComponent: SKSpriteNode {
    
    private var kvoContext = UInt8(1)
    var borderWidth = CGFloat(0) { didSet { redrawTexture() } }
    var borderColor = UIColor.blackColor() { didSet { redrawTexture() } }
    var image: UIImage? { didSet { redrawTexture() } }
    
    var diameter: CGFloat {
        
        get { return max(size.width, size.height) }
        set { size = CGSizeMake(newValue, newValue) }
    }
    
    var radius: CGFloat {
        
        get { return diameter / 2 }
        set { diameter = newValue * 2 }
    }
    
    init(diameter: CGFloat, color: UIColor? = nil, image: UIImage? = nil) { // designated
        
        super.init(texture: nil, color: color ?? UIColor.blackColor(), size: CGSize(width: diameter, height: diameter))
        
        addObserver(self, forKeyPath: "color", options: NSKeyValueObservingOptions.Old, context: &kvoContext) // listen color changes
        
        self.diameter = diameter
        self.image = image
        redrawTexture()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        removeObserver(self, forKeyPath: "color")
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        redrawTexture()
    }
    
    private func redrawTexture() {
        
        guard diameter > 0 else {
            
            texture = nil
            print("Diameter should be more than zero")
            return
        }
        
        let scale = UIScreen.mainScreen().scale
        let needSize = CGSizeMake(self.diameter, self.diameter)
        UIGraphicsBeginImageContextWithOptions(needSize, false, scale)
        let rectPath = UIBezierPath(ovalInRect: CGRect(origin: CGPointZero, size: needSize))
        rectPath.addClip()
        
        color.set()
        rectPath.fill()
        
        if let img = image {
            
            img.drawInRect(CGRect(origin: CGPointZero, size: needSize), blendMode: .Normal, alpha: 1)
        }
        
        let needImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        texture = SKTexture(image: needImage)
    }
}

//MARK: - AnalogJoystickSubstrate
public class AnalogJoystickSubstrate: AnalogJoystickComponent {
    
    // coming soon...
}

//MARK: - AnalogJoystickStick
public class AnalogJoystickStick: AnalogJoystickComponent {
    
    // coming soon...
}

//MARK: - AnalogJoystick
typealias 🕹 = AnalogJoystick
public class AnalogJoystick: SKNode {
    
    var trackingHandler: ((AnalogJoystickData) -> ())?
    var startHandler: (() -> Void)?
    var stopHandler: (() -> Void)?
    var substrate: AnalogJoystickSubstrate!
    var stick: AnalogJoystickStick!
    private var tracking = false
    private(set) var data = AnalogJoystickData()
    
    var disabled: Bool {
        
        get { return !userInteractionEnabled }
        set {
            userInteractionEnabled = !newValue
            if newValue {
                resetStick()
            }
        }
    }
    
    var diameter: CGFloat {
        
        get { return substrate.diameter }
        set {
            
            stick.diameter += newValue - diameter
            substrate.diameter = newValue
        }
    }
    
    var radius: CGFloat {
        
        get { return diameter / 2 }
        set { diameter = newValue * 2 }
    }
    
    init(substrate: AnalogJoystickSubstrate, stick: AnalogJoystickStick) {
        
        super.init()
        
        self.substrate = substrate
        substrate.zPosition = 0
        addChild(substrate)
        
        self.stick = stick
        stick.zPosition = substrate.zPosition + 1
        addChild(stick)
        
        disabled = false
        let velocityLoop = CADisplayLink(target: self, selector: #selector(listen))
        velocityLoop.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    convenience init(diameters: (substrate: CGFloat, stick: CGFloat?), colors: (substrate: UIColor?, stick: UIColor?)? = nil, images: (substrate: UIImage?, stick: UIImage?)? = nil) {
        
        let stickDiameter = diameters.stick ?? diameters.substrate * 0.6
        let jColors = colors ?? (substrate: nil, stick: nil)
        let jImages = images ?? (substrate: nil, stick: nil)
        
        let substrate = AnalogJoystickSubstrate(diameter: diameters.substrate, color: jColors.substrate, image: jImages.substrate)
        let stick = AnalogJoystickStick(diameter: stickDiameter, color: jColors.stick, image: jImages.stick)
        
        self.init(substrate: substrate, stick: stick)
    }
    
    convenience init(diameter: CGFloat, colors: (substrate: UIColor?, stick: UIColor?)? = nil, images: (substrate: UIImage?, stick: UIImage?)? = nil) {
        
        self.init(diameters: (substrate: diameter, stick: nil), colors: colors, images: images)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    func listen() {
        
        if tracking { trackingHandler?(data) }
    }
    
    //MARK: - Overrides
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first where stick == nodeAtPoint(touch.locationInNode(self)) {
            
            tracking = true
            startHandler?()
        }
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            
            guard tracking else { return }
            
            let maxDistantion = substrate.radius
            let realDistantion = sqrt(pow(location.x, 2) + pow(location.y, 2))
            let needPosition = realDistantion <= maxDistantion ? CGPointMake(location.x, location.y) : CGPointMake(location.x / realDistantion * maxDistantion, location.y / realDistantion * maxDistantion)
            
            stick.position = needPosition
            data = AnalogJoystickData(velocity: needPosition, angular: -atan2(needPosition.x, needPosition.y))
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        resetStick()
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        resetStick()
    }
    
    // CustomStringConvertible protocol
    public override var description: String {
        
        return "AnalogJoystick(data: \(data), position: \(position))"
    }
    
    // private methods
    private func resetStick() {
        
        tracking = false
        let moveToBack = SKAction.moveTo(CGPointZero, duration: NSTimeInterval(0.1))
        moveToBack.timingMode = .EaseOut
        stick.runAction(moveToBack)
        data.reset()
        stopHandler?();
    }
}