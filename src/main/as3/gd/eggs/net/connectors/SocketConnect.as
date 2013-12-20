package gd.eggs.net.connectors
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;

	import gd.eggs.net.ServerConnectConfig;

	import gd.eggs.net.events.ConnectorEvent;

	import gd.eggs.net.interfaces.IServerConnect;


	/**
	 * ...
	 * @author Dukobpa3
	 */
	public class SocketConnect extends EventDispatcher implements IServerConnect
	{
		private var _socket:Socket;

		/** текущий коннект */
		private var _config:ServerConnectConfig;

		/** данные готовые для использовани�? */
		private var _data:Object;

		/** Еще один таймер */
		private var _connectTimeout:Timer;

		private var _connected:Boolean;

		//=====================================================================
		//		CONSTRUCTOR, INIT
		//=====================================================================
		public function SocketConnect()
		{

		}

		//=====================================================================
		//		PUBLIC
		//=====================================================================

		/* INTERFACE connect.IServerSend */

		public function init(config:ServerConnectConfig):void
		{
			addLog("socketInit: ", data);
			_config = config;
			_connectTimeout = new Timer(_config.timeout);
			connectSocket();
		}

		public function close():void
		{
			_socket = new Socket();
			_socket.close();
			_socket.removeEventListener(Event.CLOSE, onSocketClose);
			_socket.removeEventListener(Event.CONNECT, onSocketConnect);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, onSocketIOError);
			_socket.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onSocketOutputData);
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError);

			_socket = null;

			_connectTimeout.stop();
			_connectTimeout = null;
		}

		/**
		 * Отправляет данные на сервер
		 * @param    data данные
		 */
		public function send(data:Object):void
		{
			addLog("socketSend: ", data);

			try
			{
				if (data is String)
				{
					_socket.writeUTFBytes(data as String);
					_socket.flush();
					dispatchEvent(new ConnectorEvent(ConnectorEvent.SEND_DATA, data));
				}
				if (data is ByteArray)
				{
					(data as ByteArray).position = 0;
					_socket.writeBytes(data as ByteArray);
					_socket.flush();
					dispatchEvent(new ConnectorEvent(ConnectorEvent.SEND_DATA, data));
				}
			}
			catch (e:Error)
			{
				addLog("socket.write Error: ", e.message);
			}

		}

		//=====================================================================
		//		PRIVATE
		//=====================================================================
		/**
		 * Создание подключения по socket
		 */
		private function connectSocket():void
		{
			addLog("connectSocket: ", _config.host, _config.port);

			_socket = new Socket();
			_socket.addEventListener(Event.CLOSE, onSocketClose);
			_socket.addEventListener(Event.CONNECT, onSocketConnect);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketIOError);
			_socket.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onSocketOutputData);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError);

			_socket.connect(_config.host, _config.port);

			_connectTimeout = new Timer(_config.timeout * 1000, 1);
			_connectTimeout.addEventListener(TimerEvent.TIMER_COMPLETE, onSocketConnectTimeout);
			_connectTimeout.start();
		}

		private function addLog(...rest):void
		{
			dispatchEvent(new ConnectorEvent(ConnectorEvent.LOG, rest, true, false));
		}

		//=====================================================================
		//		EVENTS
		//=====================================================================
		private function onSocketData(e:ProgressEvent):void
		{
			addLog("onSocketData: ", e);

			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			_socket.readBytes(bytes);

			dispatchEvent(new ConnectorEvent(ConnectorEvent.RECEIVE_DATA, bytes));

		}

		private function onSocketOutputData(e:OutputProgressEvent):void
		{
			addLog("onSocketOutputData: ", e);
		}

		private function onSocketClose(e:Event):void
		{
			addLog("onSocketClose: ", e);
			dispatchEvent(new ConnectorEvent(ConnectorEvent.CLOSE));
		}

		private function onSocketConnect(e:Event):void
		{
			addLog("onSocketConnect: ", e);
			_connected = true;
			dispatchEvent(new ConnectorEvent(ConnectorEvent.CONNECTED));

			_connectTimeout.stop();
		}

		private function onSocketIOError(e:IOErrorEvent):void
		{
			addLog("onSocketIOError: ", e);
		}

		private function onSocketSecurityError(e:SecurityErrorEvent):void
		{
			addLog("onSocketSecurityError: ", e);
		}

		private function onSocketConnectTimeout(e:TimerEvent):void
		{
			addLog("onSocketConnectTimeout: ", e);
			if (_socket && _connected && _socket.connected)
			{
				_socket.close();
				onSocketClose(null);
			}
		}

		//=====================================================================
		//		ACCESSORS
		//=====================================================================
		public function get data():Object { return _data; }

		public function get config():ServerConnectConfig { return _config; }
	}

}