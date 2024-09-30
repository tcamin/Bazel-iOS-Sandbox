import Example
@testable import ModuleB
import XCTest

class Test: XCTestCase {
    func testExample() {
        let foo = ModuleB.Foo()
        XCTAssert(foo.doSomething())
    }
}
