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

@synthesize delegate;
@synthesize tableView;
@synthesize messageArray;
@synthesize aMessage;
@synthesize heightsForRows;
@synthesize NewTouchCell;
@synthesize OldTouchCell;
@synthesize OldIndexPath;
@synthesize OldMessage;
@synthesize UnloadImage;

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
    [self.delegate       release];
    [self.tableView      release];
    [self.messageArray   release];
    [self.aMessage       release];
    [self.heightsForRows release];
    [self.NewTouchCell   release];
    [self.OldTouchCell   release];
    [self.OldIndexPath   release];
    [self.OldMessage     release];
    [self.UnloadImage    release];
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
    Message *m = [self.messageArray objectAtIndex:indexPath.row];
    CGSize size = [m.Content sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:13] constrainedToSize:CGSizeMake(320, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat changeHeight = size.height - 25.0f;
    if (m.isExpand) {
        if (changeHeight > 0) {
            return 70.0f + changeHeight;
        }else
            return 70.0f;
    }else{
        return 70.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IdentifierStr = @"cell";
    MessagesTableCell *cell = [_tableView dequeueReusableCellWithIdentifier:IdentifierStr];
    if (cell == nil) {
        cell = [[[MessagesTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierStr]autorelease];
    }
    cell.hidden = NO;
    Message *m = [self.messageArray objectAtIndex:indexPath.row];
    CGSize size = [m.Content sizeWithFont:cell.titleLabel.font constrainedToSize:CGSizeMake(320, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    NSInteger isExit = m.isExpand;
    if (isExit) {
        NSNumber *num = [NSNumber numberWithFloat:(size.height - 25.0f)];
        [cell ChangeCellHeightWithNum:num];
    }else if(isExit == 0){
        [cell ChangeCellHeightWithNum:[NSNumber numberWithFloat:-1]];
    }
 
    [cell.titleLabel setText:m.Content];
    [cell.contentLabel setText:m.messageDate];
    
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *m = [self.messageArray objectAtIndex:indexPath.row];
    MessagesTableCell *cell = (MessagesTableCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    self.OldTouchCell = cell;
    m.isExpand = m.isExpand?NO:YES;
    if (m.isExpand) {
        cell.hidden = YES;
    }else if(!m.isExpand){
        cell.hidden = YES;
    }
    [self reloadRowAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

- (void) reloadRowAtIndexPaths:(NSArray*)IndexPaths
{
    [self.tableView reloadRowsAtIndexPaths:IndexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    messageArray = [[NSMutableArray alloc]init];
    heightsForRows = [[NSMutableArray alloc]init];
    //self.tableView.editing = NO;
        
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self CheckMessageNum];
}

- (void)CheckMessageNum
{
    if ([[Model sharedModel] isConnectionAvailable]) {
        if(self.refreshHeaderView == nil)
        {
            self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(5.0f, 0.0f - 67, self.view.frame.size.width - 10.0f, 60)];
                
            self.refreshHeaderView.delegate = self;
            self.refreshHeaderView.backgroundColor = [UIColor clearColor];
            [self.tableView addSubview:self.refreshHeaderView];
            self.reloading = NO;
        }
        if(self.loadingMoreFooterView == nil)
        {
            self.loadingMoreFooterView = [[LoadingMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 60)];
            self.loadingMoreFooterView.haveMoreData = NO;
            self.loadingMoreFooterView.delegate = self;
            self.loadingMoreFooterView.backgroundColor = [UIColor clearColor];
            if (self.loadingMoreFooterView.haveMoreData == YES) {
                [self.tableView setTableFooterView:self.loadingMoreFooterView];
            }
        }
        [self.refreshHeaderView refreshLastUpdatedDate];
        [self initData];
    }else{
        self.UnloadImage.hidden = NO;
    }
}

- (void)initData
{
    NSString *urlString = [ServerURL stringByAppendingString:@"/rest/messages/find"];
    urlString = [urlString stringByAppendingFormat:@"?exKey=%@&token=%@",[Model sharedModel].selectExhibition.exKey,[Model sharedModel].systemConfig.token];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.delegate = self;
    [request startAsynchronous];
}


#pragma mark - Drop_down to refresh

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [self.loadingMoreFooterView loadingMoreTableScrollViewDidScroll:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    
    NSLog(@"loading~~~");
    [self initData];
}

- (void)RefreshStop
{
    self.reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return self.reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

#pragma mark - Drop_up to refresh

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!self.reloading) {
        [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    [self.loadingMoreFooterView setState:LoadingMoreNormal];
    if (!decelerate)
	{
        //[self loadImagesForOnscreenRows];
    }
}


#pragma mark - LoadingMoreTableFooterDelegate

- (void)didTriggerLoadingMore:(LoadingMoreTableFooterView*)view{
    //self.loadingMoreFooterView.isLoading = NO;
    //[self.loadingMoreFooterView loadingMoreTableDataSourceDidFinishedLoading:self.tableView];
}



- (void)done:(ASIHTTPRequest *)request
{
    NSDictionary *requestDic = [[request responseString] JSONValue];
    NSArray *MessageList = [requestDic objectForKey:@"list"];
    [messageArray removeAllObjects];
    for (NSDictionary *dic in MessageList) {
        Message *m = [[Message alloc]init];
        m.Content = [dic objectForKey:@"content"];
        m.exKey   = [Model sharedModel].selectExhibition.exKey;
        m.MsgKey  = [dic objectForKey:@"msgKey"];
        NSString *read = [dic objectForKey:@"read"];
        if ([read isEqualToString:@"Y"]) {
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
        [self.heightsForRows addObject:[NSNumber numberWithFloat:70.0f]];
        [m release];
    }
    
    NSInteger i = 0;
    for (Message * m in self.messageArray) {
        if (!m.messageState) {
            i ++;
        }
    }
    if ([self.messageArray count]) {
        self.UnloadImage.hidden = YES;
    }else{
        self.UnloadImage.hidden = NO;
    }
    self.reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    //[self.delegate ShowMessageUnReadWithNum:i];
    
    [self.tableView reloadData];
}

-(void)error:(ASIHTTPRequest *)request
{
    NSLog(@"Message Failed");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
