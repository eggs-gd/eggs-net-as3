package gd.eggs.net
{
	import flash.events.EventDispatcher;

	import gd.eggs.net.connectors.ConnectorsFactory;
	import gd.eggs.net.events.ConnectorEvent;
	import gd.eggs.net.events.ServerConnectorEvent;
	import gd.eggs.net.interfaces.IServerConnect;
	import gd.eggs.net.events.DecoderEvent;
	import gd.eggs.net.interfaces.IMessageDecoder;


	[Event(name="serverConnected", type="gd.eggs.net.events.ServerConnectorEvent")]
	[Event(name="serverDisconnected", type="gd.eggs.net.events.ServerConnectorEvent")]
	[Event(name="serverDataReady", type="gd.eggs.net.events.ServerConnectorEvent")]
	[Event(name="serverError", type="gd.eggs.net.events.ServerConnectorEvent")]
	[Event(name="serverProgress", type="gd.eggs.net.events.ServerConnectorEvent")]
	[Event(name="serverLog", type="gd.eggs.net.events.ServerConnectorEvent")]

	public class ServerConnector extends EventDispatcher
	{
		//=====================================================================
		//		CONSTANTS
		//=====================================================================

		//=====================================================================
		//		PARAMETERS
		//=====================================================================

		/**
		 * Собственно коннектор
		 */
		private var _connection:IServerConnect;

		/**
		 * 1. При отправке пакует нечто адекватное в неведомую серверную хуйню(ByteArray, String),
		 * 2. При получении распаковывает неведомую серверную хуйню в нечто адекватное
		 * прокси не знает ни первый ни второй формат,
		 * Коннектор соответственно тоже
		 */
		private var _decoder:IMessageDecoder;

		//=====================================================================
		//		CONSTRUCTOR, INIT
		//=====================================================================
		public function ServerConnector(decoder:IMessageDecoder)
		{
			_decoder = decoder;
		}

		/**
		 * Инициализируем подключение, подписываемся на события подключения
		 */
		public function connect(connectConfig:ServerConnectConfig):void
		{
			_connection = ConnectorsFactory.getConnector(connectConfig.type);

			_decoder.addEventListener(DecoderEvent.INVALID_DATA_TYPE, onDecoderError);
			_decoder.addEventListener(DecoderEvent.INVALID_PACKAGE_SIZE, onDecoderError);
			_decoder.addEventListener(DecoderEvent.RECEIVING_HEADER, onDecoderProgress);
			_decoder.addEventListener(DecoderEvent.IN_PROGRESS, onDecoderProgress);
			_decoder.addEventListener(DecoderEvent.DONE, onDecoderData);

			_connection.addEventListener(ConnectorEvent.CONNECT_ATTEMPT, onConnectAttempt);
			_connection.addEventListener(ConnectorEvent.CONNECT_ERROR, onConnectError);
			_connection.addEventListener(ConnectorEvent.CONNECTED, onConnected);
			_connection.addEventListener(ConnectorEvent.SEND_DATA, onSendData);
			_connection.addEventListener(ConnectorEvent.RECEIVE_DATA, onReceiveData);
			_connection.addEventListener(ConnectorEvent.CLOSE, onClose);

			_connection.addEventListener(ConnectorEvent.LOG, onLog);

			_connection.init(connectConfig);
		}

		/**
		 * Добавление сообщения в очередь
		 * @param    message
		 */
		public function sendMessage(message:Object):void
		{
			_connection.send(_decoder.pack(message));
		}

		public function close():void
		{
			_connection.close();
			_connection = null;

			_decoder.addEventListener(DecoderEvent.INVALID_DATA_TYPE, onDecoderError);
			_decoder.addEventListener(DecoderEvent.INVALID_PACKAGE_SIZE, onDecoderError);
			_decoder.addEventListener(DecoderEvent.RECEIVING_HEADER, onDecoderProgress);
			_decoder.addEventListener(DecoderEvent.IN_PROGRESS, onDecoderProgress);
			_decoder.addEventListener(DecoderEvent.DONE, onDecoderData);

			_connection.addEventListener(ConnectorEvent.CONNECT_ATTEMPT, onConnectAttempt);
			_connection.addEventListener(ConnectorEvent.CONNECT_ERROR, onConnectError);
			_connection.addEventListener(ConnectorEvent.CONNECTED, onConnected);
			_connection.addEventListener(ConnectorEvent.SEND_DATA, onSendData);
			_connection.addEventListener(ConnectorEvent.RECEIVE_DATA, onReceiveData);
			_connection.addEventListener(ConnectorEvent.CLOSE, onClose);

			_connection.addEventListener(ConnectorEvent.LOG, onLog);
		}

		//=====================================================================
		//		PRIVATE
		//=====================================================================
		private function log(data:String):void
		{
			dispatchEvent(new ServerConnectorEvent(ServerConnectorEvent.SERVER_LOG, data));
		}
		//=====================================================================
		//		HANDLERS
		//=====================================================================
		//-----------------------------
		//  Connector
		//-----------------------------
		private function onConnectAttempt(event:ConnectorEvent):void
		{
			log(String(event.data));
		}

		private function onConnectError(event:ConnectorEvent):void
		{
			log(String(event.data));
			dispatchEvent(new ServerConnectorEvent(ServerConnectorEvent.SERVER_ERROR, event.data));
		}

		private function onConnected(event:ConnectorEvent):void
		{
			log(String(event.data));
			dispatchEvent(new ServerConnectorEvent(ServerConnectorEvent.SERVER_CONNECTED));
		}

		private function onSendData(event:ConnectorEvent):void
		{
			log(String(event.data));
		}

		private function onReceiveData(event:ConnectorEvent):void
		{
			log(String(event.data));

			if (_decoder) _decoder.parse(event.data);
		}

		private function onClose(event:ConnectorEvent):void
		{
			log(String(event.data));

			dispatchEvent(new ServerConnectorEvent(ServerConnectorEvent.SERVER_DISCONNECTED));
		}

		private function onLog(event:ConnectorEvent):void
		{
			log(String(event.data));
		}

		//-----------------------------
		//  Decoder
		//-----------------------------
		private function onDecoderError(event:DecoderEvent):void
		{
			log(String(event.data));

			dispatchEvent(new ServerConnectorEvent(ServerConnectorEvent.SERVER_ERROR, event.data));
		}

		private function onDecoderProgress(event:DecoderEvent):void
		{
			log(String(event.data));

			dispatchEvent(new ServerConnectorEvent(ServerConnectorEvent.SERVER_PROGRESS, event.data));
		}

		private function onDecoderData(event:DecoderEvent):void
		{
			log(String(event.data));

			dispatchEvent(new ServerConnectorEvent(ServerConnectorEvent.SERVER_DATA_READY, event.data));
		}

		//=====================================================================
		//		ACCESSORS
		//=====================================================================
	}
}
