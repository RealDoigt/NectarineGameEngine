module nectarine.tile;
import nectarine;

class Tile(T) : NectarineObject!T
{
    private byte[UnitType] crossingCosts;
    
    this(T x, T y, UnitType[] canCross ...)
    {
        super(x, y);
        foreach(unit; canCross) crossingCosts[unit] = 1;
    }
    
    auto canCross(UnitType unit)
    {
        return !(unit !in crossingCosts || crossingCosts[unit] == 0);
    }
    
    auto getCrossingCost(UnitType unit)
    {
        return unit !in crossingCosts ? 0 : crossingCosts[unit];
    }
}