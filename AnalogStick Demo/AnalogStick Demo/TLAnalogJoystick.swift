//
//  TLAnalogJoystick.swift
//  tyApplyApp company
//
//  Created by Dmitriy Mitrophanskiy on 2/27/19.
//  Copyright © 2019 Dmitriy Mitrophanskiy. All rights reserved.
//

import SpriteKit

public typealias 🕹 = TLAnalogJoystick
public typealias TLAnalogJoystickEventHandler = (TLAnalogJoystick) -> Void
public typealias TLAnalogJoystickHandlerID = String
public typealias TLAnalogJoystickEventHandlers = [TLAnalogJoystickHandlerID: TLAnalogJoystickEventHandler]

public enum TLAnalogJoystickEventType {
	case begin
	case move
	case end
}

fileprivate let getHandlerID: () -> TLAnalogJoystickHandlerID = {
	var counter = 0
	
	return {
		counter += 1
		return "sbscrbr_\(counter)"
	}()
}

fileprivate func getDiameter(fromDiameter diameter: CGFloat, withRatio ratio: CGFloat) -> CGFloat {
	return diameter * abs(ratio)
}

// MARK: - TLAnalogJoystickHiddenArea
open class TLAnalogJoystickHiddenArea: SKShapeNode {
	private var currJoystick: TLAnalogJoystick?
	
	var joystick: TLAnalogJoystick? {
		get {
			return currJoystick
		}
		
		set {
			if let currJoystick = self.currJoystick {
				removeChildren(in: [currJoystick])
			}
			
			currJoystick = newValue
			
			if let currJoystick = self.currJoystick {
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
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let currJoystick = self.currJoystick else {
			return
		}
		
		let firstTouch = touches.first!
		currJoystick.position = firstTouch.location(in: self)
		currJoystick.isHidden = false
		currJoystick.touchesBegan(touches, with: event)
	}
	
	open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let currJoystick = self.currJoystick else {
			return
		}
		
		currJoystick.touchesMoved(touches, with: event)
	}
	
	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let currJoystick = self.currJoystick else {
			return
		}
		
		currJoystick.touchesEnded(touches, with: event)
		cancelNode(currJoystick)
	}
	
	open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let currJoystick = self.currJoystick else {
			return
		}
		
		currJoystick.touchesCancelled(touches, with: event)
		cancelNode(currJoystick)
	}
}

//MARK: - TLAnalogJoystickComponent
open class TLAnalogJoystickComponent: SKSpriteNode {
	private var kvoContext = UInt8(1)
    
    public var image: UIImage? {
        didSet {
            redrawTexture()
        }
    }
    
    public var diameter: CGFloat {
        get {
            return size.width
        }
        
        set {
            size = CGSize(width: newValue, height: newValue)
        }
    }
	
	open override var size: CGSize {
		get {
			return super.size
		}
		
		set {
			let maxVal = max(newValue.width, newValue.height)
			super.size.width = maxVal
			super.size.height = maxVal
		}
	}
    
    public var radius: CGFloat {
        get {
            return diameter / 2
        }
        
        set {
            diameter = newValue * 2
        }
    }
    
    //MARK: - DESIGNATED
    init(diameter: CGFloat, color: UIColor? = nil, image: UIImage? = nil) {
		let pureColor = color ?? UIColor.black
		let size = CGSize(width: diameter, height: diameter)
        super.init(texture: nil, color: pureColor, size: size)
		
		self.diameter = diameter
		self.image = image

        addObserver(self, forKeyPath: "color", options: NSKeyValueObservingOptions.old, context: &kvoContext)
        redrawTexture()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver(self, forKeyPath: "color")
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		
		if keyPath == "color" {
			redrawTexture()
		}
    }
    
    private func redrawTexture() {
        let scale = UIScreen.main.scale
        let needSize = CGSize(width: diameter, height: diameter)

        UIGraphicsBeginImageContextWithOptions(needSize, false, scale)
        let rectPath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: needSize))
        rectPath.addClip()
        
        if let img = image {
            img.draw(in: CGRect(origin: .zero, size: needSize), blendMode: .normal, alpha: 1)
        } else {
            color.set()
            rectPath.fill()
        }
        
        let textureImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        texture = SKTexture(image: textureImage)
    }
}

//MARK: - TLAnalogJoystick
open class TLAnalogJoystick: SKNode {
	public var isMoveable = false
	public let handle: TLAnalogJoystickComponent
    public let base: TLAnalogJoystickComponent
	
	private var pHandleRatio: CGFloat
	private var displayLink: CADisplayLink!
	private var hadnlers = [TLAnalogJoystickEventType: TLAnalogJoystickEventHandlers]()
	private var handlerIDsRelEvent = [TLAnalogJoystickHandlerID: TLAnalogJoystickEventType]()
	private(set) var tracking = false {
		didSet {
			guard oldValue != tracking else {
				return
			}
			
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
				let resetAction = SKAction.move(to: .zero, duration: 0.1)
				resetAction.timingMode = .easeOut
				handle.run(resetAction)
			}
		}
	}
	
	public var velocity: CGPoint {
		let diff = handle.diameter * 0.02
		return CGPoint(x: handle.position.x / diff, y: handle.position.y / diff)
	}
	
	public var angular: CGFloat {
		let velocity = self.velocity
		return -atan2(velocity.x, velocity.y)
	}
    
    public var disabled: Bool {
        get {
            return !isUserInteractionEnabled
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
			return pHandleRatio
		}
		
		set {
			pHandleRatio = newValue
			handle.diameter = getDiameter(fromDiameter: base.diameter, withRatio: newValue)
		}
	}
	
	public var diameter: CGFloat {
		get {
			return max(base.diameter, handle.diameter)
		}
		
		set {
			let diff = newValue - diameter
			base.diameter += diff
			handle.diameter += diff
		}
	}
    
    public var radius: CGFloat {
        get {
            return max(base.radius, handle.radius)
        }
        
        set {
			let diff = newValue - radius
			base.radius += diff
			handle.radius += diff
        }
    }
	
	public var baseColor: UIColor {
		get {
			return base.color
		}
		
		set {
			base.color = newValue
		}
	}
	
	public var handleColor: UIColor {
		get {
			return handle.color
		}
		
		set {
			handle.color = newValue
		}
	}
	
	public var baseImage: UIImage? {
		get {
			return base.image
		}
		
		set {
			base.image = newValue
		}
	}
	
	public var handleImage: UIImage? {
		get {
			return handle.image
		}
		
		set {
			handle.image = newValue
		}
	}

	init(withBase base: TLAnalogJoystickComponent, handle: TLAnalogJoystickComponent) {
        self.base = base
        self.handle = handle
		self.pHandleRatio = handle.diameter / base.diameter
		super.init()
		
		disabled = false
		displayLink = CADisplayLink(target: self, selector: #selector(listen))
		handle.zPosition = base.zPosition + 1

		addChild(base)
		addChild(handle)
    }
	
	deinit {
		displayLink.invalidate()
	}
	
	convenience init(withDiameter diameter: CGFloat, handleRatio: CGFloat = 0.6) {
		let base = TLAnalogJoystickComponent(diameter: diameter, color: .gray)
		let handleDiameter = getDiameter(fromDiameter: diameter, withRatio: handleRatio)
		let handle = TLAnalogJoystickComponent(diameter: handleDiameter, color: .black)
		self.init(withBase: base, handle: handle)
	}
    
    required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
    }
	
	private func getEventHandlers(forType type: TLAnalogJoystickEventType) -> TLAnalogJoystickEventHandlers {
		return hadnlers[type] ?? TLAnalogJoystickEventHandlers()
	}
	
	private func runEvent(_ type: TLAnalogJoystickEventType) {
		let handlers = getEventHandlers(forType: type)

		handlers.forEach { _, handler in
			handler(self)
		}
	}
	
	@discardableResult
	public func on(_ event: TLAnalogJoystickEventType, _ handler: @escaping TLAnalogJoystickEventHandler) -> TLAnalogJoystickHandlerID {
		let handlerID = getHandlerID()
		var currHandlers = getEventHandlers(forType: event)
		currHandlers[handlerID] = handler
		handlerIDsRelEvent[handlerID] = event
		hadnlers[event] = currHandlers
		
		return handlerID
	}
	
	public func off(handlerID: TLAnalogJoystickHandlerID) {
		if let event = handlerIDsRelEvent[handlerID] {
			var currHandlers = getEventHandlers(forType: event)
			currHandlers.removeValue(forKey: handlerID)
			hadnlers[event] = currHandlers
		}
		
		handlerIDsRelEvent.removeValue(forKey: handlerID)
	}
	
	public func stop() {
		tracking = false
	}
	
    @objc
	func listen() {
        runEvent(.move)
    }
    
    //MARK: - Overrides
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first!

        guard handle == atPoint(touch.location(in: self)) else {
            return
        }
		
		tracking = true
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard tracking else {
			return
		}
		
		let touch = touches.first!
		let location = touch.location(in: self)
		let baseRadius = base.radius
		let distance = sqrt(pow(location.x, 2) + pow(location.y, 2))
		let	distanceDiff = distance - baseRadius
		
		if distanceDiff > 0 {
			let handlePosition = CGPoint(x: location.x / distance * baseRadius, y: location.y / distance * baseRadius)
			handle.position = handlePosition

			if isMoveable {
				position.x += location.x - handlePosition.x
				position.y += location.y - handlePosition.y
			}
		} else {
			handle.position = location
		}
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tracking = false
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        tracking = false
    }

    open override var description: String {
		return "TLAnalogJoystick (position: \(position), velocity: \(velocity), angular: \(angular)"
    }
}
