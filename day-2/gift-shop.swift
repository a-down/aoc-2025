import Foundation

func getRangesFromFile(isTest: Bool) -> [(start: Int, end: Int)] {
  let currentDirectoryPath = FileManager().currentDirectoryPath
  let fileName: String = isTest ? "test-input.txt" : "input.txt"

  do {
    let baseUrl = URL(fileURLWithPath: currentDirectoryPath)
    let fileURL = baseUrl.appendingPathComponent(fileName)

    let fileContents: String = try String(contentsOf: fileURL, encoding: .utf8)
    let fileArray = fileContents.split(separator: ",")
    return fileArray.map { Substring in
      let bookends = Substring.split(separator: "-")
      let startInt = Int(bookends[0])
      let endInt = Int(bookends[1])

      guard let unwrappedStartInt = startInt, let unwrappedEndInt = endInt else {
        return (start: 0, end: 0)
      }
      return (start: unwrappedStartInt, end: unwrappedEndInt)

      // return (start: startInt, end: endInt)

      // return String(Substring)
    }

  } catch {
    print("Error reading from file: \(error)")
    return []
  }
}

print(getRangesFromFile(isTest: true))
