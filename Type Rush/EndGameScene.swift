//
//  EndGameScene.swift
//  Type Rush
//
//  Shown when a run ends: the player's session score against their saved best.
//

import Foundation
import SpriteKit
import UIKit

class EndGameScene: SKScene {

    private let finalScore: Int
    private let highScore: Int
    private let isNewHighScore: Bool

    init(size: CGSize, score: Int) {
        self.finalScore = score
        // submit(_:) stores the score when it's a new best and reports whether it was.
        self.isNewHighScore = ScoreStore.submit(score)
        self.highScore = ScoreStore.highScore
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        backgroundColor = .black

        let title = SKLabelNode(text: "Game Over")
        title.fontName = "Helvetica-Bold"
        title.fontSize = 48
        title.fontColor = .white
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        addChild(title)

        if isNewHighScore {
            let badge = SKLabelNode(text: "New Best!")
            badge.fontName = "Helvetica-Bold"
            badge.fontSize = 26
            badge.fontColor = .systemGreen
            badge.position = CGPoint(x: size.width / 2, y: size.height * 0.68)
            // Gentle pulse, echoing the score "bounce" used in GameScene.
            badge.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.scale(to: 1.2, duration: 0.4),
                SKAction.scale(to: 1.0, duration: 0.4)
            ])))
            addChild(badge)
        }

        let scoreLabel = SKLabelNode(text: "Score: \(finalScore)")
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.fontSize = 32
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.56)
        addChild(scoreLabel)

        let bestLabel = SKLabelNode(text: "Best: \(highScore)")
        bestLabel.fontName = "Helvetica-Bold"
        bestLabel.fontSize = 28
        bestLabel.fontColor = .systemYellow
        bestLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.48)
        addChild(bestLabel)

        let tryAgainButton = createButton(title: "Try Again", color: .systemGreen, position: CGPoint(x: size.width * 0.3, y: size.height * 0.28))
        tryAgainButton.name = "tryAgainBtn"
        addChild(tryAgainButton)

        let menuButton = createButton(title: "Menu", color: .systemBlue, position: CGPoint(x: size.width * 0.7, y: size.height * 0.28))
        menuButton.name = "menuBtn"
        addChild(menuButton)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if touchedNode.name == "tryAgainBtn" || touchedNode.parent?.name == "tryAgainBtn" {
            guard let view = self.view else { return }
            let gameScene = GameScene(size: view.bounds.size)
            gameScene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 0.5)
            view.presentScene(gameScene, transition: transition)
        } else if touchedNode.name == "menuBtn" || touchedNode.parent?.name == "menuBtn" {
            let titleScene = TitleScene(size: size)
            titleScene.scaleMode = scaleMode
            let transition = SKTransition.fade(withDuration: 0.5)
            view?.presentScene(titleScene, transition: transition)
        }
    }
}
