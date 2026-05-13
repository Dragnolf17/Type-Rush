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
        
        setupTextField()
        
        submitButton = createButton(title: "Submit", color: .systemGreen, position: CGPoint(x: size.width * 0.3, y: size.height * 0.2))
        submitButton.name = "submitBtn"
        addChild(submitButton)

        returnButton = createButton(title: "Return", color: .systemRed, position: CGPoint(x: size.width * 0.7, y: size.height * 0.2))
        returnButton.name = "returnBtn"
        addChild(returnButton)

        startTimer()
    }
    
    private func setupTextField() {
            inputField = UITextField(frame: CGRect(x: 0, y: 0, width: 290, height: 40))
            inputField.backgroundColor = .white
            inputField.layer.cornerRadius = 8
            inputField.placeholder = "Type your answer..."
            inputField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            inputField.borderStyle = .none
            inputField.textAlignment = .center
            inputField.returnKeyType = .done
            inputField.delegate = self

            // Convert SpriteKit scene coordinates to UIKit view coordinates
            if let view = view {
                let viewPosition = self.convertPoint(toView: inputBoxNode.position)
                inputField.center = viewPosition
                view.addSubview(inputField)
            }
    }
    
    private func createButton(title: String, color: UIColor, position: CGPoint) -> SKSpriteNode {
        let button = SKSpriteNode(color: color, size: CGSize(width: 130, height: 45))
        button.position = position
        button.zPosition = 1

        let label = SKLabelNode(text: title)
        label.fontName = "Helvetica-Bold"
        label.fontSize = 18
        label.fontColor = .white
        label.zPosition = 2
        button.addChild(label)

        return button
    }
    
    private func startTimer() {
        timeRemaining = 30
        timerLabel.text = "\(timeRemaining)s"
        timerLabel.fontColor = .systemYellow

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            [weak self] _ in guard let self = self else { return }
            self.timeRemaining -= 1
            self.timerLabel.text = "\(self.timeRemaining)s"
            self.timerLabel.fontColor = self.timeRemaining <= 5 ? .systemRed : .systemYellow

            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
                self.timer = nil
                self.returnToTitle()
            }
        }
    }
    
    private func returnToTitle() {
        inputField.resignFirstResponder()
        let titleScene = TitleScene(size: size)
        titleScene.scaleMode = scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(titleScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if touchedNode.name == "submitBtn" || touchedNode.parent?.name == "submitBtn" {
            print("Player submitted: \(inputField.text ?? "")")
            inputField.text = "" // Clear field
        } else if touchedNode.name == "returnBtn" || touchedNode.parent?.name == "returnBtn" {
            timer?.invalidate()
            timer = nil
            returnToTitle()
        } else {
            inputField.resignFirstResponder()
        }
    }
    
    override func willMove(from view: SKView) {
        timer?.invalidate()
        timer = nil
        inputField.removeFromSuperview()
        inputField = nil
    }
}

extension GameScene: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
