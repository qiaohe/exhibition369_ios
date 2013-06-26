//
//  ExhibitionMessageViewController.h
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "BaseUIViewController.h"
#import "Model.h"
#import "MessagesTableCell.h"
#import "Message.h"

@interface ExhibitionMessageViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray       *messageArray;
@property (nonatomic, retain) Message              *aMessage;

@end
