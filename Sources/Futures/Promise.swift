import Foundation

public final class Promise<T> {
  public let future: Future<T>
  private let fill: (T) -> Void
  
  public init() {
    (future, fill) = Future.create()
  }
  
  public func resolve(_ value: T) {
    fill(value)
  }
}

extension Promise where T == Void {
  public func resolve() {
    fill(())
  }
}
