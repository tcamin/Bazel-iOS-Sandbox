import Example
@testable import ModuleA
import XCTest

class Test: XCTestCase {
    func testExample() {
        let foo = ModuleA.Foo()
        let bar = ModuleA.ModuleABar()

        XCTAssert(foo.doSomething())
        XCTAssert(bar.doSomething())
    }
}
