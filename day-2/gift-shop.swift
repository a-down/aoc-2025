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

  // Part 1
  for id in allIdsInRange {
    let splitId = String(id).split(separator: "")
    let halfLength = splitId.count / 2
    let firstHalf = splitId[0..<halfLength].joined(separator: "")
    let secondHalf = splitId[halfLength..<splitId.count].joined(separator: "")

    if firstHalf == secondHalf {
      valueOfInvalidIds = valueOfInvalidIds + id
    }
  }

  // Part 2
  // for id in allIdsInRange {
  //   // let halfLength = String(id).count / 2

  //   for chunkLength in 1...String(id).count {
  //     // TODO: check if fully divisible by chunkLength
  //     var splitId = String(id).split(separator: "")
  //     var chunks: [String] = []
  //     for _ in stride(from: 0, to: splitId.count, by: chunkLength) {
  //       let chunk = splitId[0..<chunkLength].joined()
  //       chunks.append(chunk)
  //       for _ in 0..<chunkLength {
  //         print(splitId)
  //         splitId.remove(at: 0)
  //       }
  //       print("chunks", chunks, splitId)
  //     }
  //     let chunksSet = Set(chunks)
  //     if (chunks.count != chunksSet.count) && chunksSet.count == 1 {
  //       print("Chunks", chunks)
  //       print("ChunksSet", chunksSet)
  //       break
  //     }
  //   }
  // }

  return valueOfInvalidIds
}

func getGiftShopInvalidIdSum() {
  var sum = 0
  let ranges = getRangesFromFile()
  for range in ranges {
    let rangeValue = getInvalidIdsValueFromRange(range: (222220, 222222))
    sum = sum + rangeValue
  }
  print(sum)
}

getGiftShopInvalidIdSum()
