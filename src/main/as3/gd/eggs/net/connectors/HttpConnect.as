/**
 * Created by Dukobpa3 on 12/20/13.
 */
package gd.eggs.net.connectors
{
	import flash.events.EventDispatcher;

	import gd.eggs.net.ServerConnectConfig;
	import gd.eggs.net.interfaces.IServerConnect;


	public class HttpConnect extends EventDispatcher implements IServerConnect
	{
		public function HttpConnect()
		{
		}

		public function init(config:ServerConnectConfig):void
		{
		}

		public function close():void
		{
		}

		public function send(data:Object):void
		{
		}
	}
}
