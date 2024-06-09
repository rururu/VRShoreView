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
  (modify ?b1 (onboard TRUE))
  (modify ?b2 (onboard FALSE))
  (clear-file "../resources/public/view3d/command.fct")
  (println "Retract command")
  (retract ?cmd))
  
(defrule Update-model-cmd
	?cmd <- (Command update-model ?type ?scale ?draft)
	(Model (type ?type) (gltf ?gltf)(extra ?extra))
	?bt <- (Boat (name ?bn) (onboard TRUE))
	?bm <- (BoatModel (boat ?bn))
	=>
	(println "Command: Update model for " ?bn ": " ?type " " ?scale " " ?draft)
	(modify ?bm (model ?type ?gltf ?scale ?draft ?extra))
	(modify ?bt (model ?type ?gltf ?scale ?draft ?extra))
	(save-facts (str-cat "../NMEA_CACHE/" ?*race* "/boat_models.fct") local BoatModel)
	(clear-file "../resources/public/view3d/command.fct")
	(retract ?cmd))

  



