#include <hxcpp.h>

#ifndef INCLUDED_LocationManager
#include <LocationManager.h>
#endif
#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif

Void LocationManager_obj::__construct()
{
	return null();
}

LocationManager_obj::~LocationManager_obj() { }

Dynamic LocationManager_obj::__CreateEmpty() { return  new LocationManager_obj; }
hx::ObjectPtr< LocationManager_obj > LocationManager_obj::__new()
{  hx::ObjectPtr< LocationManager_obj > result = new LocationManager_obj();
	result->__construct();
	return result;}

Dynamic LocationManager_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< LocationManager_obj > result = new LocationManager_obj();
	result->__construct();
	return result;}

Void LocationManager_obj::startUpdatingLocation( Dynamic __o_totalTimer,Dynamic locationUpdateCB,Dynamic finishedUpdatingCB,Dynamic errorCB){
int totalTimer = __o_totalTimer.Default(30000);
	HX_SOURCE_PUSH("LocationManager_obj::startUpdatingLocation");
{
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Extension/LocationManager.hx",21)
		::LocationManager_obj::cpp_call_start_updating_location(totalTimer,locationUpdateCB,finishedUpdatingCB,errorCB);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(LocationManager_obj,startUpdatingLocation,(void))

Void LocationManager_obj::onLocationUpdate( double latitude,double longitude){
{
		HX_SOURCE_PUSH("LocationManager_obj::onLocationUpdate")
		HX_SOURCE_POS("/Users/emilianoangelini/dev/haXeNME/nmeXtensions/LocationManager/Extension/LocationManager.hx",32)
		::haxe::Log_obj::trace((((HX_CSTRING("Location arrived to haxe - latitude reported: ") + latitude) + HX_CSTRING(", ")) + longitude),hx::SourceInfo(HX_CSTRING("LocationManager.hx"),33,HX_CSTRING("LocationManager"),HX_CSTRING("onLocationUpdate")));
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(LocationManager_obj,onLocationUpdate,(void))

Dynamic LocationManager_obj::cpp_call_start_updating_location;


LocationManager_obj::LocationManager_obj()
{
}

void LocationManager_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(LocationManager);
	HX_MARK_END_CLASS();
}

Dynamic LocationManager_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 16:
		if (HX_FIELD_EQ(inName,"onLocationUpdate") ) { return onLocationUpdate_dyn(); }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"startUpdatingLocation") ) { return startUpdatingLocation_dyn(); }
		break;
	case 32:
		if (HX_FIELD_EQ(inName,"cpp_call_start_updating_location") ) { return cpp_call_start_updating_location; }
	}
	return super::__Field(inName);
}

Dynamic LocationManager_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 32:
		if (HX_FIELD_EQ(inName,"cpp_call_start_updating_location") ) { cpp_call_start_updating_location=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void LocationManager_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("startUpdatingLocation"),
	HX_CSTRING("onLocationUpdate"),
	HX_CSTRING("cpp_call_start_updating_location"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(LocationManager_obj::cpp_call_start_updating_location,"cpp_call_start_updating_location");
};

Class LocationManager_obj::__mClass;

void LocationManager_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("LocationManager"), hx::TCanCast< LocationManager_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void LocationManager_obj::__boot()
{
	hx::Static(cpp_call_start_updating_location) = ::cpp::Lib_obj::load(HX_CSTRING("locationmanager"),HX_CSTRING("locationmanager_start_updating_location"),(int)4);
}

