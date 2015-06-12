(asdf:operate 'asdf:load-op 'eezot)
(use-package :trio-utils)

;constants
(defconstant GO 1)
(defconstant WARN 0)
(defconstant MAX_FROM_HEM 2)
(defconstant POWER 1)
(defconstant TASKTIME 4)
(defconstant MAY 0)
(defconstant MUST 1)

(defvar pow-domain (loop for i from 0 to 5 collect i))
(defvar time-domain (loop for i from 0 to 4 collect i))
(defvar slot-domain (loop for i from 0 to 3 collect i))
(defvar dev-domain (loop for i from 0 to 2 collect i))
(defvar taskid-domain (loop for i from 0 to 2 collect i))
(defvar time-to-live (loop for i from 0 to TASKTIME collect i))
(defvar resp-domain '(0 1))
(defvar bool '(0 1))
(defvar task-type '(0 1))
(defvar time-to-live (loop for i from 0 to 4 collect i))


(define-variable consumption pow-domain)
(define-variable production pow-domain)
(define-variable max pow-domain)
(define-variable washPower dev-domain)
(define-variable ovenPower dev-domain)
(define-variable legPower dev-domain)
(define-variable solarPower dev-domain)
(define-variable windmillPower dev-domain)
(define-variable hemPower dev-domain)
(define-variable msgToWash (taskid-domain resp-domain))
(define-variable msgToOven (taskid-domain resp-domain))
(define-variable windmillPower dev-domain)
(define-variable ovenControl (taskid-domain task-type bool ))
(define-variable washControl (taskid-domain task-type bool ))
(define-variable washState (taskid-domain time-to-live))
(define-variable ovenState (taskid-domain time-to-live))



(define-variable windmillPower dev-domain)

;axioms

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;						EMS							;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSUMPTION, PRODUCTION, MAX STATE ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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

(defvar max-def
(-A- x pow-domain (
					-E- x2 pow-domain(
										<-> (-P- max x)
											(&& (-P- production x2)
												(= x (+ x2 MAX_FROM_HEM))
											)
									 )
				  )
)
)



(defvar existance
	(&&
		(-E- x pow-domain(-P- consumption x))
		(-E- x pow-domain(-P- production x))
		(-E- x pow-domain(-P- max x))
		(-E- x dev-domain(-P- washPower x))
		(-E- x dev-domain(-P- ovenPower x))
		(-E- x dev-domain(-P- legPower x))
		(-E- x dev-domain(-P- solarPower x))
		(-E- x dev-domain(-P- windmillPower x))
		(-E- x pow-domain(-P- hemPower x))

	)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UNIQUENESS OF STATES ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

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

(defvar unicity-max-def
	( -A- x pow-domain(
	  -A- x2 pow-domain(-> (&& (-P- max x) (-P- max x2))
	  					   (= x x2)
	  					))
	)
	)

(defvar unicity-hem-def 
	( -A- x pow-domain(
	  -A- x2 pow-domain(-> (&& (-P- hemPower x) (-P- hemPower x2))
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



;;;;;;;;;;;
;; POWER ;;
;;;;;;;;;;;

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




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WASH STATE AND OVEN STATE ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defvar wash-state-definition
	(-A- i taskid-domain( 
		-A- time time-to-live(
			-> (&& 
					(&& (-P- washState i time) (> time 0) ) 
					(!! (somp_e(-P- washControl i MAY 1)))
				) 
			   (somf_e(-P- washState i 0)))
		)
	))

( defvar wash-state-unicity
	( -A- i taskid-domain(
	  -A- i2 taskid-domain(
	  -A- time time-to-live(
	  -A- time2 time-to-live (-> (&& (-P- washState i time) (-P- washState i2 time2))
	  					   ( && ( = i i2) (= time time2))
	  					)))
	)
	))


( defvar wash-state-evolution
	(-A- i taskid-domain(
	 -A- time time-to-live(
	 -A- time2 time-to-live( ->  ( && (next(-P- washState i time)) (!! (-P- msgToWash i WARN))) 
	 	(&& (-P- washState i time2) (= time (- 1 time2)))
	 )))))

( defvar wash-state-motonicity
	(-A- i taskid-domain(
	 -A- time time-to-live(
	 -A- time2 time-to-live( ->  (next(-P- washState i time)) 
	 	(&& (-P- washState i time2) (<= time time2))
	 )))))




(defvar oven-state-definition
	(-A- i taskid-domain( 
		-A- time time-to-live(
			-> (&& (&& (-P- ovenState i time) (> time 0) ) (!! (somp_e(-P- ovenControl i MAY 1)))) (somf_e(-P- ovenState i 0)))
		)
	))

( defvar oven-state-unicity
	( -A- i taskid-domain(
	  -A- i2 taskid-domain(
	  -A- time time-to-live(
	  -A- time2 time-to-live (-> (&& (-P- ovenState i time) (-P- ovenState i2 time2))
	  					   ( && ( = i i2) (= time time2))
	  					)))
	)
	))


( defvar oven-state-evolution
	(-A- i taskid-domain(
	 -A- time time-to-live(
	 -A- time2 time-to-live( ->  ( && (next(-P- ovenState i time)) (!! (-P- msgToOven i WARN))) 
	 	(&& (-P- ovenState i time2) (= time (- 1 time2)))
	 )))))


( defvar oven-state-motonicity
	(-A- i taskid-domain(
	 -A- time time-to-live(
	 -A- time2 time-to-live( ->  (next(-P- ovenState i time)) 
	 	(&& (-P- ovenState i time2) (<= time time2))
	 )))))



;;;;;;;;;;;;;;;;;;;
;; POWER BALANCE ;;
;;;;;;;;;;;;;;;;;;;


(defvar powerBalance-a
	( -A- cons pow-domain( -A- prod pow-domain(-A- bought pow-domain(
		-> (&&  (-P- consumption cons)
				(-P- production prod)
				(-P- hemPower bought)
		   )
			(
				<= cons (+ prod bought)
			)

	))))
)



(defvar useHemOnlyifNeeded
	( -A- cons pow-domain( -A- prod pow-domain(
		-> (&&
				(-P- consumption cons)
				(-P- production prod)
				(<= cons prod)
			)
			(
				-P- hemPower 0
			)

		)
	))
)

(defvar useHemOnlyifNeeded-b
	( -A- cons pow-domain( -A- prod pow-domain(
		-> (&&
				(-P- consumption cons)
				(-P- production prod)
				(> cons prod)
			)
			(
				-P- hemPower (- cons prod)
			)

		)
	))
)

;;;;;;;;;;;;;;
;; OVERFLOF ;;
;;;;;;;;;;;;;;


(defvar overflow-def
(-A- x pow-domain(	

	<-> (-P- overflow)
		 (&&
		 	(-P- hemPower x)
		 	(> x MAX_FROM_HEM)
		 )
	)
))


(defvar overflow-shed
	( -A- i taskid-domain( -A- time time-domain
		(->  (&& (-P- overflow)
			 	 (somp (-P- washControl i 0 1) )
			 	 (-P- washState i time)
			 )
			 ( &&  (-P- msgToWash i WARN)
			 	    (next(-P- washPower 0)))
		)
	)

))



;;;;;;;;;;;;;;;;;;;;;;;;
;; RESPONSES FROM EMS ;;
;;;;;;;;;;;;;;;;;;;;;;;:

(defvar wash-start-msg-conds-1
	( -A- i taskid-domain(-> (-P- msgToWash i GO) (next(-P- washPower POWER)))
	)
	)

(defvar oven-start-msg-conds-1
	( -A- i taskid-domain(-> (-P- msgToOven i GO) (next(-P- ovenPower POWER) ) )
	)
	)


(defvar wash-response-ensurance
	(-A- i taskid-domain( -> (-P- washControl i) ( || (-P- msgToWash i GO) (-P- msgToWash i WARN))
		)
		))

(defvar wash-msg-unicity
	(-A- i taskid-domain(
		-A- r2 resp-domain(

		-A- r resp-domain( -> (&& (-P- msgToWash i r) (-P- msgToWash i r2)) (= r r2)
			))
	)))

(defvar oven-msg-unicity
	(-A- i taskid-domain(
	 -A- r2 resp-domain(
	 -A- r resp-domain( -> (&& (-P- msgToOven i r) (-P- msgToOven i r2)) (= r r2)
			))
	)))

(defvar oven-response-ensurance
	(-A- i taskid-domain( -> (-P- ovenControl i) (|| (-P- msgToOven i GO) (-P- msgToOven i WARN))))
)

(defvar may-wash-response-definition-ok(
	-A- i taskid-domain(
	-A- b bool(
	-A- p pow-domain(
	-A- p2 pow-domain
	( -> ( && (-P- washControl i MAY b) (&& (-P- consumption p) (&& (-P- max p2) (> p2 (+ p POWER)))) ) 
		( && (-P- msgToWash i GO) ( next( && (-P- washPower POWER) (-P- washState i TASKTIME)))
		)
	)))
)))

(defvar may-wash-response-definition-ko(
	-A- i taskid-domain(
	-A- b bool(
	-A- p pow-domain(
	-A- p2 pow-domain
	( -> ( && (-P- washControl i MAY b) (&& (-P- consumption p) (&& (-P- max p2) (< p2 (+ p POWER)))) ) 
		( && (-P- msgToWash i WARN) 
			(somf_e(&& (-P- msgToWash i GO) ( && (-P- washPower POWER) (-P- washState i TASKTIME))))
	))
)))))

( defvar must-wash-response-definition(
	-A- i taskid-domain(
	-A- b bool( -> (-P- washControl i MUST b) 
		( && (-P- msgToWash i GO) ( next( && (-P- washPower POWER) (-P- washState i TASKTIME))))))))



( defvar must-oven-response-definition(
	-A- i taskid-domain(
	-A- b bool( -> (-P- ovenControl i MUST b) 
		( && (-P- msgToOven i GO) 
			( next( && (-P- washPower POWER) (-P- ovenState i TASKTIME)))))
)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;						DEVICE					  ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;the system
(defvar the-system  
  (alw (&& 
          consumption-Def
          production-Def
          max-def
          existance
          unicity-hem-def
          unicity-max-def
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
          oven-state-motonicity
          oven-state-definition
          oven-state-evolution
          oven-state-unicity

          powerBalance-a
          wash-state-definition
          wash-state-unicity
          wash-state-evolution
          wash-state-motonicity

          wash-msg-unicity
          oven-msg-unicity
          overflow-def
          useHemOnlyifNeeded
          useHemOnlyifNeeded-b

		  may-wash-response-definition-ko
          may-wash-response-definition-ok
          must-wash-response-definition
          must-oven-response-definition
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

;(defvar true-conjecture
 ; (alw (-> (-P- msgToOven 1 GO )
  ;			(-P- ovenPower POWER) ) ))

(defvar true-conjecture
	(alw (-> ( && (-P- washControl 1 MUST 0) ( && (-P- consumption 1) (-P- max 5))) ( && (-P- msgToWash 1 GO) (next(&& (-P- washPower POWER) (-P- washState 1 TASKTIME) ) ))
		)))



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
