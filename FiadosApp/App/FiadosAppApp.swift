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
@main
struct FiadosAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let container = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DashboardView(
                    viewModel: container.makeDashboardViewModel(),
                    container: container
                )
            }
        }
    }
}
