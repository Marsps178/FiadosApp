import SwiftUI
// Sub-componente para las filas del Dashboard
struct DashboardCustomerRow: View {
    let customer: Customer
    
    var body: some View {
        HStack(spacing: 12) {
            InitialsAvatar(name: customer.name, size: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(customer.name)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                Text("Límite: \(AppTheme.currency(customer.creditLimit))")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(AppTheme.currency(customer.currentDebt))
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(customer.isCloseToLimit ? AppTheme.danger : .primary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}
