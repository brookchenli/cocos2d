#include "base/ccConfig.h"
#ifndef __5chess_class_h__
#define __5chess_class_h__

#include "jsapi.h"
#include "jsfriendapi.h"

extern JSClass  *jsb_cocos2d_MyChessClass_class;
extern JSObject *jsb_cocos2d_MyChessClass_prototype;

bool js_5chess_class_MyChessClass_constructor(JSContext *cx, uint32_t argc, jsval *vp);
void js_5chess_class_MyChessClass_finalize(JSContext *cx, JSObject *obj);
void js_register_5chess_class_MyChessClass(JSContext *cx, JS::HandleObject global);
void register_all_5chess_class(JSContext* cx, JS::HandleObject obj);
bool js_5chess_class_MyChessClass_OnGameStart(JSContext *cx, uint32_t argc, jsval *vp);
bool js_5chess_class_MyChessClass_get_chess_return(JSContext *cx, uint32_t argc, jsval *vp);
bool js_5chess_class_MyChessClass_poschess(JSContext *cx, uint32_t argc, jsval *vp);
bool js_5chess_class_MyChessClass_MyChessClass(JSContext *cx, uint32_t argc, jsval *vp);

#endif // __5chess_class_h__
