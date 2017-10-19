//
//  RFSMenuScene.swift
//  RaceForSurvival
//
//  Created by Z on 12.06.17.
//  Copyright © 2017  Z. All rights reserved.
//

//import UIKit
import SpriteKit
import AVFoundation

class RFSMenuScene: SKScene {

    
    var  labelGo  : SKLabelNode?
    var  audioPlayer : AVAudioPlayer?
    
        //=   SKLabelNode.init(text: <#T##String?#>)
    
    
    class func newRFSMenuScene() -> RFSMenuScene {
        // Load 'RFSMenuScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "RFSMenuScene") as? RFSMenuScene else {
            print("Failed to load RFSMenuScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
        // Get label node from scene and store it for use later
        self.labelGo   = self.childNode(withName: "GO") as? SKLabelNode
        
        
 //       let path  : String!  = Bundle.main.resourcePath?.appending("/Car_Begin1.mp3")
        
        //let url   = Bundle.main.url(forAuxiliaryExecutable: "Car_Begin1.mp3")
        
//        
//        let url   = NSURL(fileURLWithPath: path)
//      //   downloadFileFromURL(url: url!)
//        //String(format: "\( NSBundle.mainBundle.resourcePath)/Car_Begin1.mp3")
//        print("\(String(describing: url))");
//       // var  error  : NSError?;
//         self.audioPlayer? = try!  AVAudioPlayer.init(contentsOf: url as URL)
//        //guard   let
//        //init(contentsOf: String(describing: url))
//            //( url))
//        self.audioPlayer?.numberOfLoops = 1;
//        
//        if self.audioPlayer == nil {
//        print("Error audio player")
//        }
//        else {
//            self.audioPlayer?.prepareToPlay()
//            self.audioPlayer?.play()
//        }
//
       self.playSound()
        
        
        
        // Create shape node to use during mouse interaction
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            // self.makeSpinny(at: t.location(in: self), color: SKColor.green)
            
            let touchLocation : CGPoint  = t.location(in: self)
            print("\(touchLocation)")
            if (self.labelGo?.contains(touchLocation))!
            {
                print("touch to GO")
                print("Let's START!")
                self.letsGame()
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  for t in touches {
            //  self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
      //  }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  for t in touches {
            //  self.makeSpinny(at: t.location(in: self), color: SKColor.red)
      //  }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
     //   for t in touches {
            // self.makeSpinny(at: t.location(in: self), color: SKColor.red)
      //  }
    }

    func letsGame() -> Void {
       
        
        
           /*
        
        print("Test LeaderBoard Table ")
        
        let leaderBoardScene   = RFSLeaderBoard.newRFSLeaderBoardScene()
        
        let transitionTest = SKTransition.flipVertical(withDuration: 2.0)
        leaderBoardScene.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(leaderBoardScene, transition: transitionTest)

            return
        
                 */
                //  End test leaderboard
        
        
        
        
        print("- - - Game BEGIN - - -")
        
        self.audioPlayer?.stop()
        self.action
        
        self.childNode(withName: "CarInFire")?.removeAllActions()
        self.removeAllActions()
        
        let gameScene = GameScene.newGameScene()
        //(size: self.size)
        //gameScene.soundToPlay = didWin ? "fear_win.mp3" : "fear_lose.mp3"
        let transition = SKTransition.flipVertical(withDuration: 1.0)
        gameScene.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(gameScene, transition: transition)

    }
    
    
    
    //MARK:- PLAY SOUND
    func playSound() {
        let url = Bundle.main.url(forResource: "CarBegin1", withExtension: "mp3")!
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard self.audioPlayer == self.audioPlayer else { return }
            
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
}
