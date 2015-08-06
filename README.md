# AnalogStick.swift

Virtual analog stick in swift with closures

**NOTES:**
- Support only Swift 2

## Preview
![alt tag](https://dl.dropboxusercontent.com/u/25298147/AnalogStickPreview.gif)

## Features
- set/change stick & substrate colors
- set/change stick & substrate images
- set/change joystick diameter
- tracking joystick with closures

## Manual
1. Just drop the **AnalogStick.swift** file into your project.
2. That's it!

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
- var trackingHandler: AnalogStickMoveHandler?
- var stickColor: UIColor
- var substrateColor: UIColor
- var stickImage: UIImage?
- var substrateImage: UIImage?
- var diameter: CGFloat

## Examples
### Create joystick
``` swift
let analogStick = AnalogStick(diameter: 120) // you can set images/color later
```
or with images
``` swift
let analogStick = AnalogStick(diameter: 120, substrateImage: UIImage(imageNamed: "yourImage", stickImage: UIImage(imageNamed: "yourImage")))
```
### Change colors
``` swift
  analogStick.stickColor = UIColor.redColor() // set red color to stick node
  analogStick.substrateColor = UIColor.purpleColor() // set purple color to substrate node
```
