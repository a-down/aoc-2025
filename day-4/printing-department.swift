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
  let isFirstRow = rowIdx == 0
  let isLastRow = rowIdx == rows.count - 1
  let isFirstCol = colIdx == 0
  let isLastCol = colIdx == rows[0].count - 1

  let cellsToCheck: [(isNotExistent: Bool, Int, Int)] = [
    (isFirstRow || isFirstCol, rowIdx - 1, colIdx - 1),
    (isFirstRow, rowIdx - 1, colIdx),
    (isFirstRow || isLastCol, rowIdx - 1, colIdx + 1),
    (isFirstCol, rowIdx, colIdx - 1),
    (isLastCol, rowIdx, colIdx + 1),
    (isLastRow || isFirstCol, rowIdx + 1, colIdx - 1),
    (isLastRow, rowIdx + 1, colIdx),
    (isLastRow || isLastCol, rowIdx + 1, colIdx + 1),
  ]

  for cell in cellsToCheck {
    if cell.isNotExistent {
      openAdjacentPositionsCount += 1
      continue
    }
    if !rows[cell.1][cell.2] {
      openAdjacentPositionsCount += 1
    }
    if openAdjacentPositionsCount > 4 {
      break
    }
  }

  return openAdjacentPositionsCount > 4
}

print(findAccessibleRollsCount())
