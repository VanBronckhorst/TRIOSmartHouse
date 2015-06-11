(asdf:operate 'asdf:load-op 'eezot)
(use-package :trio-utils)

;constants
(defconstant GO 1)
(defconstant WARN 0)
(defconstant MAX_FROM_HEM 2)
(defconstant POWER 1)

(defvar pow-domain (loop for i from 0 to 5 collect i))
(defvar time-domain (loop for i from 0 to 5 collect i))
(defvar slot-domain (loop for i from 0 to 3 collect i))
(defvar dev-domain (loop for i from 0 to 2 collect i))
(defvar taskid-domain (loop for i from 0 to 2 collect i))
(defvar resp-domain '(GO WARN))
(defvar bool '(0 1))
(defvar task-type '(0 1))


(define-variable consumption pow-domain)
(define-variable production pow-domain)
(define-variable washPower dev-domain)
(define-variable ovenPower dev-domain)
(define-variable legPower dev-domain)
(define-variable solarPower dev-domain)
(define-variable windmillPower 'dev-domain)
(define-variable msgToWash (taskid-domain resp-domain))
(define-variable msgToOven (taskid-domain resp-domain))
(define-variable windmillPower dev-domain)
(define-variable ovenControl (taskid-domain task-type bool ))
(define-variable washControl (taskid-domain task-type bool ))

(define-variable windmillPower dev-domain)

;axioms  
(defvar consumption-Def
 (-A- x pow-domain (
  -E- a1 dev-domain(
  -E- a2 dev-domain(
  -E- a3 dev-domain(	
 	  	<-> (-P-  consumption x) 
      (&& (-P- washPower a1)
      	  (-P-  legPower a2)
      	  (-P- ovenPower a3)
      	  (= x (+ (+ a1 a2) a3)))))))))

(defvar production-Def
 (-A- x pow-domain (
  -E- a1 dev-domain(
  -E- a2 dev-domain(	
 	  	<-> (-P-  production x) 
      (&& (-P- solarPower a1)
      	  (-P- windmillPower a2)
      	  (= x (+ a1 a2) )))))))

(defvar existance
	(&&
		(-E- x pow-domain(-P- consumption x))
		(-E- x pow-domain(-P- production x))
		(-E- x dev-domain(-P- washPower x))
		(-E- x dev-domain(-P- ovenPower x))
		(-E- x dev-domain(-P- legPower x))
		(-E- x dev-domain(-P- solarPower x))
		(-E- x dev-domain(-P- windmillPower x))

	)
)

(defvar unicity-cons-def
	( -A- x pow-domain(
	  -A- x2 pow-domain(-> (&& (-P- consumption x) (-P- consumption x2))
	  					   (= x x2)
	  					))
	)
	)

(defvar unicity-prod-def
	( -A- x pow-domain(
	  -A- x2 pow-domain(-> (&& (-P- production x) (-P- production x2))
	  					   (= x x2)
	  					))
	)
	)

(defvar unicity-wash-def
	( -A- x dev-domain(
	  -A- x2 dev-domain(-> (&& (-P- washPower x) (-P- washPower x2))
	  					   (= x x2)
	  					))
	)
	)

(defvar unicity-oven-def
	( -A- x dev-domain(
	  -A- x2 dev-domain(-> (&& (-P- ovenPower x) (-P- ovenPower x2))
	  					   (= x x2)
	  					))
	)
	)

(defvar unicity-leg-def
	( -A- x dev-domain(
	  -A- x2 dev-domain(-> (&& (-P- legPower x) (-P- legPower x2))
	  					   (= x x2)
	  					))
	)
	)

(defvar unicity-sol-def
	( -A- x dev-domain(
	  -A- x2 dev-domain(-> (&& (-P- solarPower x) (-P- solarPower x2))
	  					   (= x x2)
	  					))
	)
	)

(defvar unicity-wind-def
	( -A- x dev-domain(
	  -A- x2 dev-domain(-> (&& (-P- windmillPower x) (-P- windmillPower x2))
	  					   (= x x2)
	  					))
	)
	)


(defvar wash-start-msg-conds-1
	( -A- i taskid-domain(-> (-P- msgToWash i GO) (-P- washPower POWER))
	)
	)

(defvar oven-start-msg-conds-1
	( -A- i taskid-domain(-> (-P- msgToOven i GO) (-P- ovenPower POWER ) )
	)
	)


;Define the Control messages without parameters used to speedup the solution
(defvar noParamControlDef
	(&&
		(<-> (-P- washControl)
			 ( -E- i1 taskid-domain(-E- i2 task-type(-E- i7 bool(
			 	-P- washControl i1 i2 i7
			 ))))
		)

		(<-> (-P- ovenControl)
			 ( -E- i1 taskid-domain(-E- i2 task-type(-E- i7 bool(
			 	-P- ovenControl i1 i2 i7
			 ))))
		)

	)
)

(defvar messageUnicity
	(&&
		( -A- i1 taskid-domain(-A- i2 task-type(-A- i7 bool(
		 -A- j1 taskid-domain(-A- j2 task-type(-A- j7 bool(
		-> (&&
			(-P- washControl i1 i2 i7)
			(-P- washControl j1 j2 j7)
		   )

			(&&
				(= i1 j1)
				(= i2 j2)
				
				(= i7 j7)

			)

		)))))))

		( -A- i1 taskid-domain(-A- i2 task-type(-A- i7 bool(
		 -A- j1 taskid-domain(-A- j2 task-type(-A- j7 bool(
		-> (&&
			(-P- ovenControl i1 i2 i7 )
			(-P- ovenControl j1 j2 j7 )
		   )

			(&&
				(= i1 j1)
				(= i2 j2)

				(= i7 j7)

			)

		)))))))


	)
)

(defvar powerIfRequested 
	(&&   

		(-A- x dev-domain (-> 
								(&& (-P- ovenPower x) (> x 0))
			 
			 					(somp_e (-P- ovenControl))
		))

		(-A- x dev-domain(-> 
							(&& (-P- washPower x) (> x 0))
			 
			 				(somp_e (-P- washControl))
		))

	)
)


(defvar wash-response-ensurance
	(-A- i taskid-domain( -> (-P- washControl i) (-P- msgToWash i))
		))

(defvar oven-response-ensurance
	(-A- i taskid-domain( -> (-P- ovenControl i) (-P- msgToOven i)))
)


;the system
(defvar the-system  
  (alw (&& 
          consumption-Def
          production-Def
          existance
          unicity-prod-def
          unicity-oven-def
          unicity-wash-def
          unicity-cons-def
          unicity-leg-def
          unicity-sol-def
          unicity-wind-def
          powerIfRequested
          oven-start-msg-conds-1
          wash-start-msg-conds-1
          wash-response-ensurance
          oven-response-ensurance
          noParamControlDef
          messageUnicity
)))      

;;
(defvar powerneedscontr
	(->
		(-A- x dev-domain(&& (-P- ovenPower x) (> x 0)))
		(somp_e (-P- ovenControl))

	)
)
	
(defvar init
  (&&
  		(alwp_i (!! (-P- ovenControl)))
  		(-A- x taskid-domain(-A- x2 task-type(-A- x3 bool(!! (-P- washControl x x2 x3)))))
  ))	

;;false assertion
;(defvar false-conjecture
 ; (som (&& (washPower-is 5)
  ;			(consumption-is 4) ) ))

;(defvar false-conjecture
 ; (som (&& (-P- msgToWash 1 GO)
  ;			(washPower-is 0) ) ))

;(defvar false-conjecture
  ;(alw(!! (-P- ovenPower 2))))

;(defvar false-conjecture
 ; (alw(!! (-P- ovenPower 2))))

;(defvar true-conjecture
  ;(alw (-> (-P- msgToWash 1 GO )
  ;			(-P- washPower 1) ) ))

;(defvar true-conjecture
 ; (alw (-> (-P- msgToOven 1 GO )
  ;			(-P- ovenPower 1) ) ))

(defvar true-conjecture
  (alw (-> (-P- msgToOven 1 GO )
  			(-P- ovenPower-is POWER) ) ))

;Zot call
(eezot:zot 20
  (&& 
    the-system
    (yesterday init)
    ;(!! powerneedscontr)
    ;(!! utility) ;returns UNSAT, since it cannot find counterexamples
    (!! true-conjecture) ;returns SAT, since it  finds a counterexample
  ) 
)
