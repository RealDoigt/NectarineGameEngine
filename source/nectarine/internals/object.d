module nectarine.internals.object;
import std.traits;

class NectarineObject(T) if (isNumeric!(T))
{
    private string name;

    protected 
    {
        T x, y;
        
        void setPosition(T x, T y)
        {
            this.x = x;
            this.y = y;
        }
    }
    
    this(T x, T y, string name)
    {
        this.x = x;
        this.y = y;
        this.name = name;
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