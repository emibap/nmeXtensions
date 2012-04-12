#ifndef INCLUDED_com_emibap_mailsendersample_MailSenderSample
#define INCLUDED_com_emibap_mailsendersample_MailSenderSample

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <nme/display/Sprite.h>
HX_DECLARE_CLASS3(com,emibap,mailsendersample,MailSenderSample)
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
namespace mailsendersample{


class MailSenderSample_obj : public ::nme::display::Sprite_obj{
	public:
		typedef ::nme::display::Sprite_obj super;
		typedef MailSenderSample_obj OBJ_;
		MailSenderSample_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< MailSenderSample_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~MailSenderSample_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("MailSenderSample"); }

		::nme::text::TextField label; /* REM */ 
		::nme::display::Sprite btn; /* REM */ 
		virtual Void initialize( );
		Dynamic initialize_dyn();

		virtual Void callMailWindow( ::nme::events::MouseEvent e);
		Dynamic callMailWindow_dyn();

		static Void main( );
		static Dynamic main_dyn();

};

} // end namespace com
} // end namespace emibap
} // end namespace mailsendersample

#endif /* INCLUDED_com_emibap_mailsendersample_MailSenderSample */ 
