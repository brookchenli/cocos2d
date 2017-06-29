/*
 Copyright (c) 2010 Steve Oldmeadow
 
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
 
 $Id$
 */

#import "audio/ios/SimpleAudioEngine_objc.h"

@implementation SimpleAudioEngine

static SimpleAudioEngine *sharedEngine = nil;
static CDSoundEngine* soundEngine = nil;
static CDAudioManager *am = nil;
static CDBufferManager *bufferManager = nil;

// Init
+ (SimpleAudioEngine *) sharedEngine
{
    @synchronized(self)     {
        if (!sharedEngine)
            sharedEngine = [[SimpleAudioEngine alloc] init];
    }
    return sharedEngine;
}

+ (id) alloc
{
    @synchronized(self)     {
        NSAssert(sharedEngine == nil, @"Attempted to allocate a second instance of a singleton.");
        return [super alloc];
    }
    return nil;
}

-(id) init
{
    if((self=[super init])) {
        am = [CDAudioManager sharedManager];
        soundEngine = am.soundEngine;
        bufferManager = [[CDBufferManager alloc] initWithEngine:soundEngine];
        mute_ = NO;
        enabled_ = YES;
    }
    return self;
}

// Memory
- (void) dealloc
{
    am = nil;
    soundEngine = nil;
    bufferManager = nil;
    [super dealloc];
}

+(void) end 
{
    am = nil;
    [CDAudioManager end];
    [bufferManager release];
    [sharedEngine release];
    sharedEngine = nil;
}    

#pragma mark SimpleAudioEngine - background music

-(void) preloadBackgroundMusic:(NSString*) filePath {
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    [am preloadBackgroundMusic:filePath];
}

-(void) preloadBackgroundMusic2:(NSString*) filePath {
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    [am preloadBackgroundMusic2:filePath];
}

-(void) playBackgroundMusic:(NSString*) filePath
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    [am playBackgroundMusic:filePath loop:TRUE];
}

-(void) playBackgroundMusic2:(NSString*) filePath
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    [am playBackgroundMusic2:filePath loop:TRUE];
}

-(void) playBackgroundMusic:(NSString*) filePath loop:(BOOL) loop
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    [am playBackgroundMusic:filePath loop:loop];
}

-(void) playBackgroundMusic2:(NSString*) filePath loop:(BOOL) loop
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    [am playBackgroundMusic2:filePath loop:loop];
}

-(void) stopBackgroundMusic
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    [am stopBackgroundMusic];
}

-(void) stopBackgroundMusic2
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    [am stopBackgroundMusic2];
}


-(void) pauseBackgroundMusic {
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    [am pauseBackgroundMusic];
}

-(void) pauseBackgroundMusic2 {
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    [am pauseBackgroundMusic2];
}

-(void) resumeBackgroundMusic {
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    [am resumeBackgroundMusic];
}

-(void) resumeBackgroundMusic2 {
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    [am resumeBackgroundMusic2];
}

-(void) rewindBackgroundMusic {
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    [am rewindBackgroundMusic];
}

-(void) rewindBackgroundMusic2 {
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    [am rewindBackgroundMusic2];
}

-(BOOL) isBackgroundMusicPlaying {
    BOOL value = [am isBackgroundMusicPlaying];
    NSLog(@"file=%s func=%s value=%@", __FILE__, __FUNCTION__, value?@"yes":@"no");
    return value;
}

-(BOOL) isBackgroundMusic2Playing {
    BOOL value = [am isBackgroundMusic2Playing];
    NSLog(@"file=%s func=%s value=%@", __FILE__, __FUNCTION__, value?@"yes":@"no");
    return value;
}

-(BOOL) willPlayBackgroundMusic {
    BOOL value = [am willPlayBackgroundMusic];
    NSLog(@"file=%s func=%s value=%@", __FILE__, __FUNCTION__, value?@"yes":@"no");
    return value;
}

-(BOOL) willPlayBackgroundMusic2 {
    BOOL value = [am willPlayBackgroundMusic2];
    NSLog(@"file=%s func=%s value=%@", __FILE__, __FUNCTION__, value?@"yes":@"no");
    return value;
}



#pragma mark SimpleAudioEngine - sound effects

-(ALuint) playEffect:(NSString*) filePath loop:(BOOL) loop
{
    return [self playEffect:filePath loop:loop pitch:1.0f pan:0.0f gain:1.0f];
}

-(ALuint) playEffect:(NSString*) filePath loop:(BOOL) loop pitch:(Float32) pitch pan:(Float32) pan gain:(Float32) gain
{
    int soundId = [bufferManager bufferForFile:filePath create:YES];
    if (soundId != kCDNoBuffer) {
        return [soundEngine playSound:soundId sourceGroupId:0 pitch:pitch pan:pan gain:gain loop:loop];
    } else {
        return CD_MUTE;
    }    
}

-(void) stopEffect:(ALuint) soundId {
    [soundEngine stopSound:soundId];
}    

-(void) pauseEffect:(ALuint) soundId {
  [soundEngine pauseSound: soundId];
}

-(void) pauseAllEffects {
  [soundEngine pauseAllSounds];
}

-(void) resumeEffect:(ALuint) soundId {
  [soundEngine resumeSound: soundId];
}

-(void) resumeAllEffects {
  [soundEngine resumeAllSounds];
}

-(void) stopAllEffects {
  [soundEngine stopAllSounds];
}

-(void) preloadEffect:(NSString*) filePath
{
    int soundId = [bufferManager bufferForFile:filePath create:YES];
    if (soundId == kCDNoBuffer) {
        CDLOG(@"Denshion::SimpleAudioEngine sound failed to preload %@",filePath);
    }
}

-(void) unloadEffect:(NSString*) filePath
{
    CDLOGINFO(@"Denshion::SimpleAudioEngine unloadedEffect %@",filePath);
    [bufferManager releaseBufferForFile:filePath];
}

#pragma mark Audio Interrupt Protocol
-(BOOL) mute
{
    return mute_;
}

-(void) setMute:(BOOL) muteValue
{
    if (mute_ != muteValue) {
        mute_ = muteValue;
        am.mute = mute_;
    }    
}

-(BOOL) enabled
{
    return enabled_;
}

-(void) setEnabled:(BOOL) enabledValue
{
    if (enabled_ != enabledValue) {
        enabled_ = enabledValue;
        am.enabled = enabled_;
    }    
}


#pragma mark SimpleAudioEngine - BackgroundMusicVolume
-(float) backgroundMusicVolume
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    return am.backgroundMusic.volume;
}    

-(float) backgroundMusic2Volume
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    return am.backgroundMusic2.volume;
}
-(void) setBackgroundMusicVolume:(float) volume
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    am.backgroundMusic.volume = volume;
}    

-(void) setBackgroundMusic2Volume:(float) volume
{
    NSLog(@"file=%s func=%s", __FILE__, __FUNCTION__);
    am.backgroundMusic2.volume = volume;
}

#pragma mark SimpleAudioEngine - EffectsVolume
-(float) effectsVolume
{
    return am.soundEngine.masterGain;
}    

-(void) setEffectsVolume:(float) volume
{
    am.soundEngine.masterGain = volume;
}    

-(CDSoundSource *) soundSourceForFile:(NSString*) filePath {
    int soundId = [bufferManager bufferForFile:filePath create:YES];
    if (soundId != kCDNoBuffer) {
        CDSoundSource *result = [soundEngine soundSourceForSound:soundId sourceGroupId:0];
        CDLOGINFO(@"Denshion::SimpleAudioEngine sound source created for %@",filePath);
        return result;
    } else {
        return nil;
    }    
}    

@end 
