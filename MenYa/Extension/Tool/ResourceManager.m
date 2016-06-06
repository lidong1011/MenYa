//
//  ResourceManager.m
//  MenYa
//
//  Created by apple on 13/6/3.
//  Copyright © 2013年 ldq. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "ResourceManager.h"
#import "AppDelegate.h"

@implementation ResourceManager

-(id)init
{
    if (self = [super init])
    {
        imageDic = [[NSMutableDictionary alloc] initWithCapacity:100];
        soundDic = [[NSMutableDictionary alloc] initWithCapacity:100];
        musicDic = [[NSMutableDictionary alloc] initWithCapacity:100];
        
        _loadCheckTimer = nil;
        _resourceFileVersion = @"";
    }
    return self;
}

-(void)dealloc
{
//    [imageDic removeAllObjects];
//    TT_RELEASE_SAFELY(imageDic);
//    
//    [soundDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
//     {
//         AudioServicesDisposeSystemSoundID((SystemSoundID)[(NSNumber*)obj unsignedLongValue]);
//     }];
//    [soundDic removeAllObjects];
//    TT_RELEASE_SAFELY(soundDic);
//    
//    [musicDic removeAllObjects];
//    TT_RELEASE_SAFELY(musicDic);
    
//    [super dealloc];
}

//-(void)loadResources
//{
//    TBXML* tbxml = [[TBXML alloc] initWithXMLFile:@"resources.xml"];
//    TBXMLElement* root = tbxml.rootXMLElement;
//    
//    if (root != nil)
//    {
//        TBXMLElement* resInfo = [TBXML childElementNamed:@"resource" parentElement:root];
//        
//        while (resInfo != nil)
//        {
//            NSString* typeName = [TBXML valueOfAttributeNamed:@"id" forElement:resInfo];
//            if ([typeName isEqualToString:@"image"])
//            {
//                TBXMLElement* itemInfo = [TBXML childElementNamed:@"item" parentElement:resInfo];
//                while (itemInfo != nil)
//                {
//                    [self loadImage:[TBXML valueOfAttributeNamed:@"name" forElement:itemInfo]];
//                    itemInfo = [TBXML nextSiblingNamed:@"item" searchFromElement:itemInfo];
//                }
//            }
//            else if ([typeName isEqualToString:@"sound"])
//            {
//                TBXMLElement* itemInfo = [TBXML childElementNamed:@"item" parentElement:resInfo];
//                while (itemInfo != nil)
//                {
//                    [self loadSound:[TBXML valueOfAttributeNamed:@"name" forElement:itemInfo]];
//                    itemInfo = [TBXML nextSiblingNamed:@"item" searchFromElement:itemInfo];
//                }
//            }
//            else if ([typeName isEqualToString:@"music"])
//            {
//                TBXMLElement* itemInfo = [TBXML childElementNamed:@"item" parentElement:resInfo];
//                while (itemInfo != nil)
//                {
//                    [self loadMusic:[TBXML valueOfAttributeNamed:@"name" forElement:itemInfo]];
//                    itemInfo = [TBXML nextSiblingNamed:@"item" searchFromElement:itemInfo];
//                }
//            }
//            
//            resInfo = [TBXML nextSiblingNamed:@"resource" searchFromElement:resInfo];
//        }
//    }
//    
//    [tbxml release];
//}

-(UIImage*)loadImage:(NSString*)imageString
{
    UIImage* aImage = [UIImage imageNamed:imageString];
    [imageDic setValue:aImage forKey:imageString];
    return aImage;
}

-(SystemSoundID)loadSound:(NSString*)soundName
{
    SystemSoundID soundID;
    NSURL* soundpath = [[NSBundle mainBundle] URLForResource:[soundName stringByDeletingPathExtension] withExtension:[soundName pathExtension]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundpath, &soundID);
    [soundDic setValue:[NSNumber numberWithUnsignedLong:soundID] forKey:soundName];
    return soundID;
}

-(AVAudioPlayer*)loadMusic:(NSString*)musicName
{
    NSURL* musicpath = [[NSBundle mainBundle] URLForResource:[musicName stringByDeletingPathExtension] withExtension:[musicName pathExtension]];
    AVAudioPlayer* thePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicpath error:nil];
    [thePlayer prepareToPlay];
    [thePlayer setVolume:1.0];
    [musicDic setValue:thePlayer forKey:musicName];
    return thePlayer;
}

-(UIImage*)getUIImage:(NSString*)imageString
{
    UIImage* aImage = (UIImage*)[imageDic objectForKey:imageString];
    if (aImage)
    {
        return aImage;
    }
    else
    {
        UIImage* aImage = [self loadImage:imageString];
        return aImage;
    }
}

-(SystemSoundID)playSound:(NSString*)soundName
{
    SystemSoundID soundID;
    NSNumber* obj = [soundDic objectForKey:soundName];
    if (obj)
    {
        soundID = (SystemSoundID)[obj unsignedLongValue];
    }
    else
    {
        soundID = [self loadSound:soundName];
    }
    AudioServicesPlaySystemSound(soundID);
    return soundID;
}

-(void)playVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(AVAudioPlayer*)playMusic:(NSString*)musicName target:(id<AVAudioPlayerDelegate>)target loop:(BOOL)loop
{
    AVAudioPlayer* thePlayer = (AVAudioPlayer*)[musicDic objectForKey:musicName];
    if (!thePlayer)
    {
        thePlayer = [self loadMusic:musicName];
    }
    thePlayer.delegate = target;
    if (loop)
    {
        thePlayer.numberOfLoops = -1;
    }
    else
    {
        thePlayer.numberOfLoops = 0;
    }
    
    if (!thePlayer.isPlaying)
    {
        [thePlayer play];
    }
    
    return thePlayer;
}

-(void)stopMusic:(NSString*)musicName
{
    AVAudioPlayer* thePlayer = (AVAudioPlayer*)[musicDic objectForKey:musicName];
    if (thePlayer && thePlayer.isPlaying)
    {
        [thePlayer stop];
    }
}

-(void)stopAllMusic
{
    [musicDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         [((AVAudioPlayer*)obj) stop];
     }];
}

-(UIImage*)imageFromColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIView*)uiviewFromColor:(CGRect)frame bgColor:(UIColor*)color
{
    UIView* bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = color;
    return bgView;
}

-(void)promptUIAlertView:(NSString*)title message:(NSString*)messageStr
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:messageStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

-(void)promptUIAlertView:(NSString*)title message:(NSString*)messageStr delegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:messageStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertView.delegate = delegate;
    [alertView show];
}

-(UILabel*)commonLabel:(CGRect)frame title:(NSString*)labelText
{
    UILabel* commonLabel = [[UILabel alloc] initWithFrame:frame];
    commonLabel.text = labelText;
    commonLabel.textColor = [UIColor whiteColor];
    commonLabel.backgroundColor = [UIColor clearColor];
    commonLabel.textAlignment = NSTextAlignmentLeft;
    commonLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
    return commonLabel;
}

-(UILabel*)commonTitleLabel:(CGRect)frame title:(NSString*)labelText
{
    UILabel* commonTitle = [[UILabel alloc] initWithFrame:frame];
    commonTitle.text = labelText;
    commonTitle.textColor = [UIColor grayColor];
    commonTitle.backgroundColor = [UIColor clearColor];
    commonTitle.textAlignment = NSTextAlignmentLeft;
    commonTitle.font = [UIFont boldSystemFontOfSize:14.0];
    return commonTitle;
}

-(UILabel*)commonRankNumLabel:(CGRect)frame title:(NSString*)labelText
{
    UILabel* commonTitle = [[UILabel alloc] initWithFrame:frame];
    commonTitle.text = labelText;
    commonTitle.textColor = [UIColor whiteColor];
    commonTitle.backgroundColor = [UIColor clearColor];
    commonTitle.textAlignment = NSTextAlignmentRight;
    commonTitle.font = [UIFont systemFontOfSize:10.0];
    commonTitle.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8] ;
    commonTitle.shadowOffset = CGSizeMake(0, -1);
    return commonTitle;
}

-(UIButton*)commonUIButton:(CGRect)frame normalPic:(NSString*)normalPicStr
{
    UIButton* commonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commonBtn.frame = frame;
    [commonBtn setImage:[self getUIImage:normalPicStr] forState:UIControlStateNormal];
    return commonBtn;
}

-(UIButton*)commonUIButton:(CGRect)frame normalPic:(NSString*)normalPicStr highlightPic:(NSString*)highlighPicStr
{
    UIButton* commonBtn = [self commonUIButton:frame normalPic:normalPicStr];
    [commonBtn setImage:[self getUIImage:highlighPicStr] forState:UIControlStateHighlighted];
    return commonBtn;
}

-(UIButton*)commonUIButton:(CGRect)frame normalPic:(NSString*)normalPicStr highlightPic:(NSString*)highlighPicStr disablePic:(NSString*)disablePicStr
{
    UIButton* commonBtn = [self commonUIButton:frame normalPic:normalPicStr highlightPic:highlighPicStr];
    [commonBtn setImage:[self getUIImage:disablePicStr] forState:UIControlStateDisabled];
    return commonBtn;
}

-(UIButton*)commonGrayUIButton:(CGRect)frame title:(NSString*)title
{
    UIButton* commonBtn = [[UIButton alloc] initWithFrame:frame];
    commonBtn.backgroundColor = [UIColor clearColor];
    [commonBtn setBackgroundImage:[UIImage imageNamed:@"btn_gray.png"] forState:UIControlStateNormal];
    [commonBtn setTitle:title forState:UIControlStateNormal];
    [commonBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commonBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:[UIFont buttonFontSize]]];
    return commonBtn;
}

-(UIButton*)commonRedUIButton:(CGRect)frame title:(NSString*)title
{
    UIButton* commonBtn = [[UIButton alloc] initWithFrame:frame];
    commonBtn.backgroundColor = [UIColor clearColor];
    [commonBtn setBackgroundImage:[UIImage imageNamed:@"btn_red.png"] forState:UIControlStateNormal];
    [commonBtn setTitle:title forState:UIControlStateNormal];
    [commonBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commonBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:[UIFont buttonFontSize]]];
    return commonBtn;
}

-(UIImageView*)commonUIImageView:(NSString*)picStr
{
    UIImageView* commonUIImageView = [[UIImageView alloc] initWithImage:[self getUIImage:picStr]];
    return commonUIImageView;
}

-(UIImageView*)commonUIImageView:(NSString*)picStr frame:(CGRect)frame
{
    UIImageView* commonUIImageView = [self commonUIImageView:picStr];
    commonUIImageView.frame = frame;
    return commonUIImageView;
}

-(UIImageView*)commonRaidusUIImageView:(NSString*)picStr frame:(CGRect)frame
{
    UIImageView* commonUIImageView = [self commonUIImageView:picStr frame:frame];
    commonUIImageView.backgroundColor = [UIColor clearColor];
    commonUIImageView.layer.cornerRadius = 8;
    commonUIImageView.layer.masksToBounds = YES;
    commonUIImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    commonUIImageView.layer.borderWidth = 2.0;
    return commonUIImageView;
}

//-(NSString*)urlEncode:(NSString*)unencodeString
//{
//    NSString * encodedString = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)unencodeString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
//    
//    return encodedString;
//}
//
//-(NSString*)urlDecode:(NSString*)unencodeString
//{
//    NSString * decodedString = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)unencodeString, CFSTR(""), kCFStringEncodingUTF8);
//    
//    return decodedString;
//}

-(float)degreeToRad:(float)degree
{
    return degree * 3.14159 / 180.0;
}

-(NSData *)AES128EncryptWithKey:(NSData *)oriData key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];
    
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [oriData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          
                                          keyPtr, kCCKeySizeAES128,
                                          
                                          NULL,
                                          
                                          [oriData bytes], dataLength,
                                          
                                          buffer, bufferSize,
                                          
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

-(NSData *)AES128DecryptWithKey:(NSData *)oriData key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];
    
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [oriData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          
                                          keyPtr, kCCKeySizeAES128,
                                          
                                          NULL,
                                          
                                          [oriData bytes], dataLength,
                                          
                                          buffer, bufferSize,
                                          
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

-(void)setNaviBg:(UIViewController*)nav
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *backgroundImage = [self imageFromColor:[UIColor clearColor]];
    if (version >= 5.0)
    {
        if (version >= 7.0)
        {
            nav.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
            [nav.navigationController.navigationBar setBackgroundImage:backgroundImage forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
            nav.edgesForExtendedLayout = UIRectEdgeNone;
        }
        else
        {
            [nav.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        }
    }
    else
    {
        [nav.navigationController.navigationBar insertSubview:[[UIImageView alloc] initWithImage:backgroundImage] atIndex:1];
    }
}

-(UIBarButtonItem*)getBackBarItem:(id)target action:(SEL)action
{
    return [self getBarItemWithBtn:@"back.png" target:target action:action];
}

-(UIBarButtonItem*)getSideBarItem:(id)target action:(SEL)action
{
    return [self getBarItemWithBtn:@"sidebar.png" target:target action:action];
}

-(UIBarButtonItem*)getBarItemWithBtn:(NSString*)imageName  target:(id)target  action:(SEL)action
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 60, 40)];
    [btn setBackgroundImage:[self getUIImage:imageName] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

-(NSString*)getDateTimeStringWithDate:(NSDate*)date
{
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    return [dateFormatter stringFromDate:date];
}

-(NSString*)formatNum:(int)num
{
    return [NSString stringWithFormat:@"%d", num];
}

-(BOOL)isIOS7
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return version >= 7.0;
}
@end
