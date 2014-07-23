//
//  EndScene.swift
//  anoid
//
//  Created by Juan Pedro Lozano on 18/07/14.
//  Copyright (c) 2014 Juan Pedro Lozano. All rights reserved.
//

import SpriteKit

class EndScene: SKScene {
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blackColor()
        let endGameLabel = SKLabelNode(text:"GAME OVER")
        endGameLabel.fontColor = SKColor.whiteColor()
        endGameLabel.fontName  = "Futura Medium"
        endGameLabel.fontSize = 50
        endGameLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        
        
        self.addChild(endGameLabel)
        

    }
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        let repeatGame = GameScene(size: self.size)
        self.view.presentScene(repeatGame, transition: SKTransition.doorsOpenHorizontalWithDuration(0.3))
    }
}
