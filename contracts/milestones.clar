;; title: milestones
;; version:
;; summary:
;; description:

;; traits
(impl-trait .extension-trait.extension-trait)
(use-trait proposal-trait .proposal-trait.proposal-trait)

;; token definitions

;; constants
(define-constant ERR_UNAUTHORIZED (err u3000))
(define-constant ERR_UNKNOWN_MILESTONE (err u3001))
(define-constant ERR_PROPOSAL_ALREADY_EXECUTED (err u3002))
(define-constant ERR_INCOMPLETE_MILESTONE_FOUND (err u3003))

;; data maps
(define-map milestones principal {
   milestone-name: (string-ascii 144),
   milestone-complete: bool,
   milestone-reward: uint,
   milestone-signoff: principal
})

;; public functions
(define-public (is-dao-or-extension)
  (ok (asserts! (or (is-eq tx-sender .core) (contract-call? .core is-extension contract-caller)) ERR_UNAUTHORIZED))
)

(define-public (add-milestone 
   (proposal <proposal-trait>) 
   (name (string-ascii 144))
   (reward uint)
   (signoff principal)
)
  (begin
   ;; #[filter(name, reward, signoff)]
   (try! (is-dao-or-extension))
   (asserts! (is-none (contract-call? .core executed-at proposal)) ERR_PROPOSAL_ALREADY_EXECUTED)
   (print {event: "add-milestone", proposal: proposal, signoff: tx-sender})
   (ok (asserts! (map-insert milestones (contract-of proposal) {
      milestone-name: name,
      milestone-complete: false,
      milestone-reward: reward,
      milestone-signoff: signoff
   }) ERR_INCOMPLETE_MILESTONE_FOUND))
  )
)

(define-public (callback (sender principal) (memo (buff 34)))
   (ok true)
)

;; read only functions
(define-read-only (get-milestone (proposal principal))
   (ok (unwrap! (map-get? milestones proposal) ERR_UNKNOWN_MILESTONE))
)
