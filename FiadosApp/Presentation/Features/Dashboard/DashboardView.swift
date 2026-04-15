import SwiftUI

struct DashboardView: View {
    @State var viewModel: DashboardViewModel
    let container: DependencyContainer
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                // --- TARJETA DE RESUMEN (HU-07) ---
                VStack(spacing: 10) {
                    Text("Dinero Total en la Calle")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text(AppTheme.currency(viewModel.totalDebt))
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [AppTheme.primary, AppTheme.primary.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(AppTheme.radiusCard)
                .shadow(color: AppTheme.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                
                // --- SECCIÓN TOP DEUDORES (HU-08) ---
                VStack(alignment: .leading, spacing: 15) {
                    Text("Mayores Deudores")
                        .font(.title2.bold())
                    
                    if viewModel.topDebtors.isEmpty && !viewModel.isLoading {
                        ContentUnavailableView(
                            "Sin deudas",
                            systemImage: "checkmark.circle",
                            description: Text("No hay clientes con saldos pendientes.")
                        )
                        .padding()
                    } else {
                        ForEach(viewModel.topDebtors) { customer in
                            // Envolvemos cada fila en un NavigationLink(value:)
                            // Esto dispara el .navigationDestination de abajo
                            NavigationLink(value: customer) {
                                DashboardCustomerRow(customer: customer)
                            }
                            .buttonStyle(.plain) // Para que no se vea azul todo el renglón
                        }
                    }
                }
                
                // --- BOTÓN DE ACCIÓN PRINCIPAL ---
                NavigationLink(destination: CustomerListView(
                    viewModel: container.makeCustomerListViewModel(),
                    container: container
                )) {
                    HStack {
                        Image(systemName: "person.3.fill")
                        Text("Gestionar Clientes")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.primary)
                    .foregroundColor(.white)
                    .cornerRadius(AppTheme.radiusButton)
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .navigationTitle("Inicio")
        // --- CENTRALIZACIÓN DE NAVEGACIÓN ---
        .navigationDestination(for: Customer.self) { customer in
            CustomerDetailView(viewModel: container.makeCustomerDetailViewModel(customer: customer))
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
    }
}
