import Foundation
import SwiftUI
import Observation

@Observable
final class AppSettingsManager {
    static let shared = AppSettingsManager()
    
    var currency: Currency = .pen {
        didSet {
            UserDefaults.standard.set(currency.rawValue, forKey: "app_currency")
        }
    }
    
    var language: Language = .spanish {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: "app_language")
        }
    }
    
    private init() {
        if let savedCurrency = UserDefaults.standard.string(forKey: "app_currency"),
           let currency = Currency(rawValue: savedCurrency) {
            self.currency = currency
        }
        
        if let savedLanguage = UserDefaults.standard.string(forKey: "app_language"),
           let language = Language(rawValue: savedLanguage) {
            self.language = language
        }
    }
    
    enum Currency: String, CaseIterable, Identifiable {
        case pen = "es_PE"
        case usd = "en_US"
        case eur = "es_ES"
        case mxn = "es_MX"
        case cop = "es_CO"
        
        var id: String { self.rawValue }
        
        var symbol: String {
            switch self {
            case .pen: return "S/"
            case .usd: return "$"
            case .eur: return "€"
            case .mxn: return "Mex$"
            case .cop: return "Col$"
            }
        }
        
        var name: String {
            switch self {
            case .pen: return "Soles (Perú)"
            case .usd: return "Dólares (EE.UU.)"
            case .eur: return "Euros (España)"
            case .mxn: return "Pesos (México)"
            case .cop: return "Pesos (Colombia)"
            }
        }
    }
    
    enum Language: String, CaseIterable, Identifiable {
        case spanish = "es"
        case english = "en"
        
        var id: String { self.rawValue }
        
        var name: String {
            switch self {
            case .spanish: return "Español"
            case .english: return "English"
            }
        }
    }
}
