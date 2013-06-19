//
//  IData.h
//  CCBN
//
//  Created by Jack Wang on 3/31/13.
//  Copyright (c) 2013 MobileDaily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IData : NSObject

- (NSObject *)getPData;
- (id)initWithPData:(NSObject *)data;
- (id)initWithJSONData:(NSDictionary *)data;

@end
