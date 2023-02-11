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
        Space movementRange, attackRange;
        Damage healthPoints, attackPower;
        Percentage[UnitType] attackPowerVariation;
        bool hasMoved, hasAttacked, canAttackAfterMoving;
    }
    
    this(Space x, Space y)
    {
        super(x, y);
    }
}

class Unit(T, G) : Unit!(T, G, G)
{
    this(T x, T y)
    {
        super(x, y);
    }
}

class Unit(T) : Unit!(T, T, T)
{
    this(T x, T y)
    {
        super(x, y);
    }
}