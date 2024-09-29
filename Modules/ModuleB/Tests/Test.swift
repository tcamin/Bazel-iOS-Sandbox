import Example
@testable import ModuleB
import XCTest

class Test: XCTestCase {
    func testExample() {
        let foo = ModuleB.Foo()
        let bar = ModuleB.ModuleBBar()

        XCTAssert(foo.doSomething())
        XCTAssert(bar.doSomething())
    }
}
