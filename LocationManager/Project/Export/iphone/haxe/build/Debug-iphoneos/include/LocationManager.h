#ifndef INCLUDED_LocationManager
#define INCLUDED_LocationManager

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(LocationManager)


class LocationManager_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef LocationManager_obj OBJ_;
		LocationManager_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< LocationManager_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~LocationManager_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("LocationManager"); }

		static Void startUpdatingLocation( Dynamic totalTimer,Dynamic locationUpdateCB,Dynamic finishedUpdatingCB,Dynamic errorCB);
		static Dynamic startUpdatingLocation_dyn();

		static Void onLocationUpdate( double latitude,double longitude);
		static Dynamic onLocationUpdate_dyn();

		static Dynamic cpp_call_start_updating_location; /* REM */ 
	Dynamic &cpp_call_start_updating_location_dyn() { return cpp_call_start_updating_location;}
};


#endif /* INCLUDED_LocationManager */ 
