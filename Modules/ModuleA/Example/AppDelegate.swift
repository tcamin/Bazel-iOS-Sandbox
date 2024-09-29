import ModuleA
import ModuleC
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
        self.window = window

        let foo1 = ModuleA.Foo()
        let bar1 = ModuleA.ModuleABar()
        print(foo1, bar1)

        let foo2 = ModuleC.Foo()
        let bar2 = ModuleC.ModuleCBar()
        print(foo2, bar2)

        return true
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
