import SwiftUI

struct CustomerDetailView: View {
    @Bindable var viewModel: CustomerDetailViewModel
    @State private var isShowingAddTransaction = false
    @State private var isShowingEditLimit = false
    
    var body: some View {
        VStack {
            // Header con resumen de deuda
            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.customer.name)
                            .font(.title3.bold())
                        if !viewModel.customer.phoneNumber.isEmpty {
                            Link(destination: URL(string: "tel:\(viewModel.customer.phoneNumber)")!) {
                                HStack(spacing: 4) {
                                    Image(systemName: "phone.fill")
                                    Text(viewModel.customer.phoneNumber)
                                }
                                .font(.caption)
                                .foregroundColor(AppTheme.primary)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                
                Text("Deuda Actual")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(AppTheme.currency(viewModel.customer.currentDebt))
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(viewModel.customer.isCloseToLimit ? AppTheme.danger : .primary)
                
                // FIX #7: Guard creditLimit > 0 para evitar división por cero
                if viewModel.customer.creditLimit > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        ProgressView(
                            value: viewModel.customer.currentDebt,
                            total: viewModel.customer.creditLimit
                        )
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        .tint(viewModel.customer.isCloseToLimit ? AppTheme.danger : AppTheme.primary)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: viewModel.customer.currentDebt)
                        .padding(.vertical, 4)

                        HStack {
                            let pct = Int((viewModel.customer.currentDebt / viewModel.customer.creditLimit) * 100)
                            Text("Usado: \(pct)%")
                            Spacer()
                            Text("Disponible: \(AppTheme.currency(viewModel.customer.availableCredit))")
                                .foregroundColor(viewModel.customer.isCloseToLimit ? AppTheme.danger : .secondary)
                        }
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
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
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill((transaction.type == .charge ? AppTheme.danger : AppTheme.success).opacity(0.12))
                                    .frame(width: 44, height: 44)
                                Image(systemName: transaction.type == .charge ? "arrow.up.right" : "arrow.down.left")
                                    .foregroundColor(transaction.type == .charge ? AppTheme.danger : AppTheme.success)
                                    .font(.system(size: 18, weight: .bold))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(transaction.concept)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                Text(transaction.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(transaction.type == .charge ? "+\(AppTheme.currency(transaction.amount))" : "-\(AppTheme.currency(transaction.amount))")
                                    .foregroundColor(transaction.type == .charge ? AppTheme.danger : AppTheme.success)
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                            }
                        }
                        .padding(.vertical, 4)
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
                HStack(spacing: 15) {
                    // Botón Compartir (HU adicional)
                    let shareMessage = """
                    📋 *Estado de Cuenta - FiadosApp*
                    👤 Cliente: \(viewModel.customer.name)
                    💰 Deuda Actual: \(AppTheme.currency(viewModel.customer.currentDebt))
                    ✅ Crédito Disponible: \(AppTheme.currency(viewModel.customer.availableCredit))
                    📅 Fecha: \(Date().formatted(date: .abbreviated, time: .omitted))
                    """
                    
                    ShareLink(item: shareMessage) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .bold))
                    }
                    
                    Button("Nueva Operación") { 
                        HapticManager.selection()
                        isShowingAddTransaction = true 
                    }
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    HapticManager.selection()
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
        // FIX #3: onAppear en lugar de .task para recargar transacciones
        // cada vez que la vista aparece (incluido regresar de AddTransactionView).
        .onAppear {
            Task { await viewModel.loadTransactions() }
        }
    }
}
