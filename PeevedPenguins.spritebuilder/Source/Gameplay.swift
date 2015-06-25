//
//  Gameplay.swift
//  PeevedPenguins
//
//  Created by Olivia Ross on 6/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Gameplay: CCNode {
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var levelNode: CCNode!
    weak var catapultArm: CCNode!
    
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        
        // load the first of many levels
        let level = CCBReader.load("Levels/Level1")
        // we're using levelNode to hold all our levels in one spot
        levelNode.addChild(level)
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        launchPenguin()
    }
    
    func launchPenguin(){
        
        // load the penguins we made earlier
        let penguin = CCBReader.load("Penguin") as! Penguin
        
        // set the penguins position
        penguin.position = ccpAdd(catapultArm.position, CGPoint(x: 16, y: 50))
        
        // add the penguin to the game physics node, because it's got physics enabled
        gamePhysicsNode.addChild(penguin)
        
        // manually create a force that we'll use to launch the penguin
        let launchDirection = CGPoint(x: 1, y: 0)
        let force = ccpMult(launchDirection, 8000)
        
        // apply the force and launch that bird!
        penguin.physicsBody.applyForce(force)
        
        // make sure the penguin is in a visible area when we first start
        position = CGPoint.zeroPoint
    
        // create what's essentially a camera using "CCActionFollow" to ... follow the action
        let actionFollow = CCActionFollow(target: penguin, worldBoundary: boundingBox())
        
        // Lights! Camera! CCActionFollow!
        runAction(actionFollow)
    }
    
    func retry(){
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
    }
    
}
