#Область Интерфейс

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
//  НВ_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(",один,,два,", ",")
//  - возвратит массив из 5 элементов, три из которых  - пустые: "", "один", "", "два", "";
//  НВ_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(",один,,два,", ",", Истина)
//  - возвратит массив из двух элементов: "один", "два";
//  НВ_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(" один   два  ", " ")
//  - возвратит массив из двух элементов: "один", "два";
//  НВ_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("")
//  - возвратит пустой массив;
//  НВ_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("",,Ложь)
//  - возвратит массив с одним элементом: ""(пустая строка);
//  НВ_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("", " ")
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

// Проверяет, содержит ли строка только цифры.
//
// Параметры:
//  Значение         - Строка - проверяемая строка.
//  Устаревший       - Булево - устаревший параметр, не используется.
//  ПробелыЗапрещены - Булево - если Ложь, то в строке допустимо наличие пробелов.
//
// Возвращаемое значение:
//   Булево - Истина - строка содержит только цифры или пустая, Ложь - строка содержит иные символы.
//
// Пример:
//  Результат = СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке("0123"); // Истина
//  Результат = СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке("0123abc"); // Ложь
//  Результат = СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке("01 2 3",, Ложь); // Истина
//
Функция ТолькоЦифрыВСтроке(Знач Значение, Знач Устаревший = Истина, Знач ПробелыЗапрещены = Истина) Экспорт
	
	Если ТипЗнч(Значение) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ПробелыЗапрещены Тогда
		Значение = СтрЗаменить(Значение, " ", "");
	КонецЕсли;
		
	Если СтрДлина(Значение) = 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Если содержит только цифры, то в результате замен должна быть получена пустая строка.
	// Проверять при помощи ПустаяСтрока нельзя, так как в исходной строке могут быть пробельные символы.
	Возврат СтрДлина(
		СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить(
		СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( 
			Значение, "0", ""), "1", ""), "2", ""), "3", ""), "4", ""), "5", ""), "6", ""), "7", ""), "8", ""), "9", "")) = 0;
	
КонецФункции

// Проверяет, содержит ли строка только символы кириллического алфавита.
//
// Параметры:
//  СтрокаПроверки - Строка - проверяемая строка.
//  УчитыватьРазделителиСлов - Булево - учитывать ли разделители слов или они являются исключением.
//  ДопустимыеСимволы - Строка - дополнительные разрешенные символы, кроме кириллицы.
//
// Возвращаемое значение:
//  Булево - Истина, если строка содержит только кириллические (или допустимые) символы или пустая;
//           Ложь, если строка содержит иные символы.
//
Функция ТолькоКириллицаВСтроке(Знач СтрокаПроверки, Знач УчитыватьРазделителиСлов = Истина, ДопустимыеСимволы = "") Экспорт
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтрокаПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	КодыДопустимыхСимволов = Новый Массив;
	КодыДопустимыхСимволов.Добавить(1105); // "ё"
	КодыДопустимыхСимволов.Добавить(1025); // "Ё"
	
	Для Индекс = 1 По СтрДлина(ДопустимыеСимволы) Цикл
		КодыДопустимыхСимволов.Добавить(КодСимвола(Сред(ДопустимыеСимволы, Индекс, 1)));
	КонецЦикла;
	
	Для Индекс = 1 По СтрДлина(СтрокаПроверки) Цикл
		КодСимвола = КодСимвола(Сред(СтрокаПроверки, Индекс, 1));
		Если ((КодСимвола < 1040) Или (КодСимвола > 1103)) 
			И (КодыДопустимыхСимволов.Найти(КодСимвола) = Неопределено) 
			И Не (Не УчитыватьРазделителиСлов И ЭтоРазделительСлов(КодСимвола)) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Проверяет, содержит ли строка только символы латинского алфавита.
//
// Параметры:
//  СтрокаПроверки - Строка - проверяемая строка.
//  УчитыватьРазделителиСлов - Булево - учитывать ли разделители слов или они являются исключением.
//  ДопустимыеСимволы - Строка - дополнительные разрешенные символы, кроме латиницы.
//
// Возвращаемое значение:
//  Булево - Истина, если строка содержит только латинские (или допустимые) символы;
//         - Ложь, если строка содержит иные символы.
//
Функция ТолькоЛатиницаВСтроке(Знач СтрокаПроверки, Знач УчитыватьРазделителиСлов = Истина, ДопустимыеСимволы = "") Экспорт
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтрокаПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	КодыДопустимыхСимволов = Новый Массив;
	
	Для Индекс = 1 По СтрДлина(ДопустимыеСимволы) Цикл
		КодыДопустимыхСимволов.Добавить(КодСимвола(Сред(ДопустимыеСимволы, Индекс, 1)));
	КонецЦикла;
	
	Для Индекс = 1 По СтрДлина(СтрокаПроверки) Цикл
		КодСимвола = КодСимвола(Сред(СтрокаПроверки, Индекс, 1));
		Если ((КодСимвола < 65) Или (КодСимвола > 90 И КодСимвола < 97) Или (КодСимвола > 122))
			И (КодыДопустимыхСимволов.Найти(КодСимвола) = Неопределено) 
			И Не (Не УчитыватьРазделителиСлов И ЭтоРазделительСлов(КодСимвола)) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Определяет, является ли символ разделителем.
//
// Параметры:
//  КодСимвола      - Число  - код проверяемого символа;
//  РазделителиСлов - Строка - символы разделителей. Если параметр не указан, то 
//                             разделителем считаются все символы, не являющиеся цифрами, 
//                             латинскими и кириллическими буквами, а также знаком подчеркивания.
//
// Возвращаемое значение:
//  Булево - Истина, если символ с кодом КодСимвола является разделителем.
//
Функция ЭтоРазделительСлов(КодСимвола, РазделителиСлов = Неопределено) Экспорт
	
	Если РазделителиСлов <> Неопределено Тогда
		Возврат СтрНайти(РазделителиСлов, Символ(КодСимвола)) > 0;
	КонецЕсли;
		
	Диапазоны = Новый Массив;
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 48, 57)); 		// цифры
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 65, 90)); 		// латиница большие
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 97, 122)); 		// латиница маленькие
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 1040, 1103)); 	// кириллица
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 1025, 1025)); 	// символ "Ё"
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 1105, 1105)); 	// символ "ё"
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 95, 95)); 		// символ "_"
	
	Для Каждого Диапазон Из Диапазоны Цикл
		Если КодСимвола >= Диапазон.Мин И КодСимвола <= Диапазон.Макс Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти