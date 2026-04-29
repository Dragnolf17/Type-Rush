
import Foundation

struct UserStore {
    static let filename = "Test.json"
    
    private static var FileURL : URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(filename)
    }
    
    static func initialize() {
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: FileURL.path){
            return
        }
        
        guard let bundleURL = Bundle.main.url(forResource: "Test", withExtension: "json") else {
            print("File not found in bundle")
            return
        }
        
        do {
            let data = try Data(contentsOf: bundleURL)
            try data.write(to: FileURL)
            print("File copied to Documents at ", FileURL)
        } catch {
            print("Failed to copy file")
        }
    }
    
    static func load() -> [User] {
        do {
            let data = try Data(contentsOf: FileURL)
            return try JSONDecoder().decode([User].self, from: data)
        }
        catch {
            print("Load Error")
            return []
        }
    }
    
    static func save(_ users: [User]) {
        do {
            let data = try JSONEncoder().encode(users)
            try data.write(to: FileURL)
            print("Saved")
        }
        catch {
            print("Save Error")
        }
    }
}
