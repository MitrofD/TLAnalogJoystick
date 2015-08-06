# AnalogStick.swift

Virtual analog stick in swift with closures

**NOTES:**
- Support only Swift 2

## Preview
<img src="https://dl.dropboxusercontent.com/u/25298147/AnalogStickPreview.gif" />

## Features
- set/change stick & substrate colors
- set/change stick & substrate images
- set/change joystick diameter
- tracking joystick with closures

## Manual
<ol>
<li>Just drop the **AnalogStick.swift** file into your project.</li>
<li>That's it!</li>
</ol>

### Convenience initializators:
``` swift
init(diameter: CGFloat, substrateImage: UIImage?)
init(diameter: CGFloat, stickImage: UIImage?)
```

### Designated initializator
``` swift
init(diameter: CGFloat, substrateImage: UIImage? = nil, stickImage: UIImage? = nil)
```

**WHERE:**
- **diameter** is the diameter of the joystick
- **substrateImage** is the substrate image of the joystick
- **stickImage** is the stick image of the joystick

### Typealias
``` swift
typealias AnalogStickMoveHandler = (AnalogStick) -> ()
```

### Computed Properties
- ``` swift var trackingHandler: AnalogStickMoveHandler?```
- var stickColor: UIColor
- var substrateColor: UIColor
- var stickImage: UIImage?
- var substrateImage: UIImage?
- var diameter: CGFloat


