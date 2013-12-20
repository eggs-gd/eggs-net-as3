package gd.eggs.net.decoders
{
	import flash.events.EventDispatcher;
	import gd.eggs.net.events.DecoderEvent;
	import gd.eggs.net.interfaces.IMessageDecoder;
	import flash.utils.ByteArray;


	/**
	 * ...
	 * @author Dukobpa3
	 */

	public class JsonWithIntLengthServerDecoder extends EventDispatcher implements IMessageDecoder
	{
		//=====================================================================
		//	CONSTANTS
		//=====================================================================
		private static const SIZE_NONE:int = -1;
		private static const SIZE_HEADER:int = 4;

		//=====================================================================
		//	PARAMETERS
		//=====================================================================

		private var _buffer:ByteArray;
		private var _size:int;

		public function JsonWithIntLengthServerDecoder() {

			_buffer = new ByteArray();
			_size = SIZE_NONE;
		}

		/**
		 * Бронированная система для чтения чего попало как угодно.
		 * 1. Получает некий набор байтов. Пытается считать длину.
		 * 2. Если длина недополучена (хардкод 4 байте, интегер) ждет полного заголовка длины
		 * 3. Считывает длину. Дальше ждет полного месаджа, пока не получит.
		 * 4. Если на руках есть полные месадж, парсит его и диспатчит доне.
		 * 5. Так же может обрабатывать "смежные" пакеты.
		 * 		Когда в одном пакете пришел конец предыдущего сообщения и начало следующего.
		 * 		Если видит что после чтения в буфере что-то осталось - рекурсивно пытается парсить это.
		 * @param	message <code>ByteArray</code>
		 */
		public function parse(message:Object):void
		{
			var data:ByteArray = message as ByteArray;

			if ( !data ) dispatchEvent(new DecoderEvent(DecoderEvent.INVALID_DATA_TYPE));

			data.position = 0;

			_buffer.position = _buffer.length;
			_buffer.writeBytes(data);

			if (_size == SIZE_NONE) {
				if (_buffer.length >= SIZE_HEADER) {
					_buffer.position = 0;
					_size = _buffer.readInt();
				} else {
					dispatchEvent(new DecoderEvent(DecoderEvent.RECEIVING_HEADER));
					return;
				}
			}

			_buffer.position = SIZE_HEADER;

			if (_buffer.bytesAvailable >= _size) {
				var result:String = _buffer.readUTFBytes(_size);
				dispatchEvent(new DecoderEvent(DecoderEvent.DONE, JSON.parse(result)));

				var tempBa:ByteArray = new ByteArray();
				tempBa.writeBytes(_buffer, _size + SIZE_HEADER);

				_buffer.clear();
				_size = SIZE_NONE;

				if (tempBa.length > 0) parse(tempBa);

			} else {
				dispatchEvent(new DecoderEvent(DecoderEvent.IN_PROGRESS));
			}

		}

		/**
		 * @param message <code>Object</code> - структура которая должна лететь на сервер.
		 * Пакуется целиком в нужный формат.
		 * @return <code>ByteArray</code>
		 */
		public function pack(message:Object):Object
		{
			if ( !message ) dispatchEvent(new DecoderEvent(DecoderEvent.INVALID_DATA_TYPE));

			var data:String = JSON.stringify(message);

			var buffer:ByteArray = new ByteArray();
			var length:int = data.length;
			buffer.writeInt(length);
			buffer.writeUTFBytes(data);

			return buffer;
		}

	}
}