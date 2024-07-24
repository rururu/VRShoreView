;; RulesControl

;;;;;;;;;;;;;;;;;;;;;;;; C O N T R O L ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule Load-commands
	(declare (salience -1))
	(clock ?t)
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
  
(defrule Update-model-cmd
	?cmd <- (Command update-model ?scale ?draft)
	?m <- (Model (type ?type))
	?b <- (Boat (name ?n)(onboard TRUE)(model ?m))
	=>
	(println "Command: Update model for " ?n ": " ?type " " ?scale " " ?draft)
	(modify ?m (scale ?scale)(draft ?draft))
	(clear-file "../resources/public/view3d/command.fct")
	(retract ?cmd))

(defrule Pause-update
	?cmd <- (Command pause ?val)
	=>
	(println "Command: Pause " ?val)
	(if (eq ?val plus)
		then
		(if (< ?*pause* 5)
			then (bind ?*pause* (+ ?*pause* 1))
			else (if (= ?*pause* 5)
			then (bind ?*pause* 10)
			else (bind ?*pause* (+ ?*pause* 10))))
		else 
		(if (> ?*pause* 10)
		then (bind ?*pause* (- ?*pause* 10))
		else (if (= ?*pause* 10)
		then (bind ?*pause* 5)
		else (if (and (<= ?*pause* 5)(> ?*pause* 1))
		then (bind ?*pause* (- ?*pause* 1))))))
	(println "Pause " ?*pause*)	
	(clear-file "../resources/public/view3d/command.fct")
	(retract ?cmd))



