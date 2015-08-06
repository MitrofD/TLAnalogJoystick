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
- var trackingHandler: AnalogStickMoveHandler? (get/set)
- var stickColor: UIColor (get/set)
- var substrateColor: UIColor (get/set)
- var stickImage: UIImage? (get/set)
- var substrateImage: UIImage? (get/set)
- var diameter: CGFloat (get/set)

## Examples
### Create joystick
``` swift
let analogStick = AnalogStick(diameter: 120) // you can set images/color later
```
**or with images**
``` swift
let analogStick = AnalogStick(diameter: 120, substrateImage: UIImage(imageNamed: "yourImage"), stickImage: UIImage(imageNamed: "yourImage")))
```
### Change diameter
``` swift
  analogStick.diameter = 100 // set new diameter
```
### Change colors
``` swift
  analogStick.stickColor = UIColor.redColor() // set red color to stick node
  analogStick.substrateColor = UIColor.purpleColor() // set purple color to substrate node
```
### Change images
``` swift
  analogStick.stickImage = UIImage(imageNamed: "yourStickImage") // set image to stick node
  analogStick.substrateColor = UIImage(imageNamed: "yourSubstrateImage") // set image to substrate node
```
