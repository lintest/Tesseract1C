﻿#include "stdafx.h"
#include "Tesseract1C.h"
#include "Tesseract1C.h"

std::vector<std::u16string> TesseractControl::names = {
	AddComponent(u"Tesseract1C", []() { return new TesseractControl; }),
};

TesseractControl::TesseractControl()
{
	AddProcedure(u"Init", u"Инициализировать", [&](VH path, VH lang) { this->Init(path, lang); });
	AddFunction(u"Recognize", u"Распознать", [&](VH var) { this->result = Recognize(var); });
}

TesseractControl::~TesseractControl()
{
}

void TesseractControl::Init(const std::string& path, const std::string& lang)
{
	api.Init(path.c_str(), lang.c_str(), tesseract::OEM_DEFAULT);
	api.SetPageSegMode(tesseract::PSM_AUTO);
}

struct PixDeleter {
	void operator()(PIX* pix) { if (pix) pixDestroy(&pix); }
};

std::string TesseractControl::Recognize(VH& img)
{
	std::unique_ptr<PIX, PixDeleter> pix{ 
		pixReadMem((l_uint8*)img.data(), img.size()) 
	};
	api.SetImage(pix.get());
	std::unique_ptr<char[]> text(api.GetAltoText(0));
	return std::string(text.get());
}
