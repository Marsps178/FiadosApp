import SwiftUI

struct CustomerRowView: View {
    let customer: Customer
    
    var body: some View {
        HStack {
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
                    .foregroundColor(customer.isCloseToLimit ? .red : .primary)
                
                if customer.isCloseToLimit {
                    Text("Límite cerca")
                        .font(.caption2)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
