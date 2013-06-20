//
//  ExhibitionNewsViewController.h
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "BaseUIViewController.h"
#import "NewsTableCell.h"
#import "Model.h"

@interface ExhibitionNewsViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView     *tableView;
@property (nonatomic, retain) NSMutableArray           *NewsArray;
@property (nonatomic, assign) NSInteger                index;

- (IBAction)BackView:(id)sender;
- (IBAction)JumpToApplyView:(id)sender;

@end
