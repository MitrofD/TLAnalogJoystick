# AnalogJoystick.swift

### Preview
![alt tag](https://lh3.googleusercontent.com/5fjvUhz-sGUh_ju5XZ8UlHDKfD6VXP8WuHgLL9AqZ5lw_vVR15hPsazjOdM8DlPZ4HygKOOjFdSGmJUJNBN9bsUFUVu8cF4gAQJeuILckOdCYVD9If8dSeEt4AUfsEm8wFrUbGlo0rtS8_wzCqfup-b55FBcaFLC4sSb3jA69elrv9CDrOZYUB8s068306anjhdfwL4omUP0pchNQsIPMFlUYbI0UDbHgo6TnqECJRRYqc3XL2Bs91gR4-r0-25kWniik3VfOrdBFQ0hWpl-XJWfoy09j8DEXsCKrsbxnUGINSjir3s2XL7T6GIKLuqbFcKQamFQcHt8hmSFZ60UWHKBMPqD-Y8p1hh-diHPfiiNfYVL0cMYQcsAeSHeE_bBIpP6qze-7wuJFAqSiWjPZ9NuymQDSMZUEZ-yb188U1m0N9FxtjCZUVwy40n3yzHwL6SaMYOseu8VVQCFJA0pceZVaLiRXuWC8-CW_e9P_KIPZOPiV-VX3iGbO9tkzkODBhdF7RIrsmD2TD7wBl6CB2D_r_o3GGPnnEreN7MTc8AD9UjhbCU3hQZ1hJmjMuwkG5JEq8y7VwDxRpyFrf9avcrFT9uaaiAzg5H2Es3fkYyBR0GCA_gX=w391-h220-no)

### Features
- begin handler 
- tracking handler
- stop handler
- set/change joystick diameter
- set/change stick && substrate colors
- set/change stick && substrate images

### Manual
1. Just drop the **AnalogJoystick.swift** file into your project.
2. That's it!

### Init examples:
***init with 100px diameter.Colors & images you can change later***
``` swift
let joystick = AnalogJoystick(diameter: 100)
// or
let joystick = 🕹(diameter: 100) // typealias AnalogJoystick = 🕹
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
let joystick = 🕹(diameter: 110) // let joystick = AnalogJoystick(diameter: 110)
```

### Handlers
- var beginHandler: (() -> Void)? // before move
- var trackingHandler: ((AnalogJoystickData) -> ())? // 
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
joystick.trackingHandler = { [unowned self] data in
  // something...
  // jData contains angular && velocity (data.angular, data.velocity)
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
