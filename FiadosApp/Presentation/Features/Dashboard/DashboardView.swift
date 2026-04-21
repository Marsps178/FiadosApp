import SwiftUI
import Charts

struct DashboardView: View {
    @State var viewModel: DashboardViewModel
    @Bindable var authViewModel: GlobalAuthViewModel
    let container: DependencyContainer
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                // --- TARJETA DE RESUMEN (HU-07) ---
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "wallet.pass.fill")
                            .font(.title2)
                        Text("Balance Total")
                            .font(.headline)
                        Spacer()
                    }
                    .foregroundColor(.white.opacity(0.8))
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text(AppTheme.currency(viewModel.totalDebt))
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack {
                        Text("Dinero en la calle")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption.bold())
                    }
                }
                .padding(24)
                .background(AppTheme.primaryGradient)
                .cornerRadius(AppTheme.radiusCard)
                .shadow(color: AppTheme.primary.opacity(0.3), radius: 20, x: 0, y: 10)
                
                // --- GRÁFICO DE DEUDAS (HU adicional) ---
                if !viewModel.topDebtors.isEmpty {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Distribución de Deuda")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chart.bar.xaxis")
                                .foregroundColor(.secondary)
                        }
                        
                        Chart {
                            ForEach(viewModel.topDebtors) { customer in
                                BarMark(
                                    x: .value("Deuda", customer.currentDebt),
                                    y: .value("Cliente", customer.name)
                                )
                                .foregroundStyle(AppTheme.primary.gradient)
                                .cornerRadius(4)
                                .annotation(position: .trailing) {
                                    Text(AppTheme.currency(customer.currentDebt))
                                        .font(.system(size: 10, weight: .medium, design: .rounded))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .frame(height: 160)
                        .chartXAxis(.hidden)
                        .chartYAxis {
                            AxisMarks { value in
                                AxisValueLabel()
                                    .font(.caption2)
                            }
                        }
                    }
                    .padding()
                    .background(AppTheme.cardBG)
                    .cornerRadius(AppTheme.radiusCard)
                    .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
                }
                
                // --- SECCIÓN TOP DEUDORES (HU-08) ---
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Text("Mayores Deudores")
                            .font(.title3.bold())
                        Spacer()
                        NavigationLink(value: AppRoute.customerList) {
                            Text("Ver todos")
                                .font(.caption.bold())
                                .foregroundColor(AppTheme.primary)
                        }
                    }
                    
                    if viewModel.topDebtors.isEmpty && !viewModel.isLoading {
                        ContentUnavailableView(
                            "Sin deudas",
                            systemImage: "checkmark.circle.fill",
                            description: Text("No hay clientes con saldos pendientes.")
                        )
                        .padding()
                        .cardStyle()
                    } else {
                        VStack(spacing: 12) {
                            ForEach(viewModel.topDebtors) { customer in
                                NavigationLink(value: AppRoute.customerDetail(customer)) {
                                    DashboardCustomerRow(customer: customer)
                                        .padding(.vertical, 4)
                                }
                                .buttonStyle(.plain)
                                
                                if customer.id != viewModel.topDebtors.last?.id {
                                    Divider().opacity(0.5)
                                }
                            }
                        }
                        .padding()
                        .background(AppTheme.cardBG)
                        .cornerRadius(AppTheme.radiusCard)
                    }
                }
                
                // --- BOTÓN DE ACCIÓN PRINCIPAL ---
                NavigationLink(value: AppRoute.customerList) {
                    HStack {
                        Image(systemName: "person.2.badge.gearshape.fill")
                        Text("Gestionar Cartera de Clientes")
                    }
                    .primaryButtonStyle()
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .navigationTitle("Inicio")
        // --- CENTRALIZACIÓN DE NAVEGACIÓN ---
        .navigationDestination(for: AppRoute.self) { route in
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
        .refreshable {
            await viewModel.loadDashboard()
        }
        .onAppear {
            // onAppear se dispara tanto en la carga inicial como al regresar
            // desde CustomerDetail o CustomerList via NavigationStack.
            Task {
                await viewModel.loadDashboard()
            }
        }
        .alert("Error", isPresented: .init(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil })) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    HapticManager.selection()
                    // Navegar a Configuración en lugar de logout directo
                }) {
                    NavigationLink(value: AppRoute.settings) {
                        Image(systemName: "person.circle.fill")
                            .font(.title3)
                            .foregroundColor(AppTheme.primary)
                    }
                }
            }
        }
    }
}
