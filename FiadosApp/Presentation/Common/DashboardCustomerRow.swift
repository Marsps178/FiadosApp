import SwiftUI
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
