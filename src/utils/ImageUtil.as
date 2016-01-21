package utils
{
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import silin.filters.ColorAdjust;

public class ImageUtil
{
    private static const ORIGIN:Point = new Point();

    public function ImageUtil()
    {
    }

    public static function fillZone(bmd:BitmapData, x:int, y:int, color:int, tol:int = 64):void
    {
        var wandColor:int = bmd.getPixel(x, y);

        var tmp:BitmapData = new BitmapData(bmd.width, bmd.height, false, wandColor);
        tmp.draw(bmd, null, null, BlendMode.DIFFERENCE);

        var clrMtrx:ColorAdjust = new ColorAdjust();
        clrMtrx.setChannels(0, 0, 7);
        tmp.applyFilter(tmp, tmp.rect, ORIGIN, clrMtrx.filter);
        tmp.threshold(tmp, tmp.rect, ORIGIN, "<=", tol, 0x0, 0xFF);
        tmp.floodFill(x, y, 0xFF000000);
        bmd.threshold(tmp, tmp.rect, ORIGIN, "==", 0xFF000000, color | 0xFF000000);

    }

    public static function setAlpha(shape:BitmapData, picture:BitmapData, srcRect:Rectangle, color:uint):void
    {

        for (var i:int = 0; i < srcRect.width; i++)
        {
            for (var j:int = 0; j < srcRect.height; j++)
            {

                var currentPixel:uint = shape.getPixel32(i, j);
                if (currentPixel != color && checkPixels(i, j, shape, color, picture))
                {
                    shape.setPixel32(i, j, 0x00000000);
                    picture.setPixel32(i, j, 0x00000000);
                }


            }
        }

    }
   
    public static function setScaleBitmapData(sourceBitmapData:BitmapData,scale:Number):BitmapData
    {
        var matrix:Matrix = new Matrix();
        matrix.scale(scale, scale);
        var finalBitmapData:BitmapData = new BitmapData(sourceBitmapData.width * scale, sourceBitmapData.height * scale, true, 0x000000);
        finalBitmapData.draw(sourceBitmapData, matrix, null, null, null, true);

        return finalBitmapData;
    }
   



    private static function checkPixels(x:int, y:int, shape:BitmapData, color:uint, picture):Boolean
    {
        var radius:int = 2;
        var points:Array = [];

        for (var x1:int = x - radius; x1 <= x + radius; x1++)
        {
            for (var y1:int = y - radius; y1 <= y + radius; y1++)
            {
                if (shape.getPixel32(x1, y1) == color)
                {
                    var pos:Point = new Point(x, y);
                    var pos2:Point = new Point(x1, y1);
                    var dist:Number = pos.subtract(pos2).length;

                    if (Math.abs(x1 - x) >= 1 || Math.abs(y1 - y) >= 1)
                        points.push(dist);
                }
            }
        }

        if (points.length)
        {
            var dist:Number = points[0];
            for (var i:int = 1; i < points.length; i++)
            {
                var other:Number = points[i];
                if (other < dist)
                    dist = other;
            }
            
//            var alpha:Number = 1;
            var alpha:Number = 1 - dist / Math.sqrt(radius * radius + radius * radius) ;

            if (dist <= 1)
            {
                var color:uint = (uint(Number(0xFF) * alpha) << 24) + (0x00ffffff & picture.getPixel32(x, y));
                picture.setPixel32(x, y, color);
            }
            else
            {
                var color:uint = (uint(Number(0xFF) * alpha) << 24) + (0x00ffffff & picture.getPixel32(x, y));
                picture.setPixel32(x, y, color);
            }
            return false;
        }

        return true;
    }
}
}
