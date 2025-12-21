import Foundation

var isTest = false

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

func getLinesAsArrays() -> [[String.SubSequence]] {
  let file = getFileText()
  let lines = file.split(separator: "\n")
  let linesArray = lines.map { Substring in
    return Substring.split(separator: " ", omittingEmptySubsequences: true)
  }

  return linesArray
}

func getSumOfWorksheet() {
  let lines = getLinesAsArrays()
  var humanCount = 0
  var cephCount = 0

  for idx in 0..<lines[0].count {
    let lastLine = lines.last
    var method: String = ""
    if let unwrappedLastLine = lastLine {
      method = String(unwrappedLastLine[idx])
    }

    var humanColVal = 0
    var cephColVal = 0

    for (lineIdx, line) in lines.dropLast().enumerated() {
      let int = Int(line[idx])
      if let unwrappedInt = int {
        if lineIdx == 0 {
          humanColVal = Int(unwrappedInt)
          continue
        }
        if method == "*" {
          humanColVal = humanColVal * unwrappedInt
        } else if method == "+" {
          humanColVal = humanColVal + unwrappedInt
        }
      }
    }

    var allColNumbers: [String.SubSequence] = []
    for line in lines.dropLast() {
      allColNumbers.append(line[idx])
    }

    let longestColNumber = allColNumbers.max(by: { $0.count > $1.count })?.count
    if let unwrapped = longestColNumber {
        var vertNum: [String] = []
      for numIdx in 0...unwrapped {
        vertNum.append()
      }
    }

    humanCount += humanColVal

    print("Human Column Value: \(humanColVal)")
    print("Cephalopod Column Value: \(cephColVal)")
  }

  print("Human Worksheet Value: \(humanCount)")
  print("Cephalopod Worksheet Value: \(cephCount)")
}

getSumOfWorksheet()
