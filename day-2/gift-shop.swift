import Foundation

let arguments = CommandLine.arguments.dropFirst()  // Drop the executable path

var isTest = false
if let firstArg = arguments.first {
  if firstArg == "true" {
    print("\nIS TEST\n")
    isTest = true
  }
}

func getFileText(fileName: String) -> String {
  let currentDirectoryPath = FileManager().currentDirectoryPath

  let baseUrl = URL(fileURLWithPath: currentDirectoryPath)
  let fileURL = baseUrl.appendingPathComponent(fileName)

  do {
    let fileContents: String = try String(contentsOf: fileURL, encoding: .utf8)
    return fileContents
  } catch {
    print("Error reading from file: \(error)")
    return ""
  }
}

func getRangesFromFile() -> [(Int, Int)] {
  let fileContents = getFileText(fileName: isTest ? "test-input.txt" : "input.txt")
  let fileArray = fileContents.split(separator: ",")
  return fileArray.map { Substring in
    let bookends = Substring.split(separator: "-")
    let startInt = Int(bookends[0])
    let endInt = Int(bookends[1])

    guard let unwrappedStartInt = startInt, let unwrappedEndInt = endInt else {
      return (start: 0, end: 0)
    }
    return (unwrappedStartInt, unwrappedEndInt)
  }
}

func getInvalidIdsValueFromRange(range: (Int, Int)) -> Int {
  let allIdsInRange = Array(range.0...range.1)
  var valueOfInvalidIds = 0

  for id in allIdsInRange {
    let splitId = String(id).split(separator: "")
    let halfLength = splitId.count / 2
    let firstHalf = splitId[0..<halfLength].joined(separator: "")
    let secondHalf = splitId[halfLength..<splitId.count].joined(separator: "")

    if firstHalf == secondHalf {
      valueOfInvalidIds = valueOfInvalidIds + id
    }
  }

  return valueOfInvalidIds
}

func getGiftShopInvalidIdSum() {
  var sum = 0
  let ranges = getRangesFromFile()
  for range in ranges {
    let rangeValue = getInvalidIdsValueFromRange(range: range)
    sum = sum + rangeValue
  }
  print(sum)
}

getGiftShopInvalidIdSum()
