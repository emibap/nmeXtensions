#ifndef INCLUDED_com_emibap_locationmanagersample_LocationManagerSample
#define INCLUDED_com_emibap_locationmanagersample_LocationManagerSample

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <nme/display/Sprite.h>
HX_DECLARE_CLASS3(com,emibap,locationmanagersample,LocationManagerSample)
HX_DECLARE_CLASS2(nme,display,DisplayObject)
HX_DECLARE_CLASS2(nme,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
HX_DECLARE_CLASS2(nme,display,InteractiveObject)
HX_DECLARE_CLASS2(nme,display,Sprite)
HX_DECLARE_CLASS2(nme,events,Event)
HX_DECLARE_CLASS2(nme,events,EventDispatcher)
HX_DECLARE_CLASS2(nme,events,IEventDispatcher)
HX_DECLARE_CLASS2(nme,events,MouseEvent)
HX_DECLARE_CLASS2(nme,text,TextField)
namespace com{
namespace emibap{
namespace locationmanagersample{


class LocationManagerSample_obj : public ::nme::display::Sprite_obj{
	public:
		typedef ::nme::display::Sprite_obj super;
		typedef LocationManagerSample_obj OBJ_;
		LocationManagerSample_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< LocationManagerSample_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~LocationManagerSample_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("LocationManagerSample"); }

		::nme::text::TextField labelTxt; /* REM */ 
		::nme::display::Sprite btn; /* REM */ 
		::nme::text::TextField statusTxt; /* REM */ 
		virtual Void initialize( );
		Dynamic initialize_dyn();

		virtual Void startUpdatingLocation( ::nme::events::MouseEvent e);
		Dynamic startUpdatingLocation_dyn();

		virtual Void onLocationUpdate( double lat,double lon);
		Dynamic onLocationUpdate_dyn();

		virtual Void onFinishedUpdatingLocation( ::String status);
		Dynamic onFinishedUpdatingLocation_dyn();

		virtual Void onFLocationError( ::String status);
		Dynamic onFLocationError_dyn();

		static Void main( );
		static Dynamic main_dyn();

};

} // end namespace com
} // end namespace emibap
} // end namespace locationmanagersample

#endif /* INCLUDED_com_emibap_locationmanagersample_LocationManagerSample */ 
