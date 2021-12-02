import XCTest
@testable import Futures

final class FutureTests: XCTestCase {
  func testFutureWithInitialValue() {
    let future = Future<Int>(value: 1)
    var callCount = 0
    future.resolved { _ in
      callCount += 1
    }
    XCTAssertEqual(callCount, 1)
  }
  
  func testEmptyFuture() {
    var callCount = 0
    let (future, fill) = Future<Int>.create()
    future.resolved { _ in
      callCount += 1
    }
    XCTAssertEqual(callCount, 0)
    fill(1)
    XCTAssertEqual(callCount, 1)
  }
  
  func testMapping() {
    var callCount = 0
    let (future, fill) = Future<Int>.create()
    let mapped = future.map{ $0 + 1 }
    mapped.resolved { _ in
      callCount += 1
    }
    XCTAssertEqual(callCount, 0)
    fill(1)
    XCTAssertEqual(callCount, 1)
  }
  
  func testFlatMapping() {
    var callCount = 0
    let (future, fill) = Future<Int>.create()
    
    let mapped: Future<Int> = future.flatMap { value in
      let (future2, fill2) = Future<Int>.create()
      fill2(value + 10)
      return future2
    }
    mapped.resolved { value in
      XCTAssertEqual(value, 11)
      callCount += 1
    }
    XCTAssertEqual(callCount, 0)
    fill(1)
    XCTAssertEqual(callCount, 1)
  }
  
  func testCombining() {
    var callCount = 0
    let value1 = 1; let value2 = 2
    let (future, fill) = Future<Int>.create()
    let (future2, fill2) = Future<Int>.create()
    let resultFuture = Future<Int>.all(futures: [future, future2])
    resultFuture.resolved { values in
      callCount += 1
      XCTAssertEqual(values, [1, 2])
    }
    fill(value1)
    XCTAssertEqual(callCount, 0)
    fill2(value2)
    XCTAssertEqual(callCount, 1)
  }
}
