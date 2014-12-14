package common;

import haxe.ds.Vector;
import flash.geom.Point;

class Array2D
{
    private var data : Vector<Vector<Int>>;
    private var width : Int;
    private var height : Int;

    public function new(w : Int, h : Int)
    {
        width = w;
        height = h;

        data = new Vector<Vector<Int>>(width);
        for (i in 0 ... width)
        {
            data[i] = new Vector<Int>(height);

            for (j in 0 ... height)
            {
                data[i][j] = 0;
            }
        }
    }

    private function is_outside(i : Int, j : Int) : Bool
    {
        return i < 0 || i >= width || j < 0 || j >= height;
    }

    public function set(i : Int, j : Int, value : Int) : Void
    {
        if (is_outside(i, j))
        {
            return;
        }

        data[i][j] = value;
    }

    public function get(i : Int, j : Int) : Int
    {
        if (is_outside(i, j))
        {
            return -1;
        }

        return data[i][j];
    }

    public function getAllOccupiedPositions():Array<Point>
    {
        var a:Array<Point> = [];

        for (i in 0 ... width)
        {
            for (j in 0 ... height)
            {
                if(data[i][j] != 0)
                {
                    var p:Point = new Point(i, j);
                    a.push(p);
                }
            }
        }

        return a;
    }

    public function find(aValue:Int):Point
    {
        for (i in 0 ... width)
        {
            for (j in 0 ... height)
            {
                if(data[i][j] == aValue)
                {
                    return new Point(i, j);
                }
            }
        }

        return null;
    }

    public function move(aValue:Int, x:Int, y:Int):Void
    {
        var currentPos:Point = find(aValue);

        if(currentPos != null)
        {
            set(cast(currentPos.x, Int), cast(currentPos.y, Int), 0);
            set(x, y, aValue);
        }
    }
}