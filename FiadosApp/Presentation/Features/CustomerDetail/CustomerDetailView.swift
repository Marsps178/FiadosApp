import SwiftUI

struct CustomerDetailView: View {
    @Bindable var viewModel: CustomerDetailViewModel
    @State private var isShowingAddTransaction = false
    @State private var isShowingEditLimit = false
    
    var body: some View {
        VStack {
            // Header con resumen de deuda
            VStack(spacing: 8) {
                Text("Deuda Actual")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(AppTheme.currency(viewModel.customer.currentDebt))
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(viewModel.customer.isCloseToLimit ? AppTheme.danger : .primary)
                
                VStack(alignment: .leading, spacing: 4) {
                    ProgressView(
                        value: viewModel.customer.currentDebt,
                        total: viewModel.customer.creditLimit
                    )
                    .tint(viewModel.customer.isCloseToLimit ? AppTheme.danger : AppTheme.primary)
                    .animation(.easeInOut, value: viewModel.customer.currentDebt)
                
                    HStack {
                        Text("Usado: \(Int((viewModel.customer.currentDebt / viewModel.customer.creditLimit) * 100))%")
                        Spacer()
                        Text("Disponible: \(AppTheme.currency(viewModel.customer.availableCredit))")
                            .foregroundColor(viewModel.customer.isCloseToLimit ? AppTheme.danger : .secondary)
                    }
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(AppTheme.cardBG)
            .cornerRadius(AppTheme.radiusCard)
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
                            HStack(spacing: 6) {
                                Image(systemName: transaction.type == .charge ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill")
                                    .foregroundColor(transaction.type == .charge ? AppTheme.danger : AppTheme.success)
                                
                                Text(transaction.type == .charge ? "+\(AppTheme.currency(transaction.amount))" : "-\(AppTheme.currency(transaction.amount))")
                                    .foregroundColor(transaction.type == .charge ? AppTheme.danger : AppTheme.success)
                                    .bold()
                            }
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.loadTransactions()
            }
        }
        .navigationTitle(viewModel.customer.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Nueva Operación") { isShowingAddTransaction = true }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    isShowingEditLimit = true
                } label: {
                    Image(systemName: "pencil.circle")
                }
            }
        }
        .sheet(isPresented: $isShowingAddTransaction) {
            AddTransactionView(viewModel: viewModel)
        }
        .sheet(isPresented: $isShowingEditLimit) {
            EditCreditLimitView(viewModel: viewModel)
        }
        .task {
            await viewModel.loadTransactions()
        }
    }
}
