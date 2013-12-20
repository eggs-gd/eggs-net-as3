package gd.eggs.net.interfaces
{
	import gd.eggs.net.ServerConnectConfig;
	import flash.events.IEventDispatcher;


	[Event(name="connected", type="gd.eggs.net.events.ConnectorEvent")]
	[Event(name="closeConnection", type="gd.eggs.net.events.ConnectorEvent")]
	[Event(name="connectAttempt", type="gd.eggs.net.events.ConnectorEvent")]
	[Event(name="sendData", type="gd.eggs.net.events.ConnectorEvent")]
	[Event(name="receiveData", type="gd.eggs.net.events.ConnectorEvent")]
	[Event(name="connectError", type="gd.eggs.net.events.ConnectorEvent")]

	[Event(name="log", type="flash.events.DataEvent")]

	/**
	 * ...
	 * @author Dukobpa3
	 */
	public interface IServerConnect extends IEventDispatcher
	{
		/**
		 * Подключается к определенному конфигу
		 * @param    config
		 */
		function init(config:ServerConnectConfig):void;

		/**
		 * Закрывает подключение
		 */
		function close():void;

		/**
		 * Отправляет команду на сервер
		 * @param    data собственно данные
		 */
		function send(data:Object):void;

	}

}