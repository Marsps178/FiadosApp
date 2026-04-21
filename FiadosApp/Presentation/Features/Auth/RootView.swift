import SwiftUI

struct RootView: View {
    @Bindable var authViewModel: GlobalAuthViewModel
    let container: DependencyContainer
    
    var body: some View {
        Group {
            if authViewModel.isCheckingAuth {
                ProgressView("Conectando de forma segura...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppTheme.background)
            } else if authViewModel.isAuthenticated {
                NavigationStack {
                    DashboardView(
                        viewModel: container.makeDashboardViewModel(),
                        authViewModel: authViewModel,
                        container: container
                    )
                }
            } else {
                NavigationStack {
                    LoginView(
                        viewModel: container.makeLoginViewModel(),
                        container: container
                    )
                }
            }
        }
    }
}
