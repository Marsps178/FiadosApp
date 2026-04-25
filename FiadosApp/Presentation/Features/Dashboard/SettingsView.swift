import SwiftUI

struct SettingsView: View {
    let authViewModel: GlobalAuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var settings = AppSettingsManager.shared
    @State private var showLogoutAlert = false
    
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
                            
                            if let email = authViewModel.userEmail {
                                Text(email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
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
                    // Selector de Moneda
                    Menu {
                        Picker("Moneda", selection: $settings.currency) {
                            ForEach(AppSettingsManager.Currency.allCases) { currency in
                                Text(currency.name).tag(currency)
                            }
                        }
                    } label: {
                        SettingsRow(icon: "dollarsign.circle.fill", title: "Moneda", value: settings.currency.name, color: .orange)
                    }
                    .buttonStyle(.plain)

                    // Selector de Idioma
                    Menu {
                        Picker("Idioma", selection: $settings.language) {
                            ForEach(AppSettingsManager.Language.allCases) { language in
                                Text(language.name).tag(language)
                            }
                        }
                    } label: {
                        SettingsRow(icon: "globe", title: "Idioma", value: settings.language.name, color: .blue)
                    }
                    .buttonStyle(.plain)

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
                        showLogoutAlert = true
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
                .alert("Cerrar Sesión", isPresented: $showLogoutAlert) {
                    Button("Cancelar", role: .cancel) { }
                    Button("Cerrar Sesión", role: .destructive) {
                        authViewModel.logout()
                    }
                } message: {
                    Text("¿Estás seguro de que deseas salir? Deberás ingresar tus credenciales la próxima vez.")
                }
                
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
