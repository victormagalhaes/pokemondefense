//
//  GameScene.swift
//  TowerDefensePokemon
//
//  Created by Victor Magalhães on 11/05/15.
//  Copyright (c) 2015 Victor Magalhães. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    var charmander: SKSpriteNode!
    var koffing: SKSpriteNode!
    var area: SKShapeNode!
    var scoreNode = SKLabelNode()
    var score: Int = 25
    var backgroundMusicPlayer: AVAudioPlayer!
    var isGamePaused: Bool = false
    
    struct PhysicsCategory {
        static let None: UInt32 = 0
        static let Charmander: UInt32 = 0b001
        static let Background: UInt32 = 0b010
        static let Koffing: UInt32 = 0b011
    }
    
    override func didMoveToView(view: SKView) {
        createPhysicsWorld()
        createEnvironment()
        createPoints()
        createCharmander(CGPointMake(self.frame.midX, self.frame.midY))
        playBackgroundMusic("palletBackgroundMusic.mp3")
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(createKoffingInRandomPositionAndMakeItMoveByScenario), SKAction.waitForDuration(3.0)])), withKey: "createKoffings")
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch =  touches.first as? UITouch {
            let location = touch.locationInNode(self)
            
            moveCharmander(location)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        if self.score <= 0 && !isGamePaused {
            showGameOver()
        }
    }
    
    func random() -> Float {
        return Float(arc4random()) / Float(UINT32_MAX)
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
        //area.physicsBody = SKPhysicsBody(polygonFromPath: navigationArea)
        area.physicsBody?.dynamic = false
        area.physicsBody?.restitution = 0
        area.physicsBody?.friction = 1
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
        charmander.physicsBody?.angularDamping = 1
        charmander.physicsBody?.categoryBitMask = PhysicsCategory.Charmander
        charmander.physicsBody?.contactTestBitMask = PhysicsCategory.Background | PhysicsCategory.Koffing
        charmander.physicsBody?.collisionBitMask = PhysicsCategory.Background
        
        self.addChild(charmander)
        
        let animationTexture = SKAction.animateWithTextures(createTexturesForCharmander(), timePerFrame: 0.3)
        var charmanderAnimation = SKAction.repeatActionForever(animationTexture)
        charmander.runAction(charmanderAnimation)
        charmander.runAction(SKAction.playSoundFileNamed("charmanderSayHello.mp3", waitForCompletion: false))
    }
    
    func createKoffing(positionToCreate: CGPoint) -> SKSpriteNode {
        var texture = SKTexture(imageNamed: "koffing-1")
        koffing = SKSpriteNode(texture: texture)
        koffing.xScale = 0.75
        koffing.yScale = 0.75
        koffing.position = positionToCreate
        koffing.anchorPoint = CGPointMake(0.5, 0.5)
        koffing.physicsBody = SKPhysicsBody(circleOfRadius: 18.0)
        koffing.physicsBody?.allowsRotation = false
        koffing.physicsBody?.dynamic = true
        koffing.physicsBody?.restitution = 0
        koffing.physicsBody?.linearDamping = 0
        koffing.physicsBody?.categoryBitMask = PhysicsCategory.Koffing
        koffing.physicsBody?.contactTestBitMask = PhysicsCategory.Charmander
        koffing.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        self.addChild(koffing)
        
        let animationTexture = SKAction.animateWithTextures(createTexturesForKoffing(), timePerFrame: 0.3)
        var koffingAnimation = SKAction.repeatActionForever(animationTexture)
        koffing.runAction(koffingAnimation)
        
        return koffing
    }
    
    func createKoffingInRandomPositionAndMakeItMoveByScenario() {
        var randomNumber = random()
        var typeOfMovement: Int
        var randomPosition: CGPoint
        var koffingWidth = 64
        
        if 0...0.125 ~= randomNumber {
            randomPosition = CGPointMake(self.frame.minX - 64, self.frame.maxY - 65)
            typeOfMovement = 1
        } else if 0.126...0.25 ~= randomNumber {
            randomPosition = CGPointMake(self.frame.maxX + 64, self.frame.maxY - 65)
            typeOfMovement = 2
        } else if 0.251...0.375 ~= randomNumber {
            randomPosition = CGPointMake(self.frame.minX - 64, self.frame.maxY - 240)
            typeOfMovement = 3
        } else if 0.376...0.5 ~= randomNumber {
            randomPosition = CGPointMake(self.frame.maxX + 64, self.frame.maxY - 240)
            typeOfMovement = 4
        } else if 0.51...0.625 ~= randomNumber {
            randomPosition = CGPointMake(self.frame.minX - 64, self.frame.maxY - 425)
            typeOfMovement = 5
        } else if 0.626...0.75 ~= randomNumber {
            randomPosition = CGPointMake(self.frame.maxX + 64, self.frame.maxY - 425)
            typeOfMovement = 6
        } else if 0.751...0.875 ~= randomNumber {
            randomPosition = CGPointMake(self.frame.minX + 158, self.frame.maxY + 65)
            typeOfMovement = 7
        } else {
            randomPosition = CGPointMake(self.frame.minX + 158, self.frame.minY - 65)
            typeOfMovement = 8
        }
        let koffingToAnimate = createKoffing(randomPosition)
        moveKoffing(koffingToAnimate, typeOfMovement: typeOfMovement, durationOfMovement: 5)
    }
    
    func moveKoffing(koffingToAnimate: SKSpriteNode, typeOfMovement: Int, durationOfMovement: Double) {
        if !isGamePaused {
            var movementOfKoffing: SKAction!
            switch typeOfMovement {
            case 1, 3, 5:
                movementOfKoffing = SKAction.moveToX(self.frame.size.width + (koffing.size.width * 2), duration: durationOfMovement)
            case 2, 4, 6:
                movementOfKoffing = SKAction.moveToX(0.0 - (koffing.size.width * 2), duration: durationOfMovement)
            case 7:
                movementOfKoffing = SKAction.moveToY(0.0 - (koffing.size.height * 2), duration: durationOfMovement)
            case 8:
                movementOfKoffing = SKAction.moveToY(self.frame.size.height + (koffing.size.height * 2), duration: durationOfMovement)
                
            default:
                return
            }
            
            var interval = CFTimeInterval(random() * 5)
            let koffingWait = SKAction.waitForDuration(interval)
            
            koffingToAnimate.runAction(SKAction.sequence([koffingWait, movementOfKoffing]), completion: { () -> Void in
                if koffingToAnimate.physicsBody?.velocity == CGVectorMake(0.0, 0.0) {
                    if self.score <= 60 {
                        self.score -= self.score
                    } else {
                        self.score -= 60
                    }
                    self.scoreNode.text = String(self.score)
                }
                koffingToAnimate.removeFromParent()
            })
        }
    }
    
    func moveCharmander(location: CGPoint) {
        let dy = location.y - charmander.position.y
        let dx = location.x - charmander.position.x
        let hipo = sqrt(pow(dx, 2) + pow(2, dy))
            
        var vector = CGVectorMake(dx, dy)
        charmander.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
        charmander.physicsBody?.applyForce(vector, atPoint: CGPointMake(location.x, location.y))
    }
    
    func createTexturesForCharmander() -> [SKTexture] {
        var textures : [SKTexture] = []
        
        for i in 1...3 {
            var name = "charmander-\(i)"
            var texture = SKTexture(imageNamed: name)
            textures += [texture]
        }
        
        return textures
    }
    
    func createTexturesForKoffing() -> [SKTexture] {
        var textures : [SKTexture] = []
        
        for i in 1...6 {
            var name = "koffing-\(i)"
            var texture = SKTexture(imageNamed: name)
            textures += [texture]
        }
        
        return textures
    }
    
    func createPoints() {
        var points = SKSpriteNode(texture: nil, size: CGSizeMake(self.size.width, self.size.height*0.05))
        points.anchorPoint=CGPointMake(0, 0)
        points.position = CGPointMake(0, self.size.height-points.size.height)
        
        self.addChild(points)
        
        self.scoreNode.position = CGPointMake(points.size.width * 0.9, 1)
        self.scoreNode.text = String(self.score)
        self.scoreNode.fontSize = points.size.height
        self.scoreNode.fontName = "Helvetica Bold"
        points.addChild(self.scoreNode)
    }
    
    func charmanderAttackKoffing(koffingToRemove: SKSpriteNode) {
        self.score += 75
        self.scoreNode.text = String(score)
        koffingToRemove.runAction(SKAction.playSoundFileNamed("koffingIsAttacked.mp3", waitForCompletion: false), completion: {
            koffingToRemove.removeFromParent()
        })
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if !isGamePaused {
            if (contact.bodyA.categoryBitMask == PhysicsCategory.Koffing && contact.bodyB.categoryBitMask == PhysicsCategory.Charmander) {
                charmanderAttackKoffing(contact.bodyA.node as! SKSpriteNode)
                contact.bodyB.node?.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
            } else if (contact.bodyA.categoryBitMask == PhysicsCategory.Charmander && contact.bodyB.categoryBitMask == PhysicsCategory.Koffing) {
                charmanderAttackKoffing(contact.bodyB.node as! SKSpriteNode)
                contact.bodyA.node?.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
            }
        }
    }
    
    func playBackgroundMusic(filename: String) {
        let url = NSBundle.mainBundle().URLForResource(
            filename, withExtension: nil)
        if (url == nil) {
            println("Could not find file: \(filename)")
            return
        }
        
        var error: NSError? = nil
        backgroundMusicPlayer =
            AVAudioPlayer(contentsOfURL: url, error: &error)
        if backgroundMusicPlayer == nil {
            println("Could not create audio player: \(error!)")
            return
        }
        
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        backgroundMusicPlayer.volume = 0.5
    }
    
    func restartGame() {
        playBackgroundMusic("palletBackgroundMusic.mp3")
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(createKoffingInRandomPositionAndMakeItMoveByScenario), SKAction.waitForDuration(3.0)])), withKey: "createKoffings")
    }
    
    func showGameOver() {
        self.isGamePaused = true
        self.removeActionForKey("createKoffings")
        koffing.removeAllChildren()
        self.backgroundMusicPlayer.stop()
        self.runAction(SKAction.playSoundFileNamed("gameOver.mp3", waitForCompletion: false))
        
        var alert = UIAlertController(title: "Game Over", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { _ in
            self.restartGame()
            self.score = 25
            self.scoreNode.text = String(self.score)
            self.isGamePaused = false
        })
        
        self.view?.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
}
