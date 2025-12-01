// format: swift-format ./day-1/secret-entrance.swift -i
// Day 1: Secret Entrance

import Foundation

func getTurns() -> [String] {
  let currentDirectoryPath = FileManager().currentDirectoryPath
  let fileName = "test-input.txt"

  do {
    let baseUrl = URL(fileURLWithPath: currentDirectoryPath)
    let fileURL = baseUrl.appendingPathComponent(fileName)

    let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
    let fileArray = fileContents.split(separator: "\n")
    return fileArray.map { Substring in
      String(Substring)
    }

  } catch {
    print("Error reading from file: \(error)")
    return []
  }
}

print(getTurns())
