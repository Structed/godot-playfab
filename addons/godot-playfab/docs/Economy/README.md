# Economy

godot-playfab implements PlayFab's Economy v2 features, allowing developers to manage virtual currencies, catalogs, and in-game items seamlessly within their Godot projects.

## Client/PlayFab/Steam Purchase Flow
```mermaid
---
config:
  theme: redux-dark-color
---
sequenceDiagram
    autonumber
    actor P as Player
    participant C as Game Client
    participant SW as Steam Client
    participant S as Steam Backend
    participant B as Game Backend (Azure Function)
    participant PF as PlayFab
    Note over C,PF: Precondition: Player is logged in to PlayFab via LoginWithSteam and has Steam account linked.
    P->>C: Clicks "Buy Item"
    C->>B: Request create Steam order (itemId, quantity, price)
    B->>S: InitTxn(appId, steamId, order details)
    S-->>B: InitTxn OK (OrderId)
    B-->>C: Return OrderId and launch parameters
    C->>SW: Open overlay to purchase (OrderId)
    SW->>S: Show checkout and process payment
    S-->>C: MicroTxnAuthorizationResponse_t (authorized/denied)
    alt Authorized
        C->>B: Notify order authorized (OrderId, SteamId)
        B->>S: FinalizeTxn(OrderId)
        S-->>B: Finalize OK + receipt details
        Note over B: Server-side validation of amount, item, currency, and Steam signature
        B->>PF: Redeem Steam purchase to inventory (Economy v2)
        PF-->>B: Granted inventory items + TransactionId
        B-->>C: Success (granted items summary)
        C->>PF: GetInventory (optional refresh)
        PF-->>C: Updated inventory
        C-->>P: Show purchased item in inventory
    else Denied/Failed
        C-->>P: Show error and allow retry
        B-->>PF: No changes
    end
    Note over B,PF: Keep all pricing/entitlement logic server-side..
    Note over B,PF: Do not trust the client.

```
