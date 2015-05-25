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
    override func didMoveToView(view: SKView) {
        setupPhysicsWorld()
        setBackground()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            let charmander = SKSpriteNode(imageNamed: "Charmander")
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func setBackground() {
        let background = SKSpriteNode(imageNamed: "Background")
        background.anchorPoint = CGPointMake(0.0, 1.0)
        background.size = self.frame.size
        background.position = CGPointMake(self.frame.minX + self.frame.size.width/4, self.frame.maxY)
        background.xScale = 0.5
        self.addChild(background)
    }
    
    func setupPhysicsWorld() {
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
    }
    
}
