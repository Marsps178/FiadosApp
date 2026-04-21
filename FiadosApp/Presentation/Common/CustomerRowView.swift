import SwiftUI

struct CustomerRowView: View {
    let customer: Customer
    
    var body: some View {
        HStack(spacing: 16) {
            InitialsAvatar(name: customer.name, size: 48)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(customer.name)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                
                HStack(spacing: 4) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 10))
                    Text(customer.phoneNumber.isEmpty ? "Sin teléfono" : customer.phoneNumber)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text(AppTheme.currency(customer.currentDebt))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(customer.isCloseToLimit ? AppTheme.danger : AppTheme.primary)
                
                if customer.isCloseToLimit {
                    Text("RIESGO ALTO")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppTheme.danger)
                        .cornerRadius(6)
                } else {
                    Text("SALUDABLE")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(AppTheme.success)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppTheme.success.opacity(0.1))
                        .cornerRadius(6)
                }
            }
        }
        .padding()
        .background(AppTheme.cardBG)
        .cornerRadius(AppTheme.radiusCard)
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
    }
}
