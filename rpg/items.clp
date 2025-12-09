(defglobal ?*invmatchcnt* = 0)
(defglobal ?*eqpmatchcnt* = 0)

(deftemplate item
    (slot name)
    (slot physicaldmg)
    (slot magicaldmg)
    (slot criticaldmg)
    (slot armor)
    (slot magicresist)
    (slot critresist)
    (slot price)
    (slot lvl)
    (slot location) ;invn/eqip/grnd
    (slot reqclass) ;warrior/sorcerer/rogue
    (slot slt) ;weapon/helmet/chestplate/leggings/boots/side/trinket
)

(defrule init-equipment
    ?id <- (chosenclass ?cls)
    =>
    (retract ?id)

    (if (eq ?cls warrior) then
        (assert (item (name rusty-sword) (physicaldmg 10) (magicaldmg 0) (criticaldmg 0) (armor 0) (magicresist 0) (critresist 0) (price 10) (lvl 1) (location eqip) (reqclass warrior) (slt weapon)))

        (assert (item (name good-sword) (physicaldmg 7) (magicaldmg 0) (criticaldmg 0) (armor 0) (magicresist 0) (critresist 0) (price 11) (lvl 1) (location invn) (reqclass warrior) (slt weapon)))
        (assert (item (name higher-lvl-sword) (physicaldmg 5) (magicaldmg 0) (criticaldmg 0) (armor 0) (magicresist 0) (critresist 0) (price 12) (lvl 2) (location invn) (reqclass warrior) (slt weapon)))
        (assert (item (name wrong-cls-sword) (physicaldmg 4) (magicaldmg 0) (criticaldmg 0) (armor 0) (magicresist 0) (critresist 0) (price 13) (lvl 1) (location invn) (reqclass sorcerer) (slt weapon)))

        (assert (item (name leather-helmet) (physicaldmg 0) (magicaldmg 0) (criticaldmg 0) (armor 1) (magicresist 1) (critresist 1) (price 8) (lvl 1) (location eqip) (reqclass warrior) (slt helmet)))
        (assert (item (name leather-chestplate) (physicaldmg 0) (magicaldmg 0) (criticaldmg 0) (armor 3) (magicresist 1) (critresist 2) (price 15) (lvl 1) (location eqip) (reqclass warrior) (slt chestplate)))
        (assert (item (name leather-leggings) (physicaldmg 0) (magicaldmg 0) (criticaldmg 0) (armor 2) (magicresist 1) (critresist 1) (price 12) (lvl 1) (location eqip) (reqclass warrior) (slt leggings)))
        (assert (item (name leather-boots) (physicaldmg 0) (magicaldmg 0) (criticaldmg 0) (armor 1) (magicresist 1) (critresist 1) (price 8) (lvl 1) (location eqip) (reqclass warrior) (slt boots)))
        (assert (item (name wooden-shield) (physicaldmg 0) (magicaldmg 0) (criticaldmg 0) (armor 3) (magicresist 1) (critresist 2) (price 10) (lvl 1) (location eqip) (reqclass warrior) (slt side)))
        (assert (item (name weak-amulet) (physicaldmg 1) (magicaldmg 1) (criticaldmg 1) (armor 1) (magicresist 1) (critresist 1) (price 12) (lvl 1) (location eqip) (reqclass warrior) (slt trinket)))
        (assert (invsize 3))
        (assert (eqpsize 7))
    )
    
    (if (eq ?cls sorcerer) then
        (assert (item (name wooden-staff) (physicaldmg 2) (magicaldmg 8) (criticaldmg 1) (armor 0) (magicresist 0) (critresist 0) (price 10) (lvl 1) (location eqip) (reqclass sorcerer) (slt weapon)))
        (assert (item (name cloth-hood) (physicaldmg 0) (magicaldmg 0) (criticaldmg 0) (armor 0) (magicresist 2) (critresist 1) (price 8) (lvl 1) (location eqip) (reqclass sorcerer) (slt helmet)))
        (assert (item (name cloth-robe) (physicaldmg 0) (magicaldmg 0) (criticaldmg 0) (armor 1) (magicresist 3) (critresist 2) (price 15) (lvl 1) (location eqip) (reqclass sorcerer) (slt chestplate)))
        (assert (item (name cloth-leggings) (physicaldmg 0) (magicaldmg 0) (criticaldmg 0) (armor 0) (magicresist 2) (critresist 1) (price 12) (lvl 1) (location eqip) (reqclass sorcerer) (slt leggings)))
        (assert (item (name cloth-boots) (physicaldmg 0) (magicaldmg 0) (criticaldmg 0) (armor 0) (magicresist 1) (critresist 1) (price 8) (lvl 1) (location eqip) (reqclass sorcerer) (slt boots)))
        (assert (item (name spellbook) (physicaldmg 0) (magicaldmg 5) (criticaldmg 0) (armor 0) (magicresist 1) (critresist 1) (price 10) (lvl 1) (location eqip) (reqclass sorcerer) (slt side)))
        (assert (item (name magic-ring) (physicaldmg 0) (magicaldmg 2) (criticaldmg 0) (armor 0) (magicresist 2) (critresist 1) (price 12) (lvl 1) (location eqip) (reqclass sorcerer) (slt trinket)))
        (assert (invsize 0))
        (assert (eqpsize 7))
    )

    (if (eq ?cls rogue) then
        (assert (item (name dagger) (physicaldmg 8) (magicaldmg 0) (criticaldmg 2) (armor 0) (magicresist 0) (critresist 0) (price 10) (lvl 1) (location eqip) (reqclass rogue) (slt weapon)))
        (assert (item (name leather-hood) (physicaldmg 0) (magicaldmg 0) (criticaldmg 0) (armor 1) (magicresist 1) (critresist 1) (price 8) (lvl 1) (location eqip) (reqclass rogue) (slt helmet)))
        (assert (item (name leather-vest) (physicaldmg 0) (magicaldmg 0) (criticaldmg 0) (armor 2) (magicresist 1) (critresist 2) (price 15) (lvl 1) (location eqip) (reqclass rogue) (slt chestplate)))
        (assert (item (name leather-pants) (physicaldmg 0) (magicaldmg 0) (criticaldmg 0) (armor 1) (magicresist 1) (critresist 1) (price 12) (lvl 1) (location eqip) (reqclass rogue) (slt leggings)))
        (assert (item (name leather-boots) (physicaldmg 0) (magicaldmg 0) (criticaldmg 0) (armor 1) (magicresist 1) (critresist 1) (price 8) (lvl 1) (location eqip) (reqclass rogue) (slt boots)))
        (assert (item (name throwing-knife) (physicaldmg 3) (magicaldmg 0) (criticaldmg 1) (armor 0) (magicresist 0) (critresist 0) (price 10) (lvl 1) (location eqip) (reqclass rogue) (slt side)))
        (assert (item (name stealth-cloak) (physicaldmg 0) (magicaldmg 0) (criticaldmg 0) (armor 0) (magicresist 1) (critresist 2) (price 12) (lvl 1) (location eqip) (reqclass rogue) (slt trinket)))
        (assert (invsize 0))
        (assert (eqpsize 7))
    )

    (assert (created items))
)

(defrule new-item-create 
    ?id <- (newitem ?itemname ?itemclass ?itemslot ?itemlvl) 
    (player (level ?playerLevel))
    =>
    (retract ?id)

    (bind ?scalingFactor (+ 1 (* 0.5 ?playerLevel)))

    ;; Warrior
    (if (and (eq ?itemclass warrior) (eq ?itemslot weapon)) then
        (bind ?scaledPhysicalDmg (* ?scalingFactor 2 ?itemlvl))
        (bind ?scaledMagicalDmg 0)
        (bind ?scaledCriticalDmg (* ?scalingFactor 1.5 ?itemlvl))
        (bind ?scaledArmor 0)
        (bind ?scaledMagicResist 0)
        (bind ?scaledCritResist (* ?scalingFactor 0.2 ?itemlvl)))

    (if (and (eq ?itemclass warrior) (eq ?itemslot side)) then
        (bind ?scaledPhysicalDmg (* ?scalingFactor 0.5 ?itemlvl))
        (bind ?scaledMagicalDmg 0)
        (bind ?scaledCriticalDmg 0)
        (bind ?scaledArmor (* ?scalingFactor 1.5 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 0.2 ?itemlvl))
        (bind ?scaledCritResist (* ?scalingFactor 0.1 ?itemlvl)))

    (if (and (eq ?itemclass warrior) (eq ?itemslot trinket)) then
        (bind ?scaledPhysicalDmg (* ?scalingFactor 0.5 ?itemlvl))
        (bind ?scaledMagicalDmg 0)
        (bind ?scaledCriticalDmg (* ?scalingFactor 0.8 ?itemlvl))
        (bind ?scaledArmor 0)
        (bind ?scaledMagicResist 0)
        (bind ?scaledCritResist (* ?scalingFactor 0.3 ?itemlvl)))

    (if (and (eq ?itemclass warrior) (eq ?itemslot helmet)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg 0)
        (bind ?scaledCriticalDmg 0)
        (bind ?scaledArmor (* ?scalingFactor 1.2 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 0.3 ?itemlvl))
        (bind ?scaledCritResist 0))

    (if (and (eq ?itemclass warrior) (eq ?itemslot chestplate)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg 0)
        (bind ?scaledCriticalDmg 0)
        (bind ?scaledArmor (* ?scalingFactor 1.5 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 0.5 ?itemlvl))
        (bind ?scaledCritResist 0))

    (if (and (eq ?itemclass warrior) (eq ?itemslot leggings)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg 0)
        (bind ?scaledCriticalDmg 0)
        (bind ?scaledArmor (* ?scalingFactor 1.3 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 0.4 ?itemlvl))
        (bind ?scaledCritResist 0))

    (if (and (eq ?itemclass warrior) (eq ?itemslot boots)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg 0)
        (bind ?scaledCriticalDmg 0)
        (bind ?scaledArmor (* ?scalingFactor 1.1 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 0.3 ?itemlvl))
        (bind ?scaledCritResist (* ?scalingFactor 0.2 ?itemlvl)))

    ;; Sorcerer
    (if (and (eq ?itemclass sorcerer) (eq ?itemslot weapon)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg (* ?scalingFactor 2.5 ?itemlvl))
        (bind ?scaledCriticalDmg (* ?scalingFactor 1.2 ?itemlvl))
        (bind ?scaledArmor 0)
        (bind ?scaledMagicResist (* ?scalingFactor 0.5 ?itemlvl))
        (bind ?scaledCritResist 0))

    (if (and (eq ?itemclass sorcerer) (eq ?itemslot side)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg (* ?scalingFactor 1.2 ?itemlvl))
        (bind ?scaledCriticalDmg 0)
        (bind ?scaledArmor (* ?scalingFactor 0.3 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 1.2 ?itemlvl))
        (bind ?scaledCritResist (* ?scalingFactor 0.2 ?itemlvl)))

    (if (and (eq ?itemclass sorcerer) (eq ?itemslot trinket)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg (* ?scalingFactor 1.5 ?itemlvl))
        (bind ?scaledCriticalDmg (* ?scalingFactor 0.5 ?itemlvl))
        (bind ?scaledArmor 0)
        (bind ?scaledMagicResist (* ?scalingFactor 0.8 ?itemlvl))
        (bind ?scaledCritResist (* ?scalingFactor 0.1 ?itemlvl)))

    (if (and (eq ?itemclass sorcerer) (eq ?itemslot helmet)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg (* ?scalingFactor 0.8 ?itemlvl))
        (bind ?scaledCriticalDmg 0)
        (bind ?scaledArmor (* ?scalingFactor 0.2 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 1.0 ?itemlvl))
        (bind ?scaledCritResist (* ?scalingFactor 0.1 ?itemlvl)))

    (if (and (eq ?itemclass sorcerer) (eq ?itemslot chestplate)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg (* ?scalingFactor 1.2 ?itemlvl))
        (bind ?scaledCriticalDmg 0)
        (bind ?scaledArmor (* ?scalingFactor 0.5 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 1.2 ?itemlvl))
        (bind ?scaledCritResist 0))

    (if (and (eq ?itemclass sorcerer) (eq ?itemslot leggings)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg (* ?scalingFactor 1.0 ?itemlvl))
        (bind ?scaledCriticalDmg 0)
        (bind ?scaledArmor (* ?scalingFactor 0.3 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 1.1 ?itemlvl))
        (bind ?scaledCritResist 0))

    (if (and (eq ?itemclass sorcerer) (eq ?itemslot boots)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg (* ?scalingFactor 0.8 ?itemlvl))
        (bind ?scaledCriticalDmg (* ?scalingFactor 0.3 ?itemlvl))
        (bind ?scaledArmor (* ?scalingFactor 0.2 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 0.9 ?itemlvl))
        (bind ?scaledCritResist (* ?scalingFactor 0.2 ?itemlvl)))

    ;; Rogue
    (if (and (eq ?itemclass rogue) (eq ?itemslot weapon)) then
        (bind ?scaledPhysicalDmg (* ?scalingFactor 1.8 ?itemlvl))
        (bind ?scaledMagicalDmg 0)
        (bind ?scaledCriticalDmg (* ?scalingFactor 2.0 ?itemlvl))
        (bind ?scaledArmor 0)
        (bind ?scaledMagicResist 0)
        (bind ?scaledCritResist (* ?scalingFactor 0.1 ?itemlvl)))

    (if (and (eq ?itemclass rogue) (eq ?itemslot side)) then
        (bind ?scaledPhysicalDmg (* ?scalingFactor 0.6 ?itemlvl))
        (bind ?scaledMagicalDmg 0)
        (bind ?scaledCriticalDmg (* ?scalingFactor 1.5 ?itemlvl))
        (bind ?scaledArmor (* ?scalingFactor 0.3 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 0.2 ?itemlvl))
        (bind ?scaledCritResist (* ?scalingFactor 0.2 ?itemlvl)))

    (if (and (eq ?itemclass rogue) (eq ?itemslot trinket)) then
        (bind ?scaledPhysicalDmg (* ?scalingFactor 0.7 ?itemlvl))
        (bind ?scaledMagicalDmg 0)
        (bind ?scaledCriticalDmg (* ?scalingFactor 2.5 ?itemlvl))
        (bind ?scaledArmor 0)
        (bind ?scaledMagicResist 0)
        (bind ?scaledCritResist (* ?scalingFactor 0.3 ?itemlvl)))

    (if (and (eq ?itemclass rogue) (eq ?itemslot helmet)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg 0)
        (bind ?scaledCriticalDmg 0)
        (bind ?scaledArmor (* ?scalingFactor 0.7 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 0.4 ?itemlvl))
        (bind ?scaledCritResist (* ?scalingFactor 0.1 ?itemlvl)))

    (if (and (eq ?itemclass rogue) (eq ?itemslot chestplate)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg 0)
        (bind ?scaledCriticalDmg 0)
        (bind ?scaledArmor (* ?scalingFactor 1.0 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 0.5 ?itemlvl))
        (bind ?scaledCritResist (* ?scalingFactor 0.1 ?itemlvl)))

    (if (and (eq ?itemclass rogue) (eq ?itemslot leggings)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg 0)
        (bind ?scaledCriticalDmg 0)
        (bind ?scaledArmor (* ?scalingFactor 0.8 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 0.3 ?itemlvl))
        (bind ?scaledCritResist (* ?scalingFactor 0.2 ?itemlvl)))

    (if (and (eq ?itemclass rogue) (eq ?itemslot boots)) then
        (bind ?scaledPhysicalDmg 0)
        (bind ?scaledMagicalDmg 0)
        (bind ?scaledCriticalDmg (* ?scalingFactor 0.5 ?itemlvl))
        (bind ?scaledArmor (* ?scalingFactor 0.6 ?itemlvl))
        (bind ?scaledMagicResist (* ?scalingFactor 0.3 ?itemlvl))
        (bind ?scaledCritResist (* ?scalingFactor 0.3 ?itemlvl)))

    (bind ?scaledPrice (+ (* ?itemlvl 10) (* ?playerLevel 2)))

    (assert (item (name ?itemname)
                  (physicaldmg ?scaledPhysicalDmg)
                  (magicaldmg ?scaledMagicalDmg)
                  (criticaldmg ?scaledCriticalDmg)
                  (armor ?scaledArmor)
                  (magicresist ?scaledMagicResist)
                  (critresist ?scaledCritResist)
                  (price ?scaledPrice)
                  (lvl ?itemlvl)
                  (location grnd)
                  (reqclass ?itemclass)
                  (slt ?itemslot)))
)

(defrule new-item-dialogue
    ?id <- (item (location grnd))
    ?iditem <- (item (name ?name) (physicaldmg ?phys) (magicaldmg ?mag) (criticaldmg ?crit) (armor ?arm) (magicresist ?mres) (critresist ?cres) (price ?price) (lvl ?lvl) (location grnd) (reqclass ?cls) (slt ?slt))
    ?id2 <- (invsize ?size)
    ?idgame <- (gamestate (turn ?turn))
    ?idplayer <- (player (coins ?cns))
    =>
    (printout t crlf "Item: " ?name " | PDmg: " ?phys " | MDmg: " ?mag
                " | CDmg: " ?crit " | Arm: " ?arm " | MRes: " ?mres
                " | CRes: " ?cres " | Price: " ?price " | Lvl: " ?lvl 
                " | Cls: " ?cls " | Slt: " ?slt)

    (printout t crlf "Do you want to take it? (1: Take, 2: Sell, 3: Leave)" crlf)
    (bind ?action (read))
   
    (while (not (or (eq ?action 1) (eq ?action 2) (eq ?action 3)))
        (printout t crlf "Invalid! Do you want to take it? (1: Take, 2: Sell, 3: Leave)" crlf)
        (bind ?action (read))
    )

    (if (eq ?action 1) then
      (modify ?iditem (location invn))
      (retract ?id2)
      (assert (invsize (+ ?size 1)))
    )

    (if (eq ?action 2) then
      (modify ?idplayer (coins (+ ?cns ?price)))
      (retract ?iditem)
    )

    (if (eq ?action 3) then
      (retract ?iditem)
    )

   (modify ?idgame (turn (+ ?turn 1)))
)

(defrule inventory-management
    ?id <- (gamestate (playeralive true) (turn ?turn))
    ?id2 <- (inventory true)
    =>
    (retract ?id2)
    (printout t crlf "Manage your inventory:" crlf)
    (printout t "(1: View Equipment, 2: View Items)" crlf)
    (printout t "(3: Equip Item, 4: Sell Item, 5: Delete Item)" crlf)
    (printout t "(6: Exit)" crlf)
    (bind ?action (read))
   
    (while (not (or (eq ?action 1) (eq ?action 2) (eq ?action 3) (eq ?action 4) (eq ?action 5) (eq ?action 6)))
        (printout t crlf "Invalid! Manage your inventory:" crlf)
        (printout t "(1: View Equipment, 2: View Items)" crlf)
        (printout t "(3: Equip Item, 4: Sell Item, 5: Delete Item)" crlf)
        (printout t "(6: Exit)" crlf)
        (bind ?action (read))
    )

    (if (eq ?action 1) then
      (assert (vieweqp true))
      (printout t crlf "------ Equipped Items --------------------------------------------------------------------------------------------------------------------------" crlf)
   )

    (if (eq ?action 2) then
      (assert (viewinv true))
      (printout t crlf "------ Inventory Items -------------------------------------------------------------------------------------------------------------------------" crlf)
   )

   (if (eq ?action 3) then
      (assert (askitemname equip))
   )

   (if (eq ?action 4) then
      (assert (askitemname sell))
   )

   (if (eq ?action 5) then
      (assert (askitemname delete))
   )

   (if (eq ?action 6) then
      (modify ?id (turn (+ ?turn 1)))
   )
)

(defrule ask-item-name
    ?id <- (askitemname ?operation)
    =>
    (retract ?id)
    (printout t crlf "Enter the name of the item: " crlf)
    (bind ?itemname (read))
    (assert (itemnamechk ?itemname ?operation))
)

(defrule item-found
    ?id <- (itemnamechk ?itemname ?operation)
    (item (name ?itname))
    (test (eq ?itemname ?itname))
    =>
    (retract ?id)
    (assert (itemname ?itemname ?operation))
)

(defrule item-not-found
    (declare (salience -10))
    ?id <- (itemnamechk ?itemname ?operation)
    =>
    (retract ?id)
    (printout t crlf "Item " ?itemname " not found!" crlf)
    (assert (inventory true))
)

(defrule equip-item-full-slot
    ?id <- (itemname ?itemname equip)
    ?player <- (player (cls ?cls) (level ?plevel))
    ?item <- (item (name ?itemname) (location invn) (reqclass ?reqclass) (lvl ?ilvl) (slt ?slt))
    ?equippedItem <- (item (name ?eqname) (location eqip) (slt ?slt))
    =>
    (retract ?id)

    (if (not (eq ?cls ?reqclass)) then
        (printout t crlf "You cannot equip " ?itemname ". It requires a " ?reqclass "." crlf)
        (assert (inventory true))
        (return)
    )
    
    (if (< ?plevel ?ilvl) then
        (printout t crlf "You need to be at least level " ?ilvl " to equip " ?itemname "." crlf)
        (assert (inventory true))
        (return)
    )
    
    (modify ?equippedItem (location invn))
    (modify ?item (location eqip))
    (printout t crlf "Unequipped " ?eqname " from slot " ?slt "." crlf)
    (printout t "Equipped " ?itemname " in slot " ?slt "." crlf)
    
    (assert (inventory true))
)

(defrule equip-item-empty-slot
    ?id <- (itemname ?itemname equip)
    ?player <- (player (cls ?cls) (level ?plevel))
    ?item <- (item (name ?itemname) (location invn) (reqclass ?reqclass) (lvl ?ilvl) (slt ?slt))
    ?invsize <- (invsize ?isize)
    ?eqpsize <- (eqpsize ?esize)
    =>
    (retract ?id)
    (retract ?invsize) 
    (retract ?eqpsize)

    (if (not (eq ?cls ?reqclass)) then
        (printout t crlf "You cannot equip " ?itemname ". It requires a " ?reqclass "." crlf)
        (assert (inventory true))
        (return)
    )
    
    (if (< ?plevel ?ilvl) then
        (printout t crlf "You need to be at least level " ?ilvl " to equip " ?itemname "." crlf)
        (assert (inventory true))
        (return)
    )
    
    (modify ?item (location eqip))
    (assert (invsize (- ?isize 1)))
    (assert (eqpsize (+ ?esize 1)))
    (printout t crlf "Equipped " ?itemname " in slot " ?slt "." crlf)
    
    (assert (inventory true))
)

(defrule delete-item
    ?id <- (itemname ?itemname delete)
    ?item <- (item (name ?itemname) (location invn))
    ?invsize <- (invsize ?isize)
    =>
    (retract ?id)
    (retract ?item)
    (retract ?invsize)
    (assert (invsize (- ?isize 1)))
    (printout t crlf "Deleted " ?itemname " from inventory." crlf)
    (assert (inventory true))
)

(defrule sell-item
    ?id <- (itemname ?itemname sell)
    ?item <- (item (name ?itemname) (location invn) (price ?price))
    ?idplayer <- (player (coins ?cns))
    ?invsize <- (invsize ?isize)
    =>
    (retract ?id)
    (retract ?item)
    (retract ?invsize)
    (assert (invsize (- ?isize 1)))
    (modify ?idplayer (coins (+ ?cns ?price)))
    (printout t crlf "Sold " ?itemname " for " ?price " coins." crlf)
    (assert (inventory true))
)

(defrule view-equipment
    (vieweqp true)
    (item (name ?name) (physicaldmg ?phys) (magicaldmg ?mag) (criticaldmg ?crit) (armor ?arm)
          (magicresist ?mres) (critresist ?cres) (price ?price) (lvl ?lvl) (location eqip) 
          (reqclass ?cls) (slt ?slt))
    =>
    (bind ?*eqpmatchcnt* (+ ?*eqpmatchcnt* 1))
    (printout t "Eqp Item: " ?name " | PDmg: " ?phys " | MDmg: " ?mag
                " | CDmg: " ?crit " | Arm: " ?arm " | MRes: " ?mres
                " | CRes: " ?cres " | Price: " ?price " | Lvl: " ?lvl 
                " | Cls: " ?cls " | Slt: " ?slt crlf)
)

(defrule view-inventory
    (viewinv true)
    (item (name ?name) (physicaldmg ?phys) (magicaldmg ?mag) (criticaldmg ?crit) (armor ?arm)
          (magicresist ?mres) (critresist ?cres) (price ?price) (lvl ?lvl) (location invn) 
          (reqclass ?cls) (slt ?slt))
    =>
    (bind ?*invmatchcnt* (+ ?*invmatchcnt* 1))
    (printout t "Item: " ?name " | PDmg: " ?phys " | MDmg: " ?mag
                " | CDmg: " ?crit " | Arm: " ?arm " | MRes: " ?mres
                " | CRes: " ?cres " | Price: " ?price " | Lvl: " ?lvl 
                " | Cls: " ?cls " | Slt: " ?slt crlf)
)

(defrule end-view-equipment
    (declare (salience -10))
    ?id <- (vieweqp true)
    (eqpsize ?size)
    =>
    (if (>= ?*eqpmatchcnt* ?size) then
        (retract ?id)
        (bind ?*eqpmatchcnt* 0)
        (printout t crlf "Total: " ?size crlf)
        (printout t "------------------------------------------------------------------------------------------------------------------------------------------------" crlf)
        (assert (inventory true))
    )
)

(defrule end-view-inventory
    (declare (salience -10))
    ?id <- (viewinv true)
    (invsize ?size)
    =>
    (if (>= ?*invmatchcnt* ?size) then
        (retract ?id)
        (bind ?*invmatchcnt* 0)
        (printout t crlf "Total: " ?size crlf)
        (printout t "------------------------------------------------------------------------------------------------------------------------------------------------" crlf)
        (assert (inventory true))
    )
)