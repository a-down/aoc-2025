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

func getBatteryBankJoltage(batteryBank: String, batteryLimit: Int) -> Int {
  let splitBatteryBank: [String] = batteryBank.split(separator: "").map { Substring in
    String(Substring)
  }

  var highestJoltage = 0

  var splitBatteryBankWithRemoved = splitBatteryBank
  splitBatteryBankWithRemoved.removeLast(batteryLimit - 1)

  outerLoop: for i in (1...9).reversed() {
    if let iIdx = splitBatteryBankWithRemoved.firstIndex(of: String(i)) {
      print("iIdx", iIdx, i)
      var splitBatterBankWithoutStart = splitBatteryBank
      splitBatterBankWithoutStart.removeSubrange(0...iIdx)
      print(splitBatteryBank)
      print("w/o start \(splitBatterBankWithoutStart)")

      for j: Int in (1...9).reversed() {
        print(i, j)
        if let jIdx = splitBatteryBank.indices(of: String(j))
        {
          print("indexes", iIdx, jIdx)
          if iIdx < jIdx {
            let joltage = Int("\(i)\(j)")
            guard let joltage = joltage else {
              continue
            }
            print("joltage", joltage, highestJoltage)
            if joltage > highestJoltage {
              highestJoltage = joltage
            }
            break outerLoop
          }
        }

      }
    }
  }

  var actualHighestJoltage = 0
  outerLoop: for idx in 0...(splitBatteryBank.count - 2) {
    for jdx in 0...(splitBatteryBank.count - 1) {
      if idx >= jdx {
        continue
      }
      let joltage = Int("\(splitBatteryBank[idx])\(splitBatteryBank[jdx])")
      guard let unwrappedJoltage = joltage else {
        continue
      }
      if unwrappedJoltage > actualHighestJoltage {
        actualHighestJoltage = unwrappedJoltage
      }
    }
  }

  // print(("Battery Bank: \(batteryBank)"))
  // print("Joltage: \(highestJoltage)")
  if highestJoltage != actualHighestJoltage {
    print("Battery Bank: \(batteryBank)")
    print("Incorrect Highest Joltage: \(highestJoltage)")
    print("Actual Highest Joltage: \(actualHighestJoltage)")
  }

  return highestJoltage
}

func printTotalJoltage() {
  var totalJoltage = 0

  for batteryBank in getBatteryBanks() {
    totalJoltage += getBatteryBankJoltage(batteryBank: batteryBank, batteryLimit: 2)
  }

  print("Total Joltage: \(totalJoltage)")
}

// printTotalJoltage()
print(
  getBatteryBankJoltage(
    batteryBank:
      "7553154621162252232354352224245561873423127442553452398445224242243443525234625124162152237227454463",
    batteryLimit: 2))
