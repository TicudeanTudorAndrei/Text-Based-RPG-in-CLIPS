(defglobal ?*eqaddcnt* = 0)

(defglobal ?*physdmgTotal* = 0)
(defglobal ?*magdmgTotal* = 0)
(defglobal ?*critdmgTotal* = 0)
(defglobal ?*armorTotal* = 0)
(defglobal ?*mresTotal* = 0)
(defglobal ?*cresTotal* = 0)

(defglobal ?*laststandUsed* = 0)
(defglobal ?*finaleUsed* = 0)

(defglobal ?*enemydebuffed* = 0)
(defglobal ?*playerdebuffed* = 0)

(defglobal ?*enemychoicetaken* = 0)

(deftemplate fullplayerstats
    (slot cls)
    (slot health)
    (slot strength)
    (slot agility)
    (slot intelligence)
    (slot physicaldmg)
    (slot magicaldmg)
    (slot criticaldmg)
    (slot armor)
    (slot magicresist)
    (slot critresist)
    (slot coins)
)

(deftemplate fullenemystats
   (slot health)
   (slot strength)
   (slot agility)
   (slot intelligence)
   (slot physicalDmg)
   (slot magicalDmg)
   (slot armor)
   (slot magicResist)
   (slot criticalDmg)
   (slot critResist)
   (slot coins)
   (slot experience)
   (slot cls)
)

(defrule combat-start
    ?id <- (combat true)
    =>
    (retract ?id)
    (assert (compute stats))
)

(defrule get-enemy-stats
    (enemy (health ?health) (strength ?strength) (agility ?agility) (intelligence ?intelligence) (physicalDmg ?physicalDmg) 
           (magicalDmg ?magicalDmg) (armor ?armor) (magicResist ?magicResist) (criticalDmg ?criticalDmg) 
           (critResist ?critResist) (cls ?cls) (coins ?coins) (experience ?experience))
    =>
    (assert (fullenemystats (health ?health) (strength ?strength) (agility ?agility) (intelligence ?intelligence) (physicalDmg ?physicalDmg) 
                             (magicalDmg ?magicalDmg) (armor ?armor) (magicResist ?magicResist) (criticalDmg ?criticalDmg) 
                             (critResist ?critResist) (coins ?coins) (experience ?experience) (cls ?cls))
    )
)

(defrule get-player-stats
    (compute stats)
    (item (physicaldmg ?phys) (magicaldmg ?mag) (criticaldmg ?crit)
          (armor ?arm) (magicresist ?mres) (critresist ?cres) (location eqip)
    )
    =>
    (bind ?*eqaddcnt* (+ ?*eqaddcnt* 1))

    (bind ?*physdmgTotal* (+ ?*physdmgTotal* ?phys))
    (bind ?*magdmgTotal* (+ ?*magdmgTotal* ?mag))
    (bind ?*critdmgTotal* (+ ?*critdmgTotal* ?crit))
    (bind ?*armorTotal* (+ ?*armorTotal* ?arm))
    (bind ?*mresTotal* (+ ?*mresTotal* ?mres))
    (bind ?*cresTotal* (+ ?*cresTotal* ?cres))
)

(defrule end-get-player-stats
    (declare (salience -10))
    ?id <- (compute stats)
    (player (cls ?cls) (health ?hp) (strength ?strg) (agility ?agi) (intelligence ?int) (coins ?coins))
    (eqpsize ?size)
    =>
    (if (>= ?*eqaddcnt* ?size) then
        (retract ?id)
        (assert (fullplayerstats (cls ?cls) (health ?hp) (strength ?strg) (agility ?agi) (intelligence ?int)
                                 (physicaldmg ?*physdmgTotal*) (magicaldmg ?*magdmgTotal*) (criticaldmg ?*critdmgTotal*)
                                 (armor ?*armorTotal*) (magicresist ?*mresTotal*) (critresist ?*cresTotal*) (coins ?coins)
                )
        )
        (assert (combatturn player))
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule player-action-choice
    ?id <- (combatturn player)
    =>
    (retract ?id)
    (printout t "----------------------------------------------------------" crlf)
    (printout t crlf "Choose an action: (1: Ability, 2: Consumable, 3: Stats)" crlf)
    (bind ?choice (read))
    
    (while (not (or (eq ?choice 1) (eq ?choice 2) (eq ?choice 3)))
       (printout t crlf "Invalid choice! Choose an action: (1: Ability, 2: Consumable, 3: Stats)" crlf)
       (bind ?choice (read))
    )

    (if (eq ?choice 1) then
        (assert (playeraction ability))
    )

    (if (eq ?choice 2) then
        (assert (playeraction consumable))
    )

    (if (eq ?choice 3) then
        (assert (playeraction stats))
    )
)

(defrule show-combat-stats
    ?id <- (playeraction stats)
    (fullplayerstats (cls ?cls) (health ?hp) (strength ?strg) (agility ?agi) (intelligence ?int) (physicaldmg ?pdmg) 
                     (magicaldmg ?mdmg) (criticaldmg ?cdmg) (armor ?arm) (magicresist ?mres) (critresist ?cres) (coins ?coins))
    (fullenemystats (health ?health) (strength ?strength) (agility ?agility) (intelligence ?intelligence) (physicalDmg ?physicalDmg) 
           (magicalDmg ?magicalDmg) (armor ?armor) (magicResist ?magicResist) (criticalDmg ?criticalDmg) 
           (critResist ?critResist) (cls ?clsE))
    =>
    (retract ?id)
    (printout t crlf "-----------------------" crlf)
    (printout t "Player Stats:" crlf)
    (printout t "Class: " ?cls crlf)
    (printout t "Health: " ?hp crlf)
    (printout t "Strength: " ?strg crlf)
    (printout t "Agility: " ?agi crlf)
    (printout t "Intelligence: " ?int crlf)
    (printout t "Physical Damage: " ?pdmg crlf)
    (printout t "Magical Damage: " ?mdmg crlf)
    (printout t "Critical Damage: " ?cdmg crlf)
    (printout t "Armor: " ?arm crlf)
    (printout t "Magic Resist: " ?mres crlf)
    (printout t "Critical Resist: " ?cres crlf)
    (printout t "Coins: " ?coins crlf)
    (printout t crlf "-----------------------" crlf)
    (printout t "Enemy Stats:" crlf)
    (printout t "Class: " ?clsE crlf)
    (printout t "Health: " ?health crlf)
    (printout t "Strength: " ?strength crlf)
    (printout t "Agility: " ?agility crlf)
    (printout t "Intelligence: " ?intelligence crlf)
    (printout t "Physical Damage: " ?physicalDmg crlf)
    (printout t "Magical Damage: " ?magicalDmg crlf)
    (printout t "Critical Damage: " ?criticalDmg crlf)
    (printout t "Armor: " ?armor crlf)
    (printout t "Magic Resist: " ?magicResist crlf)
    (printout t "Critical Resist: " ?critResist crlf)
    (printout t "-----------------------" crlf)
    (printout t crlf)
    (assert (combatturn player))
)

(defrule player-consumable-choice
    ?id <- (playeraction consumable)
    (player (coins ?coins))
    =>
    (retract ?id)

    (if (< ?coins 50) then
        (printout t crlf "You don't have enough coins to buy consumables!" crlf)
        (assert (combatturn player))
    )

    (if (>= ?coins 50) then
        (printout t crlf "--- Player's Turn -----------------------------------------")
        (printout t crlf "Choose a consumable: 1: Health Potion (50g), 2: Strengthening Potion (50g), 3: Mana Potion (50g), 4: Focusing Potion (50g)" crlf)
        (bind ?choice (read))
    
        (while (not (or (eq ?choice 1) (eq ?choice 2) (eq ?choice 3) (eq ?choice 4)))
            (printout t crlf "Invalid! Choose a consumable: 1: Health Potion (50g), 2: Strengthening Potion (50g), 3: Mana Potion (50g), 4: Focusing Potion (50g)" crlf)
            (bind ?choice (read))
        )

        (if (eq ?choice 1) then
            (assert (playerconsumable hppot))
        )

        (if (eq ?choice 2) then
            (assert (playerconsumable strpot))
        )

        (if (eq ?choice 3) then
            (assert (playerconsumable manapot))
        )

        (if (eq ?choice 4) then
            (assert (playerconsumable focuspot))
        )
    )
)

(defrule player-consumable-use-hp
    ?id <- (playerconsumable hppot)
    ?idstats <- (fullplayerstats (health ?hp) (coins ?coins))
    (maxhealth ?maxhp)
    =>
    (retract ?id)
    (printout t "You use a Health Potion! You heal 50% health!" crlf)
    (modify ?idstats (health (+ ?hp (/ ?maxhp 2))) (coins (- ?coins 50)))
    (assert (combatturn enemy))
)

(defrule player-consumable-use-str
    ?id <- (playerconsumable strpot)
    ?idstats <- (fullplayerstats (strength ?strg) (coins ?coins))
    =>
    (retract ?id)
    (printout t "You use a Strengthening Potion! You gain 25% strength!" crlf)
    (modify ?idstats (strength (+ ?strg (/ ?strg 4))) (coins (- ?coins 50)))
    (assert (combatturn enemy))
)

(defrule player-consumable-use-int
    ?id <- (playerconsumable manapot)
    ?idstats <- (fullplayerstats (intelligence ?int) (coins ?coins))
    =>
    (retract ?id)
    (printout t "You use a Mana Potion! You gain 25% intelligence!" crlf)
    (modify ?idstats (intelligence (+ ?int (/ ?int 4))) (coins (- ?coins 50)))
    (assert (combatturn enemy))
)

(defrule player-consumable-use-agi
    ?id <- (playerconsumable focuspot)
    ?idstats <- (fullplayerstats (agility ?agi) (coins ?coins))
    =>
    (retract ?id)
    (printout t "You use a Focusing Potion! You gain 25% agility!" crlf)
    (modify ?idstats (agility (+ ?agi (/ ?agi 4))) (coins (- ?coins 50)))
    (assert (combatturn enemy))
)

(defrule player-ability-choice
    ?id <- (playeraction ability)
    ?idstats <- (fullplayerstats (cls ?cls))
    =>
    (retract ?id)

    (printout t crlf "--- Player's Turn -----------------------------------------")
    (printout t crlf "Normal Attacks:" crlf)
    (printout t "1: Physical Attack, 2: Magic Attack, 3: Targeted Attack" crlf)
    (printout t "Special Attacks:" crlf)
    (if (eq ?cls warrior) then
        (printout t "4: Stunning Blow, 5: Skull Crusher, 6: Last Stand (EXTREME)" crlf)
    )
    (if (eq ?cls sorcerer) then
        (printout t "4: Weakening Curse, 5: Siphoning Strike, 6: Teleportation (EXTREME)" crlf)
    )
    (if (eq ?cls rogue) then
        (printout t "4: Place Mark, 5: Precision Skewer, 6: Finale (EXTREME)" crlf)
    )

    (bind ?choice (read))
    
    (while (not (or (eq ?choice 1) (eq ?choice 2) (eq ?choice 3) (eq ?choice 4) (eq ?choice 5) (eq ?choice 6)))
       (printout t crlf "Invalid choice!" crlf)
       (printout t crlf "Normal Attacks:" crlf)
        (printout t "1: Physical Attack, 2: Magic Attack, 3: Targeted Attack" crlf)
        (printout t "Special Attacks:" crlf)
        (if (eq ?cls warrior) then
            (printout t "4: Stunning Blow, 5: Skull Crusher, 6: Last Stand (EXTREME)" crlf)
        )
        (if (eq ?cls sorcerer) then
            (printout t "4: Weakening Curse, 5: Siphoning Strike, 6: Teleportation (EXTREME)" crlf)
        )
        (if (eq ?cls rogue) then
            (printout t "4: Place Mark, 5: Precision Skewer, 6: Finale (EXTREME)" crlf)
        )
       
        (bind ?choice (read))
    )

    (if (eq ?choice 1) then
        (assert (playerattack basic physical))
    )

    (if (eq ?choice 2) then
        (assert (playerattack basic magical))
    )

    (if (eq ?choice 3) then
        (assert (playerattack basic critical))
    )

    (if (eq ?choice 4) then
        (if (eq ?cls warrior) then
            (assert (playerattack special stunning))
        )
        (if (eq ?cls sorcerer) then
            (assert (playerattack special weakening))
        )
        (if (eq ?cls rogue) then
            (assert (playerattack special mark))
        )
    )

    (if (eq ?choice 5) then
        (if (eq ?cls warrior) then
            (assert (playerattack special crushing))
        )
        (if (eq ?cls sorcerer) then
            (assert (playerattack special siphoning))
        )
        (if (eq ?cls rogue) then
            (assert (playerattack special skewer))
        )
    )

    (if (eq ?choice 6) then
        (if (eq ?cls warrior) then
            (assert (playerattack extreme laststand))
        )
        (if (eq ?cls sorcerer) then
            (assert (playerattack extreme teleport))
        )
        (if (eq ?cls rogue) then
            (assert (playerattack extreme finale))
        )
    )
)

(defrule check-miss-player
    ?id <- (playerattack ?attackClass ?attackType)
    (fullplayerstats (cls ?cls) (strength ?stg) (agility ?agi) (intelligence ?int))
    =>
    (retract ?id)
    
    (if (eq ?attackClass extreme) then
        (bind ?hitChance 100)
    )
    
    (if (eq ?attackClass special) then
        (bind ?hitChance 90)
    )
    
    (if (eq ?attackClass basic) then
        
        (if (eq ?attackType physical) then
            (bind ?hitChance (+ 60 ?stg))
            (if (eq ?cls warrior) then
                (bind ?hitChance (+ ?hitChance 20))
            )
            (if (> ?hitChance 80) then
                (bind ?hitChance 80)
            )
        )

        (if (eq ?attackType magical) then
            (bind ?hitChance (+ 20 ?int))
            (if (eq ?cls sorcerer) then
                (bind ?hitChance (+ ?hitChance 60))
            )
            (if (> ?hitChance 80) then
                (bind ?hitChance 80)
            )
        )

        (if (eq ?attackType critical) then
            (bind ?hitChance (+ 40 ?agi))
            (if (eq ?cls rogue) then
                (bind ?hitChance (+ ?hitChance 40))
            )
            (if (> ?hitChance 80) then
                (bind ?hitChance 80)
            )
        )
    )

    (bind ?hitRoll (random 0 100))

    (if (> ?hitRoll ?hitChance) then
        (printout t "You missed!" crlf)
        (assert (combatturn enemy))
    )

    (if (<= ?hitRoll ?hitChance) then
        (assert (playerattack ?attackClass ?attackType hitsuccess))
    )
)

(defrule check-dodge-player
    ?id <- (playerattack ?attackClass ?attackType hitsuccess)
    (fullenemystats (strength ?stg) (agility ?agi) (intelligence ?int) (cls ?cls))
    =>
    (retract ?id)
    
    (if (eq ?attackClass extreme) then
        (bind ?dodgeChance 0)
    )

    (if (eq ?attackClass special) then
        (bind ?dodgeChance 10)
    )

    (if (eq ?attackClass basic) then
        (if (eq ?attackType physical) then
            (bind ?dodgeChance (+ 10 ?stg))
            (if (> ?dodgeChance 30) then
                (bind ?dodgeChance 30)
            )
        )
    
        (if (eq ?attackType magical) then
            (bind ?dodgeChance (+ 5 ?int))
            (if (> ?dodgeChance 30) then
                (bind ?dodgeChance 30)
            )
        )

        (if (eq ?attackType critical) then
            (bind ?dodgeChance (+ 20 ?agi))
            (if (> ?dodgeChance 30) then
                (bind ?dodgeChance 30)
            )
        )
    )

    (bind ?dodgeRoll (random 0 100))

    (if (<= ?dodgeRoll ?dodgeChance) then
        (printout t "The enemy dodged your attack!" crlf)
        (assert (combatturn enemy))
    )

    (if (> ?dodgeRoll ?dodgeChance) then
        (assert (playerattack ?attackClass ?attackType dodgesuccess))
    )
)

(defrule compute-damage-and-effects-player
    ?id <- (playerattack ?attackClass ?attackType dodgesuccess)
    ?idstats <- (fullplayerstats (health ?hp) (cls ?cls) (strength ?stg) (agility ?agi) (intelligence ?int) (physicaldmg ?pdmg) (magicaldmg ?mdmg) (criticaldmg ?cdmg))
    ?idenemy <- (fullenemystats (health ?ehp) (strength ?estr) (agility ?eagi) (intelligence ?eint) (physicalDmg ?epdmg) (magicalDmg ?emdmg) (criticalDmg ?ecdmg) (armor ?earm) (magicResist ?emres) (critResist ?ecres) (coins ?coins) (experience ?expr) (cls ?ecls))
    =>
    (retract ?id)
    
    (if (eq ?attackClass extreme) then
        (if (eq ?attackType laststand) then
            
            (if (eq ?*laststandUsed* 1) then
                (printout t "You already used Last Stand this combat!" crlf)
            )
            
            (if (eq ?*laststandUsed* 0) then
                (printout t "You use Last Stand! You steal 50% of the enemy HP but lose 20% of your stats until the end of combat! Your damage doubles!" crlf)
                (modify ?idstats (health (+ ?hp (/ ?ehp 2))) (strength (- ?stg (/ ?stg 5))) (agility (- ?agi (/ ?agi 5))) (intelligence (- ?int (/ ?int 5))) (physicaldmg (* ?pdmg 2)) (magicaldmg (* ?mdmg 2)) (criticaldmg (* ?cdmg 2)))
                (modify ?idenemy (health (- ?ehp (/ ?ehp 2))))
            
                (bind ?*laststandUsed* 1)
            )
        )

        (if (eq ?attackType teleport) then
            (printout t "You use Teleportation! You teleport back to the village! You feel your powers drained!" crlf)
            (assert (teleport true))
            (return)
        )

        (if (eq ?attackType finale) then

            (if (eq ?*finaleUsed* 1) then
                (printout t "You already used Finale this combat!" crlf)
            )
            
            (if (eq ?*finaleUsed* 0) then
                (bind ?chance (random 1 100))
                (if (> ?chance 10) then
                    (printout t "You use Finale! You instantly kill the enemy!" crlf)
                    (modify ?idenemy (health 0))
                )
            
                (if (<= ?chance 10) then
                    (printout t "You use Finale! You miss! Tragedy!" crlf)
                )
            
                (bind ?*finaleUsed* 1)
            )
        )
    )

    (if (eq ?attackClass special) then
        (if (eq ?attackType stunning) then
            (printout t "You use Stunning Blow! You deal 5% health damage and reduce AGI by 20%" crlf)
            (modify ?idenemy (health (- ?ehp (/ ?ehp 20))) (agility (- ?eagi (/ ?eagi 5))))

            (bind ?chance (random 1 100))
            (if (> ?chance 40) then
                (printout t "The enemy is stunned!" crlf)
                (bind ?*enemydebuffed* 1)
            )
            (if (<= ?chance 40) then
                (printout t "The enemy resisted the stun!" crlf)
            )
        )

        (if (eq ?attackType weakening) then
            (printout t "You use Weakening Curse! You deal 5% health damage and reduce STR by 20%" crlf)
            (modify ?idenemy (health (- ?ehp (/ ?ehp 20))) (strength (- ?estr (/ ?estr 5))))

            (bind ?chance (random 1 100))
            (if (> ?chance 40) then
                (printout t "The enemy is wakened!" crlf)
                (bind ?*enemydebuffed* 1)
            )
            (if (<= ?chance 40) then
                (printout t "The enemy resisted the weakening!" crlf)
            )
        )

        (if (eq ?attackType mark) then
            (printout t "You use Place Mark! You deal 5% health damage and reduce INT by 20%" crlf)
            (modify ?idenemy (health (- ?ehp (/ ?ehp 20))) (intelligence (- ?eint (/ ?eint 5))))

            (bind ?chance (random 1 100))
            (if (> ?chance 40) then
                (printout t "The enemy is marked!" crlf)
                (bind ?*enemydebuffed* 1)
            )
            (if (<= ?chance 40) then
                (printout t "The enemy resisted the mark!" crlf)
            )
        )

        (if (eq ?attackType crushing) then
            (printout t "You use Skull Crusher!" crlf)
            
            (if (= ?*enemydebuffed* 0) then
                (printout t "The enemy evaded the crush!" crlf)
            )

            (if (= ?*enemydebuffed* 1) then
                (printout t "The enemy is crushed! You deal 20% health damage! The stun clears!" crlf)
                (modify ?idenemy (health (- ?ehp (/ ?ehp 5))))
                (bind ?*enemydebuffed* 0)
            )
        )

        (if (eq ?attackType siphoning) then
            (printout t "You use Siphoning Strike!" crlf)
            
            (if (= ?*enemydebuffed* 0) then
                (printout t "The enemy evaded the siphon!" crlf)
            )

            (if (= ?*enemydebuffed* 1) then
                (printout t "The enemy is siphoned! You deal 20% health damage! The curse clears!" crlf)
                (modify ?idenemy (health (- ?ehp (/ ?ehp 5))))
                (bind ?*enemydebuffed* 0)
            )
        )

        (if (eq ?attackType skewer) then
            (printout t "You use Precision Skewer!" crlf)
            
            (if (= ?*enemydebuffed* 0) then
                (printout t "The enemy evaded the skewer!" crlf)
            )

            (if (= ?*enemydebuffed* 1) then
                (printout t "The enemy is skewered! You deal 20% health damage! The mark clears!" crlf)
                (modify ?idenemy (health (- ?ehp (/ ?ehp 5))))
                (bind ?*enemydebuffed* 0)
            )
        )    
    )

    (if (eq ?attackClass basic) then
        
        (if (eq ?cls warrior) then
            (bind ?physicalMultiplier 1.0)
            (bind ?magicalMultiplier 0.5)
            (bind ?criticalMultiplier 0.75)
        )

        (if (eq ?cls sorcerer) then
            (bind ?physicalMultiplier 0.5)
            (bind ?magicalMultiplier 1.0)
            (bind ?criticalMultiplier 0.75)
        )

        (if (eq ?cls rogue) then
            (bind ?physicalMultiplier 0.75)
            (bind ?magicalMultiplier 0.5)
            (bind ?criticalMultiplier 1.0)
        )
    
        (bind ?physicalDamage (- (+ ?stg (* ?pdmg ?physicalMultiplier)) ?earm))
        (bind ?magicalDamage (- (+ ?int (* ?mdmg ?magicalMultiplier)) ?emres))
        (bind ?criticalDamage (- (+ ?agi (* ?cdmg ?criticalMultiplier)) ?ecres))

        (if (< ?physicalDamage 0) then
            (bind ?physicalDamage 1)
        )

        (if (< ?magicalDamage 0) then
            (bind ?magicalDamage 1)
        )

        (if (< ?criticalDamage 0) then
            (bind ?criticalDamage 1)
        )

        (if (eq ?attackType physical) then
            (printout t "You use Physical Attack! You deal " ?physicalDamage " damage to the enemy!" crlf)
            (modify ?idenemy (health (- ?ehp ?physicalDamage)))
        )

        (if (eq ?attackType magical) then
            (printout t "You use Magic Attack! You deal " ?magicalDamage " damage to the enemy!" crlf)
            (modify ?idenemy (health (- ?ehp ?magicalDamage)))
        )

        (if (eq ?attackType critical) then
            (printout t "You use Targeted Attack! You deal " ?criticalDamage " damage to the enemy!" crlf)
            (modify ?idenemy (health (- ?ehp ?criticalDamage)))
        )
    )

    (assert (checkdeath enemy))
)

(defrule check-teleport
    ?id <- (teleport true)
    ?idenemy <- (enemy (name ?name))
    ?idstats <- (fullenemystats (health ?health))
    ?idpstats <- (fullplayerstats (health ?hp) (coins ?coins))
    ?idplayer <- (player (intelligence ?int) (health ?hp) (level ?lvl))
    ?idgame <- (gamestate (playeralive true) (crtlocation ?loc) (turn ?turn))
    =>
    (retract ?id)
    (retract ?idenemy)
    (retract ?idstats)
    (retract ?idpstats)

    (modify ?idgame (crtlocation village) (turn (+ ?turn 1)))

    (if (< ?lvl 5) then
        (modify ?idplayer (intelligence (- ?int ?lvl)) (health (- ?hp (/ ?hp 10))))
    )

    (if (>= ?lvl 5) then
        (modify ?idplayer (intelligence (- ?int 5)) (health (- ?hp (/ ?hp 10))))
    )
)

(defrule check-enemy-death
    ?id <- (checkdeath enemy)
    ?idgame <- (gamestate (turn ?turn) (playeralive true))
    ?idplayer <- (player (experience ?pexpr))
    ?idenemystats <- (fullenemystats (health ?health) (coins ?ecoins) (experience ?eexpr))
    ?idplayerstats <- (fullplayerstats (health ?php) (cls ?cls) (coins ?pcoins))
    ?idenemy <- (enemy (name ?name))
    =>
    (retract ?id)
    
    (if (<= ?health 0) then
        (retract ?idenemystats)
        (retract ?idenemy)
        (retract ?idplayerstats)
        (printout t crlf "You defeated the enemy!" crlf)
        (printout t "You gained " ?ecoins " coins and " ?eexpr " experience!" crlf)
        
        (bind ?*eqaddcnt* 0)
        (bind ?*physdmgTotal* 0)
        (bind ?*magdmgTotal* 0)
        (bind ?*critdmgTotal* 0)
        (bind ?*armorTotal* 0)
        (bind ?*mresTotal* 0)
        (bind ?*cresTotal* 0)
        (bind ?*laststandUsed* 0)
        (bind ?*finaleUsed* 0)
        (bind ?*enemydebuffed* 0) 
        
        (modify ?idplayer (health ?php) (coins (+ ?pcoins ?ecoins)) (experience (+ ?pexpr ?eexpr)))
        (assert (checklevelup true))
    )

    (if (> ?health 0) then
        (assert (combatturn enemy))
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule enemy-ability-choice
    ?id <- (combatturn enemy)
    (fullplayerstats (health ?php) (cls ?pcls) (strength ?pstg) (agility ?pagi) (intelligence ?pint) (physicaldmg ?ppdmg) (magicaldmg ?pmdmg) (criticaldmg ?pcdmg) (armor ?parm) (magicresist ?pmres) (critresist ?pcres))
    (fullenemystats (health ?ehp) (strength ?estr) (agility ?eagi) (intelligence ?eint) (physicalDmg ?epdmg) (magicalDmg ?emdmg) (criticalDmg ?ecdmg) (armor ?earm) (magicResist ?emres) (critResist ?ecres) (coins ?coins) (experience ?expr) (cls ?ecls))
    =>
    (retract ?id)
    (bind ?*enemychoicetaken* 0)

    (printout t "-----------------------------------------------------------" crlf)
    (printout t crlf "--- Enemy's Turn -----------------------------------------")
    (printout t crlf "The enemy is thinking...")

    ;Player Damage Potential
    (if (eq ?pcls warrior) then
        (bind ?pphysicalMultiplier 1.0)
        (bind ?pmagicalMultiplier 0.5)
        (bind ?pcriticalMultiplier 0.75)
    )

    (if (eq ?pcls sorcerer) then
        (bind ?pphysicalMultiplier 0.5)
        (bind ?pmagicalMultiplier 1.0)
        (bind ?pcriticalMultiplier 0.75)
    )

    (if (eq ?pcls rogue) then
        (bind ?pphysicalMultiplier 0.75)
        (bind ?pmagicalMultiplier 0.5)
        (bind ?pcriticalMultiplier 1.0)
    )
    
    (bind ?pphysicalDamage (- (+ ?pstg (* ?ppdmg ?pphysicalMultiplier)) ?earm))
    (bind ?pmagicalDamage (- (+ ?pint (* ?pmdmg ?pmagicalMultiplier)) ?emres))
    (bind ?pcriticalDamage (- (+ ?pagi (* ?pcdmg  ?pcriticalMultiplier)) ?ecres))

    (if (< ?pphysicalDamage 0) then
        (bind ?pphysicalDamage 1)
    )

    (if (< ?pmagicalDamage 0) then
        (bind ?pmagicalDamage 1)
    )

    (if (< ?pcriticalDamage 0) then
        (bind ?pcriticalDamage 1)
    )

    (bind ?playerDamagePotential (max ?pphysicalDamage ?pmagicalDamage ?pcriticalDamage))

    ;Enemy Damage Potential
    (if (eq ?ecls tank) then
        (bind ?ephysicalMultiplier 1.0)
        (bind ?emagicalMultiplier 0.5)
        (bind ?ecriticalMultiplier 0.75)
    )

    (if (eq ?ecls mage) then
        (bind ?ephysicalMultiplier 0.5)
        (bind ?emagicalMultiplier 1.0)
        (bind ?ecriticalMultiplier 0.75)
    )

    (if (eq ?ecls assassin) then
        (bind ?ephysicalMultiplier 0.75)
        (bind ?emagicalMultiplier 0.5)
        (bind ?ecriticalMultiplier 1.0)
    )
    
    (bind ?ephysicalDamage (- (+ ?estr (* ?epdmg ?ephysicalMultiplier)) ?parm))
    (bind ?emagicalDamage (- (+ ?eint (* ?emdmg ?emagicalMultiplier)) ?pmres))
    (bind ?ecriticalDamage (- (+ ?eagi (* ?ecdmg ?ecriticalMultiplier)) ?pcres))

    (if (< ?ephysicalDamage 0) then
        (bind ?ephysicalDamage 1)
    )

    (if (< ?emagicalDamage 0) then
        (bind ?emagicalDamage 1)
    )

    (if (< ?ecriticalDamage 0) then
        (bind ?ecriticalDamage 1)
    )

    (bind ?maxDamage (max ?ephysicalDamage ?emagicalDamage ?ecriticalDamage))

    ;When Player low on health attempt to finish him off
    (if (<= ?php ?maxDamage) then
        
        (if (= ?maxDamage ?ephysicalDamage) then
            (assert (enemyattack basic physical))
        )

        (if (= ?maxDamage ?emagicalDamage) then
            (assert (enemyattack basic magical))
        )

        (if (= ?maxDamage ?ecriticalDamage) then
            (assert (enemyattack basic critical))
        )

        (bind ?*enemychoicetaken* 1)
        (return)
    )

    ;When Player debuffed, use special attack
    (if (= ?*playerdebuffed* 1) then
        
        (if (eq ?ecls tank) then
            (assert (enemyattack special destroy))
        )
            
        (if (eq ?ecls mage) then
            (assert (enemyattack special drain))
        )

        (if (eq ?ecls assassin) then
            (assert (enemyattack special stab))
        )

        (bind ?*enemychoicetaken* 1)
        (return)
    )

    ;When Enemy has more health than player damage, use debuff
    (if (> ?ehp ?playerDamagePotential) then
        (if (= ?*playerdebuffed* 0) then
            (if (eq ?ecls tank) then
                (assert (enemyattack special mark))
            )
            
            (if (eq ?ecls mage) then
                (assert (enemyattack special curse))
            )

            (if (eq ?ecls assassin) then
                (assert (enemyattack special pierce))
            )

            (bind ?*enemychoicetaken* 1)
            (return)
        )
    )

    ;When Enemy has less health than player damage, use basic attack
    (if (and (<= ?ehp ?playerDamagePotential) (>= ?ehp (* ?playerDamagePotential 0.5))) then

        (if (= ?maxDamage ?ephysicalDamage) then
            (assert (enemyattack basic physical))
        )

        (if (= ?maxDamage ?emagicalDamage) then
            (assert (enemyattack basic magical))
        )

        (if (= ?maxDamage ?ecriticalDamage) then
            (assert (enemyattack basic critical))
        )

        (bind ?*enemychoicetaken* 1)
        (return)
    )

    ;When Enemy is low, use sustain
    (if (< ?ehp (* ?playerDamagePotential 0.5)) then
        (if (eq ?ecls tank) then
            (assert (enemyattack sustain shield))
        )
            
        (if (eq ?ecls mage) then
            (assert (enemyattack sustain heal))
        )

        (if (eq ?ecls assassin) then
            (assert (enemyattack sustain sharpen))
        )

        (bind ?*enemychoicetaken* 1)
        (return)
    )

    ;When no other choice is made, use basic attack
    (if (= ?*enemychoicetaken* 0) then
        (if (eq ?ecls tank) then
            (assert (enemyattack basic physical))
        )
            
        (if (eq ?ecls mage) then
            (assert (enemyattack basic magical))
        )

        (if (eq ?ecls assassin) then
            (assert (enemyattack basic critical))
        )

        (bind ?*enemychoicetaken* 1)
        (return)
    )
)

(defrule check-miss-enemy
    ?id <- (enemyattack ?attackClass ?attackType)
    (fullenemystats (cls ?cls) (strength ?stg) (agility ?agi) (intelligence ?int))
    =>
    (retract ?id)
        
    (if (eq ?attackClass sustain) then
        (bind ?hitChance 100)
    )

    (if (eq ?attackClass special) then
        (bind ?hitChance 90)
    )
    
    (if (eq ?attackClass basic) then
        
        (if (eq ?attackType physical) then
            (bind ?hitChance (+ 60 ?stg))
            (if (eq ?cls tank) then
                (bind ?hitChance (+ ?hitChance 20))
            )
            (if (> ?hitChance 80) then
                (bind ?hitChance 80)
            )
        )

        (if (eq ?attackType magical) then
            (bind ?hitChance (+ 20 ?int))
            (if (eq ?cls mage) then
                (bind ?hitChance (+ ?hitChance 60))
            )
            (if (> ?hitChance 80) then
                (bind ?hitChance 80)
            )
        )

        (if (eq ?attackType critical) then
            (bind ?hitChance (+ 40 ?agi))
            (if (eq ?cls assassin) then
                (bind ?hitChance (+ ?hitChance 40))
            )
            (if (> ?hitChance 80) then
                (bind ?hitChance 80)
            )
        )
    )

    (bind ?hitRoll (random 0 100))

    (if (> ?hitRoll ?hitChance) then
        (printout t crlf "Enemy attempted an attack but missed!" crlf)
        (assert (combatturn player))
    )

    (if (<= ?hitRoll ?hitChance) then
        (assert (enemyattack ?attackClass ?attackType hitsuccess))
    )
)

(defrule check-dodge-enemy
    ?id <- (enemyattack ?attackClass ?attackType hitsuccess)
    (fullplayerstats (strength ?stg) (agility ?agi) (intelligence ?int))
    =>
    (retract ?id)

    (if (eq ?attackClass sustain) then
        (bind ?dodgeChance 0)
    )

    (if (eq ?attackClass special) then
        (bind ?dodgeChance 10)
    )

    (if (eq ?attackClass basic) then
        (if (eq ?attackType physical) then
            (bind ?dodgeChance (+ 10 ?stg))
            (if (> ?dodgeChance 30) then
                (bind ?dodgeChance 30)
            )
        )
    
        (if (eq ?attackType magical) then
            (bind ?dodgeChance (+ 5 ?int))
            (if (> ?dodgeChance 30) then
                (bind ?dodgeChance 30)
            )
        )

        (if (eq ?attackType critical) then
            (bind ?dodgeChance (+ 20 ?agi))
            (if (> ?dodgeChance 30) then
                (bind ?dodgeChance 30)
            )
        )
    )

    (bind ?dodgeRoll (random 0 100))

    (if (<= ?dodgeRoll ?dodgeChance) then
        (printout t crlf "The enemy attempted an attack but you dodged it!" crlf)
        (assert (combatturn player))
    )

    (if (> ?dodgeRoll ?dodgeChance) then
        (assert (enemyattack ?attackClass ?attackType dodgesuccess))
    )
)

(defrule compute-damage-and-effects-enemy
    ?id <- (enemyattack ?attackClass ?attackType dodgesuccess)
    ?idstats <- (fullplayerstats (health ?hp) (cls ?cls) (strength ?stg) (agility ?agi) (intelligence ?int) (physicaldmg ?pdmg) (magicaldmg ?mdmg) (criticaldmg ?cdmg) (armor ?parm) (magicresist ?pmres) (critresist ?pcres))
    ?idenemy <- (fullenemystats (health ?ehp) (strength ?estr) (agility ?eagi) (intelligence ?eint) (physicalDmg ?epdmg) (magicalDmg ?emdmg) (criticalDmg ?ecdmg) (armor ?earm) (magicResist ?emres) (critResist ?ecres) (coins ?coins) (experience ?expr) (cls ?ecls))
    ?idgame <- (gamestate (playeralive true) (crtlocation ?loc) (turn ?turn))
    =>
    (retract ?id)

    (if (eq ?attackClass sustain) then
        (if (eq ?attackType shield) then
            (printout t crlf "The enemy uses Shield! All resistances are increased by 25%" crlf)
            (modify ?idenemy (armor (+ ?earm (/ ?earm 4))) (magicResist (+ ?emres (/ ?emres 4))) (critResist (+ ?ecres (/ ?ecres 4))))
        )

        (if (eq ?attackType heal) then
            (printout t crlf "The enemy uses Heal!" crlf)
            (modify ?idenemy (health (* ?ehp 2)))
        )

        (if (eq ?attackType sharpen) then
            (printout t crlf "The enemy uses Sharpen! All skills are inceased by 25%!" crlf)
            (modify ?idenemy (strength (+ ?estr (/ ?estr 4))) (agility (+ ?eagi (/ ?eagi 4))) (intelligence (+ ?eint (/ ?eint 4))))
        )
    )

    (if (eq ?attackClass special) then
        (if (eq ?attackType mark) then
            (printout t crlf "The enemy uses Mark! You suffer 5% health damage and lose 20% AGI" crlf)
            (modify ?idstats (health (- ?hp (/ ?hp 20))) (agility (- ?agi (/ ?agi 5))))

            (bind ?chance (random 1 100))
            (if (> ?chance 40) then
                (printout t "You are marked!" crlf)
                (bind ?*playerdebuffed* 1)
            )
            (if (<= ?chance 40) then
                (printout t "You resist the mark!" crlf)
            )
        )

        (if (eq ?attackType curse) then
            (printout t crlf "The enemy uses Curse! You suffer 5% health damage and lose 20% INT" crlf)
            (modify ?idstats (health (- ?hp (/ ?hp 20))) (intelligence (- ?int (/ ?int 5))))

            (bind ?chance (random 1 100))
            (if (> ?chance 40) then
                (printout t "You are cursed!" crlf)
                (bind ?*playerdebuffed* 1)
            )
            (if (<= ?chance 40) then
                (printout t "You resist the curse!" crlf)
            )
        )

        (if (eq ?attackType pierce) then
            (printout t crlf "The enemy uses Pierce! You suffer 5% health damage and lose 20% STG" crlf)
            (modify ?idstats (health (- ?hp (/ ?hp 20))) (strength (- ?stg (/ ?stg 5))))

            (bind ?chance (random 1 100))
            (if (> ?chance 40) then
                (printout t "You are pierced!" crlf)
                (bind ?*playerdebuffed* 1)
            )
            (if (<= ?chance 40) then
                (printout t "You resist the pierce!" crlf)
            )
        )

        (if (eq ?attackType destroy) then
            (printout t crlf "The enemy uses Destroy!" crlf)
            
            (if (= ?*playerdebuffed* 0) then
                (printout t "You evaded the destory!" crlf)
            )

            (if (= ?*playerdebuffed* 1) then
                (printout t "You are destroyed! You suffer 20% health damage! The mark clears!" crlf)
                (modify ?idstats (health (- ?hp (/ ?hp 5))))
                (bind ?*playerdebuffed* 0)
            )
        )

        (if (eq ?attackType drain) then
            (printout t crlf "The enemy uses Drain!" crlf)
            
            (if (= ?*playerdebuffed* 0) then
                (printout t "You evaded the drain!" crlf)
            )

            (if (= ?*playerdebuffed* 1) then
                (printout t "You are drained! You suffer 20% health damage! The curse clears!" crlf)
                (modify ?idstats (health (- ?hp (/ ?hp 5))))
                (bind ?*playerdebuffed* 0)
            )
        )

        (if (eq ?attackType stab) then
            (printout t crlf "The enemy uses Stab!" crlf)
            
            (if (= ?*playerdebuffed* 0) then
                (printout t "You evaded the stab!" crlf)
            )

            (if (= ?*playerdebuffed* 1) then
                (printout t "You are stabbed! You suffer 20% health damage! The pierce clears!" crlf)
                (modify ?idstats (health (- ?hp (/ ?hp 5))))
                (bind ?*playerdebuffed* 0)
            )
        )    
    )

    (if (eq ?attackClass basic) then
        
        (if (eq ?ecls tank) then
            (bind ?ephysicalMultiplier 1.0)
            (bind ?emagicalMultiplier 0.5)
            (bind ?ecriticalMultiplier 0.75)
        )

        (if (eq ?ecls mage) then
            (bind ?ephysicalMultiplier 0.5)
            (bind ?emagicalMultiplier 1.0)
            (bind ?ecriticalMultiplier 0.75)
        )

        (if (eq ?ecls assassin) then
            (bind ?ephysicalMultiplier 0.75)
            (bind ?emagicalMultiplier 0.5)
            (bind ?ecriticalMultiplier 1.0)
        )
    
        (bind ?ephysicalDamage (- (+ ?estr (* ?epdmg ?ephysicalMultiplier)) ?parm))
        (bind ?emagicalDamage (- (+ ?eint (* ?emdmg ?emagicalMultiplier)) ?pmres))
        (bind ?ecriticalDamage (- (+ ?eagi (* ?ecdmg ?ecriticalMultiplier)) ?pcres))

        (if (< ?ephysicalDamage 0) then
            (bind ?ephysicalDamage 1)
        )

        (if (< ?emagicalDamage 0) then
            (bind ?emagicalDamage 1)
        )

        (if (< ?ecriticalDamage 0) then
            (bind ?ecriticalDamage 1)
        )

        (if (eq ?attackType physical) then
            (printout t crlf "The enemy uses Physical Attack! You suffer " ?ephysicalDamage " damage!" crlf)
            (modify ?idstats (health (- ?hp ?ephysicalDamage)))
        )

        (if (eq ?attackType magical) then
            (printout t crlf "The enemy uses Magic Attack! You suffer " ?emagicalDamage " damage!" crlf)
            (modify ?idstats (health (- ?hp ?emagicalDamage)))
        )

        (if (eq ?attackType critical) then
            (printout t crlf "The enemy uses Targeted Attack! You suffer " ?ecriticalDamage " damage!" crlf)
            (modify ?idstats (health (- ?hp ?ecriticalDamage)))
        )
    )

    (assert (checkdeath player))
)

(defrule check-player-death
    ?id <- (checkdeath player)
    ?idgame <- (gamestate (turn ?turn) (playeralive true))
    ?idplayerstats <- (fullplayerstats (health ?health))
    =>
    (retract ?id)
    
    (if (<= ?health 0) then
        (modify ?idgame (playeralive false))
    )

    (if (> ?health 0) then
        (assert (combatturn player))
    )
)