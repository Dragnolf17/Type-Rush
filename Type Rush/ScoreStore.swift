//
//  ScoreStore.swift
//  Type Rush
//
//  Persists the player's best score across sessions.
//

import Foundation

struct ScoreStore {
    private static let highScoreKey = "TypeRush.highScore"

    /// The best score recorded so far. Defaults to 0 when nothing is stored yet.
    static var highScore: Int {
        get { UserDefaults.standard.integer(forKey: highScoreKey) }
        set { UserDefaults.standard.set(newValue, forKey: highScoreKey) }
    }

    /// Records a finished run's score. Returns true when it beats the stored high score.
    @discardableResult
    static func submit(_ score: Int) -> Bool {
        guard score > highScore else { return false }
        highScore = score
        return true
    }
}
