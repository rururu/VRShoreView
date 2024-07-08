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
  
(defrule Update-model-cmd
	?cmd <- (Command update-model ?scale ?draft)
	?m <- (Model (type ?type))
	?b <- (Boat (name ?n)(onboard TRUE)(model ?m))
	=>
	(println "Command: Update model for " ?n ": " ?type " " ?scale " " ?draft)
	(modify ?m (scale ?scale)(draft ?draft))
	(clear-file "../resources/public/view3d/command.fct")
	(retract ?cmd))

  



