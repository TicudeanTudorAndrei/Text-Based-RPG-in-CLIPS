(defrule explore
   ?id <- (gamestate (turn ?turn) (crtlocation ?loc))
   ?id2 <- (explore true)
   =>
   (retract ?id2)
   (printout t crlf "You explore the " ?loc "..." crlf)
   
   (bind ?chance (random 1 100))
   
   (if (< ?chance 30) then
      (assert (encounterspawn true))
   )
   
   (if (and (>= ?chance 30) (< ?chance 50)) then
      (assert (itemspawn true))
      (printout t "You found an item!" crlf)
   )
   
   (if (>= ?chance 50) then
      (printout t "You find nothing of interest." crlf)
      (modify ?id (turn (+ ?turn 1)))
   )
)

(defrule item-spawn
   ?id2 <- (itemspawn true)
   ?id3 <- (player (level ?lvl))
   =>
   (retract ?id2)

   (bind ?slots-list (create$ weapon side trinket helmet chestplate leggings boots))

   (bind ?weapon-list-warrior (create$ longsword shortsword greatsword))
   (bind ?side-list-warrior (create$ buckler shield))
   (bind ?trinket-list-warrior (create$ ring necklace bracelet amulet pendant earring charm trinket))
   (bind ?helmet-list-warrior (create$ helm helmet))
   (bind ?chestplate-list-warrior (create$ breastplate mail))
   (bind ?leggings-list-warrior (create$ greaves pants))
   (bind ?boots-list-warrior (create$ boots sandals))

   (bind ?weapon-list-sorcerer (create$ staff wand rod))
   (bind ?side-list-sorcerer (create$ orb tome spellbook grimoire))
   (bind ?trinket-list-sorcerer (create$ ring necklace bracelet amulet pendant earring charm trinket))
   (bind ?helmet-list-sorcerer (create$ hood cap))
   (bind ?chestplate-list-sorcerer (create$ robe tunic))
   (bind ?leggings-list-sorcerer (create$ pants leggings))
   (bind ?boots-list-sorcerer (create$ boots sandals))

   (bind ?weapon-list-rogue (create$ dagger shortsword rapier))
   (bind ?side-list-rogue (create$ throwing-knife shuriken))
   (bind ?trinket-list-rogue (create$ ring necklace bracelet amulet pendant earring charm trinket))
   (bind ?helmet-list-rogue (create$ hood cap))
   (bind ?chestplate-list-rogue (create$ tunic robe))
   (bind ?leggings-list-rogue (create$ pants leggings))
   (bind ?boots-list-rogue (create$ boots sandals))

   (bind ?adj (create$ good great mighty shiny dark light enchanted cursed broken heavy light ornate plain simple exquisite mysterious ancient new old worn dirty clean simple complex elegant graceful))
   (bind ?atr (create$ power doom glory strength courage wisdom knowledge fear hate hope despair sorrow rage war life death light darkness fire ice earth wind water thunder lightning shadow darkness life death space chaos order nature legend history honesty betrayal loyalty))

   (bind ?itemslotindex (random 1 7))
   (bind ?itemslot (nth$ ?itemslotindex ?slots-list))
   (bind ?itemclassindex (random 1 3))

   (if (= ?itemclassindex 1) then
      (if (= ?itemslotindex 1) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 2) ?weapon-list-warrior) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 2) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 1) ?side-list-warrior) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 3) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 7) ?trinket-list-warrior) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 4) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 1) ?helmet-list-warrior) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 5) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 1) ?chestplate-list-warrior) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 6) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 1) ?leggings-list-warrior) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 7) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 1) ?boots-list-warrior) "-of-" (nth$ (random 1 38) ?atr))))
      (bind ?itemclass warrior)
   )

   (if (= ?itemclassindex 2) then
      (if (= ?itemslotindex 1) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 2) ?weapon-list-sorcerer) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 2) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 3) ?side-list-sorcerer) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 3) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 7) ?trinket-list-sorcerer) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 4) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 1) ?helmet-list-sorcerer) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 5) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 1) ?chestplate-list-sorcerer) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 6) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 1) ?leggings-list-sorcerer) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 7) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 1) ?boots-list-sorcerer) "-of-" (nth$ (random 1 38) ?atr))))
      (bind ?itemclass sorcerer)
   )

   (if (= ?itemclassindex 3) then
      (if (= ?itemslotindex 1) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 2) ?weapon-list-rogue) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 2) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 1) ?side-list-rogue) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 3) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 7) ?trinket-list-rogue) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 4) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 1) ?helmet-list-rogue) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 5) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 1) ?chestplate-list-rogue) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 6) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 1) ?leggings-list-rogue) "-of-" (nth$ (random 1 38) ?atr))))
      (if (= ?itemslotindex 7) then (bind ?itemname (sym-cat (nth$ (random 1 26) ?adj) "-" (nth$ (random 1 1) ?boots-list-rogue) "-of-" (nth$ (random 1 38) ?atr))))
      (bind ?itemclass rogue)
   )

   (bind ?chance (random 1 100))
   (if (<= ?chance 40) then
      (bind ?itemlvl ?lvl)
   )
   (if (and (> ?chance 40) (<= ?chance 50)) then
      (bind ?itemlvl (+ ?lvl 1))
   )
   (if (and (> ?chance 50) (<= ?chance 60)) then
      (bind ?itemlvl (+ ?lvl 2))
   )
   (if (and (> ?chance 60) (<= ?chance 70)) then
      (bind ?itemlvl (+ ?lvl 3))
   )
   (if (and (> ?chance 70) (<= ?chance 80)) then
      (bind ?itemlvl (+ ?lvl 4))
   )
   (if (and (> ?chance 80) (<= ?chance 90)) then
      (bind ?itemlvl (+ ?lvl 5))
   )
   (if (> ?chance 90) then
      (bind ?itemlvl (+ ?lvl 6))
   )

   (assert (newitemcheck ?itemname ?itemclass ?itemslot ?itemlvl))
)

(defrule check-item-already-exists
   ?id <- (newitemcheck ?itemname ?itemclass ?itemslot ?itemlvl)
   (item (name ?nameitem))
   (test (eq ?nameitem ?itemname))
   =>
   (retract ?id)
   (assert (itemspawn true))
)

(defrule check-item-not-exists
   (declare (salience -10))
   ?id <- (newitemcheck ?itemname ?itemclass ?itemslot ?itemlvl)
   =>
   (retract ?id)
   (assert (newitem ?itemname ?itemclass ?itemslot ?itemlvl))
)

(defrule encounter-spawn
   (gamestate (playeralive true) (crtlocation ?loc))
   ?id <- (encounterspawn true)
   =>
   (retract ?id)
   (bind ?encounter (random 1 3))
   
   (if (eq ?loc forest) then
      (if (eq ?encounter 1) then (assert (spawn wolf)))
      (if (eq ?encounter 2) then (assert (spawn boar)))
      (if (eq ?encounter 3) then (assert (spawn raven)))
   )
   
   (if (eq ?loc mountain) then
      (if (eq ?encounter 1) then (assert (spawn stone-golem)))
      (if (eq ?encounter 2) then (assert (spawn mountain-lion)))
      (if (eq ?encounter 3) then (assert (spawn harpy)))
   )
   
   (if (eq ?loc tower) then
      (if (eq ?encounter 1) then (assert (spawn haunted-armor)))
      (if (eq ?encounter 2) then (assert (spawn dark-mage)))
      (if (eq ?encounter 3) then (assert (spawn ghost-knight)))
   )
   
   (if (eq ?loc lake) then
      (if (eq ?encounter 1) then (assert (spawn water-serpent)))
      (if (eq ?encounter 2) then (assert (spawn fishermans-spirit)))
      (if (eq ?encounter 3) then (assert (spawn kelp-monster)))
   )
   
   (if (eq ?loc cave) then
      (if (eq ?encounter 1) then (assert (spawn cave-troll)))
      (if (eq ?encounter 2) then (assert (spawn goblin)))
      (if (eq ?encounter 3) then (assert (spawn shade)))
   )
   
   (if (eq ?loc hills) then
      (if (eq ?encounter 1) then (assert (spawn hermit)))
      (if (eq ?encounter 2) then (assert (spawn wild-dog)))
      (if (eq ?encounter 3) then (assert (spawn troll)))
   )
   
   (if (eq ?loc village) then
      (if (eq ?encounter 1) then (assert (spawn bandit)))
      (if (eq ?encounter 2) then (assert (spawn cultist)))
      (if (eq ?encounter 3) then (assert (spawn peddler)))
   )
)