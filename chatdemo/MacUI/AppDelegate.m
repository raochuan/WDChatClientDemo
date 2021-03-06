//
//  AppDelegate.m
//  MacUI
//
//  Created by zhangyuchen on 15-3-27.
//  Copyright (c) 2015年 zhangyuchen. All rights reserved.
//

#import "AppDelegate.h"
#import "GLMProtocolCenter.h"
#import "WDIMClient.h"
#import "GLMProtocolManager.h"
#import "Msg.pb.h"


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    WDIMClient *client = [WDIMClient instance];
    [[WDIMClient instance] startService];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receviedNewMessage:)
                                                 name:kGLMNotificationMessageNotify
                                               object:nil];
//    [client startService];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [client handshake];
//    });
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [client login];
//    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [client sendMessage];
//    });
    
}

- (void)receviedNewMessage:(NSNotification *)nofity
{
    
    CMsgPBContent *msgContent = nofity.object;
    _chatMessageView.stringValue = [NSString stringWithFormat:@"%@\n%@",_chatMessageView.stringValue, msgContent.msgData];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)handShake:(id)sender
{
    [[WDIMClient instance] handshake];
    
    
}

- (IBAction)loginClicked:(id)sender
{
    
    
    
    
    
    
    NSString *uid = [_userIDField stringValue];;
    
    NSString *uss = [_wdussDField stringValue];
    
    [[WDIMClient instance] loginWithUserID:uid
                                       uss:uss
                                completion:^(id responeObject, NSError *error) {
        NSLog(@"%@ %@", responeObject, error);
                                    
                                    if (error) {
                                        NSAlert *alert = [NSAlert alertWithError:error];
                                        [alert beginSheetModalForWindow:_window completionHandler:^(NSModalResponse returnCode) {
                                            
                                        }];
                                    } else {
                                        NSAlert *alert = [NSAlert alertWithMessageText:@"登录成功" defaultButton:@"ok" alternateButton:@"" otherButton:@"" informativeTextWithFormat:@""];
                                        [alert beginSheetModalForWindow:_window completionHandler:^(NSModalResponse returnCode) {
                                            
                                        }];
                                        
                                        [[GLMProtocolManager sharedManager] startHeartbreakSchedule];
                                    }
                                    
    }];
}

- (IBAction)sendMessageClicked:(id)sender
{
    NSString *uid = [_msgToUIDField stringValue];
    
    NSString *messageContent = _msgContentField.stringValue;
    
    [[WDIMClient instance] sendMessageToUid:uid
                                    content:messageContent
                                 completion:^(id responeObject, NSError *error) {
        NSLog(@"%@ %@", responeObject, error);
                                     if (error) {
                                         NSAlert *alert = [NSAlert alertWithError:error];
                                         [alert beginSheetModalForWindow:_window completionHandler:^(NSModalResponse returnCode) {
                                             
                                         }];
                                     } else {
                                         _chatMessageView.stringValue = [NSString stringWithFormat:@"%@\n%@",_chatMessageView.stringValue, messageContent];
                                     }
                                     
                                     
                            
    }];

}

@end
