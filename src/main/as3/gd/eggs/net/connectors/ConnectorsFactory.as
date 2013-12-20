/**
 * Created by Dukobpa3 on 12/20/13.
 */
package gd.eggs.net.connectors
{
	import gd.eggs.net.interfaces.IServerConnect;


	public class ConnectorsFactory
	{
		private static var _connectors:Object = {};

		/**
		 * Добавить свой вариант коннектора. По-умолчанию добавляется сокет.
		 * @param type
		 * @param classRef
		 */
		public static function addConnector(type:String, classRef:Class):void
		{
			_connectors[type] = classRef;
		}

		/**
		 * Выдает инстанс коннектора
		 * @param type
		 */
		public static function getConnector(type:String):IServerConnect
		{
			if(!_connectors[ConnectorType.SOCKET]) addConnector(ConnectorType.SOCKET, SocketConnect);
			if(!_connectors[ConnectorType.HTTP]) addConnector(ConnectorType.HTTP, HttpConnect);

			if(!_connectors[type]) throw new Error("don't have connectionType implementation");

			return new (_connectors[type] as Class)();
		}

	}
}
