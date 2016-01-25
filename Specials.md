## Index ##
  * [Main Page](http://code.google.com/p/gfplus/)
  * [Plans](plans.md)
  * Upgrades, Special items, and Special Weapons
  * [How to play](Gameplay.md)
  * [Vehicles](Vehicles.md)
  * [Awards](Awards.md)
  * [Ranks](Ranks.md)

### Upgrades ###
**TIP:** Additive Cost means that it will cost +# more UP for each additional level that you purchase.
|**Name**|**Effect**|**Notes**|**Initial Cost/Additive Cost**|**Maximum Level**|
|:-------|:---------|:--------|:-----------------------------|:----------------|
|Health Upgrade|Adds 25 to your maximum health|Useful for surviving an assault on an enemy base or defending against 1-hit sniper kills. Can be combined with Armor and Weapon Upgrades to become a 'Juggernaught'.|10/+5                         |4                |
|Armor Upgrade|Adds 25 to your maximum armor|Useful for surviving an assault on an enemy base or defending against 1-hit sniper kills. Can be combined with Health and Weapon Upgrades to become a 'Juggernaught'.|10/+5                         |4                |
|Weapon Upgrade|Increases the damage your weapons inflict (varies from weapon to weapon)|Useful for taking out people with health and/or armor upgrades. Can be combined with Health and Armor Upgrades to become a 'Juggernaught'|10/+5                         |4                |
|Speed Upgrade|Increases your movement speed|Very useful for running across the map quickly and getting past obstacles such as crawltunnels set up to deter attackers by reducing the speed at which they walk and making them an easy target.|10/+5                         |4                |

### Beacons ###

Beacons benefit you and all surrounding friendly players in unique ways depending on their type. Certain beacons may also be deployable to a location, although they disappear when their owner is killed. The benefits are more abstract than percentage bonuses in most cases, as shown below.
N.B. where this overlaps with the basic upgrades design decisions are yet to be made.

|**Name**|**Effects by Level**|**Notes**|**Initial Cost/Additive Cost**|**Observations**|
|:-------|:-------------------|:--------|:-----------------------------|:---------------|
|Marksman Beacon|L1: Players have reduced recoil when firing. L2: Players do not suffer accuracy penalties for standing/not crouching. L3: Recoil directs a player's crosshair towards enemies, negative recoil being completely nullified.|The L1 effect stacks if neccessary with diminishing returns. The beacon can be deployed in a bunker to benefit all players using the bunker, without the beacon owner even being present.|5/+5                          |The beacon has no effect on weapon damage.|
|Protector Beacon|L1: Players take 2 points less damage from any incoming attack. L2: Players take 15% less damage from incoming attacks whilst crouching. L3: Players must be reduced to 1 health before an attack can put them below 1 health.|No effects stack. This again can be used for bunkers although it is also appropriate for assaults (up to L2).|10/+5                         |                |
|Assault Beacon|L1: Players move faster. L2: Players can fire (and reload?) faster. L3: Players receive no accuracy penalties for swimming or being in mid-air and gain speed whilst jumping.|The L1 effect stacks with diminishing returns. Increased movement speed and ROF will in turn make aiming proportionately more difficult.|10/+5                         |None            |
|Resupply Beacon|L1: Players regain magazines of ammunition at a moderate rate. L2: Players can be restocked of grenades at a slow rate. L3: A deployed beacon or a player crouched with the beacon resupplies all players 4x as fast to 200% of their carrying capacity.|Resupply rates stack with diminishing returns. Players can only be restocked of equipment they respawned with last.|5/+5                          |None            |


### Special Items ###
|**Name**|**Purpose**|**Notes**|**Types**|**Initial Cost/Additive Cost**|**Effects by Level**|
|:-------|:----------|:--------|:--------|:-----------------------------|:-------------------|
|Deployable Radar|A radar dish that detects intruders in a set radius around itself and displays them on your minimap and HUD.|Extremely useful for defending important areas because it gives you and your team early warning and provides HUD icons for easy location of the enemy.|Small Radar/Large Radar|Small Radar=10/+5 ; Large Radar=20/+10|L1: Small detection radius. L2: Medium detection radius. L3: Very large detection radius.|
|Deployable Turret|A popup turret that attacks intruders within its line-of-sight.|Very useful for controlling chokepoints or defending important areas. Can be used for offensive purposes but due to its long deploy time, the enemy may kill the deploying teammates.|Anti-Infantry Turret/Anti-Vehicle Turret|Anti-Infantry Turret=15/+10 ; Anti-Vehicle Turret=20/+10|L1: Small detection and weapons range, low damage. L2: Medium detection radius and weapons range, medium damage, increased HP, anti-vehicle turrets shoot explosive rounds. L3: Large detection and weapons range, high damage, further increased HP, Turrets partially cloak when not firing.|
|Deployable Spawner|Once deployed, players may spawn building blocks using this Special Item.|Useful if you wish to make a forward outpost or small base somewhere away from your main spawners, the only drawback is that you cannot spawn any of the more advanced blocks or Special Items.|N/A      |10/+5                         |L1: Able to spawn basic building blocks. L2: Able to spawn basic Special Items.|
|Deployable Shield Generator|The Shield Generator creates a shield around a predefined radius that stops bullets and projectiles but lets players through until either A) The shield is destroyed by concentrated fire, or B) The shield generator is removed.|Primarily used for protecting an area from enemy fire while players build within the shield or to provide protection from incoming enemies, can be used offensively as a safe haven within which to spawn but concentrated fire from defenders can destroy the shield.|Small Shield Generator/Large Shield Generator|Small Shield Generator=15/+5 ; Large Shield Generator=30/+10|L1: Small shield radius, low shield points. L2: Medium shield radius, medium shield points. L3: Large shield radius, high shield points, reflects enemy fire.|

### Special Weapons ###
|**Name**|**Projectile type**|**Initial Cost/Additive Cost**|**Notes**|**Effects by Level**|
|:-------|:------------------|:-----------------------------|:--------|:-------------------|
|RPG Launcher|Explosive          |10/+10                        |Can destroy enemy bases. Vehicles take full damage from an RPG round.|L1: Shoots RPG rounds that fly in a straight path. L2: Increased damage, increased max ammunition, and can lock onto enemy vehicles and track them to a limited extent. L3: Improved tracking and further increased damage and max ammunition|
|C4      |Explosive          |20/+15                        |The ultimate weapon for destroying bases but you are extremely vulnerable while deploying it. You must also defend the deployed C4 because enemy players can disarm it before it detonates.|L1: Deploys a C4 explosive that detonates after a set period of time. L2: Decreased deploy time, increased blast radius. L3: Furthur decreased deploy time, increased blast radius, partially cloaked once deployed.|
|Mass Destabilization Beam (MDB)|N/A                |15/+10                        |A specialized weapon perfect for breaching an enemy base. An enemy prop that is subjected to this weapon will slowly destabilize until it is completely dissolved. You are vulnerable while destabilizing a prop and may be attacked.|L1: Slowly destabilizes props. L2: Faster destabilization rate. L3: Even faster destabilization rate.|
|MDB Grenade|N/A                |15/+10                        |Similar to the Mass Destabilization Beam, except the grenade may be tossed and destabilizes props around it until the grenade is destroyed or its energy is depleted.|L1: 10 seconds of energy. L2: 15 seconds of energy. L3: 20 seconds of energy.|