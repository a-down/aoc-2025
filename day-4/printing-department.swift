import Foundation

let arguments = CommandLine.arguments.dropFirst()  // Drop the executable path

var isTest = false
if let firstArg = arguments.first {
  if firstArg == "true" {
    print("\nIS TEST\n")
    isTest = true
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

func getPaperRows() -> [[Bool]] {
  let rows = getFileText().split(separator: "\n")
  let rowsArrays: [[Bool]] = rows.map { row in
    let array = row.split(separator: "")
    return array.map { item in
      item == "@" ? true : false
    }
  }
  return rowsArrays
}

func findAccessibleRollsCount() -> Int {
  var count = 0
  let rows = getPaperRows()

  for (rowIdx, row) in rows.enumerated() {
    for (colIdx, pos) in row.enumerated() {
      if pos {
        if getIsPositionAccessible(rows: rows, rowIdx: rowIdx, colIdx: colIdx) {
          count += 1
        }
      }
    }
  }

  return count
}

func getIsPositionAccessible(rows: [[Bool]], rowIdx: Int, colIdx: Int) -> Bool {
  var openAdjacentPositionsCount = 0
  // TODO: Could move to args for performance
  let isFirstRow = rowIdx == 0
  let isLastRow = rowIdx == rows.count - 1
  let isFirstCol = colIdx == 0
  let isLastCol = colIdx == rows[0].count - 1

  // TODO: Yuck

  // top left
  if isFirstRow || isFirstCol || rows[rowIdx - 1][colIdx - 1] == false {
    openAdjacentPositionsCount += 1
  }
  // top center
  if isFirstRow || rows[rowIdx - 1][colIdx] == false {
    openAdjacentPositionsCount += 1
  }
  // top right
  if isFirstRow || isLastCol || rows[rowIdx - 1][colIdx + 1] == false {
    openAdjacentPositionsCount += 1
  }
  // left
  if isFirstCol || rows[rowIdx][colIdx - 1] == false {
    openAdjacentPositionsCount += 1
  }
  // right
  if isLastCol || rows[rowIdx][colIdx + 1] == false {
    openAdjacentPositionsCount += 1
  }
  // bottom left
  if isLastRow || isFirstCol || rows[rowIdx + 1][colIdx - 1] == false {
    openAdjacentPositionsCount += 1
  }
  // top center
  if isLastRow || rows[rowIdx + 1][colIdx] == false {
    openAdjacentPositionsCount += 1
  }
  // top right
  if isLastRow || isLastCol || rows[rowIdx + 1][colIdx + 1] == false {
    openAdjacentPositionsCount += 1
  }

  return openAdjacentPositionsCount > 4
}

print(findAccessibleRollsCount())
