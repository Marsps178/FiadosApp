import SwiftUI

struct SettingsView: View {
    let authViewModel: GlobalAuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section("Perfil de Usuario") {
                HStack(spacing: 15) {
                    InitialsAvatar(name: "Usuario", size: 60)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dueño de la Tienda")
                            .font(.headline)
                        Text("Suscripción Activa")
                            .font(.caption)
                            .foregroundColor(AppTheme.success)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(AppTheme.success.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section("Preferencias de la App") {
                HStack {
                    Label("Moneda Predeterminada", systemImage: "dollarsign.circle")
                    Spacer()
                    Text("Soles (S/)")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Label("Idioma", systemImage: "globe")
                    Spacer()
                    Text("Español")
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Ayuda y Soporte") {
                Button(action: { }) {
                    Label("Tutorial de Uso", systemImage: "book")
                }
                .foregroundColor(.primary)
                
                Button(action: { }) {
                    Label("Contactar Soporte", systemImage: "envelope")
                }
                .foregroundColor(.primary)
            }
            
            Section {
                Button(action: {
                    HapticManager.notification(type: .warning)
                    authViewModel.logout()
                }) {
                    HStack {
                        Spacer()
                        Text("Cerrar Sesión")
                            .foregroundColor(AppTheme.danger)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Configuración")
        .navigationBarTitleDisplayMode(.inline)
    }
}
