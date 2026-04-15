import SwiftUI

struct CustomerRowView: View {
    let customer: Customer
    
    var body: some View {
        HStack(spacing: 12) {
            InitialsAvatar(name: customer.name, size: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(customer.name)
                    .font(.headline)
                Text(customer.phoneNumber)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(AppTheme.currency(customer.currentDebt))
                    .font(.body)
                    .bold()
                    .foregroundColor(customer.isCloseToLimit ? AppTheme.danger : .primary)
                
                if customer.isCloseToLimit {
                    Text("Límite cerca")
                        .font(.caption2)
                        .foregroundColor(AppTheme.warning)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
