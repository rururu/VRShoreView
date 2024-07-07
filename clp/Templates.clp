;; Deftemplates

(deftemplate Boat
	(slot timestamp (type STRING)(default ""))
    (slot name (type STRING))
    (multislot motion (type FLOAT)) 
    (slot mmsi (type INTEGER))
	(slot type (type STRING))
	(slot model (type FACT-ADDRESS))
    (slot onboard (type SYMBOL)(default FALSE)))
    
(deftemplate BoatInfo
    (slot name (type STRING))
    (multislot motion (type FLOAT)) 
    (slot mmsi (type INTEGER)))

(deftemplate MyBoatInfo
    (slot timestamp (type STRING) (default "")) 
    (slot name (type STRING))
    (multislot motion (type FLOAT)) 
    (slot date (type STRING)))

(deftemplate Model
    (slot boat (type STRING)(default ""))
	(slot type (type STRING)(default ""))
	(slot gltf (type STRING))
	(slot scale (type FLOAT))
	(slot draft (type INTEGER))
	(slot extra (type STRING)(default "")))
	
(deftemplate BoatModel
	(slot boat (type STRING))
	(slot model (type STRING)))


