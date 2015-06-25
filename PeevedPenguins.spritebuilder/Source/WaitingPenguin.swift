//
//  WaitingPenguin.swift
//  PeevedPenguins
//
//  Created by Olivia Ross on 6/25/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class WaitingPenguin: CCSprite {
    func didLoadFromCCB(){
        let delay = CCRANDOM_0_1() * 2
        scheduleOnce("startBlinkAndJump", delay: CCTime(delay))
    }
    
    func startBlinkAndJump(){
        animationManager.runAnimationsForSequenceNamed("BlinkAndJump")
    }
}
