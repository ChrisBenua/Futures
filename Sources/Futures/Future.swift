public class Future<T> {
  private enum State {
    case empty(callbacks: [(T) -> Void])
    case resolved(value: T)
  }
  private var state: State
  
  init() {
    self.state = .empty(callbacks: [])
  }
  
  public init(value: T) {
    self.state = .resolved(value: value)
  }
  
  public static func create() -> (Future<T>, feed: (T) -> Void) {
    let future = Future()
    return (future, future.accept(_:))
  }
  
  public func resolved(_ callback: @escaping (T) -> Void) {
    switch state {
    case let .resolved(value: value):
      callback(value)
    case let .empty(callbacks: callbacks):
      self.state = .empty(callbacks: callbacks + [callback])
    }
  }
  
  public func unwrap() -> T? {
    switch state {
    case let .resolved(value: value):
      return value
    case .empty:
      return nil
    }
  }
  
  private func accept(_ value: T) {
    switch state {
    case .empty(let callbacks):
      self.state = .resolved(value: value)
      callbacks.forEach { $0(value) }
    case .resolved:
      break
    }
  }
}
