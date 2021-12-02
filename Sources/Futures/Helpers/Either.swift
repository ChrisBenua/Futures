import Foundation

public enum Either<A, B> {
  case left(A)
  case right(B)
}

public extension Either where A == B {
  var value: A {
    switch self {
    case .left(let value):
      return value
    case .right(let value):
      return value
    }
  }
}
