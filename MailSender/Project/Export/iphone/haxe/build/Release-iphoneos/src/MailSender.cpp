#include <hxcpp.h>

#ifndef INCLUDED_MailSender
#include <MailSender.h>
#endif
#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif

Void MailSender_obj::__construct()
{
	return null();
}

MailSender_obj::~MailSender_obj() { }

Dynamic MailSender_obj::__CreateEmpty() { return  new MailSender_obj; }
hx::ObjectPtr< MailSender_obj > MailSender_obj::__new()
{  hx::ObjectPtr< MailSender_obj > result = new MailSender_obj();
	result->__construct();
	return result;}

Dynamic MailSender_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< MailSender_obj > result = new MailSender_obj();
	result->__construct();
	return result;}

Void MailSender_obj::sendMail( Dynamic __o_subject,Dynamic __o_body,Dynamic __o_isHTML,Dynamic __o_to,Dynamic __o_cc,Dynamic __o_bcc){
::String subject = __o_subject.Default(HX_CSTRING(""));
::String body = __o_body.Default(HX_CSTRING(""));
bool isHTML = __o_isHTML.Default(true);
::String to = __o_to.Default(HX_CSTRING(""));
::String cc = __o_cc.Default(HX_CSTRING(""));
::String bcc = __o_bcc.Default(HX_CSTRING(""));
	HX_SOURCE_PUSH("MailSender_obj::sendMail");
{
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Extension/MailSender.hx",12)
		if (((isHTML == true))){
			HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Extension/MailSender.hx",13)
			::MailSender_obj::cpp_call_send_html_mail(subject,body,to,cc,bcc);
		}
		else{
			HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Extension/MailSender.hx",14)
			::MailSender_obj::cpp_call_send_plain_mail(subject,body,to,cc,bcc);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC6(MailSender_obj,sendMail,(void))

Dynamic MailSender_obj::cpp_call_send_html_mail;

Dynamic MailSender_obj::cpp_call_send_plain_mail;


MailSender_obj::MailSender_obj()
{
}

void MailSender_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(MailSender);
	HX_MARK_END_CLASS();
}

Dynamic MailSender_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"sendMail") ) { return sendMail_dyn(); }
		break;
	case 23:
		if (HX_FIELD_EQ(inName,"cpp_call_send_html_mail") ) { return cpp_call_send_html_mail; }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"cpp_call_send_plain_mail") ) { return cpp_call_send_plain_mail; }
	}
	return super::__Field(inName);
}

Dynamic MailSender_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 23:
		if (HX_FIELD_EQ(inName,"cpp_call_send_html_mail") ) { cpp_call_send_html_mail=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"cpp_call_send_plain_mail") ) { cpp_call_send_plain_mail=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void MailSender_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("sendMail"),
	HX_CSTRING("cpp_call_send_html_mail"),
	HX_CSTRING("cpp_call_send_plain_mail"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(MailSender_obj::cpp_call_send_html_mail,"cpp_call_send_html_mail");
	HX_MARK_MEMBER_NAME(MailSender_obj::cpp_call_send_plain_mail,"cpp_call_send_plain_mail");
};

Class MailSender_obj::__mClass;

void MailSender_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("MailSender"), hx::TCanCast< MailSender_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void MailSender_obj::__boot()
{
	hx::Static(cpp_call_send_html_mail) = ::cpp::Lib_obj::load(HX_CSTRING("mailsender"),HX_CSTRING("mailsender_send_html_mail"),(int)5);
	hx::Static(cpp_call_send_plain_mail) = ::cpp::Lib_obj::load(HX_CSTRING("mailsender"),HX_CSTRING("mailsender_send_plain_mail"),(int)5);
}

