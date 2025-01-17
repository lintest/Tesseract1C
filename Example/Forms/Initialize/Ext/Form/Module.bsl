﻿&НаКлиенте
Перем МестоположениеКомпоненты, ИдентификаторКомпоненты;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("AddInURL", AddInURL);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПараметрЗапуска = "install" Тогда
		ВыполнитьУстановкуКомпоненты();
		Отказ = Ложь;
	ИначеЕсли ПараметрЗапуска = "autotest" Тогда
		ОткрытьФормуПоИмени("AppVeyor", Истина);
		Отказ = Истина;
	Иначе
		ОткрытьФормуПоИмени("MainForm");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПоИмени(НовоеИмя, Автотестирование = Ложь)
	
	ПараметрыФормы = Новый Структура("Автотестирование,AddInURL", Автотестирование, AddInURL);
	ПозицияРазделителя = СтрНайти(ИмяФормы, ".", НаправлениеПоиска.СКонца);
	НовоеИмяФормы = Лев(ИмяФормы, ПозицияРазделителя) + НовоеИмя;
	ОткрытьФорму(НовоеИмяФормы, ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМестоположениеКомпоненты()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МакетКомпоненты = ОбработкаОбъект.ПолучитьМакет("TesseractOCR1C");
	Возврат ПоместитьВоВременноеХранилище(МакетКомпоненты, УникальныйИдентификатор);
	
КонецФункции	

&НаКлиенте
Процедура ВыполнитьУстановкуКомпоненты()
	
	МестоположениеКомпоненты = ПолучитьМестоположениеКомпоненты();
	ИдентификаторКомпоненты = "_" + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверкаПодключенияВнешнейКомпоненты", ЭтотОбъект);
	НачатьПодключениеВнешнейКомпоненты(ОписаниеОповещения, МестоположениеКомпоненты, ИдентификаторКомпоненты, ТипВнешнейКомпоненты.Native);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаПодключенияВнешнейКомпоненты(Подключение, ДополнительныеПараметры) Экспорт
	
	Если Подключение Тогда
		ЗавершитьРаботуСистемы(Ложь);
	Иначе
		НачатьУстановкуВнешнейКомпоненты(Новый ОписаниеОповещения, МестоположениеКомпоненты);
		ПодключитьОбработчикОжидания("ПослеУстановкиВнешнейКомпоненты", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУстановкиВнешнейКомпоненты()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьЗавершениеРаботыСистемы", ЭтотОбъект);
	НачатьПодключениеВнешнейКомпоненты(ОписаниеОповещения, МестоположениеКомпоненты, ИдентификаторКомпоненты, ТипВнешнейКомпоненты.Native);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗавершениеРаботыСистемы(Подключение, ДополнительныеПараметры) Экспорт
	
	ВнешняяКомпонента = Новый("AddIn." + ИдентификаторКомпоненты + ".TesseractOCR1C");
	ВнешняяКомпонента.НачатьВызовЗавершитьРаботуСистемы(Новый ОписаниеОповещения, 0);
	
КонецПроцедуры
