//
//  ExhibitionMessageViewController.m
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "ExhibitionMessageViewController.h"

@interface ExhibitionMessageViewController ()

@end

@implementation ExhibitionMessageViewController

@synthesize tableView;
@synthesize messageArray;
@synthesize aMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"消息";
    }
    return self;
}

-(void)dealloc
{
    self.tableView    = nil;
    self.messageArray = nil;
    self.aMessage     = nil;
    [super dealloc];
}


- (IBAction)BackView:(id)sender
{
    
}

- (IBAction)JumpToApplyView:(id)sender{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IdentifierStr = @"cell";
    MessagesTableCell *cell = [_tableView dequeueReusableCellWithIdentifier:IdentifierStr];
    if (cell == nil) {
        cell = [[MessagesTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierStr];
    }
    Message *m = [self.messageArray objectAtIndex:indexPath.row];
    [cell.titleLabel setText:m.messageDate];
    [cell.contentLabel setText:m.Content];
    
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 6.0;
    self.view.layer.borderWidth = 1.0;
    self.view.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.messageArray = [[NSMutableArray alloc]init];
    self.tableView.editing = NO;
    [self initData];
    // Do any additional setup after loading the view from its nib.
}

- (void)initData
{
    /*
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *message = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"message" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *array = [message JSONValue];
            for (NSDictionary *dic in array) {
                NSLog(@"name = %@",[dic objectForKey:@"name"]);
                Message *m = [[Message alloc]init];
                m.messageTitle = [dic objectForKey:@"name"];
                m.Content      = [dic objectForKey:@"content"];
                [self.messageArray addObject:m];
                [self.tableView reloadData];
            }
        });
    });*/
    NSString *urlString = [ServerURL stringByAppendingString:@"/rest/messages/find"];
    urlString = [urlString stringByAppendingFormat:@"?exKey=%@&token=%@",[Model sharedModel].selectExhibition.exKey,[Model sharedModel].systemConfig.token];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSLog(@"title = %@,exKey = %@",[Model sharedModel].selectExhibition.name,[Model sharedModel].selectExhibition.exKey);
    request.delegate = self;
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"response = %@",[request responseString]);
    NSDictionary *requestDic = [[request responseString] JSONValue];
    NSArray *MessageList = [requestDic objectForKey:@"list"];
    for (NSDictionary *dic in MessageList) {
        Message *m = [[Message alloc]init];
        m.Content = [dic objectForKey:@"content"];
        m.exKey   = [Model sharedModel].selectExhibition.exKey;
        m.MsgKey  = [dic objectForKey:@"msgKey"];
        if ([dic objectForKey:@"Y"]) {
            m.messageState = YES;
        }else {
            m.messageState = NO;
        }
        CGFloat timeoffset = [[dic objectForKey:@"createdAt"]floatValue];
        
        NSTimeInterval  timeZoneOffset=[[NSTimeZone systemTimeZone] secondsFromGMT];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeoffset/1000];
        
        NSString *NowDate = [dateFormat stringFromDate:date];
        date = [date dateByAddingTimeInterval:timeZoneOffset];
        
        m.messageDate = NowDate;
        
        [self.messageArray addObject:m];
        [m release];
    }
    [self.tableView reloadData];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Failed");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
