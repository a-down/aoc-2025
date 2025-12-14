import Foundation

var isTest = false
var isPartTwo = false

for argument in CommandLine.arguments {
  switch argument {
  case "--test":
    print("IS TEST")
    isTest.toggle()
  case "--two":
    print("→ IS PART TWO")
    isPartTwo.toggle()
  default:
    break
  }
}

func getFileText() -> String {
  let currentDirectoryPath = FileManager().currentDirectoryPath

  let baseUrl = URL(fileURLWithPath: currentDirectoryPath)
  let fileURL = baseUrl.appendingPathComponent(isTest ? "test-input.txt" : "input.txt")

  do {
    let fileContents: String = try String(contentsOf: fileURL, encoding: .utf8)
    return fileContents
  } catch {
    print("Error reading from file: \(error)")
    return ""
  }
}

func getDbData() -> (ranges: [(Int, Int)], ingredients: [Int]) {
  let file = getFileText()
  let arrays = file.split(separator: "\n\n").map { Substring in
    Substring.split(separator: "\n").map { Substring in
      String(Substring)
    }
  }
  var ranges: [(Int, Int)] = []
  for rangeString in arrays[0] {
    let split = rangeString.split(separator: "-")
    if let start = Int(split[0]), let end = Int(split[1]) {
      ranges.append((start, end))
    }
  }
  var ingredients: [Int] = []
  for ingString in arrays[1] {
    if let ingNum = Int(ingString) {
      ingredients.append(ingNum)
    }
  }
  return (ranges: ranges, ingredients: ingredients)
}

func getFreshIngredientCount() {
  var count = 0
  let data = getDbData()

  for ingredient in data.ingredients {
    for range in data.ranges {
      if (range.0...range.1).contains(ingredient) {
        count += 1
        break
      }
    }
  }

  print("Count: \(count)")
}

getFreshIngredientCount()
