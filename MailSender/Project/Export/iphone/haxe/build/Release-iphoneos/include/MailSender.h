#ifndef INCLUDED_MailSender
#define INCLUDED_MailSender

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(MailSender)


class MailSender_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef MailSender_obj OBJ_;
		MailSender_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< MailSender_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~MailSender_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("MailSender"); }

		static Void sendMail( Dynamic subject,Dynamic body,Dynamic isHTML,Dynamic to,Dynamic cc,Dynamic bcc);
		static Dynamic sendMail_dyn();

		static Dynamic cpp_call_send_html_mail; /* REM */ 
	Dynamic &cpp_call_send_html_mail_dyn() { return cpp_call_send_html_mail;}
		static Dynamic cpp_call_send_plain_mail; /* REM */ 
	Dynamic &cpp_call_send_plain_mail_dyn() { return cpp_call_send_plain_mail;}
};


#endif /* INCLUDED_MailSender */ 
