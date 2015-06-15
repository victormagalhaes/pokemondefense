//
//  RetryScene.swift
//  TowerDefensePokemon
//
//  Created by Victor Magalhães on 13/06/15.
//  Copyright (c) 2015 Victor Magalhães. All rights reserved.
//

import UIKit
import SpriteKit

class RetryScene: SKScene {
    var contentCreated = false
    
    override func didMoveToView(view: SKView) {
        
        if (!self.contentCreated) {
            self.createContent()
            self.contentCreated = true
        }
    }
    
    func createContent() {
        let gameOverLabel = SKLabelNode(fontNamed: "Helvetica Bold")
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = SKColor.whiteColor()
        gameOverLabel.text = "Game Over!"
        gameOverLabel.position = CGPointMake(self.size.width/2, 2.0 / 3.0 * self.size.height);
        
        self.addChild(gameOverLabel)
        
        let tapLabel = SKLabelNode(fontNamed: "Helvetica Bold")
        tapLabel.fontSize = 25
        tapLabel.fontColor = SKColor.whiteColor()
        tapLabel.text = "(Tap to Play Again)"
        tapLabel.position = CGPointMake(self.size.width/2, gameOverLabel.frame.origin.y - gameOverLabel.frame.size.height - 40);
        
        self.addChild(tapLabel)
        
        // black space color
        self.backgroundColor = SKColor.blackColor()
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)  {
        let gameScene = GameScene(size: self.size)
        
        self.view?.presentScene(gameScene, transition: SKTransition.fadeWithDuration(1.0))
        
    }
}
