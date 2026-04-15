import SwiftUI

struct CustomerListView: View {
    @State var viewModel: CustomerListViewModel
    @State private var isShowingAddCustomer = false
    
    let container: DependencyContainer
    
    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView("Cargando clientes...")
            } else if viewModel.filteredCustomers.isEmpty {
                if viewModel.searchText.isEmpty {
                    ContentUnavailableView(
                        "Sin clientes aún",
                        systemImage: "person.crop.circle.badge.plus",
                        description: Text("Toca + para agregar tu primer cliente.")
                    )
                } else {
                    ContentUnavailableView.search(text: viewModel.searchText)
                }
            } else {
                ForEach(viewModel.filteredCustomers) { customer in
                    NavigationLink(value: customer) {
                        CustomerRowView(customer: customer)
                    }
                }
            }
        }
        .navigationTitle("Clientes")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchText, prompt: "Buscar cliente")
        .toolbar {
            Button(action: { isShowingAddCustomer = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
        }
        .alert("Error", isPresented: .init(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil })) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .task {
            await viewModel.loadCustomers()
        }
        .sheet(isPresented: $isShowingAddCustomer, onDismiss: {
            // Recargar lista cuando el sheet se cierra (cliente guardado o cancelado)
            Task { await viewModel.loadCustomers() }
        }) {
            AddCustomerView(viewModel: container.makeAddCustomerViewModel())
        }
    }
}
