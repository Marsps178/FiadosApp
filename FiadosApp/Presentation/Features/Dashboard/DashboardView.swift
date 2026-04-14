import SwiftUI

struct DashboardView: View {
    @State var viewModel: DashboardViewModel
    let container: DependencyContainer // Necesario para inyectar en la navegación
    
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
                        Text("$\(viewModel.totalDebt, specifier: "%.2f")")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .indigo]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(20)
                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                
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
                            DashboardCustomerRow(customer: customer)
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
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .navigationTitle("Inicio")
        .refreshable {
            await viewModel.loadDashboard()
        }
        .task {
            await viewModel.loadDashboard()
        }
        .alert("Error", isPresented: .init(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil })) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

// Sub-componente para las filas del Dashboard
struct DashboardCustomerRow: View {
    let customer: Customer
    
    var body: some View {
        HStack {
            Circle()
                .fill(customer.isCloseToLimit ? .red.opacity(0.1) : .gray.opacity(0.1))
                .frame(width: 45, height: 45)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(customer.isCloseToLimit ? .red : .gray)
                )
            
            VStack(alignment: .leading) {
                Text(customer.name)
                    .font(.body.bold())
                Text("Límite: $\(customer.creditLimit, specifier: "%.0f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("$\(customer.currentDebt, specifier: "%.2f")")
                .foregroundColor(customer.isCloseToLimit ? .red : .primary)
                .font(.callout.bold())
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
