//
//  RFSLeaderBoard.swift
//  RaceForSurvivalFinal
//
//  Created by Z on 20.06.17.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit
import SpriteKit
//import RFSLeaderBoardTableView

class RFSLeaderBoard: SKScene {
    var gameTableView = RFSLeaderBoardTableView()
    //init(frame: CGRect(x:20,y:50,width:280,height:200)
//, style: UITableViewStyle)
    private var label : SKLabelNode?
    
    override func didMove(to view: SKView) {
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        // Table setup
        gameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        gameTableView.frame=CGRect(x:20,y:50,width:280,height:200)
        gameTableView.backgroundColor? = UIColor.init(colorLiteralRed: 0.1, green: 0.1, blue: 0.1, alpha: 0)
        //gameTableView.
        view.addSubview(gameTableView)
        gameTableView.reloadData()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        
        gameTableView.removeFromSuperview()
        let menuScene   = RFSMenuScene.newRFSMenuScene()
        
        let transition = SKTransition.flipVertical(withDuration: 1.0)
        menuScene.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(menuScene, transition: transition)

    }
    
    class func newRFSLeaderBoardScene() -> RFSLeaderBoard {
        // Load 'RFSMenuScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "LeaderBoard") as? RFSLeaderBoard else {
            print("Failed to load RFSMenuScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }

    
    
}
