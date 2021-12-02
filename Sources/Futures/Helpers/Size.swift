import Foundation

enum Size<U> {
  case empty
  case oneElement(first: U)
  case moreThanOneElement(first: U, other: [U])
  
  init(_ array: [U]) {
    if array.isEmpty {
      self = .empty
    }
    else {
      let first = array.first!
      if array.count == 1 {
        self = .oneElement(first: first)
      } else {
        self = .moreThanOneElement(first: first, other: Array(array.dropFirst()))
      }
    }
  }
}
