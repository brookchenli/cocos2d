/****************************************************************************
Copyright (c) 2010 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/

#include "audio/include/SimpleAudioEngine.h"
#include "audio/ios/SimpleAudioEngine_objc.h"
#include "platform/CCFileUtils.h"

USING_NS_CC;

static void static_end()
{
    [SimpleAudioEngine  end];
}

static void static_preloadBackgroundMusic(const char* pszFilePath)
{
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic: [NSString stringWithUTF8String: pszFilePath]];
}

static void static_playBackgroundMusic(const char* pszFilePath, bool bLoop)
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic: [NSString stringWithUTF8String: pszFilePath] loop: bLoop];
}

static void static_preloadBackgroundMusic2(const char* pszFilePath)
{
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic2: [NSString stringWithUTF8String: pszFilePath]];
}


static void static_playBackgroundMusic2(const char* pszFilePath, bool bLoop)
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic2: [NSString stringWithUTF8String: pszFilePath] loop: bLoop];
}


static void static_stopBackgroundMusic()
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

static void static_stopBackgroundMusic2()
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic2];
}

static void static_pauseBackgroundMusic()
{
     [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}

static void static_pauseBackgroundMusic2()
{
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic2];
}
static void static_resumeBackgroundMusic()
{
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
} 

static void static_resumeBackgroundMusic2()
{
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic2];
}

static void static_rewindBackgroundMusic()
{
    [[SimpleAudioEngine sharedEngine] rewindBackgroundMusic];
}

static void static_rewindBackgroundMusic2()
{
    [[SimpleAudioEngine sharedEngine] rewindBackgroundMusic2];
}

static bool static_willPlayBackgroundMusic()
{
    return [[SimpleAudioEngine sharedEngine] willPlayBackgroundMusic];
}

static bool static_willPlayBackgroundMusic2()
{
    return [[SimpleAudioEngine sharedEngine] willPlayBackgroundMusic2];
}

static bool static_isBackgroundMusicPlaying()
{
    return [[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying];
}

static bool static_isBackgroundMusic2Playing()
{
    return [[SimpleAudioEngine sharedEngine] isBackgroundMusic2Playing];
}

static float static_getBackgroundMusicVolume()
{
    return [[SimpleAudioEngine sharedEngine] backgroundMusicVolume];
}

static float static_getBackgroundMusic2Volume()
{
    return [[SimpleAudioEngine sharedEngine] backgroundMusic2Volume];
}


static void static_setBackgroundMusicVolume(float volume)
{
    volume = MAX( MIN(volume, 1.0), 0 );
    [SimpleAudioEngine sharedEngine].backgroundMusicVolume = volume;
}

static void static_setBackgroundMusic2Volume(float volume)
{
    volume = MAX( MIN(volume, 1.0), 0 );
    [SimpleAudioEngine sharedEngine].backgroundMusic2Volume = volume;
}

static float static_getEffectsVolume()
{
    return [[SimpleAudioEngine sharedEngine] effectsVolume];
}
     
static void static_setEffectsVolume(float volume)
{
    volume = MAX( MIN(volume, 1.0), 0 );
    [SimpleAudioEngine sharedEngine].effectsVolume = volume;
}

static unsigned int static_playEffect(const char* pszFilePath, bool bLoop, Float32 pszPitch, Float32 pszPan, Float32 pszGain)
{
    return [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithUTF8String: pszFilePath] loop:bLoop pitch:pszPitch pan: pszPan gain:pszGain];
}
     
static void static_stopEffect(int nSoundId)
{
    [[SimpleAudioEngine sharedEngine] stopEffect: nSoundId];
}
     
static void static_preloadEffect(const char* pszFilePath)
{
    [[SimpleAudioEngine sharedEngine] preloadEffect: [NSString stringWithUTF8String: pszFilePath]];
}
     
static void static_unloadEffect(const char* pszFilePath)
{
    [[SimpleAudioEngine sharedEngine] unloadEffect: [NSString stringWithUTF8String: pszFilePath]];
}

static void static_pauseEffect(unsigned int uSoundId)
{
    [[SimpleAudioEngine sharedEngine] pauseEffect: uSoundId];
}

static void static_pauseAllEffects()
{
    [[SimpleAudioEngine sharedEngine] pauseAllEffects];
}

static void static_resumeEffect(unsigned int uSoundId)
{
    [[SimpleAudioEngine sharedEngine] resumeEffect: uSoundId];
}

static void static_resumeAllEffects()
{
    [[SimpleAudioEngine sharedEngine] resumeAllEffects];
}

static void static_stopAllEffects()
{
    [[SimpleAudioEngine sharedEngine] stopAllEffects];
}

namespace CocosDenshion {

static SimpleAudioEngine *s_pEngine;

SimpleAudioEngine::SimpleAudioEngine()
{

}

SimpleAudioEngine::~SimpleAudioEngine()
{

}

SimpleAudioEngine* SimpleAudioEngine::getInstance()
{
    if (! s_pEngine)
    {
        s_pEngine = new (std::nothrow) SimpleAudioEngine();
    }
    
    return s_pEngine;
}

void SimpleAudioEngine::end()
{
    if (s_pEngine)
    {
        delete s_pEngine;
        s_pEngine = nullptr;
    }
    
    static_end();
}

void SimpleAudioEngine::preloadBackgroundMusic(const char* pszFilePath)
{
    // Changing file path to full path
    std::string fullPath = FileUtils::getInstance()->fullPathForFilename(pszFilePath);
    static_preloadBackgroundMusic(fullPath.c_str());
}

void SimpleAudioEngine::playBackgroundMusic(const char* pszFilePath, bool bLoop)
{
    // Changing file path to full path
    NSLog(@"playBackgroundMusic ......");
    std::string fullPath = FileUtils::getInstance()->fullPathForFilename(pszFilePath);
    static_playBackgroundMusic(fullPath.c_str(), bLoop);
}

void SimpleAudioEngine::playBackgroundMusic2(const char* pszFilePath, bool bLoop){
    NSLog(@"playBackgroundMusic2 ......");
    std::string fullPath = FileUtils::getInstance()->fullPathForFilename(pszFilePath);
    static_playBackgroundMusic2(fullPath.c_str(), bLoop);
}
    
    
void SimpleAudioEngine::stopBackgroundMusic(bool bReleaseData)
{
    NSLog(@"file=%s func=%s 11", __FILE__, __FUNCTION__);
    static_stopBackgroundMusic();
}

    void SimpleAudioEngine::stopBackgroundMusic2(bool bReleaseData)
    {
        NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
        static_stopBackgroundMusic2();
    }

    
void SimpleAudioEngine::pauseBackgroundMusic()
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    static_pauseBackgroundMusic();
}

    void SimpleAudioEngine::pauseBackgroundMusic2()
    {
        NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
        static_pauseBackgroundMusic2();
    }
void SimpleAudioEngine::resumeBackgroundMusic()
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    static_resumeBackgroundMusic();
}
    void SimpleAudioEngine::resumeBackgroundMusic2()
    {
        NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
        static_resumeBackgroundMusic2();
    }

void SimpleAudioEngine::rewindBackgroundMusic()
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    static_rewindBackgroundMusic();
}

    void SimpleAudioEngine::rewindBackgroundMusic2()
    {
        NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
        static_rewindBackgroundMusic2();
    }
bool SimpleAudioEngine::willPlayBackgroundMusic()
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    return static_willPlayBackgroundMusic();
}
    bool SimpleAudioEngine::willPlayBackgroundMusic2()
    {
        NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
        return static_willPlayBackgroundMusic2();
    }

bool SimpleAudioEngine::isBackgroundMusicPlaying()
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    return static_isBackgroundMusicPlaying();
}

    bool SimpleAudioEngine::isBackgroundMusicPlaying2()
    {
       //return YES;
        NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
        return static_isBackgroundMusic2Playing();
    }
    
float SimpleAudioEngine::getBackgroundMusicVolume()
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    return static_getBackgroundMusicVolume();
}
    
    float SimpleAudioEngine::getBackgroundMusicVolume2()
    {
        //return 1.0;
        NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
        return static_getBackgroundMusic2Volume();
    }

void SimpleAudioEngine::setBackgroundMusicVolume(float volume)
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    static_setBackgroundMusicVolume(volume);
}
    void SimpleAudioEngine::setBackgroundMusicVolume2(float volume)
    {
        NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
        static_setBackgroundMusic2Volume(volume);
    }

float SimpleAudioEngine::getEffectsVolume()
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    return static_getEffectsVolume();
}

void SimpleAudioEngine::setEffectsVolume(float volume)
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    static_setEffectsVolume(volume);
}

void SimpleAudioEngine::preloadBackgroundMusic2(const char* filePath){
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    //static_preloadBackgroundMusic2(filePath);
}

    
unsigned int SimpleAudioEngine::playEffect(const char *pszFilePath, bool bLoop,
                                           float pitch, float pan, float gain)
{
    // Changing file path to full path
    std::string fullPath = FileUtils::getInstance()->fullPathForFilename(pszFilePath);
    return static_playEffect(fullPath.c_str(), bLoop, pitch, pan, gain);
}

void SimpleAudioEngine::stopEffect(unsigned int nSoundId)
{
    static_stopEffect(nSoundId);
}

void SimpleAudioEngine::preloadEffect(const char* pszFilePath)
{
    // Changing file path to full path
    std::string fullPath = FileUtils::getInstance()->fullPathForFilename(pszFilePath);
    static_preloadEffect(fullPath.c_str());
}

void SimpleAudioEngine::unloadEffect(const char* pszFilePath)
{
    // Changing file path to full path
    std::string fullPath = FileUtils::getInstance()->fullPathForFilename(pszFilePath);
    static_unloadEffect(fullPath.c_str());
}

void SimpleAudioEngine::pauseEffect(unsigned int uSoundId)
{
    static_pauseEffect(uSoundId);
}

void SimpleAudioEngine::resumeEffect(unsigned int uSoundId)
{
    static_resumeEffect(uSoundId);
}

void SimpleAudioEngine::pauseAllEffects()
{
    static_pauseAllEffects();
}

void SimpleAudioEngine::resumeAllEffects()
{
    static_resumeAllEffects();
}

void SimpleAudioEngine::stopAllEffects()
{
    static_stopAllEffects();
}

} // endof namespace CocosDenshion {
