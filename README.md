# AnalogJoystick.swift

### Preview
![Analog joustick](https://github.com/MitrophD/Swift-SpriteKit-Analog-Stick/blob/master/preview.gif?raw=true)

### Features
- Begin handler 
- Tracking handler
- Stop handler
- Set/change joystick diameter
- Set/change stick && substrate colors
- Set/change stick && substrate images

### Manual
1. Just drop the **AnalogJoystick.swift** file into your project.
2. That's it!

### Init examples:
***init with 100px diameter.Colors & images you can change later***
``` swift
let joystick = AnalogJoystick(diameter: 100)
// or
let joystick = 🕹(diameter: 100)
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
- **substrate** - substrate of joystick (AnalogJoystickSubstrate:AnalogJoystickComponent)
- **stick** - stick of joystick (AnalogJoystickStick:AnalogJoystickComponent)

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
let joystick = 🕹(diameter: 110) // it's equal let joystick = AnalogJoystick(diameter: 110)
```

### Handlers
- var beginHandler: (() -> Void)? // before move
- var trackingHandler: ((AnalogJoystickData) -> ())? // when move
- var stopHandler: (() -> Void)? // after move

### Computed Properties
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
joystick.beginHandler = { [unowned self] in
  // Something...
}

joystick.trackingHandler = { [unowned self] data in
  // Something...
  // data contains angular && velocity (data.angular, data.velocity)
}

joystick.stopHandler = { [unowned self] in
  // Something...
}
```
### Change diameter
``` swift
  joystick.diameter = 100 // set new diameter
```
### Change colors
``` swift
  joystick.stick.color = UIColor.yellow() // set yellow color to stick node
  joystick.substrate.color = UIColor.red() // set red color to substrate node
```
### Change images
``` swift
  joystick.stick.image = UIImage(imageNamed: "yourStickImage") // set image to stick node
  joystick.substrate.image = UIImage(imageNamed: "yourSubstrateImage") // set image to substrate node
```
## License

The MIT License (MIT)

Copyright (c) 2015...2017 Dmitriy Mitrophanskiy

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
