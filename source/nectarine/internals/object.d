module nectarine.internals.object;
import std.trait;

class NectarineObject(T) if (isNumeric!(T))
{
    protected T x, y;
    
    this(T x, T y)
    {
        this.x = x;
        this.y = y;
    }
}