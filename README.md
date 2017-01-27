# AnalogJoystick.swift

### Preview
![alt tag](https://dl.dropboxusercontent.com/u/25298147/AnalogStickPreview.gif)

### Features
- tracking joystick with closures
- set/change joystick diameter
- set/change stick & substrate colors
- set/change stick & substrate images

### Manual
1. Just drop the **AnalogJoystick.swift** file into your project.
2. That's it!

### Init examples:
***init with 100px diameter.Colors & images you can change later***
``` swift
let joystick = AnalogJoystick(diameter: 100)
```
***Substrate has 100px diameter, stick has 50px diameter***
``` swift
let joystick = AnalogJoystick(diameters: (100, 50))
```
***init with 100px diameter.Substrate has blue color, stick has yellow color***
``` swift
let joystick = AnalogJoystick(diameter: 100, colors: (UIColor.blue(), UIColor.yellow()))
```
***init with 100px diameter.Substrate has "substrate" image, stick has "stick" image***
``` swift
let joystick = AnalogJoystick(diameter: 100, images: (UIImage(named: "substrate"), UIImage(named: "stick")))
```
***init with 100px diameter.Substrate has blue color && "substrate" image, stick has yellow color && "stick" image***
``` swift
let joystick = AnalogJoystick(diameter: 100, colors: (UIColor.blue(), UIColor.yellow()), images: (UIImage(named: "substrate"), UIImage(named: "stick")))
```
***init with substrate && stick diameters.Substrate has blue color && "substrate" image, stick has yellow color && "stick" image***
``` swift
let joystick = AnalogJoystick(diameters: (100, 50), colors: (UIColor.blue(), UIColor.yellow()), images: (UIImage(named: "substrate"), UIImage(named: "stick")))
```
***init with substrate && stick diameters.Substrate has blue color, stick has yellow color***
``` swift
let joystick = AnalogJoystick(diameters: (100, 50), colors: (UIColor.blue(), UIColor.yellow()))
```
***init with substrate && stick diameters.Substrate has "substrate" image, stick has "stick" image***
``` swift
let joystick = AnalogJoystick(diameters: (100, 50), images: (UIImage(named: "substrate"), UIImage(named: "stick")))
```

### Designated initializator
``` swift
init(substrate: AnalogJoystickSubstrate, stick: AnalogJoystickStick)
```
**WHERE:**
- **substrate** Substrate of joystick (AnalogJoystickSubstrate:AnalogJoystickComponent)
- **stick** Stick of joystick (AnalogJoystickStick:AnalogJoystickComponent)

### Convenience initializators:
``` swift
convenience init(diameters: (substrate: CGFloat, stick: CGFloat?), colors: (substrate: UIColor?, stick: UIColor?)? = nil, images: (substrate: UIImage?, stick: UIImage?)? = nil)
convenience init(diameter: CGFloat, colors: (substrate: UIColor?, stick: UIColor?)? = nil, images: (substrate: UIImage?, stick: UIImage?)? = nil)
```

### Typealias
``` swift
typealias AnalogJoystick = 🕹
```
## Example
``` swift
let joystick =  🕹(diameter: 110) // let joystick = AnalogJoystick(diameter: 110)
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
let joystick = AnalogJoystick(diameter: 100) // you can set images/color later
```
**or with images**
``` swift
let joystick = AnalogJoystick(diameter: 100, images: (UIImage(named: "substrate"), UIImage(named: "stick")))
```
### Tracking With Closure
``` swift
joystick.trackingHandler = { jData in
  // something...
  // jData contains angular && velocity (jData.angular, jData.velocity)
}
```
**or**
``` swift
func handlerTracking(data: AnalogJoystickData) {
  self.appleNode?.zRotation = jData.angular
  // something...
  // jData contains angular && velocity (jData.angular, jData.velocity)
}

joystick.trackingHandler = handlerTracking
```
### Change diameter
``` swift
  joystick.diameter = 100 // set new diameter
```
### Change colors
``` swift
  joystick.stickColor = UIColor.red() // set red color to stick node
  joystick.substrateColor = UIColor.purple() // set purple color to substrate node
```
### Change images
``` swift
  joystick.stickImage = UIImage(imageNamed: "yourStickImage") // set image to stick node
  joystick.substrateColor = UIImage(imageNamed: "yourSubstrateImage") // set image to substrate node
```
## License

The MIT License (MIT)

Copyright (c) 2015..2017 Dmitriy Mitrophanskiy

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
