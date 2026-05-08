//
//  TitleScene.swift
//  Type Rush
//
//  Created by Aluno a27942 Teste on 08/05/2026.
//

import Foundation
import SpriteKit

class TitleScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        let title = SKLabelNode(text: "Type Rush")
        title.fontName = "Helvetica-Bold"
        title.fontSize = 48
        title.fontColor = .white
        title.position = CGPoint (x: size.width / 2, y: size.height * 0.65)
        addChild(title)
        
        let startButton = SKSpriteNode(color: .systemBlue, size: CGSize(width: 220, height: 60))
        startButton.position = CGPoint(x: size.width / 2, y: size.height * 0.45)
        startButton.name = "startButton"
        addChild(startButton)
        
        let startLabel = SKLabelNode(text: "Start")
        startLabel.fontName = "Helvetica-Bold"
        startLabel.fontSize = 24
        startLabel.fontColor = .white
        startLabel.position = CGPoint(x: 0, y: 0)
        startButton.addChild(startLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "startButton" || touchedNode.parent?.name == "startButton" {
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = scaleMode
            let transition = SKTransition.fade(withDuration: 0.5)
            view?.presentScene(gameScene, transition: transition)
        }
    }
}
