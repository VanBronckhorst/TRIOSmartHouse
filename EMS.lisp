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

(defconstant MAX_OVF 3)
(defconstant MAX_TIME_OVER 3)

(defvar pow-domain (loop for i from 0 to 6 collect i))
(defvar time-domain (loop for i from 0 to 5 collect i))

(defvar slot-domain (loop for i from 0 to 3 collect i))
(defvar dev-domain (loop for i from 0 to POWER collect i))
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
(define-variable legReq dev-domain)
(define-variable solarPower dev-domain)
(define-variable windmillPower dev-domain)
(define-variable hemPower pow-domain)
(define-variable msgToWash (taskid-domain resp-domain))
(define-variable msgToOven (taskid-domain resp-domain))
(define-variable windmillPower dev-domain)
(define-variable ovenControl (taskid-domain MUST 0 ))
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
		(-E- x dev-domain(-P- legReq x))
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
	( -A- x '(-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6)(
	  -A- x2 '(-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6)(-> (&& (-P- hemPower x) (-P- hemPower x2))
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

(defvar unicity-legreq-def
	( -A- x dev-domain(
	  -A- x2 dev-domain(-> (&& (-P- legReq x) (-P- legReq x2))
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

(defvar legpower-def
	( -A- p dev-domain( -> (-P- legReq p)
							(|| (-P- legPower p)
								(-P- blackout))
					  )
	)
)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WASH STATE AND OVEN STATE ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defvar wash-state-definition
	(-A- i taskid-domain( 
		-A- time time-to-live(
			-> (&&
					(&& 
						(-P- washState i time) 
						(> time 0) 
					) 
					
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
	 -A- time2 time-to-live( ->  (&& (-P- washState i time)
	 								 (futr (-P- washState i time2) 1 )
	 								 (-P- washPower POWER)
	 							 )    
	 							 (
	 							 	= time2 (- time 1)
	 							 )
					    	)    
    ))))


( defvar wash-state-motonicity
	(-A- i taskid-domain(
	 -A- i2 taskid-domain(
	 -A- time time-to-live(
	 -A- time2 time-to-live( ->  (&& (-P- washState i time)
	 								 (futr (-P- washState i time2) 1 )
	 							 )
	 							 (<= time2 time)
	 ))))))

(defvar wash-state-continuity
	(-A- i taskid-domain(
	 -A- time time-to-live(
	 -E- time2 time-to-live( ->  (&& (-P- washState i time)
	 							 	 (!!(-P- msgToWash i WARN))
	 							 )
	 							 
	 							 	
	 							 (futr (-P- washState i time2) 1 )
	 							 	
	 )))))



(defvar oven-state-definition
	(-A- i taskid-domain( 
		-A- time time-to-live(
			-> (&&
					(&& 
						(-P- ovenState i time) 
						(> time 0) 
					) 
					
				) 
				(somf_e(-P- ovenState i 0)))
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
	 -A- time2 time-to-live( ->  (&& (-P- ovenState i time)
	 								 (futr (-P- ovenState i time2) 1 )
	 								 (-P- ovenPower POWER)
	 							 )    
	 							 (
	 							 	= time2 (- time 1)
	 							 )
					    	)    
    ))))


( defvar oven-state-motonicity
	(-A- i taskid-domain(
	 -A- i2 taskid-domain(
	 -A- time time-to-live(
	 -A- time2 time-to-live( ->  (&& (-P- ovenState i time)
	 								 (futr (-P- ovenState i time2) 1 )
	 							 )
	 							 (<= time2 time)
	 ))))))

(defvar oven-state-continuity
	(-A- i taskid-domain(
	 -A- time time-to-live(
	 -E- time2 time-to-live( ->  (&& (-P- ovenState i time)
	 							 	 (!!(-P- msgToOven i WARN))
	 							 )
	 							 
	 							 	
	 							 (futr (-P- ovenState i time2) 1 )
	 							 	
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


(defvar overflow-def
(<-> 
	(-P- overflow)
	(-E- x pow-domain(&&
		 				(-P- hemPower x)
		 				(> x MAX_FROM_HEM)
		 			)	
	)
	
))


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



(defvar overflow-shed

	( -A- i taskid-domain( -A- time time-to-live

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
	( -A- i taskid-domain(-> (-P- msgToWash i GO) (futr(-P- washPower POWER) 1))
	)
	)

(defvar oven-start-msg-conds-1
	( -A- i taskid-domain(-> (-P- msgToOven i GO) (futr (-P- ovenPower POWER) 1 ) )
	)
	)



(defvar wash-msg-unicity
	(-A- i taskid-domain(
		-A- i2 taskid-domain(
		-A- r2 resp-domain(

		-A- r resp-domain( -> (&& (-P- msgToWash i r) (-P- msgToWash i2 r2)) (&& (= r r2) ( = i i2))
			))
	))))

(defvar oven-msg-unicity
	(-A- i taskid-domain(
	 -A- i2 taskid-domain(
	 -A- r2 resp-domain(
	 -A- r resp-domain( -> (&& (-P- msgToOven i r) (-P- msgToOven i2 r2)) (&& (= r r2) (= i i2))
			))
	))))

(defvar oven-response-ensurance
	(-A- i taskid-domain( -> (-P- ovenControl i MUST 0) (-P- msgToOven i GO)))
)

(defvar wash-response-ensurance-1
	(-A- i taskid-domain( -> (-P- washControl i MUST 0) (-P- msgToWash i GO)))
)

(defvar wash-response-ensurance-2
	(-A- i taskid-domain( -> (-P- washControl i MAY 0) (-P- msgToWash i GO)))
)

(defvar wash-response-ensurance-3
	(-A- i taskid-domain( -> (-P- washControl i MAY 1) (-P- msgToWash i GO)))
)




(defvar must-wash-response-definition
	(-A- i taskid-domain(
			-A- b bool(
						->
						(-P- washControl i MUST b) 
						(-P- msgToWash i GO)
			)
	))	
)

(defvar may-wash-response-definition
	(-A- i taskid-domain(
			-A- b bool(
						->
						(-P- washControl i MAY b) 
						(-P- msgToWash i GO)
			)
	))	
)

(defvar goReactionWash
	(-A- i taskid-domain(->
							(&& (-P- msgToWash i GO)
								(!!(-E- tt time-to-live(-P- washState i tt )))
							)
							(&&
								(futr (-P- washState i TASKTIME) 1)
								(futr (-P- washPower POWER) 1)
							)
		) 
)
	)












;( defvar must-oven-response-definition(
;	-A- i taskid-domain(
;	-A- b bool( <-> (-P- ovenControl i MUST b) 
;		( && (-P- msgToOven i GO) 
;			( next( && (-P- ovenPower POWER) (-P- ovenState i TASKTIME)))))
;)))

(defvar must-oven-response-definition
	(-A- i taskid-domain(
			-A- b bool(
						->
						(-P- ovenControl i MUST b) 
						(-P- msgToOven i GO)
			)
	))	
)

(defvar goReactionOven
	(-A- i taskid-domain(->
							(&& (-P- msgToOven i GO)
								(!!(-E- tt time-to-live(-P- ovenState i tt )))
							)
							(&&
								(futr (-P- ovenState i TASKTIME) 1)
								(futr (-P- ovenPower POWER) 1)
							)
		) 
)
	)




;;;;;;;;;;;;;;;;;;;;;;;;
;; BLACKOUT ;;
;;;;;;;;;;;;;;;;;;;;;;;:

(defvar blackout-def
   
	   (<->	(-E- p pow-domain(
						   		||
						   			(&&
						   				(-P- hemPower p) 
						   				(> p MAX_OVF)
						   			) 
						   			(&&
						   				(> p MAX_FROM_HEM)
						   				(lasted_ii (-P- hemPower p) MAX_TIME_OVER )
						   			)
						   		)	
	   		)

	   		(&& 
	   			(!! (-P- blackout))
	   			(futr (-P- blackout) 1)
	   		)


	   )
   

)

(defvar blackout-continuity
	(->
		(-P- blackout)
		(until (-P- blackout) (-P- manualRestore)
		) 
	)

)

(defvar blackout-noPow
	(->
		(-P- blackout)
		(-P- consumption 0)
		) 
	)

(defvar restore-def
	(->
		(-P- manualRestore)
		(&&
			(-P- blackout)
			(futr (!! (-P- blackout)) 1)
		)
	)

)

(defvar restore-power-wash
	(-E- i taskid-domain(-E- tp time-to-live(
		-> (&&
		   		(past (-P- manualRestore) 1)
		   		(&&
					(-P- washState i tp)
					(> tp 0)

		   		)
		)
		(
			-P- msgToWash i GO
		)

	)))
)

(defvar restore-power-oven
	(-E- i taskid-domain(-E- tp time-to-live(
		-> (&&
		   		(past (-P- manualRestore) 1)
		   		(&&
					(-P- ovenState i tp)
					(> tp 0)

		   		)
		)
		(
			-P- msgToOven i GO
		)

	)))
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;						DEVICE					  ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-variable msgFromEmsOven (taskid-domain resp-domain))
(define-variable msgFromEmsWash (taskid-domain resp-domain))

(define-variable washRequestTask (taskid-domain task-type bool))
(define-variable ovenRequestTask (taskid-domain MUST 0))



(defvar wash-msg-from-to-unicity(
	-A- i taskid-domain(
	-A- r resp-domain(
	-A- i1 taskid-domain(
	-A- r1 resp-domain( -> ( && (-P- msgToWash i r) (-P- msgToWash i1 r1)) (&& (= i i1) (= r r1))
		)
	)
	))))

(defvar oven-msg-from-to-unicity(
	-A- i taskid-domain(
	-A- r resp-domain(
	-A- i1 taskid-domain(
	-A- r1 resp-domain( -> ( && (-P- msgToOven i r) (-P- msgToOven i1 r1)) (&& (= i i1) (= r r1))
		)
	)
	))))



(defvar no-request-while-working-wash(
	-A- i taskid-domain(
	-A- i1 taskid-domain(
	-A- time time-to-live(
	-A- m task-type(
	-A- b bool( -> ( && (-P- washState i time) ( > time 0)) (!! (-P- washControl i1 m b))
		))
	)))))


(defvar no-request-while-working-oven(
	-A- i taskid-domain(
	-A- i1 taskid-domain(
	-A- time time-to-live( -> ( && (-P- ovenState i time) ( > time 0)) (!! (-P- ovenControl i1 MUST 0))
		)
	))))


(defvar request-unicity-wash(
	-A- i taskid-domain(
	-A- i1 taskid-domain(
	-A- b bool(
	-A- b1 bool(
	-A- m task-type(
	-A- m1 task-type(
		-> ( && (-P- washControl i m b) (-P- washControl i1 m1 b1)) ( && ( = i i1) (&& ( = m m1) (= b b1)) )
		)
		))

	)))))


(defvar request-unicity-oven(
	-A- i taskid-domain(
	-A- i1 taskid-domain(
		-> ( && (-P- ovenControl i MUST 0) (-P- ovenControl i1 MUST 0)) ( = i i1)  
		)
		)

	))

;(defvar performing-only-with-request-wash-1(
;	-A- i taskid-domain(
;	-A- time time-to-live(
;		-> (-P- washState i time) (&& (somp_e(|| 
;												(-P- washControl i MAY 1) 
;												(||
;													(-P- washControl i MUST 0)
;													(-P- washControl i MAY 1)
;													)) 
;		(somp_e(-P- msgToWash i GO)))
;		)
;	))))

(defvar performing-only-with-request-wash-2(
	-A- i taskid-domain(
	-A- time time-to-live(
		-> (-P- washState i time) (&& (somp_e(-P- washControl i MAY 0)) (somp_e(-P- msgToWash i GO)))
		)
	)))

(defvar performing-only-with-request-wash-3(
	-A- i taskid-domain(
	-A- time time-to-live(
		-> (-P- washState i time) (&& (somp_e(-P- washControl i MUST 0)) (somp_e(-P- msgToWash i GO)))

		)
	)))


(defvar performing-only-with-request-oven(
	-A- i taskid-domain(
	-A- time time-to-live(
		-> (-P- ovenState i time) (&& (somp_e(-P- ovenControl i MUST 0)) (somp_e(-P- msgToOven i GO)))
		)
	)))

(defvar no-may-oven-1(
	-A- i taskid-domain(
	!! (-P- ovenControl i MAY 0))
	))

(defvar no-may-oven-2(
	-A- i taskid-domain(
	!! (-P- ovenControl i MAY 1)
	)))

(defvar no-may-oven-3(
	-A- i taskid-domain(
	!! (-P- ovenControl i MUST 1)
	)))

(defvar no-must-shed(
	-A- i taskid-domain(
	!! (-P- washControl i MUST 1))
	))

(defvar no-useless-message-oven
	(-A- i taskid-domain(-A- m '(0 1)
			(->
				(-P- msgToOven i m)
				(||
					(-P- blackout)
					(-P- ovenControl)
				)
			)
	))
)

(defvar no-useless-message-wash
	(-A- i taskid-domain(-A- m '(0 1)
			(->
				(-P- msgToWash i m)
				(||
					(-P- blackout)
					(-P- washControl)
				)
			)
	))
)







;the system
(defvar the-system  
  (alw (&& 
          consumption-Def
          production-Def
          max-def
          legpower-def
          existance
          unicity-hem-def
          unicity-max-def
          unicity-legreq-def
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
          wash-response-ensurance-1
          wash-response-ensurance-2
          wash-response-ensurance-3
          oven-response-ensurance
          noParamControlDef
          messageUnicity
          oven-state-motonicity
          oven-state-definition
          oven-state-evolution
          oven-state-unicity

          powerBalance-a
          ; mon e evol da fare come oven
          wash-state-definition
          wash-state-unicity
          wash-state-evolution
          wash-state-motonicity

          wash-msg-unicity
          oven-msg-unicity
          overflow-def
          useHemOnlyifNeeded
          useHemOnlyifNeeded-b


          must-wash-response-definition
          must-oven-response-definition
          may-wash-response-definition
          may-wash-response-definition



          blackout-def
          overflow-shed
          blackout-continuity
          blackout-noPow
          restore-def
          restore-power-oven
          restore-power-wash

          no-request-while-working-oven
          no-request-while-working-wash


          request-unicity-wash
          request-unicity-oven

          oven-msg-from-to-unicity
          wash-msg-from-to-unicity

          no-may-oven-1
          no-may-oven-2
          no-may-oven-3
          no-must-shed

          performing-only-with-request-oven
         ; performing-only-with-request-wash-1
         ; performing-only-with-request-wash-2
         ; performing-only-with-request-wash-3
          goReactionOven

          ;da fare per wash
          no-useless-message-oven
          no-useless-message-wash
          oven-state-continuity
          wash-state-continuity

          goReactionWash
          




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
  	    (!! (-P- blackout))
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
  			(-P- ovenPower POWER) ) ))

;(defvar true-conjecture

;	(&&
 ;  		(som (&& (-P- blackout)
  ; 				  (-P- manualRestore)
   ;				  (-E- p '( 1 2) (futr (-P- legReq p) 1))
   	;		))
   		
   ;)
;)


;Zot call
(eezot:zot 10
  (&& 
    the-system
    (yesterday init)
    ;(!! powerneedscontr)
    ;(!! utility) ;returns UNSAT, since it cannot find counterexamples
    ;(som(-E- i taskid-domain(-E- tt time-to-live(-P- ovenControl i MUST 0))))
    (som(-E- i taskid-domain(-E- tt time-to-live(-P- washControl i MAY 0))))


    ;true-conjecture ;returns SAT, since it  finds a counterexample


    ;(!! true-conjecture) ;returns SAT, since it  finds a counterexample

  ) 
)
