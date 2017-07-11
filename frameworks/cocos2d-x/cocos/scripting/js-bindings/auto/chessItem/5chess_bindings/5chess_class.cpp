#include "scripting/js-bindings/auto/chessItem/5chess_bindings/5chess_class.hpp"
#include "scripting/js-bindings/manual/cocos2d_specifics.hpp"
#include "chessItem.h"

template<class T>
static bool dummy_constructor(JSContext *cx, uint32_t argc, jsval *vp)
{
    JS_ReportError(cx, "Constructor for the requested class is not available, please refer to the API reference.");
    return false;
}

static bool empty_constructor(JSContext *cx, uint32_t argc, jsval *vp) {
    return false;
}

static bool js_is_native_obj(JSContext *cx, uint32_t argc, jsval *vp)
{
    JS::CallArgs args = JS::CallArgsFromVp(argc, vp);
    args.rval().setBoolean(true);
    return true;
}
JSClass  *jsb_cocos2d_MyChessClass_class;
JSObject *jsb_cocos2d_MyChessClass_prototype;

bool js_5chess_class_MyChessClass_OnGameStart(JSContext *cx, uint32_t argc, jsval *vp)
{
    JS::CallArgs args = JS::CallArgsFromVp(argc, vp);
    bool ok = true;
    JS::RootedObject obj(cx, args.thisv().toObjectOrNull());
    js_proxy_t *proxy = jsb_get_js_proxy(obj);
    cocos2d::MyChessClass* cobj = (cocos2d::MyChessClass *)(proxy ? proxy->ptr : NULL);
    JSB_PRECONDITION2( cobj, cx, false, "js_5chess_class_MyChessClass_OnGameStart : Invalid Native Object");
    if (argc == 1) {
        int arg0 = 0;
        ok &= jsval_to_int32(cx, args.get(0), (int32_t *)&arg0);
        JSB_PRECONDITION2(ok, cx, false, "js_5chess_class_MyChessClass_OnGameStart : Error processing arguments");
        int ret = cobj->OnGameStart(arg0);
        jsval jsret = JSVAL_NULL;
        jsret = int32_to_jsval(cx, ret);
        args.rval().set(jsret);
        return true;
    }

    JS_ReportError(cx, "js_5chess_class_MyChessClass_OnGameStart : wrong number of arguments: %d, was expecting %d", argc, 1);
    return false;
}
bool js_5chess_class_MyChessClass_get_chess_return(JSContext *cx, uint32_t argc, jsval *vp)
{
    JS::CallArgs args = JS::CallArgsFromVp(argc, vp);
    JS::RootedObject obj(cx, args.thisv().toObjectOrNull());
    js_proxy_t *proxy = jsb_get_js_proxy(obj);
    cocos2d::MyChessClass* cobj = (cocos2d::MyChessClass *)(proxy ? proxy->ptr : NULL);
    JSB_PRECONDITION2( cobj, cx, false, "js_5chess_class_MyChessClass_get_chess_return : Invalid Native Object");
    if (argc == 0) {
        std::string ret = cobj->get_chess_return();
        jsval jsret = JSVAL_NULL;
        jsret = std_string_to_jsval(cx, ret);
        args.rval().set(jsret);
        return true;
    }

    JS_ReportError(cx, "js_5chess_class_MyChessClass_get_chess_return : wrong number of arguments: %d, was expecting %d", argc, 0);
    return false;
}
bool js_5chess_class_MyChessClass_poschess(JSContext *cx, uint32_t argc, jsval *vp)
{
    JS::CallArgs args = JS::CallArgsFromVp(argc, vp);
    bool ok = true;
    JS::RootedObject obj(cx, args.thisv().toObjectOrNull());
    js_proxy_t *proxy = jsb_get_js_proxy(obj);
    cocos2d::MyChessClass* cobj = (cocos2d::MyChessClass *)(proxy ? proxy->ptr : NULL);
    JSB_PRECONDITION2( cobj, cx, false, "js_5chess_class_MyChessClass_poschess : Invalid Native Object");
    if (argc == 3) {
        int arg0 = 0;
        int arg1 = 0;
        int arg2 = 0;
        ok &= jsval_to_int32(cx, args.get(0), (int32_t *)&arg0);
        ok &= jsval_to_int32(cx, args.get(1), (int32_t *)&arg1);
        ok &= jsval_to_int32(cx, args.get(2), (int32_t *)&arg2);
        JSB_PRECONDITION2(ok, cx, false, "js_5chess_class_MyChessClass_poschess : Error processing arguments");
        int ret = cobj->poschess(arg0, arg1, arg2);
        jsval jsret = JSVAL_NULL;
        jsret = int32_to_jsval(cx, ret);
        args.rval().set(jsret);
        return true;
    }

    JS_ReportError(cx, "js_5chess_class_MyChessClass_poschess : wrong number of arguments: %d, was expecting %d", argc, 3);
    return false;
}
bool js_5chess_class_MyChessClass_constructor(JSContext *cx, uint32_t argc, jsval *vp)
{
    JS::CallArgs args = JS::CallArgsFromVp(argc, vp);
    bool ok = true;
    cocos2d::MyChessClass* cobj = new (std::nothrow) cocos2d::MyChessClass();

    js_type_class_t *typeClass = js_get_type_from_native<cocos2d::MyChessClass>(cobj);

    // link the native object with the javascript object
    JS::RootedObject jsobj(cx, jsb_create_weak_jsobject(cx, cobj, typeClass, "cocos2d::MyChessClass"));
    args.rval().set(OBJECT_TO_JSVAL(jsobj));
    if (JS_HasProperty(cx, jsobj, "_ctor", &ok) && ok)
        ScriptingCore::getInstance()->executeFunctionWithOwner(OBJECT_TO_JSVAL(jsobj), "_ctor", args);
    return true;
}


void js_cocos2d_MyChessClass_finalize(JSFreeOp *fop, JSObject *obj) {
    CCLOGINFO("jsbindings: finalizing JS object %p (MyChessClass)", obj);
    js_proxy_t* nproxy;
    js_proxy_t* jsproxy;
    JSContext *cx = ScriptingCore::getInstance()->getGlobalContext();
    JS::RootedObject jsobj(cx, obj);
    jsproxy = jsb_get_js_proxy(jsobj);
    if (jsproxy) {
        cocos2d::MyChessClass *nobj = static_cast<cocos2d::MyChessClass *>(jsproxy->ptr);
        nproxy = jsb_get_native_proxy(jsproxy->ptr);

        if (nobj) {
            jsb_remove_proxy(nproxy, jsproxy);
            delete nobj;
        }
        else
            jsb_remove_proxy(nullptr, jsproxy);
    }
}
void js_register_5chess_class_MyChessClass(JSContext *cx, JS::HandleObject global) {
    jsb_cocos2d_MyChessClass_class = (JSClass *)calloc(1, sizeof(JSClass));
    jsb_cocos2d_MyChessClass_class->name = "MyChessClass";
    jsb_cocos2d_MyChessClass_class->addProperty = JS_PropertyStub;
    jsb_cocos2d_MyChessClass_class->delProperty = JS_DeletePropertyStub;
    jsb_cocos2d_MyChessClass_class->getProperty = JS_PropertyStub;
    jsb_cocos2d_MyChessClass_class->setProperty = JS_StrictPropertyStub;
    jsb_cocos2d_MyChessClass_class->enumerate = JS_EnumerateStub;
    jsb_cocos2d_MyChessClass_class->resolve = JS_ResolveStub;
    jsb_cocos2d_MyChessClass_class->convert = JS_ConvertStub;
    jsb_cocos2d_MyChessClass_class->finalize = js_cocos2d_MyChessClass_finalize;
    jsb_cocos2d_MyChessClass_class->flags = JSCLASS_HAS_RESERVED_SLOTS(2);

    static JSPropertySpec properties[] = {
        JS_PS_END
    };

    static JSFunctionSpec funcs[] = {
        JS_FN("OnGameStart", js_5chess_class_MyChessClass_OnGameStart, 1, JSPROP_PERMANENT | JSPROP_ENUMERATE),
        JS_FN("get_chess_return", js_5chess_class_MyChessClass_get_chess_return, 0, JSPROP_PERMANENT | JSPROP_ENUMERATE),
        JS_FN("poschess", js_5chess_class_MyChessClass_poschess, 3, JSPROP_PERMANENT | JSPROP_ENUMERATE),
        JS_FS_END
    };

    JSFunctionSpec *st_funcs = NULL;

    jsb_cocos2d_MyChessClass_prototype = JS_InitClass(
        cx, global,
        JS::NullPtr(),
        jsb_cocos2d_MyChessClass_class,
        js_5chess_class_MyChessClass_constructor, 0, // constructor
        properties,
        funcs,
        NULL, // no static properties
        st_funcs);

    JS::RootedObject proto(cx, jsb_cocos2d_MyChessClass_prototype);
    JS::RootedValue className(cx, std_string_to_jsval(cx, "MyChessClass"));
    JS_SetProperty(cx, proto, "_className", className);
    JS_SetProperty(cx, proto, "__nativeObj", JS::TrueHandleValue);
    JS_SetProperty(cx, proto, "__is_ref", JS::FalseHandleValue);
    // add the proto and JSClass to the type->js info hash table
    jsb_register_class<cocos2d::MyChessClass>(cx, jsb_cocos2d_MyChessClass_class, proto, JS::NullPtr());
}

void register_all_5chess_class(JSContext* cx, JS::HandleObject obj) {
    // Get the ns
    JS::RootedObject ns(cx);
    get_or_create_js_obj(cx, obj, "chess", &ns);

    js_register_5chess_class_MyChessClass(cx, ns);
}

