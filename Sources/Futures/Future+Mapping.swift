import Foundation

extension Future {
  public func map<U>(_ trans: @escaping (T) -> U) -> Future<U> {
    let (future, fill) = Future<U>.create()
    resolved { value in
      fill(trans(value))
    }
    return future
  }
  
  public func flatMap<U>(_ trans: @escaping (T) -> Future<U>) -> Future<U> {
    let (future, fill) = Future<U>.create()
    resolved { value in
      trans(value).resolved {
        fill($0)
      }
    }
    return future
  }
  
  public func then<U>(_ cont: @escaping () -> U) -> Future<U> {
    self.map { _ in cont() }
  }
  
  public func then<U>(_ cont: @escaping () -> Future<U>) -> Future<U> {
    self.flatMap { _ in cont() }
  }
}
