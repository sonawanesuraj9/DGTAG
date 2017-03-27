//
//  ContentManager.m
//  SOSimpleChatDemo
//
// Created by : arturdev
// Copyright (c) 2014 SocialObjects Software. All rights reserved.
//

#import "ContentManager.h"
#import "Message.h"
#import "SOMessageType.h"

@implementation ContentManager

+ (ContentManager *)sharedManager
{
    static ContentManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (NSMutableArray *)generateConversation1
{
    NSMutableArray *result = [NSMutableArray new];
    NSArray *data = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Conversation" ofType:@"plist"]]];
    for (NSDictionary *msg in data) {
        Message *message = [[Message alloc] init];
        message.fromMe = [msg[@"fromMe"] boolValue];
        message.text = msg[@"message"];
        message.type = [self messageTypeFromString:msg[@"type"]];
        message.date = [NSDate date];
        
        int index = (int)[data indexOfObject:msg];
        if (index > 0) {
            Message *prevMesage = result.lastObject;
            message.date = [NSDate dateWithTimeInterval:((index % 2) ? 2 * 24 * 60 * 60 : 120) sinceDate:prevMesage.date];
        }
        
        if (message.type == SOMessageTypePhoto) {
            message.media = UIImageJPEGRepresentation([UIImage imageNamed:msg[@"image"]], 1);
        } else if (message.type == SOMessageTypeVideo) {
            message.media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:msg[@"video"] ofType:@"mp4"]];
            message.thumbnail = [UIImage imageNamed:msg[@"thumbnail"]];
        }

        [result addObject:message];
    }
    //[self login];
    return result;
}

-(NSMutableArray *)generateConversation
{
    
    NSMutableArray *result = [NSMutableArray new];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://milpeeps.com/dt-admin/messages/getmessage_information/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    //[request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *myID = [prefs stringForKey:@"user_id"];
    NSString *frID = [prefs stringForKey:@"friend_id_mes"];
    
    NSString *mapData = [NSString stringWithFormat:@"usenderid=%@&ureceiverid=%@",myID,frID];
    
    NSData *postData = [mapData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error == nil)
        {
            
            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            
            
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if(error!=nil)
            {
                NSLog(@"error = %@",error);
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                 NSLog(@"json = %@",json);
                if([[json valueForKey:@"status"] isEqual:@"0"]){
                    NSArray *data = [json valueForKey:@"data"];
                    NSLog(@"data = %@",data);
                    if(data.count > 0){
                        int i=0;
                        for (i = 0; i < (unsigned long)[data count]; i++) {
                            Message *message = [[Message alloc] init];
                            
                            bool *tmp;
                            NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"];
                            if([data[i][@"user_senderid"] isEqual:uid]){
                                tmp = YES;
                            }else{
                                tmp = NO;
                            }
                            message.fromMe =  tmp; //data[i][@"user_message"];//[msg[@"fromMe"] boolValue];
                            message.text =  data[i][@"user_message"]; //msg[@"message"];
                            message.type =  [self messageTypeFromString:@"SOMessageTypeText"];
                            
                            //message.date =  data[i][@"message_date"];//[NSDate date];
                            /*NSString *dateStr = data[i][@"message_date"];
                            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            NSDate *date = [dateFormat dateFromString:dateStr];
                            NSLog(@"current data%@",[NSDate date]);*/
                            
                            message.date = [NSDate date];  //date;
                            
                            int index = (int)[data indexOfObject:data];
                            if (index > 0) {
                                Message *prevMesage = result.lastObject;
                                message.date = [NSDate dateWithTimeInterval:((index % 2) ? 2 * 24 * 60 * 60 : 120) sinceDate:prevMesage.date];
                            }
                            
                            [result addObject:message];
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"chatDataLoaded" object:nil];
                        
                         NSLog(@"result here = %@",result);
                    }else{
                        NSLog(@"no message here = ");
                    }
                    
                }else{
                    NSLog(@"status is = 1 ");
                }
               
                //[self checkUserSuccessfulLogin:json];
            });
        }
        else{
            
            NSLog(@"Error : %@",error.description);
            
        }
        
        
    }];
    
    
    [postDataTask resume];
    
    return result;
}
- (void)checkUserSuccessfulLogin:(id)json
{
    //  NSError *error;
    NSDictionary *dictionary = (NSDictionary *)json;
    
    
    if ([[dictionary allKeys] containsObject:@"login"])
    {
        if ([[dictionary objectForKey:@"login"] boolValue])
        {
            
            NSLog(@"Successful");
            
        }
        else
        {
            NSLog(@"Unsuccessful, Try again.");
         
        }
    }
}


- (SOMessageType)messageTypeFromString:(NSString *)string
{
    if ([string isEqualToString:@"SOMessageTypeText"]) {
        return SOMessageTypeText;
    } else if ([string isEqualToString:@"SOMessageTypePhoto"]) {
        return SOMessageTypePhoto;
    } else if ([string isEqualToString:@"SOMessageTypeVideo"]) {
        return SOMessageTypeVideo;
    }

    return SOMessageTypeOther;
}

@end
