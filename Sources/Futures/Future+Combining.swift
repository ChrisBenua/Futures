import Foundation

extension Future {
  public func firstWith<U>(_ other: Future<U>) -> Future<Either<T, U>> {
    let (future, fill) = Future<Either<T, U>>.create()
    var isEmpty = true
    self.resolved { value in
      if isEmpty {
        isEmpty = false
        fill(.left(value))
      }
    }
    
    other.resolved { value in
      if isEmpty {
        isEmpty = false
        fill(.right(value))
      }
    }
    return future
  }
  
  public func with<U>(other: Future<U>) -> Future<(T, U)> {
    let (future, fill) = Future<(T, U)>.create()
    self.resolved { value in
      other.resolved { value2 in
        fill((value, value2))
      }
    }
    return future
  }
  
  public static func all(futures: [Future<T>]) -> Future<[T]> {
    switch Size<Future<T>>(futures) {
    case .empty:
      return Future<[T]>(value: [])
    case let .oneElement(first: first):
      return first.map { [$0] }
    case let .moreThanOneElement(first: first, other: other):
      return first.with(other: all(futures: other)).map { [$0.0] + $0.1 }
    }
  }
}
