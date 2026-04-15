import Foundation

/// El contenedor se encarga de instanciar y mantener las referencias de los servicios.
final class DependencyContainer {
    
    // 1. Repositorios (Capa de Data)
    // Usamos 'lazy' para que solo se creen cuando realmente se necesiten.
    private lazy var customerRepository: CustomerRepositoryProtocol = {
        FirebaseCustomerRepository()
    }()
    
    private lazy var transactionRepository: TransactionRepositoryProtocol = {
        FirebaseTransactionRepository()
    }()
    
    // 2. Casos de Uso (Capa de Dominio)
    // Los casos de uso reciben los repositorios a través de sus inicializadores.
    
    func makeGetDashboardStatsUseCase() -> GetDashboardStatsUseCase {
        GetDashboardStatsUseCase(repository: customerRepository)
    }
    
    func makeRegisterTransactionUseCase() -> RegisterTransactionUseCase {
        RegisterTransactionUseCase(
            transactionRepo: transactionRepository,
            customerRepo: customerRepository
        )
    }
    
    func makeCheckCreditLimitUseCase() -> CheckCreditLimitUseCase {
        CheckCreditLimitUseCase()
    }
    
    // 3. Métodos para la gestión de clientes (CRUD)
    func getCustomerRepository() -> CustomerRepositoryProtocol {
        customerRepository
    }
    
    
    
    // vistas
    func makeCustomerListViewModel() -> CustomerListViewModel {
        CustomerListViewModel(repository: customerRepository)
    }
    
    func makeAddCustomerViewModel() -> AddCustomerViewModel {
        AddCustomerViewModel(repository: customerRepository)
    }
    
    func makeCustomerDetailViewModel(customer: Customer) -> CustomerDetailViewModel {
        CustomerDetailViewModel(
            customer: customer,
            transactionRepo: transactionRepository,
            customerRepo: customerRepository,
            registerUseCase: makeRegisterTransactionUseCase()
        )
    }
    

    func makeDashboardViewModel() -> DashboardViewModel {
        DashboardViewModel(
            getStatsUseCase: makeGetDashboardStatsUseCase()
        )
    }
}
