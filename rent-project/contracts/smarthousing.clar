;; Enhanced Rent and Lease Smart Contract

;; Define constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-already-initialized (err u101))
(define-constant err-not-initialized (err u102))
(define-constant err-already-rented (err u103))
(define-constant err-not-rented (err u104))
(define-constant err-insufficient-funds (err u105))
(define-constant err-not-tenant (err u106))
(define-constant err-not-found (err u107))
(define-constant err-lease-not-expired (err u108))
(define-constant err-invalid-rating (err u109))

;; Define data variables
(define-data-var contract-initialized bool false)
(define-data-var platform-fee-percentage uint u5) ;; 5% platform fee
(define-data-var total-properties uint u0)

;; Define data maps
(define-map properties
  { property-id: uint }
  {
    owner: principal,
    rental-price: uint,
    security-deposit: uint,
    rental-duration: uint,
    description: (string-ascii 256),
    available: bool,
    tenant: (optional principal),
    lease-start-time: uint,
    rating: uint
  }
)

(define-map user-ratings { user: principal } { total-rating: uint, count: uint })

;; Initialize contract
(define-public (initialize (fee-percentage uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (not (var-get contract-initialized)) err-already-initialized)
    (var-set platform-fee-percentage fee-percentage)
    (var-set contract-initialized true)
    (ok true)))

;; Add a new property
(define-public (add-property (price uint) (deposit uint) (duration uint) (description (string-ascii 256)))
  (let ((new-property-id (+ (var-get total-properties) u1)))
    (begin
      (asserts! (var-get contract-initialized) err-not-initialized)
      (map-set properties
        { property-id: new-property-id }
        {
          owner: tx-sender,
          rental-price: price,
          security-deposit: deposit,
          rental-duration: duration,
          description: description,
          available: true,
          tenant: none,
          lease-start-time: u0,
          rating: u0
        }
      )
      (var-set total-properties new-property-id)
      (ok new-property-id))))

;; Update property details
(define-public (update-property (property-id uint) (price uint) (deposit uint) (duration uint) (description (string-ascii 256)))
  (match (map-get? properties { property-id: property-id })
    property (begin
      (asserts! (is-eq (get owner property) tx-sender) err-owner-only)
      (asserts! (get available property) err-already-rented)
      (ok (map-set properties
        { property-id: property-id }
        (merge property {
          rental-price: price,
          security-deposit: deposit,
          rental-duration: duration,
          description: description
        }))))
    err-not-found))

;; Rent the property
(define-public (rent-property (property-id uint))
  (match (map-get? properties { property-id: property-id })
    property
      (let (
        (total-cost (+ (get rental-price property) (get security-deposit property)))
        (fee (/ (* (get rental-price property) (var-get platform-fee-percentage)) u100))
      )
        (begin
          (asserts! (var-get contract-initialized) err-not-initialized)
          (asserts! (get available property) err-already-rented)
          (asserts! (>= (stx-get-balance tx-sender) total-cost) err-insufficient-funds)
          (try! (stx-transfer? (- total-cost fee) tx-sender (get owner property)))
          (try! (stx-transfer? fee tx-sender contract-owner))
          (ok (map-set properties
            { property-id: property-id }
            (merge property {
              available: false,
              tenant: (some tx-sender),
              lease-start-time: block-height
            })))))
    err-not-found))

;; End the lease
(define-public (end-lease (property-id uint))
  (match (map-get? properties { property-id: property-id })
    property
      (begin
        (asserts! (is-eq (some tx-sender) (get tenant property)) err-not-tenant)
        (asserts! (>= block-height (+ (get lease-start-time property) (get rental-duration property))) err-lease-not-expired)
        (try! (as-contract (stx-transfer? (get security-deposit property) contract-owner tx-sender)))
        (ok (map-set properties
          { property-id: property-id }
          (merge property {
            available: true,
            tenant: none,
            lease-start-time: u0
          }))))
    err-not-found))
