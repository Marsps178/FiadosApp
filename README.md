# 📒 FiadosApp — Gestión de Fiados para Tiendas de Conveniencia

> **Digitaliza tu cuaderno de fiados.** FiadosApp reemplaza el registro manual de cuentas por cobrar con una solución móvil moderna, conectada en tiempo real y con control automatizado de crédito.

---

## 🎯 Visión y Objetivos del Producto

**Propósito:** Digitalizar y automatizar el registro de cuentas por cobrar ("fiados") en una tienda de conveniencia, sustituyendo el cuaderno físico.

### Objetivos del MVP
| Objetivo | Descripción |
|---|---|
| ⚡ Velocidad en caja | Reducir el tiempo de registro de un fiado a segundos |
| 🔒 Integridad de datos | Eliminar pérdidas de información y descuadres de cuentas |
| 🛡️ Control de crédito | Bloqueo automático cuando un cliente supera su límite de crédito |
| 📊 Visibilidad financiera | Dashboard con el capital total "en la calle" en tiempo real |

---

## 🛠️ Stack Tecnológico

| Tecnología | Detalle |
|---|---|
| **Plataforma** | iOS 16.0+ |
| **Lenguaje** | Swift 5.9+ |
| **Framework UI** | SwiftUI |
| **Patrón de presentación** | MVVM con `@Observable` (Swift 5.9 / iOS 17) |
| **Arquitectura** | Clean Architecture (Domain / Data / Presentation) |
| **Concurrencia** | Swift Concurrency (`async` / `await` / `Task`) |
| **Backend / BD** | Firebase Firestore (modo offline/caché nativo) |
| **Gestor de dependencias** | Swift Package Manager (SPM) |

---

## 🗂️ Estructura del Proyecto

```
FiadosApp/
├── App/
│   ├── FiadosAppApp.swift          ← Entry point + AppDelegate (Firebase init)
│   └── DI/
│       └── DependencyContainer.swift   ← Inyección de dependencias manual (lazy)
│
├── Domain/                         ← Agnóstico a frameworks — Solo Swift puro
│   ├── Entities/
│   │   ├── Customer.swift          ← Entidad cliente (creditLimit, currentDebt, isCloseToLimit)
│   │   └── DebtTransaction.swift   ← Entidad transacción (charge / credit)
│   ├── Interfaces/
│   │   ├── CustomerRepositoryProtocol.swift
│   │   └── TransactionRepositoryProtocol.swift
│   └── UseCases/
│       ├── RegisterTransactionUseCase.swift   ← Registra cargo/abono con validaciones dobles
│       ├── CheckCreditLimitUseCase.swift       ← Verificación rápida local de límite
│       └── GetDashboardStatsUseCase.swift      ← Estadísticas: total deuda + top 3
│
├── Data/
│   └── Firebase/
│       ├── Repositories/
│       │   ├── FirebaseManager.swift               ← Singleton de Firestore
│       │   ├── FirebaseCustomerRepository.swift    ← CRUD de clientes
│       │   └── FirebaseTransactionRepository.swift ← Historial de movimientos
│       ├── DTOs/
│       │   ├── CustomerDTO.swift        ← Codable para Firestore (@DocumentID)
│       │   └── TransactionDTO.swift
│       └── Mappers/
│           ├── CustomerMapper.swift     ← DTO ↔ Domain
│           └── TransactionMapper.swift
│
├── Presentation/
│   ├── Common/
│   │   ├── CustomerRowView.swift        ← Fila de cliente para la lista
│   │   └── DashboardCustomerRow.swift   ← Fila de cliente para el dashboard
│   └── Features/
│       ├── Dashboard/
│       │   ├── DashboardView.swift
│       │   └── DashboardViewModel.swift
│       ├── CustomerList/
│       │   ├── CustomerListView.swift
│       │   ├── CustomerListViewModel.swift
│       │   ├── AddCustomerView.swift
│       │   └── AddCustomerViewModel.swift
│       └── CustomerDetail/
│           ├── CustomerDetailView.swift
│           ├── CustomerDetailViewModel.swift
│           └── AddTransactionView.swift
│
└── Resources/
    ├── Assets.xcassets
    └── GoogleService-Info.plist    ← Configuración de Firebase (no subir a git público)
```

---

## 🧩 Arquitectura: Clean Architecture

```
┌─────────────────────────────────┐
│         Presentation Layer       │  SwiftUI Views + @Observable ViewModels
│  DashboardView, CustomerList...  │
└──────────────┬──────────────────┘
               │ llama a
┌──────────────▼──────────────────┐
│           Domain Layer           │  Swift puro — Cero dependencias externas
│  Entities · Protocols · UseCases │
└──────────────┬──────────────────┘
               │ implementado por
┌──────────────▼──────────────────┐
│            Data Layer            │  Firebase Firestore
│  Repositories · DTOs · Mappers   │
└─────────────────────────────────┘
```

**Principios clave:**
- La capa **Domain** no importa nada de Firebase ni de SwiftUI.
- Los **UseCases** son unidades testables de lógica de negocio pura.
- Los **Repositorios** se inyectan via protocolo (`DependencyContainer`), facilitando el testing con mocks.

---

## 📦 Product Backlog (MVP)

### Épica 1 — Arquitectura y Configuración Base ✅
| ID | Historia | Estado |
|---|---|---|
| ST-01 | Configurar proyecto Xcode, estructura de carpetas y SPM | ✅ Completo |
| ST-02 | Integrar SDK de Firebase y configurar proyecto en consola | ✅ Completo |
| ST-03 | Configurar inyección de dependencias (DI) | ✅ Completo |

### Épica 2 — Gestión de Clientes (CRUD) ✅
| ID | Historia | Criterios de Aceptación | Estado |
|---|---|---|---|
| HU-01 | Agregar nuevo cliente con nombre, teléfono y límite de crédito | Validar campos vacíos. Límite > 0. Guardar en Firestore. | ✅ Completo |
| HU-02 | Ver lista de clientes ordenados, con búsqueda | Barra `Searchable`. Indicador visual si está cerca del límite (≥ 80%). | ✅ Completo |
| HU-03 | Editar el límite de crédito de un cliente existente | Solo el campo `limit` se actualiza en Firestore (merge). | ✅ Completo |

### Épica 3 — Gestión de Deudas (Transacciones) ✅
| ID | Historia | Criterios de Aceptación | Estado |
|---|---|---|---|
| HU-04 | Registrar un "Cargo" (fiado) con monto y concepto | Bloquear si supera crédito disponible (`CheckCreditLimitUseCase`). | ✅ Completo |
| HU-05 | Registrar un "Abono" (pago) cuando el cliente paga | El abono no puede ser mayor a la deuda total actual. Sin saldo a favor. | ✅ Completo |
| HU-06 | Ver historial cronológico de cargos y abonos del cliente | Ordenado por `timestamp` descendente. Muestra concepto, fecha y monto. | ✅ Completo |

### Épica 4 — Inteligencia de Negocio (Dashboard) ✅
| ID | Historia | Criterios de Aceptación | Estado |
|---|---|---|---|
| HU-07 | Ver "Dinero Total en la Calle" al abrir la app | Suma de todas las deudas activas. Actualización automática. | ✅ Completo |
| HU-08 | Ver "Top 3" de clientes que más deben | Ordenados por `currentDebt` descendente. Con `NavigationLink` al detalle. | ✅ Completo |

---

## 🔄 Flujo de Navegación

```
FiadosAppApp (NavigationStack raíz)
│
└── DashboardView
    │
    ├── [NavigationLink] → CustomerDetailView (desde Top 3)
    │                         └── [Sheet] → AddTransactionView
    │
    └── [NavigationLink] → CustomerListView
                              │
                              ├── [Sheet] → AddCustomerView
                              │
                              └── [NavigationLink] → CustomerDetailView
                                                        └── [Sheet] → AddTransactionView
```

> **Nota:** La navegación está centralizada en la raíz del `NavigationStack` en `DashboardView` mediante `.navigationDestination(for: AppRoute.self)`, evitando duplicación de lógica y conflictos de stack.

---

## ⚙️ Configuración del Entorno

### Requisitos previos
- Xcode 15.0+
- iOS 17.0+ (para `@Observable`)
- Cuenta en [Firebase Console](https://console.firebase.google.com/)

### Pasos de instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/tu-usuario/FiadosApp.git
   cd FiadosApp
   ```

2. **Configurar Firebase**
   - Crea un proyecto en [Firebase Console](https://console.firebase.google.com/)
   - Descarga el archivo `GoogleService-Info.plist`
   - Colócalo en `FiadosApp/GoogleService-Info.plist`
   - Habilita **Cloud Firestore** en modo producción (o testing para desarrollo)

3. **Instalar dependencias (SPM)**
   - Las dependencias se resuelven automáticamente al abrir el `.xcodeproj` en Xcode
   - Dependencias requeridas:
     - `firebase-ios-sdk` → `FirebaseFirestore`, `FirebaseFirestoreSwift`

4. **Compilar y ejecutar**
   - Seleccionar un simulador iOS 17.0+ o dispositivo físico
   - `Cmd + R` para compilar y lanzar

### Reglas de Firestore (seguridad básica para desarrollo)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // ⚠️ Solo para desarrollo local
    }
  }
}
```

---

## 🧠 Decisiones Técnicas Clave

### `@Observable` vs `ObservableObject`
Se optó por `@Observable` (iOS 17+) porque elimina el boilerplate de `@Published` y optimiza automáticamente el re-rendering de la UI al nivel de propiedad individual.

### Validación en doble capa
La validación del límite de crédito ocurre en **dos niveles** complementarios:
1. **UI local** (`AddTransactionView.isFormValid`) → respuesta inmediata sin latencia de red
2. **UseCase** (`RegisterTransactionUseCase.execute`) → garantía de integridad de datos independiente de la UI

### `onAppear` vs `.task` en el Dashboard
Se usa `.onAppear` en lugar de `.task` porque `onAppear` se dispara tanto en la **primera carga** como al **regresar por el NavigationStack**, garantizando datos siempre frescos sin necesidad de `NotificationCenter` ni suscripciones adicionales.

### `await setData(from:)` en Firestore
Todos los writes a Firestore usan la variante `async/await` de `setData(from:)` para garantizar que la confirmación de escritura llega antes de actualizar el estado de la UI.

---

## 📁 Colecciones de Firestore

### `customers`
| Campo | Tipo | Descripción |
|---|---|---|
| `name` | `String` | Nombre completo del cliente |
| `phone` | `String` | Teléfono de contacto |
| `limit` | `Number` | Límite de crédito en pesos |
| `debt` | `Number` | Deuda actual acumulada |

### `transactions`
| Campo | Tipo | Descripción |
|---|---|---|
| `customerId` | `String` | ID del documento en `customers` |
| `amount` | `Number` | Monto del movimiento |
| `concept` | `String` | Descripción rápida (ej. "Pan, Leche") |
| `timestamp` | `Timestamp` | Fecha y hora del movimiento |
| `type` | `String` | `"charge"` (fiado) o `"credit"` (abono) |

---

## 👨‍💻 Autor

Desarrollado como proyecto iOS personal / portafolio.

---

## 📄 Licencia

Este proyecto es de uso privado / educativo.
