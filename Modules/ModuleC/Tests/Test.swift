import Example
@testable import ModuleC
import XCTest

class Test: XCTestCase {
    func testExample() {
        let foo = ModuleC.Foo()
        let bar = ModuleC.ModuleCBar()

        XCTAssert(foo.doSomething())
        XCTAssert(bar.doSomething())
    }
}
