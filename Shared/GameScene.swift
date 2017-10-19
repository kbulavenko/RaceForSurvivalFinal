//
//  GameScene.swift
//  RaceForSurvival
//
//  Created by  Z on 09.06.17.
//  Copyright © 2017  Z. All rights reserved.
//

import SpriteKit
import AVFoundation
let pr1ntLogging = "OFF"    //  OFF   - No trace,   ON  - trace with print to console

class GameScene: SKScene , SKPhysicsContactDelegate  {
    
    // Records table saving/extraction to/from UserDefaults constants
    let RFSDictionaryInUserDefaults     = "RFSDictionaryInUserDefaults"
    let RFSUserNameInUserDefaults       = "RFSUserNameInUserDefaults"
    
    //  Game hero
    var myCar                           : Car?
    //  N (default 3)   hearts on the right at the top of the screen
    var lifesIndicator                  : SKTileMapNode?
    
    //  Label to show current race time from game timer
    var timerRaceLabel                  : SKLabelNode?
    
    //  Timer car blocking (sticking)  flag
    var timerZeroSpeedIsStarted         : Bool      = false
    
    //  Game (race) timer flag
    var timerRaceIsStarted              : Bool      = false
    
    //  Timer car blocking (sticking)
    var timerZeroSpeed                  : Timer     = Timer()
    //  Max blocking(sticking) car and/or user inactivity countdown. If counter is zero stop the race
    var timerZeroSpeedCounter           : Int       = 200
    
    //  Game (race) timer
    var timerRace                       : Timer     = Timer()
    
    //  Hundredths of a second in race timer, used for show timer on screen and calculate key for UserDefaults
    var timerRaceCounter                : Int       = 0
    var audioPlayer                     : AVAudioPlayer?
    //   Temporary variable for save current velocity vector and use for collision handler
    var lastVelocity                    : CGVector  = .zero
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            if pr1ntLogging == "ON" {
                print("Failed to load GameScene.sks") }
            abort()
        }
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        //   Collision handler
        print("scene.physicsWorld.contactDelegate  = self as? SKPhysicsContactDelegate")
        scene.physicsWorld.contactDelegate  = self as? SKPhysicsContactDelegate
        print("\(String(describing: scene.physicsWorld.contactDelegate))")
        return scene
    }
    
      override func didMove(to view: SKView) {
       // print("physicsWorld.contactDelegate = self")
        // Set delegate for not lost him  when finish
        physicsWorld.contactDelegate = self
        // Настрока машины
        myCar  = self.childNode(withName: "car")  as? Car
        self.listener   = myCar;
        self.myCar?.setCamera(camera:  self.camera! )
        lifesIndicator  = self.camera?.childNode(withName: "Lifes") as? SKTileMapNode
        timerRaceLabel  = self.camera?.childNode(withName: "raceTimerLabel") as? SKLabelNode
        // Setup initial camera position
        self.updateCamera()

        if timerRaceIsStarted  == false {
            timerRaceCounter   = 0;
            timerRace   = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.timerRaceFired), userInfo: nil, repeats: true)
            timerRaceIsStarted  = true
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        timerRaceLabel?.text = self.timerString(counter: self.timerRaceCounter)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //  print("touchesBegan")
        for touch in touches{
            let location = touch.location(in: self)
            let touchNode = atPoint(location)
            //   print("\(String(describing: touchNode.name))")
            
            // MARK: Turn LEFT
            if touchNode.name == "leftArrow" {
          //      print("leftArrow Pressed")
                self.myCar?.turnLeftDidPressed()
            }
            
            // MARK: Turn RIGHT
            if touchNode.name == "rightArrow" {
           //     print("rightArrow Pressed")
                self.myCar?.turnRightDidPressed()
            }
            
            // MARK: BRAKE Pedal
            if touchNode.name == "brakePedal"{
              //  print("Brake pedal pressed")
                self.myCar?.brakeDidPressed()
            }  // MARK: GAS Pedal
            else   if touchNode.name == "gasPedal"{
            //    print("Gas pedal is pressed")
                self.myCar?.gasDidPressed()
            }
        }
      }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     //   for t in touches {
          //  self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
     //   }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{

            let location = touch.location(in: self)
            let touchNode = atPoint(location)
            //   print("\(String(describing: touchNode.name))")
            
            
            // MARK: Turn LEFT  ENDED
            if touchNode.name == "leftArrow" {
           //     print("leftArrow ENDED")
                self.myCar?.turnLeftDidReleased()
            }
            
            // MARK: Turn RIGHT ENDED
            if touchNode.name == "rightArrow" {
            //    print("rightArrow ENDED")
                self.myCar?.turnRightDidReleased()
            }
            
            // MARK: BRAKE Pedal ENDED
            if touchNode.name == "brakePedal"{
            //    print("Brake pedal ENDED")
                self.myCar?.brakeDidReleased()
            }
        
            // MARK: GAS Pedal ENDED
            if touchNode.name == "gasPedal"{
            //    print("Gas pedal is ENDED")
                self.myCar?.gasDidReleased()
            }
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func raceOver(isWin: Bool) -> Void {
        print("- - - Game OVER - - -")

        timerRace.invalidate()
        timerRaceIsStarted = false
        
        if isWin {
            //  В случае победы   добавляем строку с рекордом
            let newKey :  String    =  String(format: "%i", (timerRaceCounter * 100 + Int(arc4random_uniform(100))))
            var   dictionaryLeaderBoard  : Dictionary<String , [String]>  = UserDefaults.standard.value(forKey: RFSDictionaryInUserDefaults) as! Dictionary<String , [String]>
            let    userName  : String   =  UserDefaults.standard.value(forKey: RFSUserNameInUserDefaults) as! String
            dictionaryLeaderBoard.updateValue([userName , self.timerString(counter: timerRaceCounter)], forKey: newKey)
            UserDefaults.standard.set(dictionaryLeaderBoard, forKey: RFSDictionaryInUserDefaults)
            //  В случае победы выводим таблицу лидеров
            let leaderBoardScene   = RFSLeaderBoard.newRFSLeaderBoardScene()
            let transition = SKTransition.flipVertical(withDuration: 2.0)
            leaderBoardScene.scaleMode = SKSceneScaleMode.aspectFill
            self.view?.presentScene(leaderBoardScene, transition: transition)
            
        } else {
            // Проиграли  - переходим в меню
            let menuScene   = RFSMenuScene.newRFSMenuScene()
            let transition = SKTransition.flipVertical(withDuration: 1.0)
            menuScene.scaleMode = SKSceneScaleMode.aspectFill
            self.view?.presentScene(menuScene, transition: transition)
        }
    }
    
    
    func checkForSticking() -> Void {    // Проверка на залипание машинки
        let speed   = (self.myCar?.carSpeed)!
        if(speed < 0.01 && timerZeroSpeedIsStarted == false) {
            timerZeroSpeedCounter   = 200;
            timerZeroSpeed   = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerZeroSpeedFired), userInfo: nil, repeats: true)
            timerZeroSpeedIsStarted   = true;
        }
    }
    
    //MARK:   Update camera. Show speed
    func updateCamera() {
        if let camera = camera {
            camera.position = CGPoint(x: myCar!.position.x, y: myCar!.position.y)
        }
        if pr1ntLogging == "ON" {
            print("updateCamera : Collision correction : ")
        }
        camera?.zRotation   =  ( self.myCar?.currentVelocityAngle())!  - 1.0 * CGFloat.pi / 2.0
        if pr1ntLogging == "ON" {
            print("updateCamera : Collision correction : camera?.zRotation   = \(String(describing: camera?.zRotation ))  рад. =  \((camera?.zRotation)! * 180 / CGFloat.pi) градусов")
            print("updateCamera    END \n")
        }
    }

     func updateCar() {
      //  print("updateCar")
       // updateCamera()
        myCar?.physicsBody?.isResting   = false
        myCar?.physicsBody?.linearDamping   =  0.0 + 0.02 * (self.myCar?.carSpeed)! / (myCar?.maxVelocitySpeed)!
        // Запоминаем последний вектор скорости для обработки столкновений  (в модель не выносим как и обработку)
        self.lastVelocity  = (self.myCar?.physicsBody?.velocity)!
        myCar?.zRotation   = (self.myCar?.currentVelocityAngle())!  - 1.0 * CGFloat.pi / 2.0
        if pr1ntLogging == "ON" {
            print("updateCamera : Collision correction : myCar?.zRotation  =\(String(describing: myCar?.zRotation)) рад. =  \((myCar?.zRotation)! * 180 / CGFloat.pi) градусов")
        }
    }
    
    override func didSimulatePhysics() {
       //   print("didSimulatePhysics")
        if let _ = myCar {
          //  print("1")
            self.checkForSticking()
            self.updateCar()
            self.updateCamera()
        }
    }
    
    
    //MARK:- CONTACT
    
    //MARK:- CONTACT DID BEGIN
    func didBegin(_ contact: SKPhysicsContact) {
       if pr1ntLogging == "ON" {
            print("\n\ndidBegin1 Contact :  ")
            print("didBegin Contact : Car velocity  = \(String(describing: self.myCar?.physicsBody?.velocity))")
        }
        let speed   = (self.myCar?.carSpeed)!
        if pr1ntLogging == "ON" {
            print("didBegin Contact : speed  = \(speed)")
        }
        let velocityAngle   = ( self.myCar?.currentVelocityAngle())!
            //ata n2((myCar?.physicsBody?.velocity.dy)!, (myCar?.physicsBody?.velocity.dx)!)
        
        if pr1ntLogging == "ON" {
            print("didBegin Contact : velocityAngle = \(velocityAngle) рад. =  \(velocityAngle * 180 / CGFloat.pi) градусов")
            //  print("didBegin Contact :  velocityAngle = \(velocityAngle) рад. =  \(velocityAngle * 180 / CGFloat.pi) градусов")
            print("didBegin Contact : myCar?.zRotation  =\(String(describing: myCar?.zRotation)) рад. =  \((myCar?.zRotation)! * 180 / CGFloat.pi) градусов")
            
            print("didBegin Contact : camera?.zRotation   = \(String(describing: camera?.zRotation ))  рад. =  \((camera?.zRotation)! * 180 / CGFloat.pi) градусов")
            
            //        print("didBegin Contact :" + String(describing: contact))
            print("didBegin Contact : BodyA:" + String(describing: contact.bodyA))
            print("didBegin Contact : BodyB:" + String(describing: contact.bodyB))
            print("didBegin Contact : Impulse:" + String(describing: contact.collisionImpulse))
            //        print("didBegin Contact : Point:" + String(describing: contact.contactPoint))
            print("didBegin Contact : Normal:" + String(describing: contact.contactNormal))
        }
        let   normalAngle  =   self.vectorAngleWithXInRad(vector: contact.contactNormal)
        if pr1ntLogging == "ON" {
            print("didBegin Contact : normalAngle = \(normalAngle) рад. =  \(normalAngle * 180 / CGFloat.pi) градусов")
        }
        let   collisionImpulse1 = contact.collisionImpulse
        let  angleBeta   : CGFloat   = ( self.myCar?.currentVelocityAngle())!      /// ata n2(dy1, dx1)    // угол отражения относительно оси  x ()
        let  angleAlpha   : CGFloat   =  self.vectorAngleWithXInRad(vector: self.lastVelocity)
        let   angleReflection  =   /*abs*/( (  angleBeta  - angleAlpha ) / 2.0  )  - 0 * CGFloat.pi /  2.0
        let   angleReflectionAbs  =   abs(angleReflection)
        if pr1ntLogging == "ON" {
            print("didBegin Contact : angleAlpha (угол вектора скорости до столкновения) : \(angleAlpha) рад. =  \(angleAlpha * 180 / CGFloat.pi) градусов")
            print("didBegin Contact : angleBeta (угол вектора скорости после столкновения)  : \(angleBeta) рад. =  \(angleBeta * 180 / CGFloat.pi) градусов")
            print("didBegin Contact : angleReflection : \(angleReflection) рад. =  \(angleReflection * 180 / CGFloat.pi) градусов")
        }
        let    deltaNormalBeta  =  normalAngle   - angleBeta
        if pr1ntLogging == "ON" {
            print("didBegin Contact : deltaNormalBeta : \(deltaNormalBeta) рад. =  \(deltaNormalBeta * 180 / CGFloat.pi) градусов")
        }
        let     name1 : String =    (contact.bodyA.node?.name)!
        let     name2 : String =    (contact.bodyB.node?.name)!
        if pr1ntLogging == "ON" {
            print("didBegin Contact : BodyA.name = \(name1)")
            print("didBegin Contact : BodyB.name =  \(name2)")
        }
        if (name1 ==  "car" && name2 == "Finish") || (name2 == "car" && name1 == "Finish") {
            print("Победа!!!!!!!!!!!! \n\n\n\n\n\n\n\n\n\n");
            self.playSoundWin()
            Thread.sleep(forTimeInterval: 2)
            self.raceOver(isWin: true)
        } else if (name1 ==  "car" && name2 == "TrassaLimit") || (name2 == "car" && name1 == "TrassaLimit") {
            print("Столкновение с ограничителем трассы")
            if angleReflectionAbs  >= CGFloat.pi / 3.0   && collisionImpulse1 > 10 {
                self.lifesIndicator?.setTileGroup(nil, forColumn: myCar!.lostLife(), row: 0)
                if ( myCar?.isAlive())! == false {
                    print("Вы разбились!!!!!!!!!!!! \n\n\n\n\n\n\n\n\n\n");
                    self.playSoundLose()
                    Thread.sleep(forTimeInterval: 2)
                    self.raceOver(isWin: false)

                } else {
                    self.myCar?.correctVelocity(correction: 0.5 - 0.49 * (angleReflectionAbs  / CGFloat.pi ))
                }
            } else {
               // print("else")
                self.myCar?.correctVelocity(correction: 0.5 - 0.4 * (angleReflectionAbs  / CGFloat.pi ))
            }
        }
        if pr1ntLogging == "ON" {
            print("didBegin Contact END \n\n")
        }
    }
    
    //MARK:- CONTACT WAS END
    func didEnd(_ contact: SKPhysicsContact) {
    }
    
    //MARK:- PLAY SOUND WIN
    func playSoundWin() {
        self.playSound(name: "win")
    }
    
    //MARK:- PLAY SOUND LOSE
    func playSoundLose() {
            self.playSound(name: "lose")
    }

    //MARK:- PLAY SOME SOUND

    func playSound(name: String) {
        let url = Bundle.main.url(forResource: name, withExtension: "mp3")!
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard self.audioPlayer == self.audioPlayer else { return }
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func vectorAngleWithXInRad(vector: CGVector) -> CGFloat {
        let   dx : CGFloat = CGFloat(vector.dx.native)
        let   dy : CGFloat = CGFloat(vector.dy.native)
        let   angle : CGFloat = atan2(dy, dx)
        return  angle
    }
    
    
    
    func timerZeroSpeedFired() -> Void {
        let speed   = (self.myCar?.carSpeed)!
        if speed > 0.1 {
            timerZeroSpeed.invalidate()
            timerZeroSpeedIsStarted = false;
        }
        timerZeroSpeedCounter -= 1;
        if(timerZeroSpeedCounter == 0)
        {
            timerZeroSpeed.invalidate()
            self.raceOver(isWin: false)
        }
    }
    
    
    
    
    func timerRaceFired() -> Void {
        self.timerRaceCounter += 1
        timerRaceLabel?.text = self.timerString(counter: self.timerRaceCounter)
    }
    
    func timerString(counter: Int) -> String {
        let part : Int = counter % 100
        let fullSeconds : Int = counter / 100
        let hours : Int = fullSeconds / 3600
        let minutes : Int = (fullSeconds / 60) % 60
        let seconds = fullSeconds  % 60
        return String(format: "%02i:%02i:%02i:%02i", hours, minutes, seconds, part)
    }
}
