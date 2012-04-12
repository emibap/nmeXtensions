#include <hxcpp.h>

#ifndef INCLUDED_MailSender
#include <MailSender.h>
#endif
#ifndef INCLUDED_com_emibap_mailsendersample_MailSenderSample
#include <com/emibap/mailsendersample/MailSenderSample.h>
#endif
#ifndef INCLUDED_nme_Lib
#include <nme/Lib.h>
#endif
#ifndef INCLUDED_nme_display_DisplayObject
#include <nme/display/DisplayObject.h>
#endif
#ifndef INCLUDED_nme_display_DisplayObjectContainer
#include <nme/display/DisplayObjectContainer.h>
#endif
#ifndef INCLUDED_nme_display_Graphics
#include <nme/display/Graphics.h>
#endif
#ifndef INCLUDED_nme_display_IBitmapDrawable
#include <nme/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_nme_display_InteractiveObject
#include <nme/display/InteractiveObject.h>
#endif
#ifndef INCLUDED_nme_display_MovieClip
#include <nme/display/MovieClip.h>
#endif
#ifndef INCLUDED_nme_display_Sprite
#include <nme/display/Sprite.h>
#endif
#ifndef INCLUDED_nme_display_Stage
#include <nme/display/Stage.h>
#endif
#ifndef INCLUDED_nme_display_StageAlign
#include <nme/display/StageAlign.h>
#endif
#ifndef INCLUDED_nme_display_StageScaleMode
#include <nme/display/StageScaleMode.h>
#endif
#ifndef INCLUDED_nme_events_Event
#include <nme/events/Event.h>
#endif
#ifndef INCLUDED_nme_events_EventDispatcher
#include <nme/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_nme_events_IEventDispatcher
#include <nme/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_nme_events_MouseEvent
#include <nme/events/MouseEvent.h>
#endif
#ifndef INCLUDED_nme_text_TextField
#include <nme/text/TextField.h>
#endif
#ifndef INCLUDED_nme_text_TextFormat
#include <nme/text/TextFormat.h>
#endif
namespace com{
namespace emibap{
namespace mailsendersample{

Void MailSenderSample_obj::__construct()
{
{
	HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",25)
	super::__construct();
	HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",27)
	this->initialize();
}
;
	return null();
}

MailSenderSample_obj::~MailSenderSample_obj() { }

Dynamic MailSenderSample_obj::__CreateEmpty() { return  new MailSenderSample_obj; }
hx::ObjectPtr< MailSenderSample_obj > MailSenderSample_obj::__new()
{  hx::ObjectPtr< MailSenderSample_obj > result = new MailSenderSample_obj();
	result->__construct();
	return result;}

Dynamic MailSenderSample_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< MailSenderSample_obj > result = new MailSenderSample_obj();
	result->__construct();
	return result;}

Void MailSenderSample_obj::initialize( ){
{
		HX_SOURCE_PUSH("MailSenderSample_obj::initialize")
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",34)
		::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->nmeSetAlign(::nme::display::StageAlign_obj::TOP_LEFT_dyn());
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",35)
		::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->nmeSetScaleMode(::nme::display::StageScaleMode_obj::NO_SCALE_dyn());
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",38)
		this->label = ::nme::text::TextField_obj::__new();
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",39)
		this->label->nmeSetDefaultTextFormat(::nme::text::TextFormat_obj::__new(HX_CSTRING("_sans"),(int)24,(int)13421772,null(),null(),null(),null(),null(),null(),null(),null(),null(),null()));
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",40)
		this->label->nmeSetWidth((int)200);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",41)
		this->label->nmeSetX((int)10);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",42)
		this->label->nmeSetY((int)20);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",43)
		this->label->nmeSetSelectable(false);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",44)
		this->label->nmeSetText(HX_CSTRING("Open Mail Window"));
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",46)
		this->btn = ::nme::display::Sprite_obj::__new();
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",47)
		this->btn->nmeGetGraphics()->beginFill((int)0,null());
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",48)
		this->btn->nmeGetGraphics()->drawRoundRect((int)0,(int)0,(int)400,(int)100,(int)8,(int)8);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",49)
		this->btn->nmeGetGraphics()->endFill();
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",51)
		this->btn->addChild(this->label);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",53)
		this->btn->addEventListener(::nme::events::MouseEvent_obj::CLICK,this->callMailWindow_dyn(),null(),null(),null());
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",55)
		this->addChild(this->btn);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(MailSenderSample_obj,initialize,(void))

Void MailSenderSample_obj::callMailWindow( ::nme::events::MouseEvent e){
{
		HX_SOURCE_PUSH("MailSenderSample_obj::callMailWindow")
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",60)
		::MailSender_obj::sendMail(HX_CSTRING("Test de mail"),HX_CSTRING("Hola como va\n"),false,HX_CSTRING("emibap@gmail.com"),HX_CSTRING("emibap@gmail.com"),HX_CSTRING("emibap@gmail.com"));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(MailSenderSample_obj,callMailWindow,(void))

Void MailSenderSample_obj::main( ){
{
		HX_SOURCE_PUSH("MailSenderSample_obj::main")
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/MailSender/Project/Source/com/emibap/mailsendersample/MailSenderSample.hx",67)
		::nme::Lib_obj::nmeGetCurrent()->addChild(::com::emibap::mailsendersample::MailSenderSample_obj::__new());
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(MailSenderSample_obj,main,(void))


MailSenderSample_obj::MailSenderSample_obj()
{
}

void MailSenderSample_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(MailSenderSample);
	HX_MARK_MEMBER_NAME(label,"label");
	HX_MARK_MEMBER_NAME(btn,"btn");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic MailSenderSample_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"btn") ) { return btn; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"main") ) { return main_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"label") ) { return label; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"initialize") ) { return initialize_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"callMailWindow") ) { return callMailWindow_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic MailSenderSample_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"btn") ) { btn=inValue.Cast< ::nme::display::Sprite >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"label") ) { label=inValue.Cast< ::nme::text::TextField >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void MailSenderSample_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("label"));
	outFields->push(HX_CSTRING("btn"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("main"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("label"),
	HX_CSTRING("btn"),
	HX_CSTRING("initialize"),
	HX_CSTRING("callMailWindow"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class MailSenderSample_obj::__mClass;

void MailSenderSample_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.emibap.mailsendersample.MailSenderSample"), hx::TCanCast< MailSenderSample_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void MailSenderSample_obj::__boot()
{
}

} // end namespace com
} // end namespace emibap
} // end namespace mailsendersample
