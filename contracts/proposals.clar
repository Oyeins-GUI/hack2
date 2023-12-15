
;; title: initialize-program
;; version:
;; summary:
;; description:

(impl-trait .proposal-trait.proposal-trait)
(use-trait proposal-trait .proposal-trait.proposal-trait)

;; Initiliaze Your Grant Program
(define-public (execute (sender principal)) 
   (begin
      ;; Enable extensions
      (try! (contract-call? .core set-extensions
			(list
				{extension: .membership-token, enabled: true}
				{extension: .proposal-voting, enabled: true}
				{extension: .proposal-submission, enabled: true}
				{extension: .initialize-program, enabled: true}
				{extension: .milestones, enabled: true}
			)
		))

      ;; Mint initial token supply.
		(try! (contract-call? .membership-token mint-many
			(list
				{amount: u1500, recipient: sender}
				{amount: u1500, recipient: 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5}
				{amount: u1500, recipient: 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG}
			)
		))

      (print "Executed proposal")
      (ok true)
   )
)

;; Create Grant Proposals
(define-public (create-proposal (title (string-ascii 50)) (description (string-utf8 500)) (proposal <proposal-trait>)) 
   (contract-call? .proposal-submission propose proposal title description)
)
