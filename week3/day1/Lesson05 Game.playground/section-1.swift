// Playground - noun: a place where people can play

import UIKit


arc4random_uniform(20)

/*
Game has players
Game has player types:
Good guys
Bad guys
All players have 100 health to start with
Add different types of good guys and bad guys with their own special moves
Make it so players can only attack the opposite type (good can only attack bad and vice versa)
Default attack power to 20 points.
Attack status and player life is displayed on each attack.

Note: Instructors and TA’s to watch the teams to make sure that both students are comfortable embarking on the bonus content.

Bonus: Create a match class that starts a match and accepts a good  guy and a bad guy. Each player hits each other in turn until the other player is out of life.

Bonus 2: Make it so each attack does a random amount of damage between 0 and 20. If the attack does 0 damage, give the players feedback that the attack was blocked (give students hint: arcrandom_uniform method).
*/

class Player
{
    var health: Int = 100
    let name: String
    
    init(name: String)
    {
        self.name = name
    }
    
    func deductHealth(opponent: Player, damage: Int)
    {
        opponent.health -= damage
        
        // if negative health after deduction then set to 0
        if (opponent.health < 0)
        {
            opponent.health = 0
        }
    }
    
    // common attack across all players
    func punch(opponent: Player)
    {
        deductHealth(opponent, damage: 1 )
    }
}

class Goodie: Player
{
    func shoot(opponent: Baddie)
    {
        deductHealth(opponent, damage: 5)
    }
    
    func stab(opponent: Baddie)
    {
        deductHealth(opponent, damage: 1)
    }
    
    func punch(opponent: Baddie) -> Int
    {
        let damage = Int(arc4random_uniform(20))
        
        deductHealth(opponent, damage: damage )
        
        return damage
    }
}

class Baddie: Player
{
    func sword(opponent: Player)
    {
        deductHealth(opponent, damage: 10)
    }
    
    func punch(opponent: Goodie) -> Int
    {
        let damage = Int(arc4random_uniform(20))
        
        deductHealth(opponent, damage: damage )
        
        return damage
    }
}

protocol Match {
    func fight (player1: Player, player2: Player)
}

class PunchUp: Match
{
    func fight(player1: Player, player2: Player)
    {
        // loop until a goodie or a badie
        while (player1.health > 0 && player2.health > 0)
        {
            player1.punch(player2)
            player2.punch(player1)
        }
    }
}

var me = Goodie(name: "nick")
var ryan = Baddie(name: "ryan")

me.stab(ryan)
ryan.health

var match = PunchUp()

match.fight(me, player2: ryan)

me.health
ryan.health



