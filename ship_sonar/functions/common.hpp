//#define FLS_DEBUG

//#define ASP_ENABLE

#ifdef ASP_ENABLE
#define ASP_SCOPE_START(name) private __ASPScope##name = createProfileScope #name
#define ASP_SCOPE_END(name) __ASPScope##name=nil
#else
#define ASP_SCOPE_START(name) ;
#define ASP_SCOPE_END(name) ;
#endif