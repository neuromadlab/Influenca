package;

//import flash.events.Event;
import haxe.Http;
/*#if mobile
import openfl.net.URLLoader;
import openfl.net.URLRequest;
#end*/


class InternetConnection
{

	/**
	* Checks to see if the internet is connected
	* by polling Google for a response code
	* 
	* Catch error to deal with potential firewalls
	* 
	* If internet connection is available retrieve latest database IP
	* 
	* @param callback
	* @return
	*/
	public static function isAvailable(?callback:Bool->Void):Bool

	
	{
		var isAvailable:Bool = false;

		try {
			var http = new Http(db_address);

			trace("Query internet connection...");

			http.onError = function(status) {
				if (callback != null) {
					callback(false);
				}
				isAvailable = false;
				trace("Internet connection not available.");
			};

			http.onStatus = function(status) {
				if (callback != null) {
					callback(true);
				}
				isAvailable = true;
				trace("Internet connection available.");
			};

			http.request(false);
			
			// Retrieve current database IP
			if (isAvailable == true) 
			{
				//#if desktop				
				var database_current_json = new haxe.Http(host_address_url);

				database_current_json.onData = function (data:String) {
					var result = haxe.Json.parse(data);
					host_address = result.ip;
				}

				database_current_json.onError = function (error) {
					trace("Error: Current database address not received due to" + error);
				}

				database_current_json.request();

				/*#elseif mobile
				var database_current_json = new URLLoader ();
				database_current_json.addEventListener (Event.COMPLETE, function (_) {

    					var result = haxe.Json.parse(database_current_json.data);
					host_address = result.ip;

				});
				database_current_json.load (new URLRequest (host_address_url));
				#end*/
			}

			return isAvailable;

		} catch ( err:Dynamic ) {
			trace("Error occurred: " + err);
			return false;
		}
	}

}
