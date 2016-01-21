package
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;

public class Picture
{
    private var _picture:MovieClip = new PictureMC();
    private var _bitmapData:BitmapData = new BitmapData(_picture.width, _picture.height);
    private var _bitmap:Bitmap

    public function Picture()
    {
        _bitmapData.draw(_picture, null, null, null, null, false);
        _bitmap = new Bitmap(_bitmapData, "auto", false);
    }


    public function get bitmap():Bitmap
    {
        return _bitmap;
    }
}
}
