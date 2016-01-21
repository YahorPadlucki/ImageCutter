package
{
import VO.PieceVo;

import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;

public class PicturePiece extends Sprite
{
    private var _loader:Loader = new Loader();

    public function PicturePiece(info:PieceVo)
    {
        loadImage(info.source);
        _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
    }

    private function onLoad(event:Event):void
    {
        var view:DisplayObject = _loader.content;
        addChild(view);
    }

    private function loadImage(url:String):void
    {
        _loader.load(new URLRequest(url));
    }
}
}
