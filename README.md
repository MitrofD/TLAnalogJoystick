# AnalogJoystick-SpriteKit

[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)  
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20iPadOS-lightgrey.svg)](https://developer.apple.com/ios/)

**AnalogJoystick-SpriteKit** is a fully customizable virtual joystick for SpriteKit games, designed for responsive touch controls and smooth interactions.  

It supports:

- Multi-touch input via `AnalogJoystickHiddenArea`
- Configurable size, colors, and images for joystick handle and base
- Dead zone with smooth adaptive sensitivity
- Event handling for `.begin`, `.move`, and `.end`
- Real-time object movement and rotation
- `isMoveable` feature to allow joystick repositioning on the screen

---

## Installation

Simply add the `AnalogJoystick.swift` file to your SpriteKit project.

- Compatible with iOS 13+
- Written in Swift 5
- No external dependencies

---

## Main Classes

### AnalogJoystickComponent

Represents a joystick part (handle or base).

**Properties:**

- `diameter: CGFloat` – the diameter of the joystick part
- `radius: CGFloat` – the radius
- `color: UIColor` – fill color
- `image: UIImage?` – optional custom image

---

### AnalogJoystick

The main joystick class.

**Properties:**

- `deadZone: CGFloat` – ignore small movements inside this threshold (default 0.05)
- `velocityExponent: CGFloat` – controls sensitivity curve (default 1.5)
- `isMoveable: Bool` – allow dragging the joystick around the screen
- `handleRatio: CGFloat` – size ratio of handle relative to base
- `velocity: CGPoint` – current velocity of the joystick
- `angular: CGFloat` – current angle in radians
- `disabled: Bool` – enable/disable joystick

**Events:**

- `.begin` – triggered when touch begins
- `.move` – triggered on movement
- `.end` – triggered when touch ends

**Example Usage:**

```swift
let moveJoystick = AnalogJoystick(withDiameter: 100)
let rotateJoystick = AnalogJoystick(withDiameter: 100)

moveJoystick.on(.move) { joystick in
    appleNode.position.x += joystick.velocity.x * 5
    appleNode.position.y += joystick.velocity.y * 5
}

rotateJoystick.on(.move) { joystick in
    appleNode.zRotation = joystick.angular
}

### AnalogJoystickHiddenArea

A touch area that automatically shows and hides the joystick when touched.

**Usage Example:**

```swift
let moveJoystickArea = AnalogJoystickHiddenArea(rect: CGRect(x: 0, y: 0, width: frame.midX, height: frame.height))
moveJoystickArea.joystick = moveJoystick
moveJoystickArea.isUserInteractionEnabled = true
addChild(moveJoystickArea)
