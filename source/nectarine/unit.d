module nectarine.unit;
import std.traits;
import nectarine;
import std.math;

enum UnitType
{
    infantry,
    cavalry,
    naval,
    air
}

class Unit(Space, Hitpoints, Percentage) : NectarineObject!Space if (isNumeric!(Hitpoints) && isNumeric(Percentage))
{
    private
    {
        alias UT = UnitType;
        alias PUT = Percentage[UT];

        UT type;
        bool canAttackAfterMoving;
        PUT attackPowerVariations;
        Space movementRange, attackRange;
        Hitpoints healthPointsInit, attackPower;
    }
    
    protected
    {
        Hitpoints healthPoints;
        bool hasMoved, hasAttacked;
        
        auto getHealthPointsPercentage()
        {
            return healthPoints / healthPointsInit * 100;
        }
    }
    
    this
    (
        Space x,
        Space y,
        UT type,
        Space movementRange,
        Hitpoints healthPoints,
        Hitpoints attackPower,
        string name,
        Space attackRange = 1,
        bool canAttackAfterMoving = true,
        PUT attackPowerVariations = null
    )
    {
        super(x, y, name);

        this.type = type;
        
        this.attackRange = attackRange;
        this.attackPower = attackPower;
        
        this.movementRange = movementRange;
        
        this.healthPoints = healthPoints;
        this.healthPointsInit = healthPoints;
        
        this.canAttackAfterMoving = canAttackAfterMoving;
    }
    
    auto getHealthPointsInit()
    {
        return healthPointsInit;
    }
    
    auto getHealthPoints()
    {
        return healthPoints;
    }
    
    auto getType()
    {
        return type;
    }
    
    auto getAttackPower()
    {
        return attackPower;
    }
    
    auto getAttackRange()
    {
        return attackRange;
    }
    
    auto getGoodMatchups()
    {
        UnitType[] units;
        
        foreach(key, value; attackPowerVariations)
            if (value > 100) units ~= key;
            
        return units;
    }
    
    auto getBadMatchups()
    {
        UnitType[] units;
        
        foreach(key, value; attackPowerVariations)
            if (value < 100) units ~= key;
            
        return units;
    }
    
    auto getHasMoved()
    {
        return hasMoved;
    }
    
    auto getHasAttacked()
    {
        return hasAttacked;
    }
    
    auto getMovementRange()
    {
        return movementRange;
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
    
    void invertHasMoved()
    {
        hasMoved = !hasMoved;
    }
    
    void invertHasAttacked()
    {
        hasMoved = !hasMoved;
    }
    
    void setHealthPoints(Hitpoints value)
    {        
        healthPoints = value >= 0 ? value <= healthPointsInit ? value : healthPointsInit : 0; 
    }
    
    void damage(Hitpoints value)
    {
        auto newValue = healthPoints - value.abs;
        healthPoints = newValue >= 0 ? newValue : 0;
    }
    
    void heal(Hitpoints value)
    {
        auto newValue = healthPoints + value.abs;
        healthPoints = newValue <= healthPointsInit ? newValue : healthPointsInit;
    }
}

class Unit(T, G) : Unit!(T, G, G)
{
    this(T x, T y, UnitType ut, T mr, G hp, G ap, string n, T ar = 1, bool caam = true, G[UnitType] apv = null)
    {
        super(x, y, ut, mr, hp, ap, n, ar, caam, apv);
    }
}

class Unit(T) : Unit!(T, T, T)
{
    this(T x, T y, UnitType ut, T mr, T hp, T ap, string n, T ar = 1, bool caam = true, T[UnitType] apv = null)
    {
        super(x, y, ut, mr, hp, ap, ar, caam, apv);
    }
}