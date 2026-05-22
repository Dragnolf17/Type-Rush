
import Foundation

struct JSONReading {
    static func loadWords(from filename: String) -> [TRWord]? {
        // 1. Load raw data
        guard let data = loadJsonFile(named: filename) else {
            print("Failed to load data from \(filename).json")
            return nil
        }
        
        // 2. Decode with error reporting
        do {
            let words = try JSONDecoder().decode([TRWord].self, from: data)
            print("Successfully decoded \(words.count) words")
            return words
        } catch {
            print("Decoding error: \(error.localizedDescription)")
            
            // More detailed decoding error info
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("Missing key: '\(key.stringValue)' — \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("Type mismatch for \(type): \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("Missing value for \(type): \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("Corrupted data: \(context.debugDescription)")
                @unknown default:
                    print("Unknown decoding error")
                }
            }
            return nil
        }
    }
    
    private static func loadJsonFile(named filename: String) -> Data? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("File not found in bundle: \(filename).json")
            print("Bundle path: \(Bundle.main.bundlePath)")
            print("Available JSON files: \(Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil))")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            print("Loaded \(data.count) bytes from \(filename).json")
            return data
        } catch {
            print("Error reading file data: \(error.localizedDescription)")
            return nil
        }
    }
}
