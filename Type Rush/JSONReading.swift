
import Foundation

struct JSONReading {
    static func loadWords(from filename: String) -> [TRWord]? {
        guard let data = loadJsonFile(named: filename) else { return nil }
        return try? JSONDecoder().decode([TRWord].self, from: data)
    }
    
    private static func loadJsonFile(named filename: String) -> Data? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("JSON file not found: \(filename).json")
            return nil
        }
        return try? Data(contentsOf: url)
    }
}
