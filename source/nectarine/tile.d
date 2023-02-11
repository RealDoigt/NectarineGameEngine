module nectarine.tile;
import nectarine;

class Tile(T) : NectarineObject!T
{
    private 
    {
        byte[UnitType] crossingCosts;
        T defenseBonus;
    }
    
    this(T x, T y, T defenseBonus, UnitType[] canCross ...)
    {
        super(x, y);
        this.defenseBonus = defenseBonus;
        foreach(unit; canCross) crossingCosts[unit] = 1;
    }
    
    this(T x, T y, T defenseBonus, byte[UnitType] crossingCosts)
    {
        super(x, y);
        this.defenseBonus = defenseBonus;
        this.crossingCosts = crossingCosts;
    }
    
    auto canCross(UnitType unit)
    {
        return getCrossingCost(unit) != 0;
    }
    
    auto getCrossingCost(UnitType unit)
    {
        return unit !in crossingCosts ? 0 : crossingCosts[unit];
    }
}