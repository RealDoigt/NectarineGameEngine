module nectarine.unit;
import std.traits;
import nectarine;

enum UnitType
{
    infantry,
    cavalry,
    naval,
    air
}

class Unit(Space, Damage, Percentage) : NectarineObject!Space if (isNumeric!(Damage) && isNumeric(Percentage))
{
    private
    {
        alias UT = UnitType;
        alias PUT = Percentage[UT];
        
        UT type;
        PUT attackPowerVariations;
        Space movementRange, attackRange;
        Damage healthPoints, attackPower;
        bool hasMoved, hasAttacked, canAttackAfterMoving;
    }
    
    this(Space x, Space y, UT ut, Space mr, Damage hp, Damage ap, Space ar = 1, bool caam = true, PUT apv = null)
    {
        super(x, y);
        
        type = ut;
        
        attackRange = ar;
        attackPower = ap;
        
        healthPoints = hp;
        movementRange = mr;
        
        canAttackAfterMoving = caam;
    }
    
    auto getHealthPoints()
    {
        return healthPoints;
    }
    
    auto getType()
    {
        return type;
    }
    
    auto getDamageFor(Unit unit, Tile occupied)
    {
        auto defense = unit.getHealthPoints / occupied.getDefenseBonus * 100;
        Damage attack;
        
        if (unit.getType !in attackPowerVariations)
            attack = attackPower / healthPoints * 100;
            
        else
            attack = (attackPower / attackPowerVariations * 100) / healthPoints * 100;
        
        return attack - defense;
    }
}

class Unit(T, G) : Unit!(T, G, G)
{
    this(T x, T y, UnitType ut, T mr, G hp, G ap, T ar = 1, bool caam = true, G[UnitType] apv = null)
    {
        super(x, y, ut, mr, hp, ap, ar, caam, apv);
    }
}

class Unit(T) : Unit!(T, T, T)
{
    this(T x, T y, UnitType ut, T mr, T hp, T ap, T ar = 1, bool caam = true, T[UnitType] apv = null)
    {
        super(x, y, ut, mr, hp, ap, ar, caam, apv);
    }
}