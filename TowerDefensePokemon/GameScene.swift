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
    var tower : SKSpriteNode!
    var currentTexture = 0
    
    override func didMoveToView(view: SKView) {
        setupPhysicsWorld()
        setBackground()
        createCharmander()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func setBackground() {
        let background = SKSpriteNode(imageNamed: "Background")
        background.anchorPoint = CGPointMake(0.0, 1.0)
        background.size = self.frame.size
        background.position = CGPointMake(self.frame.minX, self.frame.maxY)
        background.zPosition = -1
        self.addChild(background)
    }
    
    func setupPhysicsWorld() {
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
    }
    
    func createCharmander() {
        var texture = SKTexture(imageNamed: "charmander-001")
        tower = SKSpriteNode(texture: texture)
        tower.position = CGPointMake(frame.midX, frame.midY)
        tower.anchorPoint = CGPointMake(0.5, 0.5)
        self.addChild(tower)
    }
}
