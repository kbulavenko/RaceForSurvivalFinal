//
//  Car.swift
//  RaceForSurvivalFinal
//
//  Created by Z on 21.06.17.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit
import SpriteKit

class Car: SKSpriteNode {

    
    var   gasPedalIsPressedTimerIsStarted   : Bool      = false
    var   brakePedalPressedTimerIsStarted   : Bool      = false

    var timerGas                            : Timer     = Timer()
    var timerBrake                          : Timer     = Timer()

    
    
    public private(set)   var   life        : Int       = 3
    public private(set)   var   carSpeed    : CGFloat       {
        get {
            return sqrt(CGFloat(pow((self.physicsBody?.velocity.dx.native)! , 2.0) +
                            pow((self.physicsBody?.velocity.dy.native)! , 2.0 )) )
        }
        set {
            
        }
    }
    
    public    let   maxVelocitySpeed                  : CGFloat   = 1500;
    
    private   let   turnStepAngle                     : CGFloat   =   CGFloat.pi /  128     //720.0
    
    
    var   turnLeftPressedTimerIsStarted     : Bool      = false
    var   turnRightPressedTimerIsStarted    : Bool      = false
    var timerTurnLeft                       : Timer     = Timer()
    var timerTurnRight                      : Timer     = Timer()

    public  var   myCamera: SKCameraNode?
        //{
//        
//        get {
//            return self.myCamera
//        }
//        set {
//            self.myCamera  = newValue
//        }
//    }
    
    
    
    
//    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
//        super.init(texture: texture, color: color, size: size)
//        life = 3
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    
    
    func lostLife() -> Int {    //  Потеря одной игровой жизни,  вернуть сколько осталось , для обработки в игровой сцене
        self.life -= 1
        return  self.life
        
    }
    
    func isAlive() -> Bool {
        return self.life == 0 ? false : true
    }
    
    
    func letsGo(cameraRotation:  CGFloat) -> Void {
        let  angleVelocity   : CGFloat   =   CGFloat.pi / 2.0  + cameraRotation
        let velocitySpeed  : CGFloat  =  2
        let   dx   : CGFloat   =  velocitySpeed    *  cos(angleVelocity)
        let   dy   : CGFloat   =  velocitySpeed    *  sin(angleVelocity)
        self.physicsBody?.velocity  = CGVector.init(dx: dx, dy: dy)
    }

    func stop() -> Void {
        self.physicsBody?.velocity  = CGVector.zero
    }
    
    func  currentVelocityAngle() -> CGFloat {
        return  self.vectorAngleWithXInRad(vector: (self.physicsBody?.velocity)!)
    }
    
    func vectorAngleWithXInRad(vector: CGVector) -> CGFloat {
        let   dx : CGFloat = CGFloat(vector.dx.native)
        let   dy : CGFloat = CGFloat(vector.dy.native)
        let   angle : CGFloat = atan2(dy, dx)
        return  angle
    }

    func turnLeft(camera: SKCameraNode ) -> Void {
        self.turn(angle: turnStepAngle , camera: camera)
    }
    
    func turnRight(camera: SKCameraNode) -> Void {
        self.turn(angle: -turnStepAngle , camera: camera)
    }
    
    private func turn(angle: CGFloat , camera: SKCameraNode) -> Void {
        let    rotation   = angle  //* log( (self.myCar?.carSpeed)! + 1 ) * 4.0  / log( maxVelocitySpeed + 1)
        let  angleVelocity   : CGFloat   =  self.currentVelocityAngle()
        let  newAngleVelocity  : CGFloat =  angleVelocity  + rotation
        let velocitySpeed   =  self.carSpeed
        let   dx   : CGFloat   = velocitySpeed * cos(newAngleVelocity )
        let   dy   : CGFloat   =  velocitySpeed * sin(newAngleVelocity )
        self.physicsBody?.velocity  = CGVector.init(dx: dx, dy: dy)
        self.zRotation      += rotation
        camera.zRotation   += rotation
    }
    
    func turnRightDidPressed() -> Void {
        if( self.carSpeed > 1 )  {
            if(!turnRightPressedTimerIsStarted )   {
                timerTurnRight   = Timer.scheduledTimer(timeInterval: 0.01,
                                                        target: self,
                                                        selector: #selector(self.turnRightPressed),
                                                        userInfo: nil,
                                                        repeats: true)
                turnRightPressedTimerIsStarted   = true;
            }
        }

    }
    
    func turnLeftDidPressed() -> Void {
        if( self.carSpeed > 1 )  {
            if(!turnLeftPressedTimerIsStarted )   {
                timerTurnLeft   = Timer.scheduledTimer(timeInterval: 0.01,
                                                       target: self,
                                                       selector: #selector(self.turnLeftPressed),
                                                       userInfo: nil,
                                                       repeats: true)
                turnLeftPressedTimerIsStarted   = true;
            }
        }
    }
    
    
    func turnLeftDidReleased() -> Void {
        timerTurnLeft.invalidate()
        turnLeftPressedTimerIsStarted = false;
    }
    
    func turnRightDidReleased() -> Void {
        timerTurnRight.invalidate()
        turnRightPressedTimerIsStarted = false;
    }
    
    func   turnLeftPressed  () -> Void {
        //   print("turnLeftPressed")
        if(self.carSpeed < 2.0) {
            timerTurnLeft.invalidate()
            turnLeftPressedTimerIsStarted   = false;
            return
        }
        self.turnLeft(camera: self.myCamera!)
    }
    
    func   turnRightPressed  () -> Void {
        //   print("turnRightPressed")
        if  self.carSpeed  < 2.0 {
            timerTurnRight.invalidate()
            turnLeftPressedTimerIsStarted   = false;
            return
        }
        self.turnRight(camera: self.myCamera!)
    }

    
    func setCamera(camera: SKCameraNode) -> Void {
        self.myCamera  = camera
    }
    
    
    
    func gasDidPressed() -> Void {
        if(!gasPedalIsPressedTimerIsStarted )   {
            timerGas   = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.gasPedalPressed), userInfo: nil, repeats: true)
            gasPedalIsPressedTimerIsStarted   = true;
        }

    }
    
    func brakeDidPressed() -> Void {
        if(self.carSpeed >= 1 )  {
            if(!brakePedalPressedTimerIsStarted )   {
                timerBrake   = Timer.scheduledTimer(timeInterval: 0.1,
                                                    target: self,
                                                    selector: #selector(self.brakePedalPressed),
                                                    userInfo: nil,
                                                    repeats: true)
                brakePedalPressedTimerIsStarted   = true;
            }
        }

    }
    
    func gasDidReleased() -> Void {
        timerGas.invalidate()
        gasPedalIsPressedTimerIsStarted   = false;

    }
    
    func brakeDidReleased() -> Void {
        timerBrake.invalidate()
        brakePedalPressedTimerIsStarted = false;
        self.physicsBody?.friction = 0.0; // 0.2
    }

    
    func   gasPedalPressed  () -> Void {
        if(self.carSpeed < self.maxVelocitySpeed) {
            if(!brakePedalPressedTimerIsStarted)
            {
                self.correctVelocity(correction: 1.1)
            }
        }
        if self.carSpeed < 0.1 {
            // Задать начальную минимальную скорость
            self.letsGo(cameraRotation: (self.myCamera?.zRotation)!)
        }
    }
    
    func   brakePedalPressed  () -> Void {
        //   print("brakePedalPressed")
        if(self.carSpeed  < 1) {
            self.stop()
            
            self.physicsBody?.isResting   = true;
            timerBrake.invalidate()
            brakePedalPressedTimerIsStarted   = false;
            return
        }
        self.physicsBody?.friction   = 1.0;  //1.0
        self.correctVelocity(correction: 0.8)
    }
    
    
    func correctVelocity(correction: CGFloat) -> Void {
        let  angleVelocity   : CGFloat   = self.currentVelocityAngle()
        let velocitySpeed   =  self.carSpeed
        let   dx   : CGFloat   =  velocitySpeed  * correction   *  cos(angleVelocity)
        let   dy   : CGFloat   =  velocitySpeed  * correction   *  sin(angleVelocity)
        self.physicsBody?.velocity  = CGVector.init(dx: dx, dy: dy)
    }

    
    
    
}
