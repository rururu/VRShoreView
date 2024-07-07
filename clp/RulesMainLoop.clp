;; Main Defrules
;;;;;;;;;;;;;;;;;;;;;;;; MAIN LOOP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule step-clock
	(declare (salience -100))
	?c <- (clock ?t)
	=>
	(pause 1)
	(retract ?c)
	(assert (clock (+ ?t 1)))
	(run))

(defrule Main-loop
	(declare (salience +1))
	(clock ?t)
	(test (= (mod ?t ?*pause*) 0))
    =>
    (println "clock " ?t)
    (bind ?*gmt* (gm-time))
    (bind ?*race* (read-file "../NMEA_CACHE/RACE.txt"))
    (if (neq ?*race* EOF)
		then
		(load-facts (str-cat "../NMEA_CACHE/" ?*race* "/GPRMC.txt"))
		(load-facts (str-cat "../NMEA_CACHE/" ?*race* "/boat_models.fct"))))
		
(defrule Set-GEN-MODEL-1
	(GEN-MODEL ?)
	(not (NEW-MODEL ?))
	=>
	(assert (Information phase)))
	
(defrule Set-GEN-MODEL-2
	?n <- (NEW-MODEL ?nm)
	(not (GEN-MODEL ?))
	=>
	(retract ?n)
	(if (eq ?nm "")
		then (assert (GEN-MODEL "Bermuda"))
		else (assert (GEN-MODEL ?nm)))
	(assert (Information phase)))
	
(defrule Set-GEN-GEN-MODEL-3
	?g <- (GEN-MODEL ?gm)
	?n <- (NEW-MODEL ?nm)
	=>
	(if (eq ?nm "")
		then (retract ?n)
		else
		(retract ?g ?n)
		(assert (GEN-MODEL ?nm)))
	(assert (Information phase)))
		
;;;;;;;;;;;;;;;;;;;;;;;; INFORMATION PHASE ;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule Old-timestamp
	?p <- (Information phase)
    ?ts <- (timestamp ?time1)
    ?mbi <- (MyBoatInfo (timestamp ?time2))
    (test (eq ?time1 ?time2))
    =>
	(retract ?mbi)
	(move-boats ?*pause*)
	;;(println "Visualisation phase 1")
	(retract ?p)
	(assert (Visualisation phase)))

(defrule New-timestamp
	(Information phase)
    ?ts <- (timestamp ?time1)
    ?mbi <- (MyBoatInfo (timestamp ?time2))
    (test (neq ?time1 ?time2))
    =>
	(println "New Info Timestamp " ?time2)
	(retract ?ts)
	(do-for-all-facts ((?b Boat)) TRUE
		(retract ?b))
	(println "Fleet " (load-facts (str-cat "../NMEA_CACHE/" ?*race* "/AIVDM.txt"))))
	
(defrule Assert-Boat
	(Information phase)
	?bi <- (BoatInfo (motion $?motion) (mmsi ?mmsi))
	?bn <- (boat-name ?name ?mmsi)
	=>
	(retract ?bi ?bn)
	(assert (Boat (name ?name) (motion $?motion) (mmsi ?mmsi))))
    	
(defrule Assert-my-Boat
	(declare (salience -1))
	?p <- (Information phase)
    ?mbi <- (MyBoatInfo (timestamp ?time2) (motion $?mot))
	(MYBOAT ?n)
	(not (Boat (name ?n)))
	=>
	(retract ?mbi)
	(assert (timestamp ?time2))
	(assert (Boat (name ?n) (motion $?mot) (onboard TRUE)))
	(println "My boat " ?n " motion " $?mot)
	;;(println "Visualisation phase 2")
	(retract ?p)
	(assert (Visualisation phase)))
    	
;;;;;;;;;;;;;;;;;;;;;;;; VISUALISATION PHASE ;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule Set-stored-boat-model
	(declare (salience +4))
    (Visualisation phase)
	(BoatModel (boat ?boat) (model ?model))
	?m <- (Model (type ?model))
	?b <- (Boat (name ?boat &:(neq ?boat "")) 
			(model ?bm &:(neq ?bm ?m)))
	=>
	(modify ?b (model ?m)))

(defrule Assert-specific-BoatModel
	(declare (salience +3))
    (Visualisation phase)
    (Model (boat ?boat)(type ?model))
    (Boat (name ?boat &:(neq ?boat "")))
    (not (BoatModel (boat ?boat)))
    =>
    (assert (BoatModel (boat ?boat)(model ?model))))

(defrule Assert-general-BoatModel
	(declare (salience +2))
    (Visualisation phase)
    (GEN-MODEL ?gen-type)
    (Model (type ?gen-type))
    (Boat (name ?boat &:(neq ?boat "")))
    (not (BoatModel (boat ?boat)))
    =>
    (assert (BoatModel (boat ?boat) (model ?gen-type))))	

(defrule Assert-Medieval-Mix-BoatModel
	(declare (salience +2))
    (Visualisation phase)
    (GEN-MODEL "Medieval_Mix")
    (Model (type "Santa_Maria"))
    (Model (type "Santa_Isadora"))
    ?b <- (Boat (name ?boat &:(neq ?boat "")))
    (not (BoatModel (boat ?boat)))
    =>
    (if (> (random 0 1) 0)
		then (assert (BoatModel (boat ?boat) (model "Santa_Maria")))
		else (assert (BoatModel (boat ?boat) (model "Santa_Isadora")))))

(defrule Assert-Trimaran-Mix-BoatModel
	(declare (salience +2))
    (Visualisation phase)
    (GEN-MODEL "Trimaran_Mix")
    (Model (type "Black_Trimaran"))
    (Model (type "Blue_Trimaran"))
    (Model (type "Cyan_Trimaran"))
    (Model (type "Green_Trimaran"))
    (Model (type "Red_Trimaran"))
    (Model (type "Magenta_Trimaran"))
    (Model (type "Yellow_Trimaran"))
    (Model (type "White_Trimaran"))
    ?b <- (Boat (name ?boat &:(neq ?boat "")))
    (not (BoatModel (boat ?boat)))
    =>
    (switch (random 1 8)
		(case 1 then (assert (BoatModel (boat ?boat) (model "Black_Trimaran"))))
		(case 2 then (assert (BoatModel (boat ?boat) (model "Blue_Trimaran"))))
		(case 3 then (assert (BoatModel (boat ?boat) (model "Cyan_Trimaran"))))
		(case 4 then (assert (BoatModel (boat ?boat) (model "Green_Trimaran"))))
		(case 5 then (assert (BoatModel (boat ?boat) (model "Red_Trimaran"))))
		(case 6 then (assert (BoatModel (boat ?boat) (model "Magenta_Trimaran"))))
		(case 7 then (assert (BoatModel (boat ?boat) (model "Yellow_Trimaran"))))
		(case 8 then (assert (BoatModel (boat ?boat) (model "White_Trimaran"))))))

(defrule Save-BoatModels
	(declare (salience +1))
    (Visualisation phase)
	=>
	;;(println "Save Boat Models")
	(save-facts (str-cat "../NMEA_CACHE/" ?*race* "/boat_models.fct") local BoatModel GEN-MODEL)
	(do-for-all-facts ((?bm BoatModel)) TRUE
		(retract ?bm))
	(do-for-all-facts ((?gm GEN-MODEL)) TRUE
		(retract ?gm)))

(defrule Write-chart-file
    (Visualisation phase)
    =>
    ;;(println "Write-chart-file")
    (write-file "../resources/public/chart/fleet.geojson" (create-fleet-geojson)))

(defrule Write-view3d-file
    (Visualisation phase)
    =>
    ;;(println "Write-view3d-file")
    (write-file "../resources/public/view3d/czml.json" (create-fleet-czml)))
    
(defrule Continue-main-loop
    (declare (salience -1))
    ?p <- (Visualisation phase)
    =>
    ;;(println "Continue-main-loop")
	(write-file "../resources/public/view3d/view_control.json"
		(view-control-info))
    (retract ?p))
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    


	

