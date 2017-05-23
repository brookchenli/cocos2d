//
//  CocosManager.m
//  cocos2d_libs
//
//  Created by xuyuanteng on 16/11/10.
//  Copyright (c) 2016年 lcb. All rights reserved.
//

#import "CocosManager.h"
#import "GameViewController.h"
#import "cocos2d.h"
#import "platform/ios/CCEAGLView-ios.h"
#import "CppAdapter.h"
#import <AVFoundation/AVFoundation.h>

#include "SimpleAudioEngine.h"
#include "jsb_cocos2dx_auto.hpp"
#include "jsb_cocos2dx_ui_auto.hpp"
#include "jsb_cocos2dx_studio_auto.hpp"
#include "jsb_cocos2dx_builder_auto.hpp"
#include "jsb_cocos2dx_spine_auto.hpp"
#include "jsb_cocos2dx_extension_auto.hpp"
#include "jsb_cocos2dx_3d_auto.hpp"
#include "jsb_cocos2dx_3d_extension_auto.hpp"
#include "3d/jsb_cocos2dx_3d_manual.h"
#include "ui/jsb_cocos2dx_ui_manual.h"
#include "cocostudio/jsb_cocos2dx_studio_manual.h"
#include "cocosbuilder/js_bindings_ccbreader.h"
#include "spine/jsb_cocos2dx_spine_manual.h"
#include "extension/jsb_cocos2dx_extension_manual.h"
#include "localstorage/js_bindings_system_registration.h"
#include "chipmunk/js_bindings_chipmunk_registration.h"
#include "jsb_opengl_registration.h"
#include "network/XMLHTTPRequest.h"
#include "network/jsb_websocket.h"
#include "network/jsb_socketio.h"
#include "jsb_cocos2dx_physics3d_auto.hpp"
#include "physics3d/jsb_cocos2dx_physics3d_manual.h"
#include "jsb_cocos2dx_navmesh_auto.hpp"
#include "navmesh/jsb_cocos2dx_navmesh_manual.h"
#include "assets-manager/AssetsManagerEx.h"
#include "CCFileUtils.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "jsb_cocos2dx_experimental_video_auto.hpp"
#include "experimental/jsb_cocos2dx_experimental_video_manual.h"
#include "jsb_cocos2dx_experimental_webView_auto.hpp"
#include "experimental/jsb_cocos2dx_experimental_webView_manual.h"
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WINRT || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include "jsb_cocos2dx_audioengine_auto.hpp"
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "platform/android/CCJavascriptJavaBridge.h"
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
#include "platform/ios/JavaScriptObjCBridge.h"
#endif

//#import "AVAudioSession.h"

static CocosManager *instance = nullptr;

@interface CocosManager()
@property (nonatomic, strong) CCEAGLView *m_eaglView;

@end

@implementation CocosManager

+(CocosManager *) instance
{
    if( ! instance)
     {
        instance = [[CocosManager alloc]init];
     }
     return instance;
}

-(UIView*)getCocosEaglView
{
    float screenHeight=[[UIScreen mainScreen] bounds].size.height;
    float screenWidth=[[UIScreen mainScreen] bounds].size.width;
    cocos2d::Application *app = cocos2d::Application::getInstance();
    app->initGLContextAttrs();
    cocos2d::GLViewImpl::convertAttrs();
    
    // Add the view controller's view to the window and display.
    self.m_eaglView = [CCEAGLView viewWithFrame: CGRectMake(0, 0, screenHeight, screenWidth)
                                    pixelFormat: kEAGLColorFormatRGBA8
                                    depthFormat: GL_DEPTH24_STENCIL8_OES
                             preserveBackbuffer: NO
                                     sharegroup: nil
                                  multiSampling: NO
                                numberOfSamples: 0 ];
    
    float gameRate =348.000/1136;
    float gameHeight =screenHeight*gameRate;
    float blankHeight =160*gameRate;
    
    //模拟显示cocos游戏层不可穿透区域大小
    UIView* tempGameView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - blankHeight - gameHeight, screenWidth, gameHeight)];
    tempGameView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:0.4];
    //[testUIView addSubview:tempGameView];
    
    //设置cocos游戏层不可穿透区域
    //CGRect notAllowedTouchRect = CGRectMake(0, screenHeight - blankHeight - gameHeight, screenWidth, gameHeight);
    CGRect notAllowedTouchRect = CGRectMake(0, 0, screenHeight, screenWidth);
    self.m_eaglView.m_notAllowedTouchRect = notAllowedTouchRect;
    
    [self.m_eaglView setMultipleTouchEnabled:NO];
    //透明背景
    self.m_eaglView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];//[UIColor clearColor];//
    self.m_eaglView.opaque = YES;
    
    _gameViewController = [[GameViewController alloc] init];
    [_gameViewController initGameViewController];
    
    [[UIApplication sharedApplication] setStatusBarHidden:true];
    // IMPORTANT: Setting the GLView should be done after creating the RootViewController
    cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView((__bridge void*)self.m_eaglView);
    cocos2d::Director::getInstance()->setOpenGLView(glview);
    CppAdapter::getInstance()->setCocosIsInit(true);
    //允许触摸穿透cocos层到ios的view
    self.m_eaglView.m_allowedThrough = NO;
    
    app->run();
    
    //静音状态下可以播放声音
    //AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //[audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];

    return self.m_eaglView;
}

-(void)startCocosScene001
{
    NSLog(@"startCocosScene001...");
    //CocosDelegate::getInstance()->startCocosScene001();
    //CppAdapter::getInstance()->startCocosScene001();
    ScriptingCore::getInstance()->evalString("startJsCocosScene001()");
}

-(void)startCocosScene002
{
    NSLog(@"startCocosScene002...");

    //ScriptingCore::getInstance()->evalString("startJsCocosScene002()");
    ScriptingCore::getInstance()->evalString("main.js");
//    string param001 = "param001";
//    string param002 = "param002";
//    std::string jsCallStr = cocos2d::StringUtils::format("engineCallback(\"%s\",\"%s\");", param001.c_str(),param002.c_str());
//    NSLog(@"jsCallStr = %s", jsCallStr.c_str());
//    ScriptingCore::getInstance()->evalString(jsCallStr.c_str());
}

-(void) runCocosZipForName:(NSString*) zipName
{
    std::string zipNameStr = [zipName UTF8String];
    
    NSLog(@"CocosManager runCocosZipForName zipName = %s",zipNameStr.c_str());
    
    std::string writablePath = cocos2d::FileUtils::getInstance()->getWritablePath();
    cocos2d::FileUtils::getInstance()->addSearchPath(writablePath);
    
    cocos2d::extension::AssetsManagerEx* assetsManagerEx = new cocos2d::extension::AssetsManagerEx("test","test");
    bool isSucceed = assetsManagerEx->decompressLocalZip([zipName UTF8String]);
    
    if (isSucceed) {
        NSLog(@"applicationDidFinishLaunching isSucceed isSucceed");
        ScriptingCore::getInstance()->runScript("main.js");
    }
}


-(void)callJsEngineCallBack:(NSString*) funcNameStr withCmd:(NSString*) cmdStr withContent:(NSString*) contentStr
{
    NSLog(@"callJsEngineCallBack...");
    
    string funcName = [funcNameStr UTF8String];
    string param001 = [cmdStr UTF8String];
    string param002 = [contentStr UTF8String];
    std::string jsCallStr = cocos2d::StringUtils::format("%s(\"%s\",\"%s\");",funcName.c_str(), param001.c_str(),param002.c_str());
    NSLog(@"jsCallStr = %s", jsCallStr.c_str());
    ScriptingCore::getInstance()->evalString(jsCallStr.c_str());
}

-(void)enterCocosGameScene:(NSString*) userKey withRoomId:(int) roomId
{
    NSLog(@"enterCocosGameScene...");
    if (!self.m_bGameLayerIsVisible)
    {
        // NSLog(@"enterCocosGameScene... self.m_bGameLayerIsVisible = false");
        //不允许触摸穿透cocos层到ios的view
        //self.m_eaglView.m_allowedThrough = NO;
        self.m_bGameLayerIsVisible = true;
    }
    else
    {
        //NSLog(@"enterCocosGameScene... self.m_bGameLayerIsVisible = true");
        [self removeCocosGameLayer];
    }
}

-(void)removeCocosGameLayer
{
     NSLog(@"removeCocosGameLayer... ");
     self.m_bGameLayerIsVisible = false;
     //移除游戏界面后允许触摸穿透到ios层
     //self.m_eaglView.m_allowedThrough = YES;
     CppAdapter::getInstance()->removeCocosGameLayer();
}

-(void)cocosApplicationDidEnterBackground
{
    CocosDelegate::getInstance()->applicationDidEnterBackground();
}

-(void)cocosApplicationWillEnterForeground
{
     CocosDelegate::getInstance()->applicationWillEnterForeground();
}

-(void)exitCocosGame
{
    NSLog(@"exitCocosGame... ");
    //允许触摸穿透cocos层到ios的view
    //self.m_eaglView.m_allowedThrough = YES;
    self.m_bGameLayerIsVisible = false;
    //退出时删除eglview，不然再次加载时opengl会出错，模拟器显示红色，真机透明
    self.m_eaglView = nullptr;
    instance = nullptr;
    //CppAdapter::getInstance()->setCocosIsInit(false);
    //CppAdapter::getInstance()->exitCocosGame();
    cocos2d::Director::getInstance()->end();
}

@end
