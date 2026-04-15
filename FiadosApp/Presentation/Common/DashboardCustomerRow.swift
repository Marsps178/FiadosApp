import SwiftUI
// Sub-componente para las filas del Dashboard
struct DashboardCustomerRow: View {
    let customer: Customer
    
    var body: some View {
        HStack {
            InitialsAvatar(name: customer.name)
            
            VStack(alignment: .leading) {
                Text(customer.name)
                    .font(.body.bold())
                Text("Límite: \(AppTheme.currency(customer.creditLimit))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(AppTheme.currency(customer.currentDebt))
                .foregroundColor(customer.isCloseToLimit ? .red : .primary)
                .font(.callout.bold())
        }
        .padding()
        .background(AppTheme.cardBG)
        .cornerRadius(AppTheme.radiusCard)
    }
}
