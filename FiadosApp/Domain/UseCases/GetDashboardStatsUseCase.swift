import Foundation

struct GetDashboardStatsUseCase {
    private let repository: CustomerRepositoryProtocol

    init(repository: CustomerRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> (totalDebt: Double, topDebtors: [Customer]) {
        let customers = try await repository.fetchCustomers()

        let total = customers.reduce(0) { $0 + $1.currentDebt }

        // FIX #6: Solo incluir clientes con deuda activa > 0 en el Top 3.
        // Sin este filtro, clientes con $0 aparecían como "Mayores Deudores".
        let top3 = Array(
            customers
                .filter { $0.currentDebt > 0 }
                .sorted { $0.currentDebt > $1.currentDebt }
                .prefix(3)
        )

        return (total, top3)
    }
}
