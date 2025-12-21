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
  var count = 0

  for idx in 0..<lines[0].count {
    let lastLine = lines.last
    var method: String = ""
    if let unwrappedLastLine = lastLine {
      method = String(unwrappedLastLine[idx])
    }

    var lineVal = 0

    for (lineIdx, line) in lines.dropLast().enumerated() {
      let int = Int(line[idx])
      if let unwrappedInt = int {
        if lineIdx == 0 {
          lineVal = Int(unwrappedInt)
          continue
        }
        if method == "*" {
          lineVal = lineVal * unwrappedInt
        } else if method == "+" {
          lineVal = lineVal + unwrappedInt
        }
      }
    }

    count += lineVal
    print("Line Value: \(lineVal)")
  }

  print("Worksheet Value: \(count)")
}

getSumOfWorksheet()
