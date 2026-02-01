# AnalogJoystick

A lightweight, fully customizable analog joystick for **SpriteKit** on iOS. Supports single-touch tracking, moveable base, dead zone, velocity exponent tuning, and an optional hidden-area mode for floating joystick placement.

---

## Features

- **Single-touch multi-finger safe** — each joystick locks to its own `UITouch`, ignoring other fingers
- **Moveable base** — enable `isMoveable` to let the joystick drift with the finger
- **Hidden-area mode** — place the joystick anywhere inside a transparent `AnalogJoystickHiddenArea`; it appears on first touch and disappears on release
- **Dead zone** — configurable threshold below which velocity reads zero
- **Velocity exponent** — non-linear velocity curve for finer low-speed control
- **Event system** — subscribe to `.begin`, `.move`, `.end` with named handlers; unsubscribe at any time
- **Fully skinnable** — set solid colors or custom `UIImage` textures on both the base and handle independently
- **Smooth reset** — handle animates back to center on release (configurable `resetDuration`)

---

## Installation

Copy `AnalogJoystick.swift` into your SpriteKit project. No dependencies beyond UIKit and SpriteKit.

---

## Quick Start

```swift
// 1. Create a joystick with a 150 pt diameter, handle is 60 % of that by default
let joystick = AnalogJoystick(withDiameter: 150)

// 2. Position and add to your scene
joystick.position = CGPoint(x: 100, y: 100)
scene.addChild(joystick)

// 3. React to input
joystick.on(.move) { joystick in
    let speed: CGFloat = 5
    player.position.x += joystick.velocity.x * speed
    player.position.y += joystick.velocity.y * speed
}
```

---

## Core API

### `AnalogJoystick`

| Property | Type | Default | Description |
|---|---|---|---|
| `deadZone` | `CGFloat` | `0.05` | Normalized threshold; input below this is treated as zero |
| `velocityExponent` | `CGFloat` | `1.5` | Exponent applied to normalized velocity (1.0 = linear) |
| `isMoveable` | `Bool` | `false` | When `true`, the joystick base follows the finger |
| `resetDuration` | `TimeInterval` | `0.15` | Seconds the handle takes to animate back to center |
| `velocity` | `CGPoint` | — | Read-only. Normalized (-1…1) velocity after dead-zone and exponent |
| `angular` | `CGFloat` | — | Read-only. Angle in radians derived from `velocity` |
| `disabled` | `Bool` | `false` | Disables touch input and stops tracking |
| `diameter` / `radius` | `CGFloat` | — | Get/set the overall joystick size |
| `handleRatio` | `CGFloat` | `0.6` | Ratio of handle diameter to base diameter |

#### Colors & Images

```swift
joystick.baseColor   = .gray
joystick.handleColor = .white
joystick.baseImage   = UIImage(named: "joystick-base")
joystick.handleImage = UIImage(named: "joystick-thumb")
```

When an image is set it takes priority over the color for that component.

#### Events

```swift
// Subscribe — returns an ID you can use to unsubscribe later
let id = joystick.on(.begin) { _ in print("touch started") }
joystick.on(.move)          { j in print("velocity: \(j.velocity)") }
joystick.on(.end)           { _ in print("touch ended") }

// Unsubscribe
joystick.off(handlerID: id)
```

| Event | Fires when |
|---|---|
| `.begin` | Finger touches the handle |
| `.move` | Every frame while the joystick is being dragged |
| `.end` | Finger lifts or the touch is cancelled |

---

## Hidden-Area (Floating) Joystick

`AnalogJoystickHiddenArea` is an invisible `SKShapeNode` that spawns the joystick exactly where the player first touches, then hides it again on release — ideal for mobile games where a fixed joystick position wastes screen space.

```swift
// Create a hidden area covering the left half of the screen
let area = AnalogJoystickHiddenArea(
    rect: CGRect(x: 0, y: 0, width: scene.frame.width / 2, height: scene.frame.height)
)
area.lineWidth = 0          // make it fully invisible
area.joystick = joystick    // attach your joystick
area.joystick?.isMoveable = true
scene.addChild(area)
```

The joystick is hidden by default and appears at the exact touch point on `touchesBegan`.

---

## Advanced: Custom Components

Both the base and handle are instances of `AnalogJoystickComponent`. You can create them manually for full control:

```swift
let base   = AnalogJoystickComponent(diameter: 200, color: .systemBlue)
let handle = AnalogJoystickComponent(diameter: 80,  image: UIImage(named: "thumb"))

let joystick = AnalogJoystick(withBase: base, handle: handle)
```

`AnalogJoystickComponent` renders itself as a clipped circle — either filled with its `color` or drawn with the provided `UIImage`.

---

## Velocity Math (under the hood)

1. The raw handle offset is divided by the base radius → normalized to the unit circle.
2. The vector length is clamped to **1.0**.
3. A smooth dead zone is applied: values below `deadZone` become `0`; values above are rescaled into the full 0…1 range.
4. The `velocityExponent` is applied per-axis via `pow`, giving a non-linear feel curve.

Setting `velocityExponent` to **1.0** gives perfectly linear response; values above 1.0 (default **1.5**) make low-speed movement feel more precise.

---

## License

Copyright © 2024 Dmitriy Mitrofansky. All rights reserved.
