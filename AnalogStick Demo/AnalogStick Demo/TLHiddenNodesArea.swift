//
//  TLHiddenNodesArea.swift
//  tyApplyApp company
//
//  Created by Dmitriy Mitrophanskiy on 3/2/19.
//  Copyright © 2019 Dmitriy Mitrophanskiy. All rights reserved.
//

import SpriteKit

open class TLHiddenNodesArea: SKShapeNode {
	open override var isUserInteractionEnabled: Bool {
		get {
			return true
		}
		
		set {}
	}

	open override func addChild(_ node: SKNode) {
		cancelNode(node)
		super.addChild(node)
	}
	
	public func cancelNode(_ node: SKNode) {
		node.isHidden = true
	}
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first!
		
		for node in children {
			node.position = touch.location(in: self)
			node.isHidden = false
			node.touchesBegan(touches, with: event)
		}
	}
	
	open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for node in children {
			node.touchesMoved(touches, with: event)
		}
	}
	
	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for node in children {
			node.touchesEnded(touches, with: event)
			cancelNode(node)
		}
	}
	
	open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		for node in children {
			node.touchesCancelled(touches, with: event)
			cancelNode(node)
		}
	}
}
