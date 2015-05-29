//
//  GameScene.swift
//  TowerDefensePokemon
//
//  Created by Victor Magalhães on 11/05/15.
//  Copyright (c) 2015 Victor Magalhães. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var charmander: SKSpriteNode!
    var area : SKShapeNode!
    var charmanderIsMoving: Bool = false
    
    struct PhysicsCategory {
        static let None: UInt32 = 0
        static let Charmander: UInt32 = 0b001
        static let Background: UInt32 = 0b010
    }
    
    override func didMoveToView(view: SKView) {
        setupPhysicsWorld()
        createBackground()
        createCharmander(CGPointMake(self.frame.midX, self.frame.midY))
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch =  touches.first as? UITouch {
            let location = touch.locationInNode(self)
            
            moveCharmander(location)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func setupPhysicsWorld() {
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
    }
    
    func createBackground() {
        let background = SKSpriteNode(imageNamed: "Background")
        background.anchorPoint = CGPointMake(0.0, 1.0)
        background.size = self.frame.size
        background.position = CGPointMake(self.frame.minX, self.frame.maxY)

        let navigationArea = CGPathCreateMutable()
        CGPathMoveToPoint(navigationArea, nil, self.frame.minX, self.frame.maxY - 45.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.maxX, self.frame.maxY - 45.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.maxX, self.frame.maxY - 90.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.maxX - 98.0, self.frame.maxY - 90.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.maxX - 98.0, self.frame.maxY - 220.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.maxX, self.frame.maxY - 220.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.maxX, self.frame.maxY - 265.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.maxX - 126.0, self.frame.maxY - 265.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.maxX - 126.0, self.frame.maxY - 265.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.maxX - 126.0, self.frame.maxY - 395.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.maxX, self.frame.maxY - 395.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.maxX, self.frame.minY)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.minX + 138.0, self.frame.minY)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.minX + 138.0, self.frame.minY + 88.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.minX, self.frame.minY + 88.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.minX, self.frame.minY + 350.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.minX + 109.0, self.frame.minY + 350.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.minX + 109.0, self.frame.minY + 480.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.minX, self.frame.minY + 480.0)
        CGPathAddLineToPoint(navigationArea, nil, self.frame.minX, self.frame.maxY)
        CGPathCloseSubpath(navigationArea)
        
        area = SKShapeNode(path: navigationArea)
        area.physicsBody = SKPhysicsBody(edgeChainFromPath: navigationArea)
        
        area.physicsBody?.dynamic = false
        area.physicsBody?.restitution = 0
        area.physicsBody?.categoryBitMask = PhysicsCategory.Background
        area.physicsBody?.contactTestBitMask = PhysicsCategory.Background
        area.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        self.addChild(area)
        self.addChild(background)
    }
    
    func createCharmander(positionToCreate: CGPoint) {
        var texture = SKTexture(imageNamed: "charmander-001")
        charmander = SKSpriteNode(texture: texture)
        charmander.position = positionToCreate
        charmander.anchorPoint = CGPointMake(0.55, 0.25)
        charmander.physicsBody = SKPhysicsBody(circleOfRadius: 20.0)
        charmander.physicsBody?.allowsRotation = false
        charmander.physicsBody?.dynamic = true
        charmander.physicsBody?.restitution = 0
        charmander.physicsBody?.linearDamping = 0
        charmander.physicsBody?.categoryBitMask = PhysicsCategory.Charmander
        charmander.physicsBody?.contactTestBitMask = PhysicsCategory.Background
        charmander.physicsBody?.collisionBitMask = PhysicsCategory.Background
        
            
        self.addChild(charmander)
    }
    
    func convertToRadians(angle: CGFloat) -> CGFloat {
        return angle - CGFloat(M_PI_2)
    }
    
    func moveCharmander(location: CGPoint) {
        let dy = location.y - charmander.position.y
        let dx = location.x - charmander.position.x
        let hipo = sqrt(pow(dx, 2) + pow(2, dy))
//            
//        let angle = atan2(dy, dx)
//        let radAngle = convertToRadians(angle)
            
        var vector = CGVectorMake(dx, dy)
            
        charmander.physicsBody?.applyForce(vector)
        charmanderIsMoving = true
    }
}
