// Разбивает строку на несколько строк по указанному разделителю. Разделитель может иметь любую длину.
// В случаях, когда разделителем является строка из одного символа, и не используется параметр СокращатьНепечатаемыеСимволы,
// рекомендуется использовать функцию платформы СтрРазделить.
//
// Параметры:
//  Значение               - Строка - текст с разделителями;
//  Разделитель            - Строка - разделитель строк текста, минимум 1 символ;
//  ПропускатьПустыеСтроки - Булево - признак необходимости включения в результат пустых строк.
//    Если параметр не задан, то функция работает в режиме совместимости со своей предыдущей версией:
//     - для разделителя-пробела пустые строки не включаются в результат, для остальных разделителей пустые строки
//       включаются в результат.
//     - если параметр Строка не содержит значащих символов или не содержит ни одного символа (пустая строка), то в
//       случае разделителя-пробела результатом функции будет массив, содержащий одно значение "" (пустая строка), а
//       при других разделителях результатом функции будет пустой массив.
//  СокращатьНепечатаемыеСимволы - Булево - сокращать непечатаемые символы по краям каждой из найденных подстрок.
//
// Возвращаемое значение:
//  Массив - массив строк.
//
// Пример:
//  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(",один,,два,", ",")
//  - возвратит массив из 5 элементов, три из которых  - пустые: "", "один", "", "два", "";
//  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(",один,,два,", ",", Истина)
//  - возвратит массив из двух элементов: "один", "два";
//  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(" один   два  ", " ")
//  - возвратит массив из двух элементов: "один", "два";
//  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("")
//  - возвратит пустой массив;
//  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("",,Ложь)
//  - возвратит массив с одним элементом: ""(пустая строка);
//  СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("", " ")
//  - возвратит массив с одним элементом: "" (пустая строка).
//
Функция РазложитьСтрокуВМассивПодстрок(Знач Значение, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено, СокращатьНепечатаемыеСимволы = Ложь) Экспорт
	
	Результат = Новый Массив;
	
	// Для обеспечения обратной совместимости.
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Значение) Тогда
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	
	Позиция = Найти(Значение, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Значение, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Если СокращатьНепечатаемыеСимволы Тогда
				Результат.Добавить(СокрЛП(Подстрока));
			Иначе
				Результат.Добавить(Подстрока);
			КонецЕсли;
		КонецЕсли;
		Значение = Сред(Значение, Позиция + СтрДлина(Разделитель));
		
		Позиция = Найти(Значение, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Значение) Тогда
		Если СокращатьНепечатаемыеСимволы Тогда
			Результат.Добавить(СокрЛП(Значение));
		Иначе
			Результат.Добавить(Значение);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Вставляет параметры в строку, учитывая, что в параметрах могут использоваться подстановочные слова %1, %2 и т.д.
//
Функция ПодставитьПараметрыВСтрокуАльтернативныйАлгоритм(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено,
	Знач Параметр3 = Неопределено, Знач Параметр4 = Неопределено,
	Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено,
	Знач Параметр9 = Неопределено)
	
	Результат = "";
	
	Позиция = Найти(СтрокаПодстановки, "%");
	Пока Позиция > 0 Цикл
		Результат = Результат + Лев(СтрокаПодстановки, Позиция - 1);
		СимволПослеПроцента = Сред(СтрокаПодстановки, Позиция + 1, 1);
		ПодставляемыйПараметр = "";
		Если СимволПослеПроцента = "1" Тогда
			ПодставляемыйПараметр = Параметр1;
		ИначеЕсли СимволПослеПроцента = "2" Тогда
			ПодставляемыйПараметр = Параметр2;
		ИначеЕсли СимволПослеПроцента = "3" Тогда
			ПодставляемыйПараметр = Параметр3;
		ИначеЕсли СимволПослеПроцента = "4" Тогда
			ПодставляемыйПараметр = Параметр4;
		ИначеЕсли СимволПослеПроцента = "5" Тогда
			ПодставляемыйПараметр = Параметр5;
		ИначеЕсли СимволПослеПроцента = "6" Тогда
			ПодставляемыйПараметр = Параметр6;
		ИначеЕсли СимволПослеПроцента = "7" Тогда
			ПодставляемыйПараметр = Параметр7
		ИначеЕсли СимволПослеПроцента = "8" Тогда
			ПодставляемыйПараметр = Параметр8;
		ИначеЕсли СимволПослеПроцента = "9" Тогда
			ПодставляемыйПараметр = Параметр9;
		КонецЕсли;
		Если ПодставляемыйПараметр = "" Тогда
			Результат = Результат + "%";
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 1);
		Иначе
			Результат = Результат + ПодставляемыйПараметр;
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 2);
		КонецЕсли;
		
		Позиция = Найти(СтрокаПодстановки, "%");
	КонецЦикла;
	Результат = Результат + СтрокаПодстановки;
	
	Возврат Результат;
КонецФункции

// Подставляет параметры в строку. Максимально возможное число параметров - 9.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров начинается с единицы.
//
// Параметры:
//	СтрокаПодстановки  - Строка - шаблон строки с параметрами (вхождениями вида "%ИмяПараметра");
//	Параметр<n>        - Строка - подставляемый параметр.
//
// Возвращаемое значение:
//	Строка   - текстовая строка с подставленными параметрами.
//
// Пример:
//	ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), "Вася", "Зоопарк") = "Вася пошел в Зоопарк".
//
// Примечание:
//	В случаях, когда число используемых параметров в строке совпадает с числом переданных для подстановки параметров,
//	рекомендуется использовать функцию платформы СтрШаблон.
//
Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки, Знач Параметр1,
	Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено,
	Знач Параметр6 = Неопределено, Знач Параметр7 = Неопределено,
	Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено) Экспорт
	
	ИспользоватьАльтернативныйАлгоритм = Найти(Параметр1, "%")
	Или Найти(Параметр2, "%") Или Найти(Параметр3, "%")
	Или Найти(Параметр4, "%") Или Найти(Параметр5, "%")
	Или Найти(Параметр6, "%") Или Найти(Параметр7, "%")
	Или Найти(Параметр8, "%") Или Найти(Параметр9, "%");
	
	Если ИспользоватьАльтернативныйАлгоритм Тогда
		СтрокаПодстановки = ПодставитьПараметрыВСтрокуАльтернативныйАлгоритм(СтрокаПодстановки, Параметр1, Параметр2, Параметр3, Параметр4, Параметр5, Параметр6, Параметр7, Параметр8, Параметр9);
	Иначе
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%1", Параметр1);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%2", Параметр2);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%3", Параметр3);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%4", Параметр4);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%5", Параметр5);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%6", Параметр6);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%7", Параметр7);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%8", Параметр8);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%9", Параметр9);
	КонецЕсли;
	
	Возврат СтрокаПодстановки;
	
КонецФункции

Функция СтрокаИзМассиваПодстрок(Знач ЧастиСтроки, Знач Разделитель = "",
	ПропускатьПустыеСтроки = Ложь, СокращатьНепечатаемыеСимволы = Ложь) Экспорт
	
	Результат = "";
	ПустойРезультат = "";
	
	#Область Предусловия
	
	Если ЧастиСтроки.Количество() = 0 Тогда
		Возврат ПустойРезультат;
	КонецЕсли;
	
	#КонецОбласти
	
	Для каждого ЧастьСтроки Из ЧастиСтроки Цикл
		
		Если СокращатьНепечатаемыеСимволы Тогда
			ЧастьСтроки = СокрЛП(ЧастьСтроки);
		КонецЕсли;
		
		Если ПропускатьПустыеСтроки Тогда
			Если Не ЗначениеЗаполнено(ЧастьСтроки) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Результат = Результат + ЧастьСтроки + Разделитель;
		
	КонецЦикла;
	
	Если СтрДлина(Разделитель) > 0 Тогда
		Результат = Лев(Результат, СтрДлина(Результат) - СтрДлина(Разделитель));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

