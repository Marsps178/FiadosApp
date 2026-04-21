import SwiftUI

struct CustomerDetailView: View {
    @Bindable var viewModel: CustomerDetailViewModel
    @State private var isShowingAddTransaction = false
    @State private var isShowingEditLimit = false
    
    var body: some View {
        VStack {
            // Header con resumen de deuda
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.customer.name)
                            .font(.title2.bold())
                        if !viewModel.customer.phoneNumber.isEmpty {
                            Link(destination: URL(string: "tel:\(viewModel.customer.phoneNumber)")!) {
                                HStack(spacing: 6) {
                                    Image(systemName: "phone.circle.fill")
                                    Text(viewModel.customer.phoneNumber)
                                }
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(AppTheme.primary)
                            }
                        }
                    }
                    Spacer()
                    
                    InitialsAvatar(name: viewModel.customer.name, size: 50)
                }
                
                Divider()
                
                VStack(spacing: 8) {
                    Text("DEUDA ACTUAL")
                        .font(.caption2.bold())
                        .tracking(1)
                        .foregroundColor(.secondary)
                    
                    Text(AppTheme.currency(viewModel.customer.currentDebt))
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundColor(viewModel.customer.isCloseToLimit ? AppTheme.danger : .primary)
                }
                .padding(.vertical, 8)
                
                // FIX #7: Guard creditLimit > 0 para evitar división por cero
                if viewModel.customer.creditLimit > 0 {
                    VStack(alignment: .leading, spacing: 10) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.secondary.opacity(0.1))
                                    .frame(height: 12)
                                
                                Capsule()
                                    .fill(viewModel.customer.isCloseToLimit ? AppTheme.danger.gradient : AppTheme.primary.gradient)
                                    .frame(width: min(geo.size.width * CGFloat(viewModel.customer.currentDebt / viewModel.customer.creditLimit), geo.size.width), height: 12)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: viewModel.customer.currentDebt)
                            }
                        }
                        .frame(height: 12)

                        HStack {
                            let pct = Int((viewModel.customer.currentDebt / viewModel.customer.creditLimit) * 100)
                            Text("\(pct)% del límite utilizado")
                                .font(.caption.bold())
                                .foregroundColor(viewModel.customer.isCloseToLimit ? AppTheme.danger : .secondary)
                            Spacer()
                            Text("Límite: \(AppTheme.currency(viewModel.customer.creditLimit))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading) {
                        Text("DISPONIBLE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.secondary)
                        Text(AppTheme.currency(viewModel.customer.availableCredit))
                            .font(.subheadline.bold())
                            .foregroundColor(AppTheme.success)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(AppTheme.success.opacity(0.05))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading) {
                        Text("ESTADO")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.secondary)
                        Text(viewModel.customer.isCloseToLimit ? "Riesgo Alto" : "Saludable")
                            .font(.subheadline.bold())
                            .foregroundColor(viewModel.customer.isCloseToLimit ? AppTheme.danger : AppTheme.success)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background((viewModel.customer.isCloseToLimit ? AppTheme.danger : AppTheme.success).opacity(0.05))
                    .cornerRadius(12)
                }
            }
            .padding(20)
            .background(AppTheme.cardBG)
            .cornerRadius(AppTheme.radiusCard)
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
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
