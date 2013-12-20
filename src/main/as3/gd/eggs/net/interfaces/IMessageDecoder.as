package gd.eggs.net.interfaces
{
	import flash.events.IEventDispatcher;

	[Event(name="invalid data type", type="gd.eggs.net.events.DecoderEvent")]
	[Event(name="invalid package size", type="gd.eggs.net.events.DecoderEvent")]
	[Event(name="receiving header", type="gd.eggs.net.events.DecoderEvent")]
	[Event(name="in progress", type="gd.eggs.net.events.DecoderEvent")]
	[Event(name="done", type="gd.eggs.net.events.DecoderEvent")]

	/**
	 * ...
	 * @author Dukobpa3
	 */
	public interface IMessageDecoder extends IEventDispatcher
	{
		//=====================================================================
		//	PUBLIC
		//=====================================================================
		/**
		 * Пар�?ит "нечто" которое может быть чем-то вн�?тным, или же байтарреем
		 * @param    message "нечто", которе мы получили �? �?ервера
		 */
		function parse(message:Object):void

		/**
		 * пакует внутреннее "нечто" в �?ерверное
		 * @param    data
		 * @return
		 */
		function pack(data:Object):Object
	}
}