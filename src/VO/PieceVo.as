package VO
{
public class PieceVo
{
    private var _xPos:Number;
    private var _yPos:Number;
    private var _source:String;

    public function PieceVo(piece:XML):void
    {
        _source = piece.@source;
        _xPos = piece.@x;
        _yPos = piece.@y;
    }

    public function get xPos():Number
    {
        return _xPos;
    }

    public function get yPos():Number
    {
        return _yPos;
    }

    public function get source():String
    {
        return _source;
    }


}
}
