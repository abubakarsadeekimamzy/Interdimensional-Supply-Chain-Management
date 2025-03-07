;; Multiversal Customs and Tariff Contract

(define-map tariffs
  { item-id: uint, from-dimension: uint, to-dimension: uint }
  { rate: uint }
)

(define-constant contract-owner tx-sender)

(define-public (set-tariff (item-id uint) (from-dimension uint) (to-dimension uint) (rate uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u403))
    (ok (map-set tariffs
      { item-id: item-id, from-dimension: from-dimension, to-dimension: to-dimension }
      { rate: rate }
    ))
  )
)

(define-read-only (get-tariff (item-id uint) (from-dimension uint) (to-dimension uint))
  (default-to
    { rate: u0 }
    (map-get? tariffs { item-id: item-id, from-dimension: from-dimension, to-dimension: to-dimension })
  )
)

(define-public (calculate-tariff (item-id uint) (from-dimension uint) (to-dimension uint) (value uint))
  (let
    ((tariff-rate (get rate (get-tariff item-id from-dimension to-dimension))))
    (ok (/ (* value tariff-rate) u100))
  )
)

