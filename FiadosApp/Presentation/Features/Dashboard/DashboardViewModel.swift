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
    
    init(getStatsUseCase: GetDashboardStatsUseCase) {
        self.getStatsUseCase = getStatsUseCase
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
}
