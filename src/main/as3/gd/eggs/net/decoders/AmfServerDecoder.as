/**
 * Created by Dukobpa3 on 12/21/13.
 */
package gd.eggs.net.decoders
{
	import flash.events.EventDispatcher;

	import gd.eggs.net.interfaces.IMessageDecoder;


	public class AmfServerDecoder extends EventDispatcher implements IMessageDecoder
	{
		public function AmfServerDecoder()
		{
		}

		public function parse(message:Object):void
		{
		}

		public function pack(data:Object):Object
		{
			return null;
		}

	}
}
