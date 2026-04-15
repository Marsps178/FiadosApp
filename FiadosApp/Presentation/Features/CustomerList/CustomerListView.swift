import SwiftUI

struct CustomerListView: View {
    @State var viewModel: CustomerListViewModel
    @State private var isShowingAddCustomer = false
    
    let container: DependencyContainer
    
    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView("Cargando clientes...")
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
