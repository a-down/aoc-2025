// Day 1: Secret Entrance
// Part 1: Times stopped at 0
// Part 2: Times 0 was touched

import Foundation

enum Part: Int {
  case one = 1
  case two = 2
}

func getTurnsFromFile(isTest: Bool) -> [String] {
  let currentDirectoryPath = FileManager().currentDirectoryPath
  let fileName: String = isTest ? "test-input.txt" : "input.txt"

  do {
    let baseUrl = URL(fileURLWithPath: currentDirectoryPath)
    let fileURL = baseUrl.appendingPathComponent(fileName)

    let fileContents: String = try String(contentsOf: fileURL, encoding: .utf8)
    let fileArray = fileContents.split(separator: "\n")
    return fileArray.map { Substring in
      String(Substring)
    }

  } catch {
    print("Error reading from file: \(error)")
    return []
  }
}

func getTimesAtPositionZero(part: Part, isTest: Bool) -> Int {
  var position = 50
  var timesAtPositionZero = 0

  for turn in getTurnsFromFile(isTest: isTest) {
    let direction = turn.first
    let distance = Int(turn.dropFirst())

    guard let distance = distance else {
      continue
    }

    var newPosition = position

    var intArray = [Int](repeating: 0, count: distance - 1)
    intArray.append(1)
    for num in intArray {
      if direction == "L" {
        if newPosition == 0 {
          newPosition = 99
        } else {
          newPosition = newPosition - 1
        }
      }

      if direction == "R" {
        if newPosition == 99 {
          newPosition = 0
        } else {
          newPosition = newPosition + 1
        }
      }

      if part == .two {
        if newPosition == 0 {
          timesAtPositionZero = timesAtPositionZero + 1
        }
      }

      if num == 1 {
        if part == .one {
          if newPosition == 0 {
            timesAtPositionZero = timesAtPositionZero + 1
          }
        }
        position = newPosition
      }
    }
  }

  return timesAtPositionZero
}

print("Times at Zero: \(getTimesAtPositionZero(part: .two, isTest: false))")
