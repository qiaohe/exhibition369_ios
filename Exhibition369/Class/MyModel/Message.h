//
//  Message.h
//  369HUI
//
//  Created by M J on 13-6-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic, retain) NSString *exKey;
@property (nonatomic, retain) NSString *messageTitle;
@property (nonatomic, retain) NSString *messageDate;
@property (nonatomic, assign) BOOL     messageState;
@property (nonatomic, retain) NSString *MsgKey;
@property (nonatomic, retain) NSString *Content;
@property (nonatomic, assign) BOOL     isExpand;

- (id)init;

@end
