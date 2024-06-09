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
    ;;(println "Main-loop")
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
	(println "Visualisation phase 1")
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
	(println "Visualisation phase 2")
	(retract ?p)
	(assert (Visualisation phase)))
    	
;;;;;;;;;;;;;;;;;;;;;;;; VISUALISATION PHASE ;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule Set-boat-model
	(declare (salience +4))
    (Visualisation phase)
	(BoatModel (boat ?boat) (model $?m1))
	?b <- (Boat (name ?boat) (model $?m2&:(neq $?m1 $?m2)))
	=>
	(modify ?b (model $?m1)))

(defrule Assert-specific-BoatModel
	(declare (salience +3))
    (Visualisation phase)
    (Model (type ?type)(boat ?boat)(gltf ?g)(scale ?s)(draft ?d)(extra ?e))
    ?b <- (Boat (name ?boat))
    (not (BoatModel (boat ?boat)))
    =>
    (assert (BoatModel (boat ?boat) (model (create$ ?type ?g ?s ?d ?e)))))	

(defrule Assert-general-BoatModel
	(declare (salience +2))
    (Visualisation phase)
    (GEN-MODEL ?gen-type)
    (Model (type ?gen-type)(gltf ?g)(scale ?s)(draft ?d)(extra ?e))
    ?b <- (Boat (name ?boat))
    (not (BoatModel (boat ?boat)))
    =>
    (assert (BoatModel (boat ?boat) (model (create$ ?gen-type ?g ?s ?d ?e)))))	

(defrule Assert-Medieval-Mix-BoatModel
	(declare (salience +2))
    (Visualisation phase)
    (GEN-MODEL "Medieval_Mix")
    (Model (type "Santa_Maria")(gltf ?gm)(scale ?sm)(draft ?dm)(extra ?em))
    (Model (type "Santa_Isadora")(gltf ?gi)(scale ?si)(draft ?di)(extra ?ei))
    ?b <- (Boat (name ?boat))
    (not (BoatModel (boat ?boat)))
    =>
    (if (> (random 0 1) 0)
		then (assert (BoatModel (boat ?boat) (model (create$ "Santa_Maria" ?gm ?sm ?dm ?em))))
		else (assert (BoatModel (boat ?boat) (model (create$ "Santa_Isadora" ?gi ?si ?di ?ei))))))

(defrule Assert-Trimaran-Mix-BoatModel
	(declare (salience +2))
    (Visualisation phase)
    (GEN-MODEL "Trimaran_Mix")
    (Model (type "Black_Trimaran")(gltf ?gb)(scale ?sb)(draft ?db)(extra ?eb))
    (Model (type "Blue_Trimaran")(gltf ?gu)(scale ?su)(draft ?du)(extra ?eu))
    (Model (type "Cyan_Trimaran")(gltf ?gc)(scale ?sc)(draft ?dc)(extra ?ec))
    (Model (type "Green_Trimaran")(gltf ?gg)(scale ?sg)(draft ?dg)(extra ?eg))
    (Model (type "Red_Trimaran")(gltf ?gr)(scale ?sr)(draft ?dr)(extra ?er))
    (Model (type "Magenta_Trimaran")(gltf ?gm)(scale ?sm)(draft ?dm)(extra ?em))
    (Model (type "Yellow_Trimaran")(gltf ?gy)(scale ?sy)(draft ?dy)(extra ?ey))
    (Model (type "White_Trimaran")(gltf ?gw)(scale ?sw)(draft ?dw)(extra ?ew))
    ?b <- (Boat (name ?boat))
    (not (BoatModel (boat ?boat)))
    =>
    (switch (random 1 8)
		(case 1 then (assert (BoatModel (boat ?boat) (model (create$ "Black_Trimaran" ?gb ?sb ?db ?eb)))))
		(case 2 then (assert (BoatModel (boat ?boat) (model (create$ "Blue_Trimaran" ?gu ?su ?du ?eu)))))
		(case 3 then (assert (BoatModel (boat ?boat) (model (create$ "Cyan_Trimaran" ?gc ?sc ?dc ?ec)))))
		(case 4 then (assert (BoatModel (boat ?boat) (model (create$ "Green_Trimaran" ?gg ?sg ?dg ?eg)))))
		(case 5 then (assert (BoatModel (boat ?boat) (model (create$ "Red_Trimaran" ?gr ?sr ?dr ?er)))))
		(case 6 then (assert (BoatModel (boat ?boat) (model (create$ "Magenta_Trimaran" ?gm ?sm ?dm ?em)))))
		(case 7 then (assert (BoatModel (boat ?boat) (model (create$ "Yellow_Trimaran" ?gy ?sy ?dy ?ey)))))
		(default (assert (BoatModel (boat ?boat) (model (create$ "White_Trimaran" ?gw ?sw ?dw ?ew)))))))

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
    


	

