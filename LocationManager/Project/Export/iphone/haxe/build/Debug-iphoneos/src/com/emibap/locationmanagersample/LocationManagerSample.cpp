#include <hxcpp.h>

#ifndef INCLUDED_LocationManager
#include <LocationManager.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_com_emibap_locationmanagersample_LocationManagerSample
#include <com/emibap/locationmanagersample/LocationManagerSample.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
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
namespace locationmanagersample{

Void LocationManagerSample_obj::__construct()
{
{
	HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",26)
	super::__construct();
	HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",27)
	this->initialize();
}
;
	return null();
}

LocationManagerSample_obj::~LocationManagerSample_obj() { }

Dynamic LocationManagerSample_obj::__CreateEmpty() { return  new LocationManagerSample_obj; }
hx::ObjectPtr< LocationManagerSample_obj > LocationManagerSample_obj::__new()
{  hx::ObjectPtr< LocationManagerSample_obj > result = new LocationManagerSample_obj();
	result->__construct();
	return result;}

Dynamic LocationManagerSample_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< LocationManagerSample_obj > result = new LocationManagerSample_obj();
	result->__construct();
	return result;}

Void LocationManagerSample_obj::initialize( ){
{
		HX_SOURCE_PUSH("LocationManagerSample_obj::initialize")
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",34)
		::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->nmeSetAlign(::nme::display::StageAlign_obj::TOP_LEFT_dyn());
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",35)
		::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->nmeSetScaleMode(::nme::display::StageScaleMode_obj::NO_SCALE_dyn());
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",37)
		this->statusTxt = ::nme::text::TextField_obj::__new();
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",38)
		this->statusTxt->nmeSetDefaultTextFormat(::nme::text::TextFormat_obj::__new(HX_CSTRING("_sans"),(int)20,(int)0,null(),null(),null(),null(),null(),null(),null(),null(),null(),null()));
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",39)
		this->statusTxt->nmeSetWidth((int)640);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",40)
		this->statusTxt->nmeSetHeight((int)960);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",41)
		this->statusTxt->nmeSetX((int)0);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",42)
		this->statusTxt->nmeSetY((int)0);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",43)
		this->statusTxt->nmeSetSelectable(false);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",44)
		this->statusTxt->nmeSetMultiline(true);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",45)
		this->statusTxt->nmeSetText(HX_CSTRING("Hello-\n\n\n"));
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",49)
		this->labelTxt = ::nme::text::TextField_obj::__new();
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",50)
		this->labelTxt->nmeSetDefaultTextFormat(::nme::text::TextFormat_obj::__new(HX_CSTRING("_sans"),(int)24,(int)13421772,null(),null(),null(),null(),null(),null(),null(),null(),null(),null()));
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",51)
		this->labelTxt->nmeSetWidth((int)320);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",52)
		this->labelTxt->nmeSetX((int)20);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",53)
		this->labelTxt->nmeSetY((int)18);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",54)
		this->labelTxt->nmeSetSelectable(false);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",55)
		this->labelTxt->nmeSetText(HX_CSTRING("start Updating Location"));
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",57)
		this->btn = ::nme::display::Sprite_obj::__new();
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",58)
		this->btn->nmeGetGraphics()->beginFill((int)0,.8);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",59)
		this->btn->nmeGetGraphics()->drawRoundRect((int)0,(int)0,(int)300,(int)70,(int)12,(int)12);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",60)
		this->btn->nmeGetGraphics()->endFill();
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",62)
		this->btn->nmeSetX((int)320);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",63)
		this->btn->nmeSetY((int)20);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",65)
		this->btn->addChild(this->labelTxt);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",67)
		this->btn->addEventListener(::nme::events::MouseEvent_obj::CLICK,this->startUpdatingLocation_dyn(),null(),null(),null());
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",69)
		this->addChild(this->statusTxt);
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",71)
		this->addChild(this->btn);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(LocationManagerSample_obj,initialize,(void))

Void LocationManagerSample_obj::startUpdatingLocation( ::nme::events::MouseEvent e){
{
		HX_SOURCE_PUSH("LocationManagerSample_obj::startUpdatingLocation")
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",77)
		::LocationManager_obj::startUpdatingLocation((int)10,this->onLocationUpdate_dyn(),this->onFinishedUpdatingLocation_dyn(),this->onFLocationError_dyn());
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",78)
		::haxe::Log_obj::trace(HX_CSTRING("- StartUpdatingLocation..."),hx::SourceInfo(HX_CSTRING("LocationManagerSample.hx"),78,HX_CSTRING("com.emibap.locationmanagersample.LocationManagerSample"),HX_CSTRING("startUpdatingLocation")));
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",79)
		{
			HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",79)
			::nme::text::TextField _g = this->statusTxt;
			HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",79)
			_g->nmeSetText((_g->nmeGetText() + HX_CSTRING("\n- StartUpdatingLocation...")));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(LocationManagerSample_obj,startUpdatingLocation,(void))

Void LocationManagerSample_obj::onLocationUpdate( double lat,double lon){
{
		HX_SOURCE_PUSH("LocationManagerSample_obj::onLocationUpdate")
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",83)
		::haxe::Log_obj::trace((((HX_CSTRING("- Location arrived to haxe - latitude reported: ") + lat) + HX_CSTRING(", ")) + ::Std_obj::string(lon)),hx::SourceInfo(HX_CSTRING("LocationManagerSample.hx"),83,HX_CSTRING("com.emibap.locationmanagersample.LocationManagerSample"),HX_CSTRING("onLocationUpdate")));
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",84)
		{
			HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",84)
			::nme::text::TextField _g = this->statusTxt;
			HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",84)
			_g->nmeSetText((_g->nmeGetText() + ((((HX_CSTRING("\n- Location arrived: ") + ::Std_obj::string(lat)) + HX_CSTRING(", ")) + ::Std_obj::string(lon)))));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(LocationManagerSample_obj,onLocationUpdate,(void))

Void LocationManagerSample_obj::onFinishedUpdatingLocation( ::String status){
{
		HX_SOURCE_PUSH("LocationManagerSample_obj::onFinishedUpdatingLocation")
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",88)
		::haxe::Log_obj::trace((HX_CSTRING("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    !!!!!!!!!!!!!!   Location finished Updating: ") + status),hx::SourceInfo(HX_CSTRING("LocationManagerSample.hx"),88,HX_CSTRING("com.emibap.locationmanagersample.LocationManagerSample"),HX_CSTRING("onFinishedUpdatingLocation")));
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",89)
		{
			HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",89)
			::nme::text::TextField _g = this->statusTxt;
			HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",89)
			_g->nmeSetText((_g->nmeGetText() + ((HX_CSTRING("\n- Location finished Updating: ") + ::Std_obj::string(status)))));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(LocationManagerSample_obj,onFinishedUpdatingLocation,(void))

Void LocationManagerSample_obj::onFLocationError( ::String status){
{
		HX_SOURCE_PUSH("LocationManagerSample_obj::onFLocationError")
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",93)
		::haxe::Log_obj::trace((HX_CSTRING("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    !!!!!!!!!!!!!!   Location ERROR: ") + status),hx::SourceInfo(HX_CSTRING("LocationManagerSample.hx"),93,HX_CSTRING("com.emibap.locationmanagersample.LocationManagerSample"),HX_CSTRING("onFLocationError")));
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",94)
		{
			HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",94)
			::nme::text::TextField _g = this->statusTxt;
			HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",94)
			_g->nmeSetText((_g->nmeGetText() + ((HX_CSTRING("\n- Location ERROR: ") + ::Std_obj::string(status)))));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(LocationManagerSample_obj,onFLocationError,(void))

Void LocationManagerSample_obj::main( ){
{
		HX_SOURCE_PUSH("LocationManagerSample_obj::main")
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Project/Source/com/emibap/locationmanagersample/LocationManagerSample.hx",99)
		::nme::Lib_obj::nmeGetCurrent()->addChild(::com::emibap::locationmanagersample::LocationManagerSample_obj::__new());
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(LocationManagerSample_obj,main,(void))


LocationManagerSample_obj::LocationManagerSample_obj()
{
}

void LocationManagerSample_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(LocationManagerSample);
	HX_MARK_MEMBER_NAME(labelTxt,"labelTxt");
	HX_MARK_MEMBER_NAME(btn,"btn");
	HX_MARK_MEMBER_NAME(statusTxt,"statusTxt");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic LocationManagerSample_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"btn") ) { return btn; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"main") ) { return main_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"labelTxt") ) { return labelTxt; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"statusTxt") ) { return statusTxt; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"initialize") ) { return initialize_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"onLocationUpdate") ) { return onLocationUpdate_dyn(); }
		if (HX_FIELD_EQ(inName,"onFLocationError") ) { return onFLocationError_dyn(); }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"startUpdatingLocation") ) { return startUpdatingLocation_dyn(); }
		break;
	case 26:
		if (HX_FIELD_EQ(inName,"onFinishedUpdatingLocation") ) { return onFinishedUpdatingLocation_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic LocationManagerSample_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"btn") ) { btn=inValue.Cast< ::nme::display::Sprite >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"labelTxt") ) { labelTxt=inValue.Cast< ::nme::text::TextField >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"statusTxt") ) { statusTxt=inValue.Cast< ::nme::text::TextField >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void LocationManagerSample_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("labelTxt"));
	outFields->push(HX_CSTRING("btn"));
	outFields->push(HX_CSTRING("statusTxt"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("main"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("labelTxt"),
	HX_CSTRING("btn"),
	HX_CSTRING("statusTxt"),
	HX_CSTRING("initialize"),
	HX_CSTRING("startUpdatingLocation"),
	HX_CSTRING("onLocationUpdate"),
	HX_CSTRING("onFinishedUpdatingLocation"),
	HX_CSTRING("onFLocationError"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class LocationManagerSample_obj::__mClass;

void LocationManagerSample_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.emibap.locationmanagersample.LocationManagerSample"), hx::TCanCast< LocationManagerSample_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void LocationManagerSample_obj::__boot()
{
}

} // end namespace com
} // end namespace emibap
} // end namespace locationmanagersample
