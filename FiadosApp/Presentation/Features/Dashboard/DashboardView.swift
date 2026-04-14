import SwiftUI

struct DashboardView: View {
    @State var viewModel: DashboardViewModel
    let container: DependencyContainer // Para navegar a la lista de clientes
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                // Tarjeta de Resumen (HU-07)
                VStack(spacing: 10) {
                    Text("Dinero Total en la Calle")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("$\(viewModel.totalDebt, specifier: "%.2f")")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.blue, .indigo]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(20)
                .shadow(radius: 10)
                
                // Sección Top 3 (HU-08)
                VStack(alignment: .leading, spacing: 15) {
                    Text("Mayores Deudores")
                        .font(.title2.bold())
                    
                    if viewModel.topDebtors.isEmpty && !viewModel.isLoading {
                        Text("No hay deudas registradas.")
                            .foregroundColor(.secondary)
                    }
                    
                    ForEach(viewModel.topDebtors) { customer in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                            
                            VStack(alignment: .leading) {
                                Text(customer.name)
                                    .font(.body.bold())
                                Text("Límite: $\(customer.creditLimit, specifier: "%.0f")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("$\(customer.currentDebt, specifier: "%.2f")")
                                .foregroundColor(.red)
                                .bold()
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                }
                
                // Acceso rápido a clientes
                NavigationLink(destination: CustomerListView(viewModel: container.makeCustomerListViewModel())) {
                    Label("Ver todos los clientes", systemImage: "person.3.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Resumen")
        .refreshable {
            await viewModel.loadDashboard()
        }
        .task {
            await viewModel.loadDashboard()
        }
    }
}
