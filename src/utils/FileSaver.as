
package utils
{
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

import mx.controls.Alert;

public class FileSaver
{
    public function FileSaver()
    {
    }


    public static function saveBinary(byteArray:ByteArray, name:String):void
    {


        var f:File = new File('c:\\Work\\JigSawTool\\out\\production\\JigSawTool\\assets\\pieces' + "\\" + name);
        var fs:FileStream = new FileStream();

        fs.open(f, FileMode.WRITE);
        fs.writeBytes(byteArray);
        fs.close()

    }

    public static function clearDirectory():void
    {
        var directory = File.documentsDirectory.resolvePath("c:\\Work\\JigSawTool\\out\\production\\JigSawTool\\assets\\pieces");
        directory.deleteDirectory(true);
        directory.createDirectory();
    }

    public static function saveFile(dataString:String="",metadataFile:String = "c:\\Work\\JigSawTool\\out\\production\\JigSawTool\\data.xml"):void
    {
        var fs:FileStream = new FileStream();
        fs.open(new File(metadataFile), FileMode.WRITE);
        fs.writeMultiByte(dataString, "UTF-8");
        fs.close();
    }
}
}
