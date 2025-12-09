(deftemplate location
   (slot name)
   (slot north)
   (slot east)
   (slot south)
   (slot west)
)

(defrule create-map
   (created player)
   =>
   (assert (location (name village) (north forest) (east lake) (south cave) (west tower)))
   (assert (location (name forest) (north mountain) (east null) (south village) (west null)))
   (assert (location (name mountain) (north null) (east null) (south forest) (west null)))
   (assert (location (name lake) (north null) (east null) (south null) (west village)))
   (assert (location (name cave) (north village) (east null) (south hills) (west null)))
   (assert (location (name hills) (north cave) (east null) (south null) (west null)))
   (assert (location (name tower) (north null) (east village) (south null) (west null)))
   (assert (created map))
)

(deffunction printmap ()
   (printout t crlf
      "                     +-------------+" crlf
      "                     |   Mountain  |" crlf
      "                     |      ^      |" crlf
      "                     +-------------+" crlf
      "                            |" crlf
      "                     +-------------+" crlf
      "                     |   Forest    |" crlf
      "                     |  * * * * *  |" crlf
      "                     +-------------+" crlf
      "                            |" crlf
      "   +-------------+   +-------------+   +-------------+" crlf
      "   |    Tower    |---|   Village   |---|    Lake     |" crlf
      "   |      ||     |   |   [] [] []  |   |    -----    |" crlf
      "   +-------------+   +-------------+   +-------------+" crlf
      "                            |" crlf
      "                     +-------------+" crlf
      "                     |    Cave     |" crlf
      "                     |    [()]     |" crlf
      "                     +-------------+" crlf
      "                            |" crlf
      "                     +-------------+" crlf
      "                     |    Hills    |" crlf
      "                     |    ~ ~ ~    |" crlf
      "                     +-------------+" crlf
   )
)

(defrule prompt-move-show-map
   ?id <- (canmove true true)
   =>
   (retract ?id)
   (printmap)
   (printout t crlf "Where would you like to go? (1: North, 2: East, 3: South, 4: West, 5: Stay)" crlf)
   (bind ?choice (read))
   
   (while (not (or (eq ?choice 1) (eq ?choice 2) (eq ?choice 3) (eq ?choice 4) (eq ?choice 5)))
      (printout t crlf "Invalid choice! Where would you like to go? (1: North, 2: East, 3: South, 4: West, 5: Stay)" crlf)
      (bind ?choice (read))
   )
   
   (if (eq ?choice 1) then 
      (assert (move north))
   )
   
   (if (eq ?choice 2) then 
      (assert (move east))
   )
   
   (if (eq ?choice 3) then 
      (assert (move south))
   )
   
   (if (eq ?choice 4) then 
      (assert (move west))
   )

   (if (eq ?choice 5) then 
      (assert (move stay))
   )
)

(defrule prompt-move-no-map
   ?id <- (canmove true false)
   =>
   (retract ?id)
   (printout t crlf "Where would you like to go? (1: North, 2: East, 3: South, 4: West, 5: Stay)" crlf)
   (bind ?choice (read))
   
   (while (not (or (eq ?choice 1) (eq ?choice 2) (eq ?choice 3) (eq ?choice 4) (eq ?choice 5)))
      (printout t crlf "Invalid choice! Where would you like to go? (1: North, 2: East, 3: South, 4: West, 5: Stay)" crlf)
      (bind ?choice (read))
   )
   
   (if (eq ?choice 1) then 
      (assert (move north))
   )
   
   (if (eq ?choice 2) then 
      (assert (move east))
   )
   
   (if (eq ?choice 3) then 
      (assert (move south))
   )
   
   (if (eq ?choice 4) then 
      (assert (move west))
   )

   (if (eq ?choice 5) then 
      (assert (move stay))
   )
)

(defrule move-north
   ?id <- (gamestate (crtlocation ?current-location) (turn ?turn))
   (location (name ?loc) (north ?new-location))
   (test (eq ?current-location ?loc))
   (test (not (eq ?new-location null)))
   ?id2 <- (move north)
   =>
   (retract ?id2)
   (printout t crlf "You move north to " ?new-location "!" crlf)
   (modify ?id (crtlocation ?new-location) (turn (+ 1 ?turn)))
)

(defrule move-south
   ?id <- (gamestate (crtlocation ?current-location) (turn ?turn))
   (location (name ?loc) (south ?new-location))
   (test (eq ?current-location ?loc))
   (test (not (eq ?new-location null)))
   ?id2 <- (move south)
   =>
   (retract ?id2)
   (printout t crlf "You move south to " ?new-location "!" crlf)
   (modify ?id (crtlocation ?new-location) (turn (+ 1 ?turn)))
)

(defrule move-east
   ?id <- (gamestate (crtlocation ?current-location) (turn ?turn))
   (location (name ?loc) (east ?new-location))
   (test (eq ?current-location ?loc))
   (test (not (eq ?new-location null)))
   ?id2 <- (move east)
   =>
   (retract ?id2)
   (printout t crlf "You move east to " ?new-location "!" crlf)
   (modify ?id (crtlocation ?new-location) (turn (+ 1 ?turn)))
)

(defrule move-west
   ?id <- (gamestate (crtlocation ?current-location) (turn ?turn))
   (location (name ?loc) (west ?new-location))
   (test (eq ?current-location ?loc))
   (test (not (eq ?new-location null)))
   ?id2 <- (move west)
   =>
   (retract ?id2)
   (printout t crlf "You move west to " ?new-location "!" crlf)
   (modify ?id (crtlocation ?new-location) (turn (+ 1 ?turn)))
)

(defrule move-stay
   ?id <- (gamestate (crtlocation ?current-location) (turn ?turn))
   ?id2 <- (move stay)
   =>
   (retract ?id2)
   (printout t crlf "You stay in the " ?current-location "!" crlf)
   (modify ?id (turn (+ 1 ?turn)))
)

(defrule invalid-move-north
   ?id <- (move north)
   (gamestate (crtlocation ?current-location))
   (location (name ?loc) (north null))
   (test (eq ?current-location ?loc))
   =>
   (printout t crlf "You can't go north from here!" crlf)
   (retract ?id)
   (assert (canmove true false))
)

(defrule invalid-move-south
   ?id <- (move south)
   (gamestate (crtlocation ?current-location))
   (location (name ?loc) (south null))
   (test (eq ?current-location ?loc))
   =>
   (printout t crlf "You can't go south from here!" crlf)
   (retract ?id)
   (assert (canmove true false))
)

(defrule invalid-move-east
   ?id <- (move east)
   (gamestate (crtlocation ?current-location))
   (location (name ?loc) (east null))
   (test (eq ?current-location ?loc))
   =>
   (printout t crlf "You can't go east from here!" crlf)
   (retract ?id)
   (assert (canmove true false))
)

(defrule invalid-move-west
   ?id <- (move west)
   (gamestate (crtlocation ?current-location))
   (location (name ?loc) (west null))
   (test (eq ?current-location ?loc))
   =>
   (printout t crlf "You can't go west from here!" crlf)
   (retract ?id)
   (assert (canmove true false))
)