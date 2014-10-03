Swift-SpriteKit-Analog-Stick
============================
<h2>How to use:</h2>
<ol>
<li>Import "AnalogStick" folder to your project</li>
<li>Use</li>
</ol>
============================
<h3>Description</h3>
<p>Virtual alternative analog joystick </p>
<img src="https://dl.dropboxusercontent.com/u/25298147/IMG_2251.PNG" />
============================
<h3>Initialization</h3>
<p>
UIImage bgImage = UIImage(named: "bgImage")<br/>
UIImage thumbImage = UIImage(named: "thumbImage")
</p>
<ol>
	<li>
		<strong>With background and thumb image:</strong><br/>
		<p>let analogstick = AnalogStick(thumbImage: thumbImage, bgImage: bgImage)</p>
	</li>
	<li>
		<strong>With thumb image:</strong><br/>
		<p>let analogstick = AnalogStick(thumbImage: thumbImage)</p>
	</li>
	<li>
		<strong>With background image:</strong><br/>
		<p>let analogstick = AnalogStick(bgImage: bgImage)</p>
	</li>
</ol>
<p>
analogstick.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) // center position <br/>
self.addChild(analogstick)
</p>
============================
<h3>AnalogStickProtocol</h3>
<p>
@objc protocol AnalogStickProtocol {
    func moveAnalogStick(analogStick: AnalogStick, velocity: CGPoint, angularVelocity: Float)
}<br/>
func moveAnalogStick(analogStick: AnalogStick, velocity: CGPoint, angularVelocity: Float) - change position of the cursor<br/>
</p>
<ul>
	<li>var bgNodeDiametr: CGFloat // get/set background node diametr </li>
	<li>var thumbNodeDiametr: CGFloat // get/set thumb node diametr </li>
	<li>let thumbNode: SKSpriteNode, bgNode: SKSpriteNode // thumb & background nodes (readonly)</li>
</ul>
============================
<h3>Methods</h3>
<ul>
	<li>func setBgImage(image: UIImage?, sizeToFit: Bool) // set background node image; sizeToFit - resize or not resize to image size </li>
	<li>func setThumbImage(image: UIImage?, sizeToFit: Bool) // set thumb node image; sizeToFit - resize or not resize to image size </li>
</ul>
