;; RulesControl

;;;;;;;;;;;;;;;;;;;;;;;; C O N T R O L ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule Load-commands
	(declare (salience -1))
	(clock ?t)
	(test (= (mod ?t 2) 0))
	=>
	(load-facts "../resources/public/view3d/command.fct"))
	 
(defrule Go-onboard-cmd
	?cmd <- (Command onboard ?n1)
	?b1 <- (Boat (name ?n1) (onboard FALSE))
	?b2 <- (Boat (name ?n2)(onboard TRUE))
	=>
	(println "Command: Go onboard " ?n1)
	(retract ?cmd)
	(modify ?b1 (onboard TRUE))
	(modify ?b2 (onboard FALSE))
	(clear-file "../resources/public/view3d/command.fct"))
  
;(defrule Update-model-cmd
	;?cmd <- (Command update-model ?type ?scale ?draft)
	;?m <- (Model (type ?type))
	;?b <- (Boat (name ?bn) (onboard TRUE))
	;=>
	;(println "Command: Update model for " ?bn ": " ?type " " ?scale " " ?draft)
	;(modify ?b (model ?m))
	;(save-facts (str-cat "../NMEA_CACHE/" ?*race* "/boat_models.fct") local BoatModel)
	;(clear-file "../resources/public/view3d/command.fct")
	;(retract ?cmd))

  



