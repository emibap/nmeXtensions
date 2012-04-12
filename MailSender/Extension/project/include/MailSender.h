#ifndef MailSender
#define MailSender

namespace mailSender {
	void SendHTMLMail (const char *subject, const char *body, const char *to, const char *cc, const char *bcc);
	void SendPlainMail (const char *subject, const char *body, const char *to, const char *cc, const char *bcc);
}

#endif
