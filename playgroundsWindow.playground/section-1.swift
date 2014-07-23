import SpriteKit
import XCPlayground


/*for i in 0.0...100.0 {
    cos(i / 10)
}*/

func addTriangle(scene: SKScene) -> Void {
}

let sceneWidth = 500
let sceneHeight = 200
let skView = SKView(frame: NSRect(x: 0, y: 0, width: sceneWidth, height: sceneHeight))
let skScene = SKScene(size: CGSize(width:sceneWidth, height:sceneHeight))
skScene.backgroundColor = SKColor.redColor()

skView.presentScene(skScene)

//

XCPShowView("Vista preliminar", skView)