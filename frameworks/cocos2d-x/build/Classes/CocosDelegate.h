#ifndef __APP_DELEGATE_H__
#define __APP_DELEGATE_H__

#include "cocos2d.h"
//#include "platform/CCApplication.h"
/**
@brief    The cocos2d Application.

Private inheritance here hides part of interface from Director.
*/
class  CocosDelegate : private cocos2d::Application
{
public:
    CocosDelegate();
    virtual ~CocosDelegate();
    
    static CocosDelegate* getInstance()
    {
        static CocosDelegate* cocosDelegate = new CocosDelegate();
        if (cocosDelegate)
        {
            return cocosDelegate;
        }
        return NULL;
    }

    virtual void initGLContextAttrs();

    /**
    @brief    Implement Director and Scene init code here.
    @return true    Initialize success, app continue.
    @return false   Initialize failed, app terminate.
    */
    virtual bool applicationDidFinishLaunching();

    /**
    @brief  Called when the application moves to the background
    @param  the pointer of the application
    */
    virtual void applicationDidEnterBackground();

    /**
    @brief  Called when the application reenters the foreground
    @param  the pointer of the application
    */
    virtual void applicationWillEnterForeground();
    
    void startCocosScene001();
    
    void startCocosScene002();
    
    void exitLuaGameView();
    virtual void clearSc();

};

#endif  // __APP_DELEGATE_H__

