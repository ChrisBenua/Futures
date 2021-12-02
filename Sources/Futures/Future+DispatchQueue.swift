import Foundation

extension Future {
  public func onQueue(queue: DispatchQueue) -> Future {
    let (future, fill) = Future.create()
    self.resolved { value in
      queue.async {
        fill(value)
      }
    }
    return future
  }
  
  public static func withAsyncTask(
    task: (@escaping (T) -> Void) -> Void
  ) -> Future {
    let (future, fill) = Future.create()
    task(fill)
    return future
  }
  
  public func after(
    timeInterval: TimeInterval,
    onQueue: DispatchQueue
  ) -> Future {
    let (future, fill) = Future.create()
    self.resolved { value in
      onQueue.asyncAfter(deadline: .now() + .milliseconds(Int(timeInterval * 1000))) {
        fill(value)
      }
    }
    return future
  }
  
  public static func withBackgroundAsyncTask(
    task: @escaping () -> Future<T>,
    launchQueue: DispatchQueue,
    resolveQueue: DispatchQueue
  ) -> Future {
    let (future, fill) = Future.create()
    launchQueue.async {
      task().resolved { value in
        resolveQueue.async {
          fill(value)
        }
      }
    }
    return future
  }
  
  public static func withBackgroundAsyncTask(
    task: @escaping () -> T,
    launchQueue: DispatchQueue,
    resolveQueue: DispatchQueue
  ) -> Future {
    let (future, fill) = Future.create()
    launchQueue.async {
      let result = task()
      resolveQueue.async {
        fill(result)
      }
    }
    return future
  }
  
  public func withTimeOut(
    timeOut: TimeInterval,
    onQueue: DispatchQueue,
    defaultValue: T
  ) -> Future {
    let defaultFuture = Future(value: defaultValue).after(timeInterval: timeOut, onQueue: onQueue)

    return self.firstWith(defaultFuture).map{ $0.value }
  }
}
