//
//  GameScene.swift
//  stick test
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//  Copyright (c) 2014 Dmitriy Mitrophanskiy. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var appleNode: SKSpriteNode?
    let jSizePlusSpriteNode = SKSpriteNode(imageNamed: "plus"), jSizeMinusSpriteNode = SKSpriteNode(imageNamed: "minus"),
    setJoystickStickImageBtn = SKLabelNode(), setJoystickSubstrateImageBtn = SKLabelNode(),
    joystickStickColorBtn = SKLabelNode(text: "Sticks Random Color"), joystickSubstrateColorBtn = SKLabelNode(text: "Substrates Random Color")
    
    var joystickStickImageEnabled = true {
        
        didSet {
            
            let image = joystickStickImageEnabled ? UIImage(named: "jStick") : nil
            moveAnalogStick.stick.image = image
            rotateAnalogStick.stick.image = image
            setJoystickStickImageBtn.text = joystickStickImageEnabled ? "Remove Stick Images" : "Set Stick Images"
        }
    }
    
    var joystickSubstrateImageEnabled = true {
        
        didSet {
            
            let image = joystickSubstrateImageEnabled ? UIImage(named: "jSubstrate") : nil
            moveAnalogStick.substrate.image = image
            rotateAnalogStick.substrate.image = image
            setJoystickSubstrateImageBtn.text = joystickSubstrateImageEnabled ? "Remove Substrate Images" : "Set Substrate Images"
        }
    }
    
    let moveAnalogStick =  🕹(diameter: 110)
    let rotateAnalogStick = AnalogJoystick(diameter: 110)
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = UIColor.whiteColor()
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
        moveAnalogStick.position = CGPointMake(moveAnalogStick.radius + 15, moveAnalogStick.radius + 15)
        addChild(moveAnalogStick)
        moveAnalogStick.trackingHandler = { jData in
            
            guard let aN = self.appleNode else { return }
            aN.position = CGPointMake(aN.position.x + (jData.velocity.x * 0.12), aN.position.y + (jData.velocity.y * 0.12))
        }
        
        rotateAnalogStick.position = CGPointMake(CGRectGetMaxX(self.frame) - rotateAnalogStick.radius - 15, rotateAnalogStick.radius + 15)
        addChild(rotateAnalogStick)
        rotateAnalogStick.trackingHandler = { jData in
            
            self.appleNode?.zRotation = jData.angular
        }
        
        let btnsOffset: CGFloat = 10
        let btnsOffsetHalf = btnsOffset / 2
        let joystickSizeLabel = SKLabelNode(text: "Joysticks Size:")
        joystickSizeLabel.fontSize = 20
        joystickSizeLabel.fontColor = UIColor.blackColor()
        joystickSizeLabel.horizontalAlignmentMode = .Left
        joystickSizeLabel.verticalAlignmentMode = .Top
        joystickSizeLabel.position = CGPoint(x: btnsOffset, y: self.frame.size.height - btnsOffset)
        addChild(joystickSizeLabel)
        
        joystickStickColorBtn.fontColor = UIColor.blackColor()
        joystickStickColorBtn.fontSize = 20
        joystickStickColorBtn.verticalAlignmentMode = .Top
        joystickStickColorBtn.horizontalAlignmentMode = .Left
        joystickStickColorBtn.position = CGPoint(x: btnsOffset, y: self.frame.size.height - 40)
        addChild(joystickStickColorBtn)
        
        joystickSubstrateColorBtn.fontColor = UIColor.blackColor()
        joystickSubstrateColorBtn.fontSize = 20
        joystickSubstrateColorBtn.verticalAlignmentMode = .Top
        joystickSubstrateColorBtn.horizontalAlignmentMode = .Left
        joystickSubstrateColorBtn.position = CGPoint(x: btnsOffset, y: self.frame.size.height - 65)
        addChild(joystickSubstrateColorBtn)
        
        jSizeMinusSpriteNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        jSizeMinusSpriteNode.position = CGPoint(x: CGRectGetMaxX(joystickSizeLabel.frame) + btnsOffset, y: CGRectGetMidY(joystickSizeLabel.frame))
        addChild(jSizeMinusSpriteNode)
        
        jSizePlusSpriteNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        jSizePlusSpriteNode.position = CGPoint(x: CGRectGetMaxX(jSizeMinusSpriteNode.frame) + btnsOffset, y: CGRectGetMidY(joystickSizeLabel.frame))
        addChild(jSizePlusSpriteNode)
        
        setJoystickStickImageBtn.fontColor = UIColor.blackColor()
        setJoystickStickImageBtn.fontSize = 20
        setJoystickStickImageBtn.verticalAlignmentMode = .Bottom
        setJoystickStickImageBtn.position = CGPointMake(CGRectGetMidX(self.frame), moveAnalogStick.position.y - btnsOffsetHalf)
        addChild(setJoystickStickImageBtn)
        
        setJoystickSubstrateImageBtn.fontColor  = UIColor.blackColor()
        setJoystickSubstrateImageBtn.fontSize = 20
        setJoystickStickImageBtn.verticalAlignmentMode = .Top
        setJoystickSubstrateImageBtn.position = CGPointMake(CGRectGetMidX(self.frame), moveAnalogStick.position.y + btnsOffsetHalf)
        addChild(setJoystickSubstrateImageBtn)
        
        joystickStickImageEnabled = true
        joystickSubstrateImageEnabled = true
        
        setRandomStickColor()
        addApple(CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame)))
    }
    
    func addApple(position: CGPoint) {
        
        guard let appleImage = UIImage(named: "apple") else { return }
        
        let texture = SKTexture(image: appleImage)
        let apple = SKSpriteNode(texture: texture)
        if #available(iOS 8.0, *) {
            apple.physicsBody = SKPhysicsBody(texture: texture, size: apple.size)
            apple.physicsBody!.affectedByGravity = false
        } else {
            // Fallback on earlier versions
        }
        
        insertChild(apple, atIndex: 0)
        apple.position = position
        appleNode = apple
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if let touch = touches.first {
            
            let node = nodeAtPoint(touch.locationInNode(self))
            
            switch node {
                
            case jSizePlusSpriteNode:
                moveAnalogStick.diameter += 1
                rotateAnalogStick.diameter += 1
            case jSizeMinusSpriteNode:
                moveAnalogStick.diameter -= 1
                rotateAnalogStick.diameter -= 1
            case setJoystickStickImageBtn:
                joystickStickImageEnabled = !joystickStickImageEnabled
            case setJoystickSubstrateImageBtn:
                joystickSubstrateImageEnabled = !joystickSubstrateImageEnabled
            case joystickStickColorBtn:
                setRandomStickColor()
            case joystickSubstrateColorBtn:
                setRandomSubstrateColor()
            default:
                addApple(touch.locationInNode(self))
            }
        }
    }
    
    func setRandomStickColor() {
        
        let randomColor = UIColor.random()
        moveAnalogStick.stick.color = randomColor
        rotateAnalogStick.stick.color = randomColor
    }
    
    func setRandomSubstrateColor() {
        
        let randomColor = UIColor.random()
        moveAnalogStick.substrate.color = randomColor
        rotateAnalogStick.substrate.color = randomColor
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

extension UIColor {
    
    static func random() -> UIColor {
        
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}
