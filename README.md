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
init(diameter: CGFloat)
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
### Tracking With Closure
``` swift
  analogStick.trackingHandler = { analogStick in
      //  something...
  }
```
**or**
``` swift
  func handlerTracking(analogStick: AnalogStick) {
    //  something...
  }
  
  analogStick.trackingHandler = handlerTracking
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
## License

The MIT License (MIT)

Copyright (c) 2015 Dmitriy Mitrophanskiy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
