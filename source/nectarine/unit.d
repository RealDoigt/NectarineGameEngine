module nectarine.unit;
import std.traits;

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
        alias PUT = Percentage[UnitType];
        Space movementRange, attackRange;
        Damage healthPoints, attackPower;
        Percentage[UnitType] attackPowerVariation;
        bool hasMoved, hasAttacked, canAttackAfterMoving;
    }
    
    this(Space x, Space y, Space mr, Damage hp, Damage ap, Space ar = 1, bool caam = true, PUT apv = null)
    {
        super(x, y);
    }
}

class Unit(T, G) : Unit!(T, G, G)
{
    this(T x, T y, T mr, G hp, G ap, T ar = 1, bool caam = true, G[UnitType] apv = null)
    {
        super(x, y, mr, hp, ap, ar, caam, apv);
    }
}

class Unit(T) : Unit!(T, T, T)
{
    this(T x, T y, T mr, T hp, T ap, T ar = 1, bool caam = true, T[UnitType] apv = null)
    {
        super(x, y, mr, hp, ap, ar, caam, apv);
    }
}