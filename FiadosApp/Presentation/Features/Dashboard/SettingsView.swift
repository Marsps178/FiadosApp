import SwiftUI

struct SettingsView: View {
    let authViewModel: GlobalAuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            List {
                Section {
                    HStack(spacing: 20) {
                        InitialsAvatar(name: "Usuario", size: 70)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Dueño de la Tienda")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                            
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(AppTheme.success)
                                Text("Suscripción Activa")
                                    .font(.caption.bold())
                                    .foregroundColor(AppTheme.success)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(AppTheme.success.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 12)
                }
                .listRowBackground(AppTheme.cardBG)
                
                Section("PREFERENCIAS") {
                    SettingsRow(icon: "dollarsign.circle.fill", title: "Moneda", value: "Soles (S/)", color: .orange)
                    SettingsRow(icon: "globe", title: "Idioma", value: "Español", color: .blue)
                    SettingsRow(icon: "bell.fill", title: "Notificaciones", value: "Activadas", color: .red)
                }
                .listRowBackground(AppTheme.cardBG)
                
                Section("SOPORTE") {
                    SettingsActionRow(icon: "book.fill", title: "Guía de Usuario", color: .purple)
                    SettingsActionRow(icon: "envelope.fill", title: "Contactar Soporte", color: .cyan)
                    SettingsActionRow(icon: "star.fill", title: "Calificar App", color: .yellow)
                }
                .listRowBackground(AppTheme.cardBG)
                
                Section {
                    Button(action: {
                        HapticManager.notification(type: .warning)
                        authViewModel.logout()
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "power")
                            Text("Cerrar Sesión")
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .foregroundColor(AppTheme.danger)
                    }
                }
                .listRowBackground(AppTheme.cardBG)
                
                Section {
                    VStack(spacing: 4) {
                        Text("FiadosApp v1.0.0")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("Hecho con ❤️ en Perú")
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(.secondary.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Ajustes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(color)
                .cornerRadius(8)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct SettingsActionRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(color)
                .cornerRadius(8)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.secondary.opacity(0.3))
        }
        .padding(.vertical, 4)
    }
}
