import Example
@testable import ModuleA
import XCTest

class Test: XCTestCase {
    func testExample() {
        let foo = ModuleA.Foo()
        XCTAssert(foo.doSomething())
    }
}
