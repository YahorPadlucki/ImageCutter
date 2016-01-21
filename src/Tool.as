package
{
import VO.Model;
import VO.PieceVo;

import events.XMLParsedEvent;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

import mx.graphics.codec.PNGEncoder;

import utils.FileSaver;
import utils.ImageUtil;
import utils.XMLGenerator;
import utils.XMLLoader;

public class Tool extends Sprite
{

//    [SWF(backgroundColor="0x666666", width=1500, height=1500)]  ?
    private var _shapeMC:ShapeMC = new ShapeMC();
    private var _shapeBitmapData:BitmapData = new BitmapData(_shapeMC.width, _shapeMC.height);
    private var _shapeBitmap:Bitmap;

    private var _colorsToPaint:Array = [];
    private var _colors:Array = [];

    private var _pngEncoder = new PNGEncoder();

    private var _pictureBitmap:Picture = new Picture();
    private var _xmlData:String = '';

    private const TOLERANCE:int = 10;
    private const SCALE:Number = 0.5;


    public function Tool()
    {

        _shapeBitmapData.draw(_shapeMC, null, null, null, null, false);
        _shapeBitmap = new Bitmap(_shapeBitmapData, "auto", false);

        addChild(_shapeBitmap);
        colorPieces();
    }

    private function colorPieces():void
    {
        for (var i:int = 0; i <= _shapeMC.width; i++)
        {
            for (var j:int = 0; j <= _shapeMC.height; j++)
            {

                if (_shapeBitmap.hitTestPoint(i, j))
                {
                    if (ImageUtil.luminance(_shapeBitmap.bitmapData.getPixel(i, j)) == 255)
                    {
                        var color:uint = selectColor();

                        ImageUtil.fillZone(_shapeBitmap.bitmapData, i, j, color, 50);
                        _colors.push(_shapeBitmap.bitmapData.getPixel32(i, j));
                    }
                }

            }
        }
        cutImageToPieces();
     
    }

    private function selectColor():uint
    {
        var color:uint = Math.random() * 0xFFFFFF;
        for each (var col:uint in _colorsToPaint)
        {
            if (col == color)
                color = selectColor();
        }
        _colorsToPaint.push(color);
        return color;
    }


    private function cutImageToPieces():void
    {

//        FileSaver.clearDirectory();
        for each (var color:uint in _colors)
        {
            var rect:Rectangle = rectToCut(color);
            if (rect.width < TOLERANCE)continue;
            var saveShapeData:BitmapData = ImageUtil.getBitmapData(_shapeBitmap.bitmapData, rect);
            var savePictureData:BitmapData = ImageUtil.getBitmapData(_pictureBitmap.bitmap.bitmapData, rect);

            ImageUtil.setAlpha(saveShapeData, savePictureData, rect, color);

            savePictureData = ImageUtil.setScaleBitmapData(savePictureData, SCALE);

            var byteArray:ByteArray = _pngEncoder.encode(savePictureData);

            FileSaver.saveBinary(byteArray, color.toString() + ".png");

            _xmlData += XMLGenerator.pieceBlock(color.toString() + ".png", rect.x * SCALE, rect.y * SCALE) + '\n';

        }
        FileSaver.saveFile('<puzzle><row>' + _xmlData + '</row></puzzle>');
    }


    private function rectToCut(color:uint):Rectangle
    {
        var rect:Rectangle = _shapeBitmap.bitmapData.getColorBoundsRect(0xFFFFFFFF, color);

        var additionalRadius:int = 2;
        return new Rectangle(rect.x - additionalRadius, rect.y - additionalRadius, rect.width + 2 * additionalRadius, rect.height + 2 * additionalRadius);
    }


}
}
