import SpriteKit
import UIKit
import GameplayKit

class GameScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var timeRemaining : Int = 30
    private var timer: Timer?
    private var timerLabel : SKLabelNode!
    private var scoreLabel : SKLabelNode!
    private var inputField : UITextField!
    private var submitButton : SKSpriteNode!
    private var returnButton : SKSpriteNode!
    private var inputBoxNode : SKShapeNode!
    private var trWord: [TRWord] = []
    private var currentTargetWord: String = ""
    private var score: Int = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .darkGray
        
        if let words = JSONReading.loadWords(from: "Words") {
            self.trWord = words
        } else {
            print("Failed to load word data")
        }
        
        timerLabel = SKLabelNode(text: "\(timeRemaining)")
        timerLabel.fontName = "Helvetica-Bold"
        timerLabel.fontSize = 36
        timerLabel.fontColor = .systemYellow
        timerLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.9)
        addChild(timerLabel)
        
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
        
        let wordBox = SKShapeNode(rectOf: CGSize(width: 320, height: 50))
        wordBox.name = "wordBox"
        wordBox.fillColor = .white
        wordBox.position = CGPoint(x: size.width / 2, y: size.height * 0.6)
        addChild(wordBox)
        
        let wordLabel = SKLabelNode(text: "Example")
        wordLabel.name = "wordLabel"
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
        loadRandomWord()
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
                self.gameOver()
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

    private func gameOver() {
        inputField?.resignFirstResponder()
        let endScene = EndGameScene(size: size, score: score)
        endScene.scaleMode = scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(endScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if touchedNode.name == "submitBtn" || touchedNode.parent?.name == "submitBtn" {
            let playerAnswer = inputField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
            let targetWord = currentTargetWord.lowercased()
            let isCorrect = WordComparison(sub: playerAnswer, word: targetWord)
            
            let letterCount = currentTargetWord.count
            
            adjustTime(by: letterCount, isCorrect: isCorrect)
            
            if isCorrect {
                    timerLabel.run(SKAction.scale(to: 1.3, duration: 0.1)) {
                        self.timerLabel.run(SKAction.scale(to: 1.0, duration: 0.1))
                    }
                    loadRandomWord()
                } else {
                    // Optional: Shake animation for wrong answer
                    let shake = SKAction.shake(duration: 0.3, amplitude: 5)
                    inputBoxNode.run(shake)
                }
            
            inputField.text = ""
            inputField.resignFirstResponder()
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
    
    // Lógica do jogo

    private func loadRandomWord() {
        guard !trWord.isEmpty else {
            print("No valid words to display")
            return
        }
        
        let randomWord = trWord.randomElement()!
        let target = randomWord.cWord
        let fake = randomWord.anonWord
        
        if (target != "") {
            currentTargetWord = target
            
            if let wordBox = childNode(withName: "//wordBox") as? SKShapeNode,
               let label = wordBox.childNode(withName: "//wordLabel") as? SKLabelNode {
                label.text = fake
            }
        }
    }

    func WordComparison(sub: String, word: String) -> Bool {
        return sub.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ==
               word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
    private func adjustTime(by letters: Int, isCorrect: Bool) {
        let timeChange: Int
        
        if isCorrect {
            timeChange = letters
            timeRemaining += letters * 2
            // timeRemaining = min(timeRemaining, 120)
        } else {
            timeChange = -letters
            timeRemaining -= letters * 3
        }
        
        score += timeChange
        
        timeRemaining = max(timeRemaining, 0)
        
        timerLabel.text = "\(timeRemaining)s"
        timerLabel.fontColor = timeRemaining <= 5 ? .systemRed : .systemYellow
        scoreLabel.text = "Score: \(score)"
        
        if isCorrect {
            scoreLabel.run(SKAction.sequence([
                SKAction.scale(to: 1.4, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1)
            ]))
        }
        
        if timeRemaining <= 0 {
            timer?.invalidate()
            timer = nil
            gameOver()
        }
    }
}

extension GameScene: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SKAction {
    static func shake(duration: TimeInterval, amplitude: CGFloat) -> SKAction {
        return SKAction.sequence([
            SKAction.moveBy(x: -amplitude, y: 0, duration: duration/4),
            SKAction.moveBy(x: amplitude*2, y: 0, duration: duration/2),
            SKAction.moveBy(x: -amplitude, y: 0, duration: duration/4)
        ])
    }
}

