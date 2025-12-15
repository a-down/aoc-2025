import Foundation

var isTest = false
var isPartTwo = false

for argument in CommandLine.arguments {
  switch argument {
  case "--test":
    print("IS TEST")
    isTest.toggle()
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

  var allRanges: [ClosedRange<Int>] = []

  for ingredient in data.ingredients {
    for range in data.ranges {
      allRanges.append(range.0...range.1)
      if (range.0...range.1).contains(ingredient) {
        count += 1
        break
      }
    }
  }

  let combinedRanges = getCombinedRanges(intervals: allRanges)
  var combinedCount = 0
  for comb in combinedRanges {
    combinedCount += comb.count
  }

  print("Part One: \(count)")
  print("Part Two: \(combinedCount)")
}

func getCombinedRanges(intervals: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
  var combined = [ClosedRange<Int>]()
  let sortedIntervals = intervals.sorted { $0.lowerBound < $1.lowerBound }

  guard var accumulator = sortedIntervals.first else { return [] }

  for interval in sortedIntervals.dropFirst() {
    if accumulator.upperBound >= interval.lowerBound
      || accumulator.upperBound == interval.lowerBound - 1
    {
      accumulator = accumulator.lowerBound...max(accumulator.upperBound, interval.upperBound)
    } else {
      combined.append(accumulator)
      accumulator = interval
    }
  }
  combined.append(accumulator)

  return combined
}

getFreshIngredientCount()
