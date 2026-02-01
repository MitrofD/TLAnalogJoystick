//
//  AnalogJoystick.swift
//  tyApplyApp company
//
//  Copyright © 2024 Dmitriy Mitrofansky. All rights reserved.
//

import SpriteKit

private func getDiameter(fromDiameter diameter: CGFloat, withRatio ratio: CGFloat) -> CGFloat {
    diameter * abs(ratio)
}

// MARK: - AnalogJoystickHiddenArea

open class AnalogJoystickHiddenArea: SKShapeNode {
    private var currJoystick: AnalogJoystick?
	
    var joystick: AnalogJoystick? {
        get {
            return currJoystick
        }
		
        set {
            if let currJoystick = currJoystick {
                removeChildren(in: [currJoystick])
            }
			
            currJoystick = newValue
			
            if let currJoystick = currJoystick {
                isUserInteractionEnabled = true
                cancelNode(currJoystick)
                addChild(currJoystick)
            } else {
                isUserInteractionEnabled = false
            }
        }
    }
	
    private func cancelNode(_ node: SKNode) {
        node.isHidden = true
    }
	
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currJoystick, let firstTouch = touches.first else { return }
        currJoystick.position = firstTouch.location(in: self)
        currJoystick.isHidden = false
        currJoystick.touchesBegan(touches, with: event)
    }
	
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currJoystick else { return }
        currJoystick.touchesMoved(touches, with: event)
    }
	
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currJoystick else { return }
        currJoystick.touchesEnded(touches, with: event)
        cancelNode(currJoystick)
    }
	
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currJoystick else { return }
        currJoystick.touchesCancelled(touches, with: event)
        cancelNode(currJoystick)
    }
}

// MARK: - AnalogJoystickComponent

open class AnalogJoystickComponent: SKSpriteNode {
    public var image: UIImage? {
        didSet {
            redrawTexture()
        }
    }
    
    override open var color: UIColor {
        didSet {
            redrawTexture()
        }
    }
    
    public var diameter: CGFloat {
        get {
            size.width
        }
        
        set {
            size = CGSize(width: newValue, height: newValue)
        }
    }
	
    override open var size: CGSize {
        get {
            super.size
        }
		
        set {
            let maxVal = max(newValue.width, newValue.height)
            super.size = CGSize(width: maxVal, height: maxVal)
            redrawTexture()
        }
    }
    
    public var radius: CGFloat {
        get {
            diameter / 2
        }
        
        set {
            diameter = newValue * 2
        }
    }
    
    // MARK: - DESIGNATED

    init(diameter: CGFloat, color: UIColor? = nil, image: UIImage? = nil) {
        let pureColor = color ?? UIColor.black
        let size = CGSize(width: diameter, height: diameter)
        super.init(texture: nil, color: pureColor, size: size)
        self.diameter = diameter
        self.image = image
        redrawTexture()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func redrawTexture() {
        guard size.width > .zero, size.height > .zero else { return }
        let scale = UIScreen.main.scale

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rectPath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size))
        rectPath.addClip()
        
        if let image {
            image.draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: 1)
        } else {
            color.set()
            rectPath.fill()
        }
        
        guard let textureImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return
        }

        UIGraphicsEndImageContext()
        texture = SKTexture(image: textureImage)
    }
}

// MARK: - AnalogJoystick

open class AnalogJoystick: SKNode {
    public var deadZone: CGFloat = 0.05
    public var isMoveable = false
    public let handle: AnalogJoystickComponent
    public let base: AnalogJoystickComponent
    public var resetDuration: TimeInterval = 0.15
    public var velocityExponent: CGFloat = 1.5
    
    private var activeTouch: UITouch?
    private var pHandleRatio: CGFloat
    private var displayLink: CADisplayLink!
    private var handlers = [EventType: EventHandlersMap]()
    private var handlerEventById = [EventHandlerId: EventType]()
    
    public enum EventType {
        case begin
        case move
        case end
    }
    
    public typealias EventHandlerId = String
    public typealias EventHandler = (AnalogJoystick) -> Void
    public typealias EventHandlersMap = [EventHandlerId: EventHandler]
    
    private static let getHandlerId: () -> EventHandlerId = {
        var counter = 0
        
        return {
            counter += 1
            return "sbscrbr_\(counter)"
        }()
    }

    private(set) var tracking = false {
        didSet {
            guard oldValue != tracking else { return }
			
            #if swift(>=4.2)
                let loopMode = RunLoop.Mode.common
            #else
                let loopMode = RunLoopMode.commonModes
            #endif
			
            if tracking {
                displayLink.add(to: .current, forMode: loopMode)
                runEvent(.begin)
            } else {
                displayLink.remove(from: .current, forMode: loopMode)
                runEvent(.end)
                let resetAction = SKAction.move(to: .zero, duration: resetDuration)
                resetAction.timingMode = .easeOut
                handle.run(resetAction)
            }
        }
    }
    
    public var velocity: CGPoint {
        guard base.radius > 0 else { return .zero }

        var nx = handle.position.x / base.radius
        var ny = handle.position.y / base.radius

        // Ограничиваем длину вектора до 1
        let length = sqrt(nx * nx + ny * ny)
        if length > 1 {
            nx /= length
            ny /= length
        }

        // Плавный deadZone
        func applyDeadZone(_ value: CGFloat) -> CGFloat {
            let absValue = abs(value)
            if absValue < deadZone {
                return 0
            } else {
                // Нормируем из диапазона deadZone..1 -> 0..1
                return copysign((absValue - deadZone) / (1 - deadZone), value)
            }
        }

        let vx = applyDeadZone(nx)
        let vy = applyDeadZone(ny)
        let adjustedX = copysign(pow(abs(vx), velocityExponent), vx)
        let adjustedY = copysign(pow(abs(vy), velocityExponent), vy)

        return CGPoint(x: adjustedX, y: adjustedY)
    }

    public var angular: CGFloat {
        atan2(velocity.y, velocity.x)
    }
    
    public var disabled: Bool {
        get {
            !isUserInteractionEnabled
        }
        
        set {
            isUserInteractionEnabled = !newValue

            if newValue {
                stop()
            }
        }
    }
	
    public var handleRatio: CGFloat {
        get {
            pHandleRatio
        }
		
        set {
            pHandleRatio = newValue
            handle.diameter = getDiameter(fromDiameter: base.diameter, withRatio: newValue)
        }
    }
	
    public var diameter: CGFloat {
        get {
            max(base.diameter, handle.diameter)
        }
		
        set {
            let diff = newValue - diameter
            base.diameter += diff
            handle.diameter += diff
        }
    }
    
    public var radius: CGFloat {
        get {
            max(base.radius, handle.radius)
        }
        
        set {
            let diff = newValue - radius
            base.radius += diff
            handle.radius += diff
        }
    }
	
    public var baseColor: UIColor {
        get {
            base.color
        }
		
        set {
            base.color = newValue
        }
    }
	
    public var handleColor: UIColor {
        get {
            handle.color
        }
		
        set {
            handle.color = newValue
        }
    }
	
    public var baseImage: UIImage? {
        get {
            base.image
        }
		
        set {
            base.image = newValue
        }
    }
	
    public var handleImage: UIImage? {
        get {
            handle.image
        }
		
        set {
            handle.image = newValue
        }
    }

    init(withBase base: AnalogJoystickComponent, handle: AnalogJoystickComponent) {
        self.base = base
        self.handle = handle
        pHandleRatio = handle.diameter / base.diameter
        super.init()
		
        disabled = false
        displayLink = CADisplayLink(target: self, selector: #selector(listen))
        handle.zPosition = base.zPosition + 1

        addChild(base)
        addChild(handle)
    }
    
    convenience init(withDiameter diameter: CGFloat, handleRatio: CGFloat = 0.6) {
        let base = AnalogJoystickComponent(diameter: diameter, color: .gray)
        let handleDiameter = getDiameter(fromDiameter: diameter, withRatio: handleRatio)
        let handle = AnalogJoystickComponent(diameter: handleDiameter, color: .black)
        self.init(withBase: base, handle: handle)
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func removeFromParent() {
        super.removeFromParent()
        displayLink.invalidate()
    }
	
    deinit {
        displayLink.invalidate()
    }
	
    private func getEventHandlers(forType type: EventType) -> EventHandlersMap {
        handlers[type] ?? EventHandlersMap()
    }
	
    private func runEvent(_ type: EventType) {
        let handlers = getEventHandlers(forType: type)

        for (_, handler) in handlers {
            handler(self)
        }
    }
	
    @discardableResult
    public func on(_ event: EventType, _ handler: @escaping EventHandler) -> EventHandlerId {
        let handlerId = Self.getHandlerId()
        var currHandlers = getEventHandlers(forType: event)
        currHandlers[handlerId] = handler
        handlerEventById[handlerId] = event
        handlers[event] = currHandlers
        return handlerId
    }
	
    public func off(handlerID: EventHandlerId) {
        if let event = handlerEventById[handlerID] {
            var currHandlers = getEventHandlers(forType: event)
            currHandlers.removeValue(forKey: handlerID)
            handlers[event] = currHandlers
        }
		
        handlerEventById.removeValue(forKey: handlerID)
    }
	
    public func stop() {
        tracking = false
    }
	
    @objc
    func listen() {
        runEvent(.move)
    }
    
    // MARK: - Overrides

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Если джойстик уже занят, игнорируем новые пальцы
        guard activeTouch == nil,
              let touch = touches.first,
              handle == atPoint(touch.location(in: self)) else { return }

        activeTouch = touch
        tracking = true
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Двигаем только активный палец
        guard tracking,
              let touch = activeTouch,
              touches.contains(touch) else { return }

        let location = touch.location(in: self)
        let baseRadius = base.radius
        let distance = hypot(location.x, location.y)
        
        guard distance > 0 else {
            handle.position = .zero
            return
        }
        
        if distance > baseRadius {
            let handlePosition = CGPoint(x: location.x / distance * baseRadius,
                                         y: location.y / distance * baseRadius)
            handle.position = handlePosition

            if isMoveable {
                position.x += location.x - handlePosition.x
                position.y += location.y - handlePosition.y
            }
        } else {
            handle.position = location
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = activeTouch, touches.contains(touch) {
            activeTouch = nil
            tracking = false
        }
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = activeTouch, touches.contains(touch) {
            activeTouch = nil
            tracking = false
        }
    }

    override open var description: String {
        return "AnalogJoystick [position: \(position), velocity: \(velocity), angular: \(angular)]"
    }
}
