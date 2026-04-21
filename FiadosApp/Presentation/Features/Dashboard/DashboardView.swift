import SwiftUI
import Charts

struct DashboardView: View {
    @State var viewModel: DashboardViewModel
    @Bindable var authViewModel: GlobalAuthViewModel
    let container: DependencyContainer
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    
                    // --- HEADER CON SALUDO ---
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hola, Negocio")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                            Text(Date().formatted(date: .long, time: .omitted))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if let uiImage = UIImage(contentsOfFile: Bundle.main.path(forResource: "logo", ofType: "png") ?? "") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                        } else {
                            InitialsAvatar(name: "Usuario", size: 44)
                        }
                    }
                    .padding(.top, 10)
                    
                    // --- TARJETA DE RESUMEN (HU-07) ---
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("BALANCE TOTAL")
                                    .font(.caption2.bold())
                                    .tracking(1.5)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text(AppTheme.currency(viewModel.totalDebt))
                                    .font(.system(size: 44, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .skeleton(isLoading: viewModel.isLoading)
                            }
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        HStack {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.up.forward.circle.fill")
                                Text("Dinero en la calle")
                            }
                            .font(.caption.bold())
                            .foregroundColor(.white.opacity(0.9))
                            
                            Spacer()
                            
                            Text("\(viewModel.topDebtors.count) clientes activos")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(24)
                    .background(
                        ZStack {
                            AppTheme.primaryGradient
                            
                            // Círculos decorativos para el efecto Premium
                            Circle()
                                .fill(.white.opacity(0.1))
                                .frame(width: 150)
                                .offset(x: 100, y: -50)
                            
                            Circle()
                                .fill(.white.opacity(0.05))
                                .frame(width: 200)
                                .offset(x: -80, y: 60)
                        }
                    )
                    .cornerRadius(AppTheme.radiusCard)
                    .shadow(color: AppTheme.primary.opacity(0.35), radius: 20, x: 0, y: 12)
                    .animation(.easeInOut, value: viewModel.isLoading)
                    
                    // --- GRÁFICO DE DISTRIBUCIÓN ---
                    if !viewModel.topDebtors.isEmpty || viewModel.isLoading {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("Distribución de Deuda")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chart.pie.fill")
                                    .foregroundColor(AppTheme.primary.opacity(0.5))
                            }
                            
                            Chart {
                                ForEach(viewModel.isLoading ? [Customer(id: "1", name: "A", phoneNumber: "", creditLimit: 0, currentDebt: 50), Customer(id: "2", name: "B", phoneNumber: "", creditLimit: 0, currentDebt: 30)] : viewModel.topDebtors) { customer in
                                    BarMark(
                                        x: .value("Deuda", customer.currentDebt),
                                        y: .value("Cliente", customer.name)
                                    )
                                    .foregroundStyle(AppTheme.primary.gradient)
                                    .cornerRadius(6)
                                }
                            }
                            .frame(height: 140)
                            .chartXAxis(.hidden)
                            .chartYAxis {
                                AxisMarks { value in
                                    AxisValueLabel()
                                        .font(.system(size: 10, weight: .medium))
                                }
                            }
                            .skeleton(isLoading: viewModel.isLoading)
                        }
                        .padding(20)
                        .background(AppTheme.cardBG)
                        .cornerRadius(AppTheme.radiusCard)
                        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
                    }
                    
                    // --- SECCIÓN TOP DEUDORES (HU-08) ---
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Mayores Deudores")
                                .font(.title3.bold())
                            Spacer()
                            NavigationLink(value: AppRoute.customerList) {
                                HStack(spacing: 4) {
                                    Text("Ver todos")
                                    Image(systemName: "chevron.right")
                                }
                                .font(.caption.bold())
                                .foregroundColor(AppTheme.primary)
                            }
                        }
                        
                        if viewModel.topDebtors.isEmpty && !viewModel.isLoading {
                            ContentUnavailableView(
                                "Sin deudas",
                                systemImage: "checkmark.circle.fill",
                                description: Text("Todo está al día.")
                            )
                            .padding()
                            .cardStyle()
                        } else {
                            VStack(spacing: 0) {
                                let displayList = viewModel.isLoading ? [Customer(id: "1", name: "Cargando...", phoneNumber: "", creditLimit: 100, currentDebt: 50), Customer(id: "2", name: "Cargando...", phoneNumber: "", creditLimit: 100, currentDebt: 50)] : viewModel.topDebtors
                                
                                ForEach(displayList) { customer in
                                    NavigationLink(value: AppRoute.customerDetail(customer)) {
                                        DashboardCustomerRow(customer: customer)
                                            .skeleton(isLoading: viewModel.isLoading)
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(viewModel.isLoading)
                                    
                                    if customer.id != displayList.last?.id {
                                        Divider().padding(.leading, 64).opacity(0.5)
                                    }
                                }
                            }
                            .background(AppTheme.cardBG)
                            .cornerRadius(AppTheme.radiusCard)
                            .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
                            .animation(.spring(), value: viewModel.isLoading)
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
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
