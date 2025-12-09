(deftemplate enemy
   (slot name)
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

(defrule deal-with-enemy
   ?id <- (gamestate (playeralive true) (turn ?turn))
   ?id2 <- (enemy (name ?name) (health ?health) (strength ?strength) (agility ?agility) (intelligence ?intelligence) (physicalDmg ?physicalDmg) (magicalDmg ?magicalDmg) (armor ?armor) 
                  (magicResist ?magicResist) (criticalDmg ?criticalDmg) (critResist ?critResist) (coins ?coins) (experience ?experience) (cls ?cls)
            )
   =>
   (printout t "--------------------------------------------------------------------------------------------------------------------------------------------------------------" crlf)
   (printout t "You encounter a " ?name "!" crlf)
   (printout t "Enemy: " ?name " | HP: " ?health " | Cls: " ?cls
             " | Str: " ?strength
             " | Agi: " ?agility " | Int: " ?intelligence 
             " | PDmg: " ?physicalDmg " | MDmg: " ?magicalDmg " | CDmg: " ?criticalDmg
             " | Arm: " ?armor " | MRes: " ?magicResist " | CRes: " ?critResist 
             " | Coins: " ?coins " | Exp: " ?experience crlf)
   (printout t "--------------------------------------------------------------------------------------------------------------------------------------------------------------" crlf)
   
   (printout t crlf "Do you want to fight? (1: Fight, 2: Flee)" crlf)
   (bind ?choice (read))
   
   (while (not (or (eq ?choice 1) (eq ?choice 2)))
      (printout t crlf "Invalid choice! Do you want to fight? (1: Fight, 2: Flee)" crlf)
      (bind ?choice (read))
   )
   
   (if (eq ?choice 1) then
      (assert (combat true))
   )
   
   (if (eq ?choice 2) then
      (bind ?chance (random 1 100))
      (if (<= ?chance 75) then
         (printout t crlf "You flee from the " ?name "." crlf)
         (retract ?id2)
         (modify ?id (turn (+ 1 ?turn)))
      )
      (if (> ?chance 75) then
         (printout t crlf "The " ?name " blocks your path! It's time to fight!" crlf)
         (assert (combat true))
      )
   )
)

(defrule choose-enemy
   ?id <- (spawn ?enemyType)
   (player (level ?playerLevel))
   =>
   (retract ?id)
   (if (eq ?enemyType wolf) then
      (assert (enemyStats wolf (* 30 ?playerLevel) (* 5 ?playerLevel) (* 7 ?playerLevel) (* 2 ?playerLevel)
         (* 6 ?playerLevel) (* 2 ?playerLevel) (* 3 ?playerLevel) (* 2 ?playerLevel) 1.5 0.2 (* 2 ?playerLevel) (* 10 ?playerLevel) assassin)) 
   )

   (if (eq ?enemyType boar) then
      (assert (enemyStats boar (* 50 ?playerLevel) (* 7 ?playerLevel) (* 3 ?playerLevel) (* 2 ?playerLevel)
         (* 8 ?playerLevel) (* 1 ?playerLevel) (* 6 ?playerLevel) (* 4 ?playerLevel) 1.2 0.4 (* 3 ?playerLevel) (* 15 ?playerLevel) tank)) 
   )
   
   (if (eq ?enemyType raven) then
      (assert (enemyStats raven (* 25 ?playerLevel) (* 3 ?playerLevel) (* 4 ?playerLevel) (* 8 ?playerLevel)
         (* 2 ?playerLevel) (* 7 ?playerLevel) (* 2 ?playerLevel) (* 5 ?playerLevel) 1.6 0.3 (* 2 ?playerLevel) (* 12 ?playerLevel) mage)) 
   )

   (if (eq ?enemyType stone-golem) then
      (assert (enemyStats stone-golem (* 80 ?playerLevel) (* 10 ?playerLevel) (* 2 ?playerLevel) (* 2 ?playerLevel)
         (* 10 ?playerLevel) (* 1 ?playerLevel) (* 8 ?playerLevel) (* 5 ?playerLevel) 1.2 0.5 (* 5 ?playerLevel) (* 20 ?playerLevel) tank)) 
   )

   (if (eq ?enemyType mountain-lion) then
      (assert (enemyStats mountain-lion (* 40 ?playerLevel) (* 6 ?playerLevel) (* 10 ?playerLevel) (* 3 ?playerLevel)
         (* 7 ?playerLevel) (* 2 ?playerLevel) (* 4 ?playerLevel) (* 3 ?playerLevel) 1.7 0.3 (* 3 ?playerLevel) (* 15 ?playerLevel) assassin)) 
   )

   (if (eq ?enemyType harpy) then
      (assert (enemyStats harpy (* 30 ?playerLevel) (* 4 ?playerLevel) (* 6 ?playerLevel) (* 8 ?playerLevel)
         (* 3 ?playerLevel) (* 8 ?playerLevel) (* 3 ?playerLevel) (* 6 ?playerLevel) 1.5 0.2 (* 4 ?playerLevel) (* 18 ?playerLevel) mage)) 
   )

   (if (eq ?enemyType haunted-armor) then
      (assert (enemyStats haunted-armor (* 70 ?playerLevel) (* 8 ?playerLevel) (* 2 ?playerLevel) (* 6 ?playerLevel)
         (* 9 ?playerLevel) (* 3 ?playerLevel) (* 7 ?playerLevel) (* 5 ?playerLevel) 1.3 0.4 (* 5 ?playerLevel) (* 20 ?playerLevel) tank)) 
   )

   (if (eq ?enemyType dark-mage) then
      (assert (enemyStats dark-mage (* 40 ?playerLevel) (* 3 ?playerLevel) (* 4 ?playerLevel) (* 12 ?playerLevel)
         (* 3 ?playerLevel) (* 10 ?playerLevel) (* 3 ?playerLevel) (* 6 ?playerLevel) 1.8 0.3 (* 6 ?playerLevel) (* 25 ?playerLevel) mage)) 
   )

   (if (eq ?enemyType ghost-knight) then
      (assert (enemyStats ghost-knight (* 50 ?playerLevel) (* 6 ?playerLevel) (* 8 ?playerLevel) (* 5 ?playerLevel)
         (* 8 ?playerLevel) (* 4 ?playerLevel) (* 5 ?playerLevel) (* 4 ?playerLevel) 1.7 0.3 (* 4 ?playerLevel) (* 18 ?playerLevel) assassin)) 
   )

   (if (eq ?enemyType water-serpent) then
      (assert (enemyStats water-serpent (* 45 ?playerLevel) (* 5 ?playerLevel) (* 9 ?playerLevel) (* 4 ?playerLevel)
         (* 6 ?playerLevel) (* 3 ?playerLevel) (* 4 ?playerLevel) (* 3 ?playerLevel) 1.6 0.2 (* 4 ?playerLevel) (* 15 ?playerLevel) assassin)) 
   )

   (if (eq ?enemyType fishermans-spirit) then
      (assert (enemyStats fishermans-spirit (* 35 ?playerLevel) (* 2 ?playerLevel) (* 3 ?playerLevel) (* 10 ?playerLevel)
         (* 2 ?playerLevel) (* 9 ?playerLevel) (* 2 ?playerLevel) (* 5 ?playerLevel) 1.4 0.3 (* 5 ?playerLevel) (* 20 ?playerLevel) mage)) 
   )

   (if (eq ?enemyType kelp-monster) then
      (assert (enemyStats kelp-monster (* 70 ?playerLevel) (* 9 ?playerLevel) (* 4 ?playerLevel) (* 3 ?playerLevel)
         (* 8 ?playerLevel) (* 2 ?playerLevel) (* 7 ?playerLevel) (* 5 ?playerLevel) 1.2 0.4 (* 5 ?playerLevel) (* 18 ?playerLevel) tank)) 
   )

   (if (eq ?enemyType cave-troll) then
      (assert (enemyStats cave-troll (* 90 ?playerLevel) (* 12 ?playerLevel) (* 2 ?playerLevel) (* 1 ?playerLevel)
         (* 12 ?playerLevel) (* 1 ?playerLevel) (* 10 ?playerLevel) (* 4 ?playerLevel) 1.1 0.5 (* 6 ?playerLevel) (* 25 ?playerLevel) tank)) 
   )

   (if (eq ?enemyType goblin) then
      (assert (enemyStats goblin (* 25 ?playerLevel) (* 3 ?playerLevel) (* 8 ?playerLevel) (* 2 ?playerLevel)
         (* 5 ?playerLevel) (* 2 ?playerLevel) (* 3 ?playerLevel) (* 2 ?playerLevel) 1.7 0.2 (* 2 ?playerLevel) (* 10 ?playerLevel) assassin)) 
   )

   (if (eq ?enemyType shade) then
      (assert (enemyStats shade (* 30 ?playerLevel) (* 2 ?playerLevel) (* 6 ?playerLevel) (* 9 ?playerLevel)
         (* 2 ?playerLevel) (* 8 ?playerLevel) (* 3 ?playerLevel) (* 5 ?playerLevel) 1.5 0.3 (* 3 ?playerLevel) (* 15 ?playerLevel) mage)) 
   )

   (if (eq ?enemyType hermit) then
      (assert (enemyStats hermit (* 35 ?playerLevel) (* 3 ?playerLevel) (* 4 ?playerLevel) (* 10 ?playerLevel)
         (* 2 ?playerLevel) (* 9 ?playerLevel) (* 3 ?playerLevel) (* 5 ?playerLevel) 1.5 0.3 (* 4 ?playerLevel) (* 15 ?playerLevel) mage)) 
   )

   (if (eq ?enemyType wild-dog) then
      (assert (enemyStats wild-dog (* 50 ?playerLevel) (* 6 ?playerLevel) (* 5 ?playerLevel) (* 2 ?playerLevel)
         (* 7 ?playerLevel) (* 2 ?playerLevel) (* 6 ?playerLevel) (* 4 ?playerLevel) 1.3 0.3 (* 3 ?playerLevel) (* 15 ?playerLevel) assassin)) 
   )

   (if (eq ?enemyType troll) then
      (assert (enemyStats troll (* 80 ?playerLevel) (* 10 ?playerLevel) (* 3 ?playerLevel) (* 1 ?playerLevel)
         (* 9 ?playerLevel) (* 1 ?playerLevel) (* 8 ?playerLevel) (* 4 ?playerLevel) 1.2 0.4 (* 5 ?playerLevel) (* 20 ?playerLevel) tank)) 
   )

   (if (eq ?enemyType bandit) then
      (assert (enemyStats bandit (* 40 ?playerLevel) (* 6 ?playerLevel) (* 9 ?playerLevel) (* 3 ?playerLevel)
         (* 7 ?playerLevel) (* 2 ?playerLevel) (* 4 ?playerLevel) (* 3 ?playerLevel) 1.6 0.3 (* 3 ?playerLevel) (* 15 ?playerLevel) assassin)) 
   )

   (if (eq ?enemyType cultist) then
      (assert (enemyStats cultist (* 30 ?playerLevel) (* 3 ?playerLevel) (* 4 ?playerLevel) (* 10 ?playerLevel)
         (* 3 ?playerLevel) (* 9 ?playerLevel) (* 3 ?playerLevel) (* 5 ?playerLevel) 1.7 0.2 (* 4 ?playerLevel) (* 18 ?playerLevel) mage)) 
   )

   (if (eq ?enemyType peddler) then
      (assert (enemyStats peddler (* 60 ?playerLevel) (* 8 ?playerLevel) (* 3 ?playerLevel) (* 5 ?playerLevel)
         (* 9 ?playerLevel) (* 2 ?playerLevel) (* 7 ?playerLevel) (* 5 ?playerLevel) 1.3 0.4 (* 5 ?playerLevel) (* 20 ?playerLevel) tank)) 
   )
)

(defrule spawn-enemy
   ?id <- (enemyStats ?name ?health ?strength ?agility ?intelligence ?physicalDmg ?magicalDmg ?armor ?magicResist ?criticalDmg ?critResist ?coins ?experience ?cls)
   =>
   (retract ?id)
   (assert (enemy (name ?name) (health ?health) (strength ?strength) (agility ?agility) (intelligence ?intelligence) (physicalDmg ?physicalDmg) (magicalDmg ?magicalDmg) (armor ?armor) (magicResist ?magicResist) (criticalDmg ?criticalDmg) (critResist ?critResist) (coins ?coins) (experience ?experience) (cls ?cls)))
)