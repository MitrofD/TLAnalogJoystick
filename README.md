# AnalogStick.swift

Virtual analog stick in swift with closures

**NOTES:**
- Support only Swift 2

## Installation
<ol>
<li>Just drop the **AnalogStick.swift** file into your project.</li>
<li>That's it!</li>
</ol>

## Preview
<img src="https://dl.dropboxusercontent.com/u/25298147/AnalogStickPreview.gif" />

## Initializations
### Designated:
``` swift
init(diameter: CGFloat, substrateImage: UIImage? = nil, stickImage: UIImage? = nil)
```

### Convenience:
``` swift
init(diameter: CGFloat, substrateImage: UIImage?)
init(diameter: CGFloat, stickImage: UIImage?)
```
**WHERE:**
- **diameter** is the diameter of the joystick
- **substrateImage** is the substrate image of the joystick
- **stickImage** is the stick image of the joystick
