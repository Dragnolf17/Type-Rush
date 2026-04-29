//
//  GameScene.swift
//  Json Reading
//
//  Created by Aluno a27942 Teste on 29/04/2026.
//

import SpriteKit
import GameplayKit

struct User : Codable {
    let id : Int
    let name : String
    let age : Int
}

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        var users = UserStore.load()
        for user in users {
            print(user.name, user.id, user.age)
        }
        
        users.append(User(id: 10, name: "Kril", age: 1000))
        UserStore.save(users)
    }
    
    func loadUsers() -> [User]? {
        guard let data = loadJsonFile(named: "Test") else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode([User].self, from: data)
    }
    
    func loadJsonFile(named filename: String) -> Data? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json")
        else {
            print("File not found")
            return nil
        }
        return try? Data(contentsOf: url)
    }
    
}
