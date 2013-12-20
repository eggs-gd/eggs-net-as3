package gd.eggs.net.events
{
	import flash.events.Event;


	/**
	 * ...
	 * @author Dukobpa3
	 */
	public class DecoderEvent extends Event
	{
		// errors
		public static const INVALID_DATA_TYPE:String = "invalid data type";
		public static const INVALID_PACKAGE_SIZE:String = "invalid package size";

		// status
		public static const IN_PROGRESS:String = "in progress";
		public static const RECEIVING_HEADER:String = "receiving header";
		public static const DONE:String = "done";

		private var _data:Object;

		public function DecoderEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}

		public override function clone():Event
		{
			return new DecoderEvent(type, data, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("DecoderEvent", "type", data, "bubbles", "cancelable", "eventPhase");
		}

		public function get data():Object { return _data; }

	}

}