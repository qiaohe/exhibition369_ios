//
//  DataButton.h
//  ChatClient
//
//  Created by Jack Wang on 6/8/13.
//
//

#import <UIKit/UIKit.h>

@interface DataButton : UIButton

@property(nonatomic, assign) NSObject *data;
@property(nonatomic, retain) NSIndexPath *selectIndex;

- (id)initWithFrame:(CGRect)frame data:(NSObject *)inObject;

@end
