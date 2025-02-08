;; Property Token Contract

(define-fungible-token property-token)

(define-map properties
  { property-id: uint }
  {
    name: (string-ascii 64),
    total-supply: uint,
    price-per-token: uint
  }
)

(define-data-var property-nonce uint u0)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_NOT_FOUND (err u404))
(define-constant ERR_INSUFFICIENT_TOKENS (err u402))

(define-public (create-property (name (string-ascii 64)) (total-supply uint) (price-per-token uint))
  (let
    (
      (property-id (+ (var-get property-nonce) u1))
    )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (try! (ft-mint? property-token total-supply CONTRACT_OWNER))
    (map-set properties
      { property-id: property-id }
      {
        name: name,
        total-supply: total-supply,
        price-per-token: price-per-token
      }
    )
    (var-set property-nonce property-id)
    (ok property-id)
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (try! (ft-transfer? property-token amount sender recipient))
    (match memo to-print (print to-print) 0x)
    (ok true)
  )
)

(define-read-only (get-balance (account principal))
  (ok (ft-get-balance property-token account))
)

(define-read-only (get-property (property-id uint))
  (map-get? properties { property-id: property-id })
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply property-token))
)

