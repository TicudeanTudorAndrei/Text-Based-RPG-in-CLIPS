# Text-Based RPG in CLIPS

This project implements a **rule-based RPG (Role Playing Game)** using **CLIPS**, modeling classic game mechanics through expert-system reasoning.  

It features a fully interactive text interface, a modular architecture, and AI‑driven enemies that make decisions using inference rules.

---

## System Structure
The game is built from **eight CLIPS modules**, each responsible for major gameplay functionality.

### 1. Start Game (`startgame.clp`)
- Entry point of the game  
- Loads all modules and initializes global state  

- Run CLIPS using "CLIPSIDE.exe"
- Make sure to set the correct folder path (for example: E:\Clips\rpg) via Environment -> Set Directory
- Write ```(batch startgame.clp)```
- Press "Enter"
- If everyhting goes well you should see:
```clips
CLIPS>  (batch startgame.clp)
TRUE
CLIPS> (clear)
CLIPS> (load gameloop.clp)
%***
TRUE
CLIPS> (load player.clp)
::::%***
TRUE
CLIPS> (load locations.clp)
%*!***********
TRUE
CLIPS> (load items.clp)
::%***************
TRUE
CLIPS> (load encounters.clp)
*****
TRUE
CLIPS> (load enemies.clp)
%***
TRUE
CLIPS> (load combat.clp)
::::::::::::%%**********************
TRUE
CLIPS> (reset)
CLIPS> (run)
```
- Press "Enter"
- You should see:
```clips
You find yourself in a village!
Welcome! Please create a name: 
Tahm

Choose your class! (1: Warrior, 2: Sorcerer, 3: Rogue)
1

----------------------------------------
What do you want to do? (Turn 1)
1: Player statistics
2: Manage inventory
3: Explore the village
4: Move to another region
5: Quit
----------------------------------------
```
- Follow the indications and don't worry if you get something wrong (each input is checked to match the correct format)

### 2. Player (`player.clp`)
Defines the player template:
- name, class (warrior/sorcerer/rogue)
- HP, level, XP, gold
- attributes: strength, intelligence, agility

Includes rules:
- `initialize-player`
- `show-stats`
- `level-up` (XP threshold = level² × 20 + 50; HP increases by 10 × new level)

```clips
----------------------------------------
What do you want to do? (Turn 1)
1: Player statistics
2: Manage inventory
3: Explore the village
4: Move to another region
5: Quit
----------------------------------------
1

-----------------------
Player Stats:
Name: Tahm
Class: warrior
Health: 150
Level: 1
Experience: 68
Strength: 12
Agility: 6
Intelligence: 2
Coins: 500
Max Health: 150
-----------------------
```

### 3. Game Loop (`gameloop.clp`)
Main game controller:
- Tracks current region, player status, turn count
- Provides:
  - View stats  
  - Manage inventory  
  - Explore current area  
  - Move to another region  
  - Quit game  

### 4. Locations (`locations.clp`)
- Implements world regions as a static graph  
- Movement rules (north, south, east, west)  
- Map display and travel prompts

```clips
----------------------------------------
What do you want to do? (Turn 2)
1: Player statistics
2: Manage inventory
3: Explore the village
4: Move to another region
5: Quit
----------------------------------------
4

                     +-------------+
                     |   Mountain  |
                     |      ^      |
                     +-------------+
                            |
                     +-------------+
                     |   Forest    |
                     |  * * * * *  |
                     +-------------+
                            |
   +-------------+   +-------------+   +-------------+
   |    Tower    |---|   Village   |---|    Lake     |
   |      ||     |   |   [] [] []  |   |    -----    |
   +-------------+   +-------------+   +-------------+
                            |
                     +-------------+
                     |    Cave     |
                     |    [()]     |
                     +-------------+
                            |
                     +-------------+
                     |    Hills    |
                     |    ~ ~ ~    |
                     +-------------+

Where would you like to go? (1: North, 2: East, 3: South, 4: West, 5: Stay)
1

You move north to forest!
```   

### 5. Items (`items.clp`)
Handles:
- Inventory and equipment
- Dynamic item creation
- Stat scaling based on class, slot, and item level

```clips
----------------------------------------
What do you want to do? (Turn 5)
1: Player statistics
2: Manage inventory
3: Explore the forest
4: Move to another region
5: Quit
----------------------------------------
3

You explore the forest...
You found an item!

Item: mysterious-breastplate-of-war | PDmg: 0 | MDmg: 0 | CDmg: 0 | Arm: 2.25 | MRes: 0.75 | CRes: 0 | Price: 12 | Lvl: 1 | Cls: warrior | Slt: chestplate
Do you want to take it? (1: Take, 2: Sell, 3: Leave)
2

----------------------------------------
What do you want to do? (Turn 6)
1: Player statistics
2: Manage inventory
3: Explore the forest
4: Move to another region
5: Quit
----------------------------------------
```   

Item categories:
- weapon, side weapon, trinket  
- helmet, chestplate, leggings, boots  

Actions:
- Equip  
- Sell  
- Delete  
- Process newly found items  

```clips
----------------------------------------
What do you want to do? (Turn 3)
1: Player statistics
2: Manage inventory
3: Explore the forest
4: Move to another region
5: Quit
----------------------------------------
2

Manage your inventory:
(1: View Equipment, 2: View Items)
(3: Equip Item, 4: Sell Item, 5: Delete Item)
(6: Exit)
1

------ Equipped Items --------------------------------------------------------------------------------------------------------------------------
Eqp Item: weak-amulet | PDmg: 1 | MDmg: 1 | CDmg: 1 | Arm: 1 | MRes: 1 | CRes: 1 | Price: 12 | Lvl: 1 | Cls: warrior | Slt: trinket
Eqp Item: wooden-shield | PDmg: 0 | MDmg: 0 | CDmg: 0 | Arm: 3 | MRes: 1 | CRes: 2 | Price: 10 | Lvl: 1 | Cls: warrior | Slt: side
Eqp Item: leather-boots | PDmg: 0 | MDmg: 0 | CDmg: 0 | Arm: 1 | MRes: 1 | CRes: 1 | Price: 8 | Lvl: 1 | Cls: warrior | Slt: boots
Eqp Item: leather-leggings | PDmg: 0 | MDmg: 0 | CDmg: 0 | Arm: 2 | MRes: 1 | CRes: 1 | Price: 12 | Lvl: 1 | Cls: warrior | Slt: leggings
Eqp Item: leather-chestplate | PDmg: 0 | MDmg: 0 | CDmg: 0 | Arm: 3 | MRes: 1 | CRes: 2 | Price: 15 | Lvl: 1 | Cls: warrior | Slt: chestplate
Eqp Item: leather-helmet | PDmg: 0 | MDmg: 0 | CDmg: 0 | Arm: 1 | MRes: 1 | CRes: 1 | Price: 8 | Lvl: 1 | Cls: warrior | Slt: helmet
Eqp Item: rusty-sword | PDmg: 10 | MDmg: 0 | CDmg: 0 | Arm: 0 | MRes: 0 | CRes: 0 | Price: 10 | Lvl: 1 | Cls: warrior | Slt: weapon

Total: 7
------------------------------------------------------------------------------------------------------------------------------------------------

Manage your inventory:
(1: View Equipment, 2: View Items)
(3: Equip Item, 4: Sell Item, 5: Delete Item)
(6: Exit)
2

------ Inventory Items -------------------------------------------------------------------------------------------------------------------------
Item: wrong-cls-sword | PDmg: 4 | MDmg: 0 | CDmg: 0 | Arm: 0 | MRes: 0 | CRes: 0 | Price: 13 | Lvl: 1 | Cls: sorcerer | Slt: weapon
Item: higher-lvl-sword | PDmg: 5 | MDmg: 0 | CDmg: 0 | Arm: 0 | MRes: 0 | CRes: 0 | Price: 12 | Lvl: 2 | Cls: warrior | Slt: weapon
Item: good-sword | PDmg: 7 | MDmg: 0 | CDmg: 0 | Arm: 0 | MRes: 0 | CRes: 0 | Price: 11 | Lvl: 1 | Cls: warrior | Slt: weapon

Total: 3
------------------------------------------------------------------------------------------------------------------------------------------------

Manage your inventory:
(1: View Equipment, 2: View Items)
(3: Equip Item, 4: Sell Item, 5: Delete Item)
(6: Exit)
3

Enter the name of the item: 
good-sword

Unequipped rusty-sword from slot weapon.
Equipped good-sword in slot weapon.

Manage your inventory:
(1: View Equipment, 2: View Items)
(3: Equip Item, 4: Sell Item, 5: Delete Item)
(6: Exit)
1

------ Equipped Items --------------------------------------------------------------------------------------------------------------------------
Eqp Item: good-sword | PDmg: 7 | MDmg: 0 | CDmg: 0 | Arm: 0 | MRes: 0 | CRes: 0 | Price: 11 | Lvl: 1 | Cls: warrior | Slt: weapon
Eqp Item: weak-amulet | PDmg: 1 | MDmg: 1 | CDmg: 1 | Arm: 1 | MRes: 1 | CRes: 1 | Price: 12 | Lvl: 1 | Cls: warrior | Slt: trinket
Eqp Item: wooden-shield | PDmg: 0 | MDmg: 0 | CDmg: 0 | Arm: 3 | MRes: 1 | CRes: 2 | Price: 10 | Lvl: 1 | Cls: warrior | Slt: side
Eqp Item: leather-boots | PDmg: 0 | MDmg: 0 | CDmg: 0 | Arm: 1 | MRes: 1 | CRes: 1 | Price: 8 | Lvl: 1 | Cls: warrior | Slt: boots
Eqp Item: leather-leggings | PDmg: 0 | MDmg: 0 | CDmg: 0 | Arm: 2 | MRes: 1 | CRes: 1 | Price: 12 | Lvl: 1 | Cls: warrior | Slt: leggings
Eqp Item: leather-chestplate | PDmg: 0 | MDmg: 0 | CDmg: 0 | Arm: 3 | MRes: 1 | CRes: 2 | Price: 15 | Lvl: 1 | Cls: warrior | Slt: chestplate
Eqp Item: leather-helmet | PDmg: 0 | MDmg: 0 | CDmg: 0 | Arm: 1 | MRes: 1 | CRes: 1 | Price: 8 | Lvl: 1 | Cls: warrior | Slt: helmet

Total: 7
------------------------------------------------------------------------------------------------------------------------------------------------

Manage your inventory:
(1: View Equipment, 2: View Items)
(3: Equip Item, 4: Sell Item, 5: Delete Item)
(6: Exit)
2

------ Inventory Items -------------------------------------------------------------------------------------------------------------------------
Item: rusty-sword | PDmg: 10 | MDmg: 0 | CDmg: 0 | Arm: 0 | MRes: 0 | CRes: 0 | Price: 10 | Lvl: 1 | Cls: warrior | Slt: weapon
Item: wrong-cls-sword | PDmg: 4 | MDmg: 0 | CDmg: 0 | Arm: 0 | MRes: 0 | CRes: 0 | Price: 13 | Lvl: 1 | Cls: sorcerer | Slt: weapon
Item: higher-lvl-sword | PDmg: 5 | MDmg: 0 | CDmg: 0 | Arm: 0 | MRes: 0 | CRes: 0 | Price: 12 | Lvl: 2 | Cls: warrior | Slt: weapon

Total: 3
------------------------------------------------------------------------------------------------------------------------------------------------

Manage your inventory:
(1: View Equipment, 2: View Items)
(3: Equip Item, 4: Sell Item, 5: Delete Item)
(6: Exit)
6

----------------------------------------
What do you want to do? (Turn 4)
1: Player statistics
2: Manage inventory
3: Explore the forest
4: Move to another region
5: Quit
----------------------------------------
```   

### 6. Encounters (`encounters.clp`)
Exploration logic:
- 50% nothing  
- 20% item found  
- 30% enemy appears  
- Flee chance: **75%**

Enemy type chosen per region:
- tank  
- mage  
- assassin  

```clips
----------------------------------------
What do you want to do? (Turn 6)
1: Player statistics
2: Manage inventory
3: Explore the forest
4: Move to another region
5: Quit
----------------------------------------
3

You explore the forest...
--------------------------------------------------------------------------------------------------------------------------------------------------------------
You encounter a raven!
Enemy: raven | HP: 25 | Cls: mage | Str: 3 | Agi: 4 | Int: 8 | PDmg: 2 | MDmg: 7 | CDmg: 1.6 | Arm: 2 | MRes: 5 | CRes: 0.3 | Coins: 2 | Exp: 12
--------------------------------------------------------------------------------------------------------------------------------------------------------------

Do you want to fight? (1: Fight, 2: Flee)
1
----------------------------------------------------------

Choose an action: (1: Ability, 2: Consumable, 3: Stats)
1

--- Player's Turn -----------------------------------------
Normal Attacks:
1: Physical Attack, 2: Magic Attack, 3: Targeted Attack
Special Attacks:
4: Stunning Blow, 5: Skull Crusher, 6: Last Stand (EXTREME)
4
You use Stunning Blow! You deal 5% health damage and reduce AGI by 20%
The enemy resisted the stun!
-----------------------------------------------------------

--- Enemy's Turn -----------------------------------------
The enemy is thinking...
The enemy uses Curse! You suffer 5% health damage and lose 20% INT
You resist the curse!
----------------------------------------------------------

Choose an action: (1: Ability, 2: Consumable, 3: Stats)
1

--- Player's Turn -----------------------------------------
Normal Attacks:
1: Physical Attack, 2: Magic Attack, 3: Targeted Attack
Special Attacks:
4: Stunning Blow, 5: Skull Crusher, 6: Last Stand (EXTREME)
1
You use Physical Attack! You deal 18.0 damage to the enemy!
-----------------------------------------------------------

--- Enemy's Turn -----------------------------------------
The enemy is thinking...
The enemy uses Heal!
----------------------------------------------------------

Choose an action: (1: Ability, 2: Consumable, 3: Stats)
1

--- Player's Turn -----------------------------------------
Normal Attacks:
1: Physical Attack, 2: Magic Attack, 3: Targeted Attack
Special Attacks:
4: Stunning Blow, 5: Skull Crusher, 6: Last Stand (EXTREME)
1
You use Physical Attack! You deal 18.0 damage to the enemy!

You defeated the enemy!
You gained 2 coins and 12 experience!

Congratulations! You are now level 2. You have 3 skill points to allocate!
Choose a stat to increase! (1: Strength, 2: Agility, 3: Intelligence)
```

### 7. Enemies (`enemies.clp`)
Generates enemies with stats scaled to the player level and class:
- Tanks: high HP, armor, physical damage  
- Mages: high magic damage, intelligence  
- Assassins: high crit, agility  

```clips
What do you want to do? (Turn 10)
1: Player statistics
2: Manage inventory
3: Explore the forest
4: Move to another region
5: Quit
----------------------------------------
3

You explore the forest...
--------------------------------------------------------------------------------------------------------------------------------------------------------------
You encounter a boar!
Enemy: boar | HP: 100 | Cls: tank | Str: 14 | Agi: 6 | Int: 4 | PDmg: 16 | MDmg: 2 | CDmg: 1.2 | Arm: 12 | MRes: 8 | CRes: 0.4 | Coins: 6 | Exp: 30
--------------------------------------------------------------------------------------------------------------------------------------------------------------

Do you want to fight? (1: Fight, 2: Flee)
1
----------------------------------------------------------

Choose an action: (1: Ability, 2: Consumable, 3: Stats)
3

-----------------------
Player Stats:
Class: warrior
Health: 162.5
Strength: 15
Agility: 6
Intelligence: 2
Physical Damage: 8
Magical Damage: 1
Critical Damage: 1
Armor: 11
Magic Resist: 6
Critical Resist: 8
Coins: 514

-----------------------
Enemy Stats:
Class: tank
Health: 100
Strength: 14
Agility: 6
Intelligence: 4
Physical Damage: 16
Magical Damage: 2
Critical Damage: 1.2
Armor: 12
Magic Resist: 8
Critical Resist: 0.4
-----------------------
```

### 8. Combat (`combat.clp`)
Most complex module (>1000 lines).  
Implements:
- Physical, magical, and critical attacks  
- Special attacks using debuffs and mark system  
- Extreme abilities (once per fight for player, multiple for enemies)  
- Enemy AI with rule‑based decision tree:
  - Attempts kill combo if player is low  
  - Applies mark if preparing strong attack  
  - Uses sustain ability when low HP  
- The combat system is best understood through playtesting

## Notes

- Some balancing issues may exist due to scaling differences between classes/enemies.

