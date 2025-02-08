;; Rental Income Distribution Contract

(define-map rental-income
  { property-id: uint }
  { total-income: uint }
)

(define-map user-income
  { property-id: uint, user: principal }
  { claimed-income: uint }
)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_NOT_FOUND (err u404))
(define-constant ERR_INSUFFICIENT_INCOME (err u402))

(define-public (add-rental-income (property-id uint) (amount uint))
  (let
    (
      (current-income (default-to { total-income: u0 } (map-get? rental-income { property-id: property-id })))
    )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (map-set rental-income
      { property-id: property-id }
      { total-income: (+ (get total-income current-income) amount) }
    )
    (ok true)
  )
)

(define-public (claim-income (property-id uint))
  (let
    (
      (user tx-sender)
      (total-income (unwrap! (get total-income (map-get? rental-income { property-id: property-id })) ERR_NOT_FOUND))
      (claimed-income (default-to { claimed-income: u0 } (map-get? user-income { property-id: property-id, user: user })))
      (claimable-income (/ total-income u100)) ;; Simplified: each user gets 1% of total income
    )
    (asserts! (> claimable-income u0) ERR_INSUFFICIENT_INCOME)
    (try! (as-contract (stx-transfer? claimable-income tx-sender user)))
    (map-set user-income
      { property-id: property-id, user: user }
      { claimed-income: (+ (get claimed-income claimed-income) claimable-income) }
    )
    (ok claimable-income)
  )
)

(define-read-only (get-claimable-income (property-id uint) (user principal))
  (let
    (
      (total-income (unwrap! (get total-income (map-get? rental-income { property-id: property-id })) ERR_NOT_FOUND))
      (claimed-income (default-to { claimed-income: u0 } (map-get? user-income { property-id: property-id, user: user })))
    )
    (ok (- (/ total-income u100) (get claimed-income claimed-income)))
  )
)

