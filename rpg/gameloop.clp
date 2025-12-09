(deftemplate gamestate
   (slot crtlocation)
   (slot playeralive)
   (slot turn)
)

(defrule start-game
   ?id1 <- (created player)
   ?id2 <- (created map)
   ?id3 <- (created items)
   =>
   (retract ?id1)
   (retract ?id2)
   (retract ?id3)
   (assert (gamestate (crtlocation village) (playeralive true) (turn 1)))
)

(defrule game-loop
   ?gamestate <- (gamestate (crtlocation ?loc) (playeralive true) (turn ?turn))
   =>
   (printout t crlf "----------------------------------------" crlf)
   (printout t "What do you want to do? (Turn " ?turn ")" crlf)
   (printout t "1: Player statistics" crlf)
   (printout t "2: Manage inventory" crlf)
   (printout t "3: Explore the " ?loc crlf)
   (printout t "4: Move to another region" crlf)
   (printout t "5: Quit" crlf)
   (printout t "----------------------------------------" crlf)
   (bind ?action (read))
   
   (while (not (or (eq ?action 1) (eq ?action 2) (eq ?action 3) (eq ?action 4) (eq ?action 5)))
      (printout t crlf "----------------------------------------" crlf)
      (printout t "Invalid choice! What do you want to do? (Turn " ?turn ")" crlf)
      (printout t "1: Player statistics" crlf)
      (printout t "2: Manage inventory" crlf)
      (printout t "3: Explore the " ?loc crlf)
      (printout t "4: Move to another region" crlf)
      (printout t "5: Quit" crlf)
      (printout t "----------------------------------------" crlf)
      (bind ?action (read))
   )

   (if (eq ?action 1) then
      (assert (showstats true))
   )

   (if (eq ?action 2) then
      (assert (inventory true))
   )

   (if (eq ?action 3) then
      (assert (explore true))
   )

    (if (eq ?action 4) then
      (assert (canmove true true))
   )

   (if (eq ?action 5) then
      (printout t crlf "Goodbye!" crlf)
      (halt)
   )
)

(defrule player-defeated
   ?gamestate <- (gamestate (playeralive false))
   =>
   (printout t crlf "You have been defeated!" crlf)
   (halt)
)