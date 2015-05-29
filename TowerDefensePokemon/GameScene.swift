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
    var koffing: SKSpriteNode!
    var area: SKShapeNode!
    
    struct PhysicsCategory {
        static let None: UInt32 = 0
        static let Charmander: UInt32 = 0b001
        static let Background: UInt32 = 0b010
    }
    
    override func didMoveToView(view: SKView) {
        createPhysicsWorld()
        createEnvironment()
        createCharmander(CGPointMake(self.frame.midX, self.frame.midY))
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch =  touches.first as? UITouch {
            let location = touch.locationInNode(self)
            
            moveCharmander(location)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
    }
    
    func createPhysicsWorld() {
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
    }
    
    func createEnvironment() {
        let background = SKSpriteNode(imageNamed: "background-pallet")
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
        var texture = SKTexture(imageNamed: "charmander-1")
        charmander = SKSpriteNode(texture: texture)
        charmander.xScale = 0.75
        charmander.yScale = 0.75
        charmander.position = positionToCreate
        charmander.anchorPoint = CGPointMake(0.55, 0.3)
        charmander.physicsBody = SKPhysicsBody(circleOfRadius: 20.0)
        charmander.physicsBody?.allowsRotation = false
        charmander.physicsBody?.dynamic = true
        charmander.physicsBody?.restitution = 0
        charmander.physicsBody?.linearDamping = 0
        charmander.physicsBody?.categoryBitMask = PhysicsCategory.Charmander
        charmander.physicsBody?.contactTestBitMask = PhysicsCategory.Background
        charmander.physicsBody?.collisionBitMask = PhysicsCategory.Background
        
        self.addChild(charmander)
        
        let animationTexture = SKAction.animateWithTextures(createTexturesForCharmander(), timePerFrame: 0.3)
        var charmanderAnimation = SKAction.repeatActionForever(animationTexture)
        charmander.runAction(charmanderAnimation)
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
        charmander.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
        charmander.physicsBody?.applyForce(vector, atPoint: CGPointMake(location.x, location.y))
    }
    
    func createTexturesForCharmander() -> [SKTexture] {
        var textures : [SKTexture] = []
        
        for i in 1...3 {
            var name = "charmander-\(i)"
            println(name)
            var texture = SKTexture(imageNamed: name)
            textures += [texture]
        }
        
        return textures
    }
    
    func createTexturesForKoffing() -> [SKTexture] {
        var textures : [SKTexture] = []
        
        for i in 1...3 {
            var name = "koffing-\(i)"
            println(name)
            var texture = SKTexture(imageNamed: name)
            textures += [texture]
        }
        
        return textures
    }
}
