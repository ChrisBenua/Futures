import Foundation

extension Future where T == Void {
  public convenience init() {
    self.init(value: ())
  }
}

