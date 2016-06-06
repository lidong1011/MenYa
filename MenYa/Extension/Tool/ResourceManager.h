//
//  ResourceManager.h
//  MenYa
//
//  Created by apple on 13/6/3.
//  Copyright © 2013年 ldq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define RESOURCE_FILE_VERSION_KEY  @"Resource_File_Version_Key"
//if the resource class is changed, we must change the file version
#define RESOURCE_FILE_VERSION      @"1.0"
#define RESOURCE_FILE_NAME         @"Resource_File"

#define RESOURCE_LOAD_SUCCESS      @"Resource_Load_Success"
#define RESOURCE_LOAD_FAIL         @"Resource_Load_Fail"

@interface ResourceManager : NSObject
{
    NSMutableDictionary*   imageDic;
    NSMutableDictionary*   soundDic;
    NSMutableDictionary*   musicDic;
    
    NSTimer*               _loadCheckTimer;
    
    NSString*              _resourceFileVersion;
    
}

-(void)loadResources;

-(UIImage*)loadImage:(NSString*)imageString;
-(SystemSoundID)loadSound:(NSString*)soundName;
-(AVAudioPlayer*)loadMusic:(NSString*)musicName;

-(UIImage*)getUIImage:(NSString*)imageString;

-(SystemSoundID)playSound:(NSString*)soundName;
-(void)playVibrate;
-(AVAudioPlayer*)playMusic:(NSString*)musicName target:(id<AVAudioPlayerDelegate>)target loop:(BOOL)loop;
-(void)stopMusic:(NSString*)musicName;
-(void)stopAllMusic;

-(UIImage*)imageFromColor:(UIColor*)color;
-(UIView*)uiviewFromColor:(CGRect)frame bgColor:(UIColor*)color;

-(void)promptUIAlertView:(NSString*)title message:(NSString*)messageStr;
-(void)promptUIAlertView:(NSString*)title message:(NSString*)messageStr delegate:(id<UIAlertViewDelegate>)delegate;

-(UILabel*)commonLabel:(CGRect)frame title:(NSString*)labelText;
-(UILabel*)commonTitleLabel:(CGRect)frame title:(NSString*)labelText;
-(UILabel*)commonRankNumLabel:(CGRect)frame title:(NSString*)labelText;

-(UIButton*)commonUIButton:(CGRect)frame normalPic:(NSString*)normalPicStr;
-(UIButton*)commonUIButton:(CGRect)frame normalPic:(NSString*)normalPicStr highlightPic:(NSString*)highlighPicStr;
-(UIButton*)commonUIButton:(CGRect)frame normalPic:(NSString*)normalPicStr highlightPic:(NSString*)highlighPicStr disablePic:(NSString*)disablePicStr;

-(UIImageView*)commonUIImageView:(NSString*)picStr;
-(UIImageView*)commonUIImageView:(NSString*)picStr frame:(CGRect)frame;
-(UIImageView*)commonRaidusUIImageView:(NSString*)picStr frame:(CGRect)frame;

-(UIButton*)commonGrayUIButton:(CGRect)frame title:(NSString*)title;
-(UIButton*)commonRedUIButton:(CGRect)frame title:(NSString*)title;

-(NSString*)urlEncode:(NSString*)unencodeString;
-(NSString*)urlDecode:(NSString*)unencodeString;

-(float)degreeToRad:(float)degree;
-(float)getDistanceByLatLng:(float)lat1 lng1:(float)lng1 lat2:(float)lat2 lng2:(float)lng2;

-(NSString *)md5HexDigest:(NSString*)str;
-(NSData *)AES128EncryptWithKey:(NSData *)oriData key:(NSString *)key;
-(NSData *)AES128DecryptWithKey:(NSData *)oriData key:(NSString *)key;
-(NSString*)generateLoginSign:(NSString*)userName pwd:(NSString*)password;

-(void)setNaviBg:(UIViewController*)nav;

-(UIBarButtonItem*)getBackBarItem:(id)target action:(SEL)action;
-(UIBarButtonItem*)getSideBarItem:(id)target action:(SEL)action;
-(UIBarButtonItem*)getBarItemWithBtn:(NSString*)imageName target:(id)target action:(SEL)action;

-(NSString*)getDateTimeStringWithDate:(NSDate*)date;
-(NSString*)formatNum:(int)num;

-(BOOL)isIOS7;

@end
