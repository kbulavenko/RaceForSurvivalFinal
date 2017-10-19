//
//  GameViewController.swift
//  RaceForSurvivalFinal
//
//  Created by Z on 17.06.17.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let  defaultDictionary :  Dictionary<String , [String]>   =  [
            "0"             :      ["Name",       "Time"],
            "76898901"      :      ["Alex",       "02:08:09:89"],
            "124993502"     :      ["Dmitry",     "03:28:19:35"],
            "167211303"     :      ["Konstantin", "04:38:41:13"]
        ]
        
        
        let  defaultName  : String  = "You"
        
        let    RFSDictionaryInUserDefaults  = "RFSDictionaryInUserDefaults"

        let    RFSUserNameInUserDefaults  = "RFSUserNameInUserDefaults"

        
        
        UserDefaults.standard.register(defaults: [RFSDictionaryInUserDefaults : defaultDictionary])
        //(defaults: RFSDictionaryInUserDefaults,  defaultDictionary )
        
        UserDefaults.standard.register(defaults: [RFSUserNameInUserDefaults : defaultName])
        
        
        
        let menuScene   = RFSMenuScene.newRFSMenuScene()
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(menuScene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
