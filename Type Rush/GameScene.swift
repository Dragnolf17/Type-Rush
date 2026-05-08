//
//  GameScene.swift
//  Type Rush
//
//  Created by Aluno a27942 Teste on 08/05/2026.
//

import SpriteKit
import UIKit
import GameplayKit

class GameScene: SKScene {
    
    private var timeRemaining : Int = 30
    private var timer: Timer?
    private var timerLabel : SKLabelNode!
    private var inputField : UITextField!
    private var submitButton : SKSpriteNode!
    private var returnButton : SKSpriteNode!
    private var inputBoxNode : SKShapeNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .darkGray
        
        timerLabel = SKLabelNode(text: "\(timeRemaining)")
        timerLabel.fontName = "Helvetica-Bold"
        timerLabel.fontSize = 36
        timerLabel.fontColor = .systemYellow
        timerLabel.position = CGPoint(x: size.width / 2, y: size.height - 60)
        addChild(timerLabel)
        
        let wordBox = SKShapeNode(rectOf: CGSize(width: 320, height: 50))
        wordBox.fillColor = .white
        wordBox.position = CGPoint(x: size.width / 2, y: size.height * 0.6)
        addChild(wordBox)
        
        let wordLabel = SKLabelNode(text: "Example")
        wordLabel.fontName = "Helvetica-Bold"
        wordLabel.fontSize = 22
        wordLabel.fontColor = .black
        wordLabel.position = CGPoint(x: 0, y: 0)
        wordBox.addChild(wordLabel)
        
        inputBoxNode = SKShapeNode(rectOf: CGSize(width: 320, height: 50), cornerRadius: 12)
        inputBoxNode.fillColor = .systemGray4
        inputBoxNode.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
        addChild(inputBoxNode)
        
        
    }
}
