import Foundation
import Observation

@Observable
class DashboardViewModel {
    // Estado de la UI
    var totalDebt: Double = 0
    var topDebtors: [Customer] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    // Dependencia
    private let getStatsUseCase: GetDashboardStatsUseCase
    private let logoutUseCase: LogoutUseCase
    
    init(getStatsUseCase: GetDashboardStatsUseCase, logoutUseCase: LogoutUseCase) {
        self.getStatsUseCase = getStatsUseCase
        self.logoutUseCase = logoutUseCase
    }
    
    @MainActor
    func loadDashboard() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let stats = try await getStatsUseCase.execute()
            self.totalDebt = stats.totalDebt
            self.topDebtors = stats.topDebtors
            isLoading = false
        } catch {
            self.errorMessage = "No se pudieron cargar las estadísticas."
            isLoading = false
        }
    }
    
    func logout() {
        do {
            try logoutUseCase.execute()
        } catch {
            self.errorMessage = "Error al cerrar sesión."
        }
    }
}
