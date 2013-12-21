package gd.eggs.net.events
{
	import flash.events.Event;


	public class ServerConnectorEvent extends Event
	{
		public static const SERVER_CONNECTED:String = "serverConnected";
		public static const SERVER_DISCONNECTED:String = "serverDisconnected";
		public static const SERVER_DATA_READY:String = "serverDataReady";

		public static const SERVER_ERROR:String = "serverError";
		public static const SERVER_PROGRESS:String = "serverProgress";

		public static const SERVER_LOG:String = "serverLog";

		private var _data:Object;

		public function ServerConnectorEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
