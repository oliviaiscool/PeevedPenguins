//
//  Gameplay.swift
//  PeevedPenguins
//
//  Created by Olivia Ross on 6/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Gameplay: CCNode {
    
    weak var levelNode: CCNode!
    weak var contentNode: CCNode!
    
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var pullBackNode: CCPhysicsNode!
    weak var catapultArm: CCNode!
    
    weak var mouseJointNode:CCNode!
    var mouseJoint: CCPhysicsJoint?
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        
        // load the first of many levels
        let level = CCBReader.load("Levels/Level1")
        // using levelNode to hold all our levels in one spot in the Gameplay
        levelNode.addChild(level)
        
        // make the physics bodies and joints visible
        gamePhysicsNode.debugDraw = true
        
        // create an empty collisionMask so nothing bumps into the invisible nodes
        pullBackNode.physicsBody.collisionMask = []
        mouseJointNode.physicsBody.collisionMask = []
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let touchLocation = touch.locationInNode(contentNode)
        
        // start dragging the catapult arm back when a touch on the inside of the arm occurs
        if CGRectContainsPoint(catapultArm.boundingBox(), touchLocation) {
            // move the mouseJointNode to the touch position
            mouseJointNode.position = touchLocation
            
            // set up a spring joint between the mouseJointNode and the catapultArm
            mouseJoint = CCPhysicsJoint.connectedSpringJointWithBodyA(mouseJointNode.physicsBody, bodyB: catapultArm.physicsBody, anchorA: CGPointZero, anchorB: CGPoint(x:34, y: 38), restLength: 0, stiffness: 3000, damping: 150)
        }
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        // if the touch moves, update the touchLocation to be wherever the touch moved to
        
        let touchLocation = touch.locationInNode(contentNode)
        mouseJointNode.position = touchLocation
    }
    
    func releaseCatapult(){
        if let joint = mouseJoint {
            // releases the joint, allowing the catapult to "snap back"
            joint.invalidate()
            mouseJoint = nil
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        releaseCatapult()
    }
    
    override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        releaseCatapult()
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
        contentNode.runAction(actionFollow)
    }
    
    func retry(){
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
    }
    
}
