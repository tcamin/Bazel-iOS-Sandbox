import Example
@testable import ModuleC
import XCTest

class Test: XCTestCase {
    func testExample() {
        let foo = ModuleC.Foo()
        XCTAssert(foo.doSomething())
    }
}
