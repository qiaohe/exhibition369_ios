//
//  ExhibitionsNews.h
//  369HUI
//
//  Created by M J on 13-6-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExhibitionsNews : NSObject

@property (nonatomic, assign) NSInteger NewsKey;
@property (nonatomic, retain) UIImage   *Icon;
@property (nonatomic, retain) NSString  *Title;
@property (nonatomic, retain) NSString  *Content;
@property (nonatomic, retain) NSString  *exKey;

- (id)initWithEXKey:(NSString*)_exKey;

@end
