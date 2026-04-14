import SwiftUI

struct CustomerDetailView: View {
    @State var viewModel: CustomerDetailViewModel
    @State private var isShowingAddTransaction = false
    
    var body: some View {
        VStack {
            // Header con resumen de deuda
            VStack(spacing: 8) {
                Text("Deuda Actual")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("$\(viewModel.customer.currentDebt, specifier: "%.2f")")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(viewModel.customer.isCloseToLimit ? .red : .primary)
                
                HStack {
                    Label("Límite: $\(viewModel.customer.creditLimit, specifier: "%.0f")", systemImage: "creditcard")
                    Spacer()
                    Label("Disponible: $\(viewModel.customer.availableCredit, specifier: "%.0f")", systemImage: "checkmark.circle")
                }
                .font(.footnote)
                .padding(.horizontal)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding()

            // Lista de transacciones
            List {
                Section("Historial de Movimientos") {
                    if viewModel.transactions.isEmpty && !viewModel.isLoading {
                        Text("No hay movimientos registrados").font(.caption).foregroundColor(.secondary)
                    }
                    
                    ForEach(viewModel.transactions) { transaction in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(transaction.concept)
                                    .font(.body)
                                Text(transaction.date, style: .date)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(transaction.type == .charge ? "+$\(transaction.amount, specifier: "%.2f")" : "-$\(transaction.amount, specifier: "%.2f")")
                                .foregroundColor(transaction.type == .charge ? .red : .green)
                                .bold()
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.customer.name)
        .toolbar {
            Button("Nueva Operación") { isShowingAddTransaction = true }
        }
        .sheet(isPresented: $isShowingAddTransaction) {
            AddTransactionView(viewModel: viewModel) // Vista que crearemos a continuación
        }
        .task {
            await viewModel.loadTransactions()
        }
    }
}
