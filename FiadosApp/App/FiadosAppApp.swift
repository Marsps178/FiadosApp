import SwiftUI
import FirebaseCore

// 1. El AppDelegate es necesario para inicializar Firebase al arrancar la App
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct FiadosAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let container = DependencyContainer()
    @State private var globalAuthViewModel: GlobalAuthViewModel

    init() {
        let dc = DependencyContainer()
        self.container = dc
        _globalAuthViewModel = State(initialValue: dc.makeGlobalAuthViewModel())
    }

    var body: some Scene {
        WindowGroup {
            RootView(authViewModel: globalAuthViewModel, container: container)
        }
    }
}
