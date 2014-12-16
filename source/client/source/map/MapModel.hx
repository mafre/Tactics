package map;

import flash.display.Sprite;
import flash.geom.Point;
import flash.Vector;
import openfl.Assets;
import haxe.Json;
import haxe.ds.IntMap;

import statm.explore.haxeAStar.AStar;
import statm.explore.haxeAStar.IAStarClient;
import statm.explore.haxeAStar.IntPoint;
import statm.explore.haxeAStar.Node;

import common.Array2D;
import common.StageInfo;
import enemy.Enemy;

enum GroundType
{
    Unknown;
    Empty;
    Grass;
    Swamp;
    Snow;
    Rock;
    Water;
    Ice;
}

enum ObstacleType
{
    Empty;
    Unknown;
    Rock1;
    Tree1;
}

class MapModel
{
    private var maps:Array<Map>;

    public function new():Void
    {
        maps = [];
    };

    public function load():Void
    {
        var json:Dynamic = Json.parse(Assets.getText("assets/json/maps.json"));

        for (n in Reflect.fields(json.maps))
        {
            var level:Dynamic = Reflect.field(json.maps, n);
            var mapName:String = Std.string(n);
            var width:Int = level.width;
            var height:Int = level.height;
            var startPositions:IntMap<Point> = new IntMap<Point>();

            for(m in Reflect.fields(level.startPositions))
            {
                var id:Int = Std.parseInt(m);
                var pos:Array<Int> = Reflect.field(level.startPositions, m);
                var p:Point = new Point(pos[0], pos[1]);
                startPositions.set(id, p);
            }

            var map:Map = new Map(mapName, width, height, startPositions);

            var enemies:Array<Dynamic> = level.enemies;
            if(enemies != null)
            {
                for (aEnemy in enemies)
                {
                    var id:Int = aEnemy.id;
                    var position:Array<Int> = aEnemy.position;

                    map.set_enemy(position[0], position[1], id);
                }
            }

            var obstacles:Array<Dynamic> = level.obstacles;
            if(obstacles != null)
            {
                for (aObstacle in obstacles)
                {
                    var id:Int = aObstacle.id;
                    var position:Array<Int> = aObstacle.position;

                    map.set_obstacle(position[0], position[1], id);
                }
            }

            maps.push(map);
        };
    };

    public function getMap(index:Int):Map
    {
        return maps[index];
    }
}

class Map implements IAStarClient
{
    private var height : Int;
    private var width : Int;
    private var mapName : String;
    private var startPositions:IntMap<Point>;
    private var characterPosition:Point;

    private var ground_height : Array2D;
    private var ground_type : Array2D;
    private var obstacles : Array2D;
    private var characters : Array2D;
    private var enemies : Array2D;
    private var target : Array2D;

    public var rowTotal(default, null):Int;
    public var colTotal(default, null):Int;

    public function new(aMapName:String, aWidth:Int, aHeight:Int, aStartPositions:IntMap<Point>)
    {
        mapName = aMapName;
        width = aWidth;
        height = aHeight;
        startPositions = aStartPositions;

        rowTotal = aWidth;
        colTotal = aHeight;

        ground_height = new Array2D(width, height);
        ground_type = new Array2D(width, height);
        obstacles = new Array2D(width, height);
        characters = new Array2D(width, height);
        enemies = new Array2D(width, height);
        target = new Array2D(width, height);
    }

    public function setCharacterPosition(aPosition:Point):Void
    {
        characterPosition = aPosition;
        AStar.getAStarInstance(this).updateMap();
    }

    public function isWalkable(x:Int, y:Int):Bool
    {
        if(get_character(x, y) != 0)
        {
            if(characterPosition.x == x && characterPosition.y == y)
            {
                return true;
            }

            return false;
        }

        if(get_enemy(x, y) != 0)
        {
            return false;
        }

        if(get_obstacle(x, y) != ObstacleType.Empty)
        {
            return false;
        }

        return !is_occupied(x, y);
    }

    public function getPath(startPos:Point, endPos:Point):Vector<IntPoint>
    {
        var p1:IntPoint = new IntPoint();
        p1.x = Std.int(startPos.x);
        p1.y = Std.int(startPos.y);

        var p2:IntPoint = new IntPoint();
        p2.x = Std.int(endPos.x);
        p2.y = Std.int(endPos.y);

        return AStar.getAStarInstance(this).findPath(p1, p2);
    }

    public function get_mapName():String
    {
        return mapName;
    }

    public function get_width():Int
    {
        return width;
    }

    public function get_height():Int
    {
        return height;
    }

    public function get_start_x_position(aPlayOrder:Int):Int
    {
        return cast(startPositions.get(aPlayOrder).x, Int);
    }

    public function get_start_y_position(aPlayOrder:Int):Int
    {
        return cast(startPositions.get(aPlayOrder).y, Int);
    }

    public function is_occupied(i : Int, j : Int) : Bool
    {
        if( (Type.createEnumIndex(ObstacleType, obstacles.get(i, j)) != ObstacleType.Empty) || (enemies.get(i, j) > 0) || (characters.get(i, j) > 0))
        {
            return true;
        }

        return false;
    }

    private function is_outside(i : Int, j : Int) : Bool
    {
        return i < 0 || i >= width || j < 0 || j >= height;
    }

    public function get_ground_height(i : Int, j : Int) : Int
    {
        if (is_outside(i, j))
        {
            return -1;
        }

        return ground_height.get(i, j);
    }

    public function get_ground_type(i : Int, j : Int) : GroundType
    {
        if (is_outside(i, j))
        {
            return GroundType.Unknown;
        }

        return Type.createEnumIndex(GroundType, ground_type.get(i, j));
    }

    public function get_obstacle(i : Int, j : Int) : ObstacleType
    {
        if (is_outside(i, j))
        {
            return ObstacleType.Unknown;
        }

        return Type.createEnumIndex(ObstacleType, obstacles.get(i, j));
    }

    public function set_obstacle(i : Int, j : Int, aValue : Int) : Void
    {
        obstacles.set(i, j, aValue);
    }

    public function get_target(i : Int, j : Int) : Int
    {
        if (is_outside(i, j))
        {
            return -1;
        }

        return target.get(i, j);
    }

    public function set_target(i : Int, j : Int, aValue : Int) : Void
    {
        target.set(i, j, aValue);
    }

    public function get_character(i : Int, j : Int) : Int
    {
        if (is_outside(i, j))
        {
            return -1;
        }

        return characters.get(i, j);
    }

    public function set_character(i : Int, j : Int, aValue : Int) : Void
    {
        characters.set(i, j, aValue);
    }

    public function move_character(aValue : Int, x : Int, y : Int) : Void
    {
        characters.move(aValue, x, y);
    }

    public function find_character(aValue:Int):Point
    {
        return characters.find(aValue);
    }

    public function remove_character(aValue:Int):Void
    {
        characters.remove(aValue);
    }

    public function getAllCharacterPositions():Array<Point>
    {
        return characters.getAllOccupiedPositions();
    }

    public function get_enemy(i : Int, j : Int) : Int
    {
        if (is_outside(i, j))
        {
            return -1;
        }

        return enemies.get(i, j);
    }

    public function find_enemy(aValue:Int):Point
    {
        return enemies.find(aValue);
    }

    public function remove_enemy(aValue:Int):Void
    {
        enemies.remove(aValue);
    }

    public function getAllEnemyPositions():Array<Point>
    {
        return enemies.getAllOccupiedPositions();
    }

    public function set_enemy(i : Int, j : Int, aValue : Int) : Void
    {
        enemies.set(i, j, aValue);
    }

    public function get_value(i : Int, j : Int) : Int
    {
        var value : Int = enemies.get(i, j);

        if(value == 0)
        {
            value = characters.get(i, j);
        }

        return value;
    }

    public function getAllUnitPositionsExcept(aValue:Int):Array<Point>
    {
        var a:Array<Point> = enemies.getAllOccupiedPositionsExcept(aValue);
        a = a.concat(characters.getAllOccupiedPositionsExcept(aValue));
        return a;
    }
}