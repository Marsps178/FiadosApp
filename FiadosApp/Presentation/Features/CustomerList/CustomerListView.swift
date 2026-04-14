import SwiftUI

struct CustomerListView: View {
    @State var viewModel: CustomerListViewModel
    @State private var isShowingAddCustomer = false
    
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
        .sheet(isPresented: $isShowingAddCustomer) {
            AddCustomerView(viewModel: container.makeAddCustomerViewModel())
        }
        .navigationDestination(for: Customer.self) { customer in
            // Detalle del cliente
            Text("Detalle de \(customer.name)")
        }
    }
}
