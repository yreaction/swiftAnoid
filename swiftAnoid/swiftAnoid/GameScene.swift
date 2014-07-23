//
//  GameScene.swift
//  swiftAnoid
//
//  Created by Juan Pedro Lozano on 15/07/14.
//  Copyright (c) 2014 Juan Pedro Lozano. All rights reserved.
//

/* Up to 32 Categories using bitmasking 
    Why : 32 bytes or 4 bits
    Can be used as a switch
    Add the categories to the physics bodies
    Default settings: only as collision but not contacts
    physicbody.contactBitMask = 0000..
    physicbody.collisionBitMask = 1111....
    physicbody.categoryBitMask = 1111...
*/

/*
    3 choices:
    Volume Base bodys: Dynamic affected by forces
                       Static still collide but are not move by the simulation (can be done with code)
    Edge Bodys: Invisible boundery
*/

import SpriteKit

enum gameCollCategories:UInt32 {
    case ballCategory = 1 //00000000000000000000000000000001
    case brickCategory = 2 //00000000000000000000000000000010
    case paddleCategory = 4
    case edgeCategory = 8
    case bottomEdgeCategory = 16
}

struct categoriasCollision {
    var ballCategory = 0x01
}
class GameScene: SKScene,SKPhysicsContactDelegate  {
    //bitmasks categories
    var minMaxX:CGFloat = 0.0 {
        didSet(newMinMaxX) {
            if newMinMaxX < 50 {minMaxX = 50}
            else if newMinMaxX > 280 {minMaxX = 280}
        }
    }
    
    //constants & vars
    let ballNode = SKShapeNode(circleOfRadius: 15)
    let paddle = SKShapeNode (rectOfSize: CGSizeMake(120, 55))
    let rightBlockWall = SKShapeNode(rectOfSize: CGSizeMake(35,100))
    let leftBlockWall = SKShapeNode (rectOfSize: CGSizeMake(35,100))
    var bottomEdg = SKNode()
    var ballImpulseVector = CGVectorMake(5.0, 10.0)
    var brickCount = 15
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor.grayColor()
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody.friction = 0.1
        self.physicsBody.linearDamping = 0
        self.physicsBody.restitution = 0
        self.physicsBody.categoryBitMask = gameCollCategories.edgeCategory.toRaw()
        
        // change gravity settings of physic world
        /* Force: applied over time like gravity, engines, jet pack, wind...
        Impulse: single instant kick */
       
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        
        addBall(self.size)
        addPlayer(self.size)
        addBricks(self.size)
        addBottomEdge(self.size)
    }
    
    func removeBrick(theBrick:SKNode) {
        let brick:SKShapeNode = theBrick as SKShapeNode
        brick.fillColor = SKColor.redColor()
        let explodeParticle = SKEmitterNode(fileNamed: "spark")
        explodeParticle.setScale(0.5)
        self.addChild(explodeParticle)
        explodeParticle.position = CGPointMake (theBrick.position.x,CGRectGetMinY(theBrick.frame))

        let brickExplosion = SKAction.sequence([SKAction.scaleBy(0.2, duration: 0.1), SKAction.scaleBy(-1, duration: 0.2)])
        theBrick.runAction(brickExplosion, completion: {() -> Void in
            theBrick.removeFromParent()
            })
        --brickCount
        ballNode.physicsBody.applyImpulse(CGVector(25/brickCount,-25/brickCount))
    }
    
    func didBeginContact(contact: SKPhysicsContact!) {
        //placeholder for nonball objects
        var notTheBall:SKPhysicsBody?;
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            notTheBall = contact.bodyB
        } else {
            notTheBall = contact.bodyA
        }
        if notTheBall?.categoryBitMask == gameCollCategories.brickCategory.toRaw() {
            //Brick touch
            self.removeBrick(notTheBall!.node)
           
        } else {
            //Paddle
        }
        if notTheBall?.categoryBitMask == gameCollCategories.bottomEdgeCategory.toRaw() {
            let endScene = EndScene(size: self.size)
            self.view.presentScene(endScene, transition: SKTransition.doorsCloseHorizontalWithDuration(0.2))
        }
    }
    
    func addBottomEdge (size:CGSize) {
        bottomEdg.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointMake(0, 1), toPoint: CGPointMake(size.width, 1))
        bottomEdg.physicsBody.categoryBitMask = gameCollCategories.bottomEdgeCategory.toRaw()
        self.addChild(bottomEdg)
    }
    
    func addBricks (size:CGSize) {
        for x in 0...2{
            for i in 0...4{
                let brickNode = SKShapeNode(rectOfSize: CGSizeMake(50, 50))
                brickNode.fillColor = SKColor.greenColor()
                brickNode.strokeColor = SKColor.clearColor()
                brickNode.physicsBody = SKPhysicsBody(rectangleOfSize: brickNode.frame.size)
                brickNode.physicsBody.dynamic = false
                brickNode.physicsBody.categoryBitMask = gameCollCategories.brickCategory.toRaw()
                brickNode.position = CGPointMake(size.width/6 * (CGFloat(i+1)), size.height - (CGFloat((x+1)*55)))
                self.addChild(brickNode)
            }
        }
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
        //add category
        
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
        
        ballNode.physicsBody.friction = 0
        ballNode.physicsBody.linearDamping = 0
        ballNode.physicsBody.restitution = 1.0
        //add category
        ballNode.physicsBody.categoryBitMask = gameCollCategories.ballCategory.toRaw()
        ballNode.physicsBody.contactTestBitMask = gameCollCategories.brickCategory.toRaw() | gameCollCategories.paddleCategory.toRaw() | gameCollCategories.bottomEdgeCategory.toRaw()
        //ballNode.physicsBody.collisionBitMask = gameCollCategories.edgeCategory.toRaw()
        
        self.addChild(ballNode)
        ballNode.physicsBody.applyImpulse(ballImpulseVector)
        ballNode.physicsBody.applyTorque(5.0)
    }
    
    func addPlayer(size:CGSize) {
        paddle.position = CGPointMake(size.width/2, 100)
        paddle.strokeColor = SKColor.clearColor()
        paddle.fillColor = SKColor.whiteColor()
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.frame.size)
        paddle.physicsBody.dynamic = false
        paddle.physicsBody.friction = 0.0
        paddle.physicsBody.restitution = 1.0
        paddle.physicsBody.categoryBitMask = gameCollCategories.paddleCategory.toRaw()
        self.addChild(paddle)
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        
        
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)  {
        let touch:UITouch = touches.anyObject() as UITouch
        let position = touch.locationInNode(self)
        if CGRectContainsPoint(paddle.frame, position){
            var newPosition =  CGPointMake(position.x, paddle.position.y)
            if position.x < paddle.frame.size.width/2 {
                newPosition.x = paddle.frame.size.width/2
            }
            if position.x > self.frame.size.width - paddle.frame.size.width/2 {
                newPosition.x = self.frame.size.width - paddle.frame.size.width/2
            }
            paddle.position = newPosition

        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if brickCount == 0 {
            let scene = GameScene(size: self.size)
            self.view.presentScene(scene)
        }
      
    }
    
    /*
    NOCIONES DE COLISION Y CONTACTO
    Collision: prevent objects from intersecting
     Contact: When we need to know two objects touch so we can change the gampeplay, is not default and it requieres work optin
    Contact without collision - Something pass something but theres no colission
    Categories: Describe interaction when objects of different categories touch
     Examples:
        Ball / paddle : Shoudl collide
        Ball/brick : should collide and contact
        Ball/Ball : Nothing
    */
    
    
}

