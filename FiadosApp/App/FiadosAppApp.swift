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
    
    // Instanciamos el contenedor único para toda la App
    let container = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                // Inyectamos las dependencias necesarias al ViewModel del Dashboard
                DashboardView(
                    viewModel: DashboardViewModel(
                        getStatsUseCase: container.makeGetDashboardStatsUseCase()
                    )
                )
            }
        }
    }
}
