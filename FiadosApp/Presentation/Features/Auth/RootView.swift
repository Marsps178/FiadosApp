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
                TabView {
                    // TAB 1: INICIO (DASHBOARD)
                    NavigationStack {
                        DashboardView(
                            viewModel: container.makeDashboardViewModel(),
                            authViewModel: authViewModel,
                            container: container
                        )
                        .navigationDestination(for: AppRoute.self) { route in
                            destinationView(for: route)
                        }
                    }
                    .tabItem {
                        Label("Inicio", systemImage: "house.fill")
                    }
                    
                    // TAB 2: CLIENTES
                    NavigationStack {
                        CustomerListView(
                            viewModel: container.makeCustomerListViewModel(),
                            container: container
                        )
                        .navigationDestination(for: AppRoute.self) { route in
                            destinationView(for: route)
                        }
                    }
                    .tabItem {
                        Label("Clientes", systemImage: "person.3.fill")
                    }
                    
                    // TAB 3: AJUSTES
                    NavigationStack {
                        SettingsView(authViewModel: authViewModel)
                    }
                    .tabItem {
                        Label("Ajustes", systemImage: "gearshape.fill")
                    }
                }
                .tint(AppTheme.primary)
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

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .customerList:
            CustomerListView(
                viewModel: container.makeCustomerListViewModel(),
                container: container
            )
        case .customerDetail(let customer):
            CustomerDetailView(viewModel: container.makeCustomerDetailViewModel(customer: customer))
        case .settings:
            SettingsView(authViewModel: authViewModel)
        }
    }
}
