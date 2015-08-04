//
//  GameScene.swift
//  stick test
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//  Copyright (c) 2014 Dmitriy Mitrophanskiy. All rights reserved.
//

import SpriteKit

let kAnalogStickDiametr: CGFloat = 110

class GameScene: SKScene {
    
    var appleNode: SKSpriteNode?
    
    let jSizePlusSpriteNode = SKSpriteNode(imageNamed: "plus"), jSizeMinusSpriteNode = SKSpriteNode(imageNamed: "minus")
    
    let setJoystickStickImageBtn = SKLabelNode()
    let setJoystickSubstrateImageBtn = SKLabelNode()
    let joystickStickColorBtn = SKLabelNode(text: "Sticks Random Color")
    let joystickSubstrateColorBtn = SKLabelNode(text: "Substrates Random Color")
<<<<<<< HEAD
    
=======

>>>>>>> origin/master
    private var _isSetJoystickStickImage = false, _isSetJoystickSubstrateImage = false
    
    var isSetJoystickStickImage: Bool {
        
        get { return _isSetJoystickStickImage }
        
        set {
            
            _isSetJoystickStickImage = newValue
            let image = newValue ? UIImage(named: "jStick") : nil
            moveAnalogStick.stickImage = image
            rotateAnalogStick.stickImage = image
            setJoystickStickImageBtn.text = newValue ? "Remove Stick Images" : "Set Stick Images"
        }
    }
    
    var isSetJoystickSubstrateImage: Bool {
        
        get { return _isSetJoystickSubstrateImage }
        
        set {
            
            _isSetJoystickSubstrateImage = newValue
            let image = newValue ? UIImage(named: "jSubstrate") : nil
            moveAnalogStick.substrateImage = image
            rotateAnalogStick.substrateImage = image
            setJoystickSubstrateImageBtn.text = newValue ? "Remove Substrate Images" : "Set Substrate Images"
        }
    }
    
    var joysticksDiametrs: CGFloat {
        
        get { return max(moveAnalogStick.diametr, rotateAnalogStick.diametr) }
        
        set(newDiametr) {
            
            moveAnalogStick.diametr = newDiametr
            rotateAnalogStick.diametr = newDiametr
        }
    }
    
    let moveAnalogStick = AnalogStick(diametr: kAnalogStickDiametr)
    let rotateAnalogStick = AnalogStick(diametr: kAnalogStickDiametr)
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        backgroundColor = UIColor.whiteColor()
        let jRadius = kAnalogStickDiametr / 2
        
        moveAnalogStick.diametr = kAnalogStickDiametr
        moveAnalogStick.position = CGPointMake(jRadius + 15, jRadius + 15)
        moveAnalogStick.moveHandler = { analogStick in
            
            guard let aN = self.appleNode else { return }
            
            aN.position = CGPointMake(aN.position.x + (analogStick.data.velocity.x * 0.12), aN.position.y + (analogStick.data.velocity.y * 0.12))
        }
        addChild(moveAnalogStick)
        
        rotateAnalogStick.diametr = kAnalogStickDiametr
        rotateAnalogStick.position = CGPointMake(CGRectGetMaxX(self.frame) - jRadius - 15, jRadius + 15)
        
        rotateAnalogStick.moveHandler = { analogStick in
            
<<<<<<< HEAD
            self.appleNode?.zRotation = analogStick.data.angular
=======
           self.appleNode?.zRotation = analogStick.data.angular
>>>>>>> origin/master
        }
        
        addChild(rotateAnalogStick)
        
        appleNode = appendAppleToPoint(CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)))
        insertChild(appleNode!, atIndex: 0)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        addChild(appendAppleToPoint(CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))))
        
        let btnsOffset = CGFloat(10)
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
        
        jSizePlusSpriteNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        jSizeMinusSpriteNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        jSizeMinusSpriteNode.position = CGPoint(x: CGRectGetMaxX(joystickSizeLabel.frame) + btnsOffset, y: CGRectGetMidY(joystickSizeLabel.frame))
        
        jSizePlusSpriteNode.position = CGPoint(x: CGRectGetMaxX(jSizeMinusSpriteNode.frame) + btnsOffset, y: CGRectGetMidY(joystickSizeLabel.frame))
        
        addChild(jSizePlusSpriteNode)
        addChild(jSizeMinusSpriteNode)
        
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
        
        isSetJoystickStickImage = _isSetJoystickStickImage
        isSetJoystickSubstrateImage = _isSetJoystickSubstrateImage
    }
    
    func appendAppleToPoint(position: CGPoint) -> SKSpriteNode {
<<<<<<< HEAD
        
=======
            
>>>>>>> origin/master
        let appleImage = UIImage(named: "apple")
        
        precondition(appleImage != nil, "Please set right image")
        
        let texture = SKTexture(image: appleImage!)
        
        let apple = SKSpriteNode(texture: texture)
        apple.physicsBody = SKPhysicsBody(texture: texture, size: apple.size)
        apple.physicsBody!.affectedByGravity = false
        apple.position = position
        
        return apple
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        super.touchesBegan(touches, withEvent: event)
        
        if let touch = touches.first {
            
            let node = nodeAtPoint(touch.locationInNode(self))
            
            switch node {
                
            case jSizePlusSpriteNode:
                joysticksDiametrs = joysticksDiametrs + 1
            case jSizeMinusSpriteNode:
                joysticksDiametrs = joysticksDiametrs - 1
            case setJoystickStickImageBtn:
                isSetJoystickStickImage = !isSetJoystickStickImage
            case setJoystickSubstrateImageBtn:
                isSetJoystickSubstrateImage = !isSetJoystickSubstrateImage
            case joystickStickColorBtn:
                isSetJoystickStickImage = false
                let randomColor = UIColor.random()
                moveAnalogStick.stickColor = randomColor
                rotateAnalogStick.stickColor = randomColor
            case joystickSubstrateColorBtn:
                isSetJoystickSubstrateImage = false
                let randomColor = UIColor.random()
                moveAnalogStick.substrateColor = randomColor
                rotateAnalogStick.substrateColor = randomColor
            default:
                appleNode?.position = touch.locationInNode(self)
            }
        }
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
