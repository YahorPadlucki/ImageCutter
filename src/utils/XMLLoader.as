package utils
{
import VO.Model;
import VO.PieceVo;

import events.XMLParsedEvent;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class XMLLoader extends EventDispatcher
{
    private var _xmlLoader:URLLoader = new URLLoader();

    public function XMLLoader()
    {
        _xmlLoader.addEventListener(Event.COMPLETE, parseXML);
    }

    private function parseXML(event:Event):void
    {

        if (event.target.data)
        {

            var puzzle:XML = XML(event.target.data);
            for each (var piece:XML in puzzle.row.piece)
            {
                var p:PieceVo = new PieceVo(piece);
                Model.pieces.push(p);
            }
        }
        dispatchEvent(new XMLParsedEvent('parsed'));
    }

    public function loadXML(url:String):void
    {

        _xmlLoader.load(new URLRequest(url));
    }


}
}
