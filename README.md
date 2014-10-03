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
============================
<h3>Initialization</h3>
<p>
UIImage bgImage = UIImage(named: "bgImage")<br/>
UIImage thumbImage = UIImage(named: "thumbImage")
</p>
<ol>
	<li>
		<strong>With background and thumb image:</strong><br/>
		<p>
			let analogstick = AnalogStick(thumbImage: thumbImage, bgImage: bgImage)
		</p>
	</li>
	<li>
		<strong>With thumb image:</strong><br/>
		<p>
			let analogstick = AnalogStick(thumbImage: thumbImage)
		</p>
	</li>
	<li>
		<strong>With background image:</strong><br/>
		<p>
			let analogstick = AnalogStick(bgImage: bgImage)
		</p>
	</li>
</ol>
<p>
analogstick.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) // center position <br/>
self.addChild(analogstick)
</p>
