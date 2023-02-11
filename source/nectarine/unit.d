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
        bool canAttackAfterMoving;
        PUT attackPowerVariations;
        Space movementRange, attackRange;
        Damage healthPoints, healthPointsInit, attackPower;
        
        auto getHealthPointsPercentage()
        {
            return healthPoints / healthPointsInit * 100;
        }
    }
    
    package bool hasMoved, hasAttacked;
    
    this(Space x, Space y, UT ut, Space mr, Damage hp, Damage ap, Space ar = 1, bool caam = true, PUT apv = null)
    {
        super(x, y);
        
        type = ut;
        
        attackRange = ar;
        attackPower = ap;
        
        movementRange = mr;
        
        healthPoints = hp;
        healthPointsInit = hp;
        
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
        auto defense = occupied.getDefenseBonus / unit.getHealthPointsPercentage * 100;
        Damage attack;
        
        if (unit.getType !in attackPowerVariations)
            attack = attackPower / getHealthPointsPercentage * 100;
            
        else
            attack = (attackPower / attackPowerVariations[unit.getType] * 100) / getHealthPointsPercentage * 100;
        
        return attack - defense;
    }
    
    auto canAttack()
    {
        if (hasAttacked) return false;
        if (!canAttackAfterMoving) return !hasMoved;
        
        return true;
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