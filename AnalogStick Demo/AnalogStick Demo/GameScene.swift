//
//  GameScene.swift
//  stick test
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//  Copyright (c) 2014 Dmitriy Mitrophanskiy. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, AnalogStickProtocol {
    var appleNode: SKSpriteNode?
    let moveAnalogStick: AnalogStick = AnalogStick()
    let rotateAnalogStick: AnalogStick = AnalogStick()
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let bgDiametr: CGFloat = 120
        let thumbDiametr: CGFloat = 60
        let joysticksRadius = bgDiametr / 2
        moveAnalogStick.bgNodeDiametr = bgDiametr
        moveAnalogStick.thumbNodeDiametr = thumbDiametr
        moveAnalogStick.position = CGPointMake(joysticksRadius + 15, joysticksRadius + 15)
        moveAnalogStick.delagate = self
        self.addChild(moveAnalogStick)
        rotateAnalogStick.bgNodeDiametr = bgDiametr
        rotateAnalogStick.thumbNodeDiametr = thumbDiametr
        rotateAnalogStick.position = CGPointMake(CGRectGetMaxX(self.frame) - joysticksRadius - 15, joysticksRadius + 15)
        rotateAnalogStick.delagate = self
        self.addChild(rotateAnalogStick)
        // apple
        appleNode = SKSpriteNode(imageNamed: "apple")
        if let aN = appleNode {
            aN.physicsBody = SKPhysicsBody(texture: aN.texture, size: aN.size)
            aN.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            aN.physicsBody?.affectedByGravity = false;
            self.insertChild(aN, atIndex: 0)
        }
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        addOneApple()
    }
    
    func addOneApple()->Void {
        let appleNode = SKSpriteNode(imageNamed: "apple");
        appleNode.physicsBody = SKPhysicsBody(texture: appleNode.texture, size: appleNode.size)
        appleNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        appleNode.physicsBody?.affectedByGravity = false;
        self.addChild(appleNode)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        super.touchesBegan(touches, withEvent: event)
        
        if let touch = touches.first as? UITouch {
            
            appleNode?.position = touch.locationInNode(self)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: AnalogStickProtocol
    func moveAnalogStick(analogStick: AnalogStick, velocity: CGPoint, angularVelocity: Float) {
        if let aN = appleNode {
            if analogStick.isEqual(moveAnalogStick) {
                aN.position = CGPointMake(aN.position.x + (velocity.x * 0.12), aN.position.y + (velocity.y * 0.12))
            } else if analogStick.isEqual(rotateAnalogStick) {
                aN.zRotation = CGFloat(angularVelocity)
            }
        }
    }
}
