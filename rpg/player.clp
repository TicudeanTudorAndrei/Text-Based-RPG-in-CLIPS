(defglobal ?*pta* = 0)

(defglobal ?*stg* = 0)
(defglobal ?*int* = 0)
(defglobal ?*agi* = 0)

(deftemplate player
   (slot name)
   (slot cls)
   (slot health)
   (slot level)
   (slot experience)
   (slot strength)
   (slot agility)
   (slot intelligence)
   (slot coins)
)

(defrule show-stats
   ?id <- (showstats true)
   (player (name ?name) (cls ?cls) (health ?hp) (experience ?expr) (level ?lvl) (strength ?stg) (agility ?agi) (intelligence ?int) (coins ?cns))
   ?id2 <- (gamestate (playeralive true) (turn ?turn))
   (maxhealth ?maxhp)
   =>
   (retract ?id)
   (printout t crlf "-----------------------" crlf)
   (printout t "Player Stats:" crlf)
   (printout t "Name: " ?name crlf)
   (printout t "Class: " ?cls crlf)
   (printout t "Health: " ?hp crlf)
   (printout t "Level: " ?lvl crlf)
   (printout t "Experience: " ?expr crlf)
   (printout t "Strength: " ?stg crlf)
   (printout t "Agility: " ?agi crlf)
   (printout t "Intelligence: " ?int crlf)
   (printout t "Coins: " ?cns crlf)
   (printout t "Max Health: " ?maxhp crlf)
   (printout t "-----------------------" crlf)
   (modify ?id2 (turn (+ ?turn 1)))
)

(defrule initialize-player
   =>
   (printout t crlf crlf "You find yourself in a village!" crlf)
   (printout t "Welcome! Please create a name: " crlf)
   
   (bind ?name (read))

   (printout t crlf "Choose your class! (1: Warrior, 2: Sorcerer, 3: Rogue)" crlf)
   (bind ?class-choice (read))

   (while (not (or (eq ?class-choice 1) (eq ?class-choice 2) (eq ?class-choice 3)))
      (printout t crlf "Invalid! Choose your class! (1: Warrior, 2: Sorcerer, 3: Rogue)" crlf)
      (bind ?class-choice (read))
   )

   (if (eq ?class-choice 1) then
      (assert (chosenclass warrior))
      (assert (player (name ?name) (health 150) (strength 12) (agility 6) (intelligence 2) (cls warrior) (level 1) (experience 68) (coins 500)))
      (assert (maxhealth 150))
   )
   
   (if (eq ?class-choice 2) then
      (assert (chosenclass sorcerer))
      (assert (player (name ?name) (health 50) (strength 1) (agility 5) (intelligence 14) (cls sorcerer) (level 1) (experience 0) (coins 0)))
      (assert (maxhealth 50))
   )
   
   (if (eq ?class-choice 3) then
      (assert (chosenclass rogue))
      (assert (player (name ?name) (health 100) (strength 5) (agility 10) (intelligence 5) (cls rogue) (level 1) (experience 0) (coins 0)))
      (assert (maxhealth 100))
   )

   (assert (created player))
)

(defrule level-up
   (declare (salience 10))
   ?id_player <- (player (experience ?expr) (health ?hp) (level ?lvl) (strength ?stg) (agility ?agi) (intelligence ?int))
   ?id <- (checklevelup true)
   ?idgame <- (gamestate (turn ?turn))
   ?id2 <- (maxhealth ?maxhp)
   =>
   (retract ?id)
   (retract ?id2)

   (if (>= ?expr (+ 50 (* ?lvl ?lvl 20))) then
      
      (bind ?lvl_thr (+ 50 (* ?lvl ?lvl 20)))
      (bind ?new_level (+ ?lvl 1))
      (bind ?new_exp (- ?expr ?lvl_thr))

      (bind ?health_scaling 10)
      (bind ?new_health (+ ?maxhp (* ?new_level ?health_scaling)))

      (bind ?extrahp (- ?new_health ?maxhp))

      (printout t crlf "Congratulations! You are now level " ?new_level ". You have 3 skill points to allocate!" crlf)

      (bind ?*pta* 3)

      (while (> ?*pta* 0)
         (printout t "Choose a stat to increase! (1: Strength, 2: Agility, 3: Intelligence)" crlf)
         (bind ?stat-choice (read))

         (while (not (or (eq ?stat-choice 1) (eq ?stat-choice 2) (eq ?stat-choice 3)))
            (printout t crlf "Invalid! Choose a stat to increase! (1: Strength, 2: Agility, 3: Intelligence)" crlf)
            (bind ?stat-choice (read))
         )
      
         (if (eq ?stat-choice 1) then
            (bind ?*stg* (+ ?*stg* 1))
            (printout t crlf "Strength Increased!" crlf)
         )
      
         (if (eq ?stat-choice 2) then
            (bind ?*agi* (+ ?*agi* 1))
            (printout t crlf "Agility Increased!" crlf)
         )
      
         (if (eq ?stat-choice 3) then
            (bind ?*int* (+ ?*int* 1))
            (printout t crlf "Intelligence Increased!" crlf)
         )
      
         (bind ?*pta* (- ?*pta* 1))
         (printout t crlf "Points remaining: " ?*pta* crlf)
      )

      (bind ?new_stg (+ ?stg ?*stg*))
      (bind ?new_agi (+ ?agi ?*agi*))
      (bind ?new_int (+ ?int ?*int*))

      (modify ?id_player (health (+ ?hp ?extrahp)) (level ?new_level) (experience ?new_exp) (strength ?new_stg) (agility ?new_agi) (intelligence ?new_int))
      (assert (maxhealth ?new_health))
      (modify ?idgame (turn (+ ?turn 1)))
   )

   (if (< ?expr (+ 50 (* ?lvl ?lvl 20))) then
      (assert (maxhealth ?maxhp))
      (modify ?idgame (turn (+ ?turn 1)))
   )
)

