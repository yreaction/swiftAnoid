//
//  GameScene.swift
//  swiftAnoid
//
//  Created by Juan Pedro Lozano on 15/07/14.
//  Copyright (c) 2014 Juan Pedro Lozano. All rights reserved.
//

/*
    3 choices:
    Volume Base bodys: Dynamic affected by forces
                       Static still collide but are not move by the simulation (can be done with code)
    Edge Bodys: Invisible boundery
*/

import SpriteKit

class GameScene: SKScene {
    //ball Shape
    let ballNode = SKShapeNode(circleOfRadius: 25)
    let paddle = SKShapeNode (rectOfSize: CGSizeMake(100, 50))
    var ballImpulseVector = CGVectorMake(25, 50)
    var minMaxX:CGFloat {
        didSet {
        
        }
    }
    let rightBlockWall = SKShapeNode(rectOfSize: CGSizeMake(35,100))
    let leftBlockWall = SKShapeNode (rectOfSize: CGSizeMake(35,100))
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        // change gravity settings of physic world
        /* Force: applied over time like gravity, engines, jet pack, wind...
        Impulse: single instant kick */
       
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        addBall(self.size)
        addPlayer(self.size)

        /* Wall setUp */
        
    }
    
    func addWalls() {
        rightBlockWall.position = CGPointMake(25, CGRectGetMidY(self.frame))
        leftBlockWall.position = CGPointMake(self.frame.size.width-25/2, CGRectGetMidY(self.frame))
        rightBlockWall.fillColor = SKColor.greenColor()
        rightBlockWall.strokeColor = SKColor.clearColor()
        leftBlockWall.fillColor = rightBlockWall.fillColor
        leftBlockWall.strokeColor = rightBlockWall.fillColor
        self.addChild(rightBlockWall)
        self.addChild(leftBlockWall)
        /*add physics to Wall bricks*/
        rightBlockWall.physicsBody = SKPhysicsBody(rectangleOfSize: rightBlockWall.frame.size)
        rightBlockWall.physicsBody.dynamic = false
        leftBlockWall.physicsBody = SKPhysicsBody(rectangleOfSize: leftBlockWall.frame.size)
        leftBlockWall.physicsBody.dynamic = false
    }
    
    func addBall(size:CGSize) {
        /* Ball setUp */
        ballNode.position = CGPointMake(CGRectGetMidX(self.frame) - ballNode.frame.size.width/4, CGRectGetMidY(self.frame) - ballNode.frame.size.height/4)
        ballNode.fillColor = SKColor.redColor()
        ballNode.strokeColor = SKColor.clearColor()
        
        /*add physics to Ball        */
        
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: ballNode.frame.size.width/2)
        
        /*ball physics properties(0.0-1.0)
        friction: reduce velocity with contact, sometimes restitution can put in a static path an moving physic object forever, thats where's usefull
        linearDamping: resistance of moving object versus physicworld
        restitution: bouncines (rebote), o cuanta energia se pierde cada vez que choca
        speed after collision/speed before collision
        */
        
        ballNode.physicsBody.friction = 0.0
        ballNode.physicsBody.linearDamping = 0.0
        ballNode.physicsBody.restitution = 1.0
        
        self.addChild(ballNode)
        
        ballNode.physicsBody.applyImpulse(ballImpulseVector)

        
    }
    
    func addPlayer(size:CGSize) {
        paddle.position = CGPointMake(size.width/2, 100)
        paddle.strokeColor = SKColor.clearColor()
        paddle.fillColor = SKColor.blackColor()
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.frame.size)
        paddle.physicsBody.dynamic = false
        paddle.physicsBody.friction = 0.0
        self.addChild(paddle)
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        
        
    }
    
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)  {
        let touch:UITouch = touches.anyObject() as UITouch
        let position = touch.locationInNode(self)
        if CGRectContainsPoint(paddle.frame, position){
            paddle.position = CGPointMake({(paddle.position.x) -> CGFloat in return 0.0 } , paddle.position.y)
        }
    }


    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
      
    }
}

