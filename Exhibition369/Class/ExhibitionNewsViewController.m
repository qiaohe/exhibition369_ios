//
//  ExhibitionNewsViewController.m
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "ExhibitionNewsViewController.h"

@interface ExhibitionNewsViewController ()

@end

@implementation ExhibitionNewsViewController

@synthesize delegate;
@synthesize tableView;
@synthesize NewsArray;
@synthesize UnloadImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"展会新闻";
    }
    return self;
}

- (void)dealloc
{
    [self.delegate    release];
    [self.tableView   release];
    [self.NewsArray   release];
    [self.UnloadImage release];
    [super dealloc];
}

- (void)ExhibitionNewsShow:(BOOL)CanShow
{
    self.UnloadImage.hidden = CanShow;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    NewsArray = [[NSMutableArray alloc]init];
    if ([[Model sharedModel] isConnectionAvailable]) {
        if(self.refreshHeaderView == nil)
        {
            self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(5.0f, 0.0f - 67, self.view.frame.size.width - 10.0f, 60)];
            
            self.refreshHeaderView.delegate = self;
            self.refreshHeaderView.backgroundColor = [UIColor clearColor];
            [self.tableView addSubview:self.refreshHeaderView];
            self.reloading = NO;
            [self updateData];
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
    }else{
            self.UnloadImage.hidden = NO;
    }
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - Drop_down to refresh

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [self.loadingMoreFooterView loadingMoreTableScrollViewDidScroll:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    
    NSLog(@"loading~~~");
    [self updateData];
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)updateData
{
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/news/find",ServerURL];
    [self sendRequestWith:urlString params:[NSDictionary dictionaryWithObject:[Model sharedModel].selectExhibition.exKey forKey:@"exKey"] method:RequestMethodGET];
}


- (IBAction)BackView:(id)sender
{
    [Model sharedModel].mainView = [[[MainViewController alloc] init] autorelease];

    [[Model sharedModel] pushView:[Model sharedModel].mainView option:ViewTrasitionEffectMoveRight];
}

- (IBAction)JumpToApplyView:(id)sender{
    
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.NewsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IdentifierStr = @"cell";
    NewsTableCell *cell = [tableViews dequeueReusableCellWithIdentifier:IdentifierStr];
    if (cell == nil) {
        cell = [[NewsTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IdentifierStr];
    }
    ExhibitionsNews *new = [self.NewsArray objectAtIndex:indexPath.row];
    
    [cell.titleLabel setText:new.Title];
    [cell.theImage setImage:new.Icon];
    [cell.detailLabel setText:new.NewsDate];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailViewController *newsView = [[NewsDetailViewController alloc]initWithNibName:@"NewsDetailViewController" bundle:nil];
    newsView.aNew = [self.NewsArray objectAtIndex:indexPath.row];
    [self.delegate SuperViewPresentViewController:newsView];
    [newsView release];
}

-(void)error:(ASIHTTPRequest *)request
{
    [self ExhibitionNewsShow:NO];
    NSLog(@"failed");
}

-(void)done:(ASIHTTPRequest *)request
{
    NSInteger RequestType = [[request.userInfo objectForKey:@"RequestType"]integerValue];
    if (RequestType == RequestNewsIcon) {
        ExhibitionsNews *new = [request.userInfo objectForKey:@"aNews"];
        new.Icon = [UIImage imageWithData:[request responseData]];
        
        [self reloadData];
    }else{
        [self.NewsArray removeAllObjects];
        NSString *responseStr = [request responseString];
        NSDictionary *dic = [responseStr JSONValue];
        NSArray *array = [dic objectForKey:@"list"];
        
        for (NSDictionary *resultDic in array) {
            ExhibitionsNews *new = [[ExhibitionsNews alloc]initWithEXKey:[Model sharedModel].selectExhibition.exKey];
            new.Title = [resultDic objectForKey:@"title"];
            new.NewsKey = [resultDic objectForKey:@"newsKey"];
            
            CGFloat timeoffset = [[resultDic objectForKey:@"createdAt"]floatValue];
            
            NSTimeInterval  timeZoneOffset=[[NSTimeZone systemTimeZone] secondsFromGMT];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeoffset/1000];
            
            NSString *NowDate = [dateFormat stringFromDate:date];
            date = [date dateByAddingTimeInterval:timeZoneOffset];
            
            new.NewsDate = NowDate;
            
            [self.NewsArray addObject:new];
            [new release];
            
            NSString *urlStr = [[Model sharedModel].systemConfig.assetServer stringByAppendingFormat:@"/%@/news/%@.png",[Model sharedModel].selectExhibition.exKey,new.NewsKey];
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:RequestNewsIcon] ,@"RequestType",
                                                                                 new ,@"aNews",
                                                                                 nil];
            [request setUserInfo:userInfo];
            request.delegate = self;
            [request startAsynchronous];
            [request release];
        }
        
        if ([self.NewsArray count]) {
            [self ExhibitionNewsShow:YES];
        }else{
            [self ExhibitionNewsShow:NO];
        }
    }
    self.reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
