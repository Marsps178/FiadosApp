import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
}

@main
struct FiadosAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var container = DependencyContainer()
    @State private var globalAuthViewModel: GlobalAuthViewModel

    init() {
        FirebaseApp.configure()
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
