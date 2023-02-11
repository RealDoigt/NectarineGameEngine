module nectarine.internals.object;
import std.traits;

class NectarineObject(T) if (isNumeric!(T))
{
    protected T x, y;
    
    this(T x, T y)
    {
        this.x = x;
        this.y = y;
    }
    
    T getX()
    {
        return x;
    }
    
    T getY()
    {
        return y;
    }
}