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

func getBatteryBanks() -> [String] {
  let file = getFileText(fileName: isTest ? "test-input.txt" : "input.txt")
  return file.split(separator: "\n").map { Substring in
    String(Substring)
  }
}

func getBatteryBankJoltage(batteryBank: String) -> Int {
  let splitBatteryBank: [String] = batteryBank.split(separator: "").map { Substring in
    String(Substring)
  }

  var highestJoltage = 0
  outerLoop: for idx in 0...(splitBatteryBank.count - 2) {
    for jdx in 0...(splitBatteryBank.count - 1) {
      if idx >= jdx {
        continue
      }
      let joltage = Int("\(splitBatteryBank[idx])\(splitBatteryBank[jdx])")
      guard let unwrappedJoltage = joltage else {
        continue
      }
      if unwrappedJoltage > highestJoltage {
        highestJoltage = unwrappedJoltage
      }
    }
  }

  print(("Battery Bank: \(batteryBank)"))
  print("Joltage: \(highestJoltage)")

  return highestJoltage
}

func printTotalJoltage() {
  var totalJoltage = 0

  for batteryBank in getBatteryBanks() {
    totalJoltage += getBatteryBankJoltage(batteryBank: batteryBank)
  }

  print("Total Joltage: \(totalJoltage)")
}
