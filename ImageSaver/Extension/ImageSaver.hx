package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#else
import nme.Lib;
#end

import nme.utils.ByteArray;
import nme.display.BitmapData;
import nme.geom.Rectangle;

class ImageSaver {	


	public static function saveImage(bmd:BitmapData):Void {
		#if cpp
			var ba:ByteArray = bmd.getPixels(new Rectangle(0, 0, bmd.width, bmd.height));
			cpp_call_save_image(ba.getData(), Std.int(bmd.width), Std.int(bmd.height));
		#end	
	}
	
	#if cpp
	private static var cpp_call_save_image = Lib.load ("imagesaver", "imagesaver_save_image", 3);
	#end
	
}