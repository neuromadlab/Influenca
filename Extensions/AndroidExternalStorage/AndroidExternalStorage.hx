package;


import lime.system.CFFI;
import lime.system.JNI;


class AndroidExternalStorage {
	
	#if android

	public static function getAndroidStoragePath ():String {
		
		var storagePath = androidexternalstorage_getandroidstoragepath_jni();
				
		return storagePath;
		
	}
	
	
	private static var androidexternalstorage_getandroidstoragepath = CFFI.load ("androidexternalstorage", "androidexternalstorage_getandroidstoragepath", 1);

	private static var androidexternalstorage_getandroidstoragepath_jni = JNI.createStaticMethod ("org.haxe.extension.AndroidExternalStorage", "getAndroidStoragePath", "()Ljava/lang/String;");
	#end
	
	
}
