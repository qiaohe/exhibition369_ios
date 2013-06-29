//
//  MainViewController.m
//  Exhibition369
//
//  Created by Jack Wang on 6/17/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import "MainViewController.h"
#import "Model.h"
#import "Exhibition.h"
#import "ExhibitionDetailViewController.h"
#import "Utils.h"
#import "DataButton.h"
#import "Constant.h"
#import "ExhibitionTableCell.h"
#import "IconDownloader.h"
#import "PlistProxy.h"
#import "ApplyViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize AppliedExhibitions;
@synthesize requestQueue;
@synthesize appliedStateBtn;
@synthesize SearchArray;


-(id)init
{
    if ((self = [super init]))
    {
        typeGroup = [[NSMutableArray alloc] init];
        typeVSExhibitions = [[NSMutableDictionary alloc] init];
        
        unAppliedExhibitions = [[NSMutableArray alloc] init];
        AppliedExhibitions = [[NSMutableArray alloc]init];
        SearchArray = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    /*
    activeTab = MainViewActiveTabAppliedExhibitions;
    self.appliedBtn.selected = YES;
    self.unAppliedBtn.selected = NO;
    [self.tabImage setImage:[UIImage imageNamed:@"2.png"]];
    [_theTableView reloadData];*/
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    activeTab = MainViewActiveTabExhibitions;
    [_tabImage setImage:[UIImage imageNamed:@"1.png"]];
    

    self.requestQueue = [[ASINetworkQueue alloc]init];
    self.requestQueue.delegate = self;
    [self.requestQueue setQueueDidFinishSelector:@selector(QueueDidFinish:)];
    [self.requestQueue setRequestDidFinishSelector:@selector(requestFinished:)];
    [self.requestQueue go];
    
    [self updateData];
    if ([Model sharedModel].HaveNetwork) {
        [self requestExhibitions];
    }else{
        /*
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"未连接网络" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];*/
        [self SetListStateWithActiveTab:MainViewActiveTabAppliedExhibitions];
    }
    
    
    if(self.refreshHeaderView == nil)
    {
        self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(5.0f, 0.0f - 67, self.view.frame.size.width - 10.0f, 60)];
        
        self.refreshHeaderView.delegate = self;
        self.refreshHeaderView.backgroundColor = [UIColor clearColor];
        [self.theTableView addSubview:self.refreshHeaderView];
        self.reloading = NO;
    }
    [self.refreshHeaderView refreshLastUpdatedDate];
}

- (void)QueueDidFinish:(ASIHTTPRequest*)request
{
    /*
    NSMutableArray *appliedList = [[NSMutableArray alloc]init];
    for (int i = 0;i<[self.AppliedExhibitions count];i++) {
        Exhibition *e = [self.AppliedExhibitions objectAtIndex:i];
        for (Exhibition *elem in unAppliedExhibitions) {
            if ([e.exKey isEqualToString:elem.exKey]) {
                elem.status = e.status;
                NSLog(@"e.status = %@",e.status);
                [appliedList addObject:elem];
            }else {
                if (![appliedList containsObject:elem]) {
                    elem.status = @"N";
                }
            }
        }
    }
    for (Exhibition *el in appliedList) {
        NSLog(@"el.status = %@",el.status);
    }
    self.AppliedExhibitions = appliedList;
    */
    [self.AppliedExhibitions removeAllObjects];
    for (Exhibition *e in unAppliedExhibitions) {
        if (![e.status isEqualToString:@"N"]) {
            [self.AppliedExhibitions addObject:e];
        }
    }
    [Model sharedModel].appliedExhibitionList = AppliedExhibitions;
    [[PlistProxy sharedPlistProxy]updateAppliedExhibitions];
    self.reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.theTableView];
    [self reloadData];
}

- (void) reloadData
{
    for (Exhibition *e in self.AppliedExhibitions) {
        if (![self AppliedExhibitions:[Model sharedModel].appliedExhibitionList ContentsObject:e]) {
            [[Model sharedModel].appliedExhibitionList addObject:e];
            [[PlistProxy sharedPlistProxy] updateAppliedExhibitions];
        }
    }
    [self updateData];
    
}

- (void)updateData
{
    [typeGroup removeAllObjects];
	[typeVSExhibitions removeAllObjects];
    NSString *group;
    NSMutableArray *array;
    for (Exhibition *e in [Model sharedModel].appliedExhibitionList) {
        group = e.status;
        array = [typeVSExhibitions objectForKey:group];
        if (array == nil)
        {
            array = [NSMutableArray array];
            [typeVSExhibitions setObject:array forKey:group];
            [typeGroup addObject:group];
        }
        [array addObject:e];
    }
    [self.theTableView reloadData];
}

- (void)Update
{
    [typeGroup removeAllObjects];
	[typeVSExhibitions removeAllObjects];
    NSString *group;
    NSMutableArray *array;
    for (Exhibition *e in [Model sharedModel].appliedExhibitionList) {
        group = e.status;
        array = [typeVSExhibitions objectForKey:group];
        if (array == nil)
        {
            array = [NSMutableArray array];
            [typeVSExhibitions setObject:array forKey:group];
            [typeGroup addObject:group];
        }
        [array addObject:e];
    }
}

- (void)requestExhibitions{
    NSLog(@"text = %@",_searchInput.text);
    if([Model sharedModel].systemConfig){
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [Model sharedModel].systemConfig.token, @"token",
                                       @"-1", @"size",
                                       @"-1", @"last",
                                       _searchInput.text, @"name",
                                       nil];
        
        [self sendRequestWith:[NSString stringWithFormat:@"%@/rest/exhibitions/find", ServerURL] params:params method:RequestMethodGET];
    }
}

- (NSString *)getStatusTxt:(NSString *)status {
    if([status isEqualToString:EXHIBITION_STATUS_N])
        return @"未报名";
    else if([status isEqualToString:EXHIBITION_STATUS_P])
        return @"审核中";
    else if([status isEqualToString:EXHIBITION_STATUS_A])
        return @"审核通过";
    else if([status isEqualToString:EXHIBITION_STATUS_D])
        return @"审核未通过";
    else
        return @"";
}

- (UIImage *)getStatusHeaderImage:(NSString *)status {
    if([status isEqualToString:EXHIBITION_STATUS_P])
        return [UIImage imageNamed:@"tag-check.png"];
    else if([status isEqualToString:EXHIBITION_STATUS_A])
        return [UIImage imageNamed:@"tag-pass.png"];
    else if([status isEqualToString:EXHIBITION_STATUS_D])
        return [UIImage imageNamed:@"tag-failure"];
    else
        return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

-(void)buttonTapped:(DataButton *)sender{
    NSIndexPath *indexPath = sender.selectIndex;
    if (activeTab == MainViewActiveTabExhibitions) {
        [Model sharedModel].selectExhibition = [unAppliedExhibitions objectAtIndex:indexPath.row];
        ApplyViewController *viewController = [[ApplyViewController alloc]initWithNibName:@"ApplyViewController" bundle:nil];
        viewController.applyDelegate = self;
        [self presentViewController:viewController animated:YES completion:nil];
    }else{
        
    }
}

- (void)SetListStateWithActiveTab:(MainViewActiveTab)_activeTab
{
    activeTab = _activeTab;

    [self requestExhibitions];
    NSString *stringValue1 = [[NSNumber numberWithInteger:_activeTab] stringValue];
    NSString *stringValue2 = [[NSNumber numberWithInteger:MainViewActiveTabAppliedExhibitions] stringValue];
    if ([stringValue1 isEqualToString:stringValue2]) {
        self.appliedBtn.selected = YES;
        self.unAppliedBtn.selected = NO;
        [self.tabImage setImage:[UIImage imageNamed:@"2.png"]];
    }else{
        self.appliedBtn.selected = NO;
        self.unAppliedBtn.selected = YES;
        [self.tabImage setImage:[UIImage imageNamed:@"1.png"]];
    }
}

- (void) ApplyViewApplySuccess
{
    [self SetListStateWithActiveTab:MainViewActiveTabAppliedExhibitions];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    for (Exhibition *e in self.AppliedExhibitions) {
        
    }
    
    if(activeTab == MainViewActiveTabAppliedExhibitions){
        NSMutableArray *array = [typeVSExhibitions objectForKey:[typeGroup objectAtIndex:section]];
        
        return [array count];
    } else {
        return [unAppliedExhibitions count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(activeTab == MainViewActiveTabAppliedExhibitions)
        return [typeGroup count];
    else
        return 1;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(activeTab == MainViewActiveTabAppliedExhibitions)
        return [self getStatusTxt:[typeGroup objectAtIndex:section]];
    else
        return @"";
}*/
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(activeTab == MainViewActiveTabAppliedExhibitions){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 27)];
        UIImageView *bg = [[UIImageView alloc] initWithImage:[self getStatusHeaderImage:[typeGroup objectAtIndex:section]]];
        bg.frame = CGRectMake(5, 0, 310, 27);
        [headerView addSubview:bg];
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
        bottomLine.frame = CGRectMake(10, 25, 300, 2);
        //[headerView addSubview:bottomLine];
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake (35,0,280,27)];
        header.textColor = [UIColor colorWithRed:66 green:155 blue:221 alpha:1];
        header.text = [self getStatusTxt:[typeGroup objectAtIndex:section]];
        header.minimumFontSize = 11;
        header.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        header.backgroundColor = [UIColor clearColor];
        [headerView addSubview:header];
        
        
        return headerView;
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    
}*/
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(activeTab == MainViewActiveTabAppliedExhibitions)
        return 27;
    else
        return 0;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *Title_ID = @"Title_ID";
	ExhibitionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:Title_ID];
	UILabel *theTitle = nil;
    UILabel *theDate = nil;
	UILabel *theAddress = nil;
    UILabel *theOrganizer = nil;
    DataButton *theButton = nil;
    UIImageView *theImage;
    
	if (cell == nil)
	{
		cell = [[[ExhibitionTableCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:Title_ID] autorelease];
        
        theButton = (DataButton *)[cell.contentView viewWithTag:5];
        [theButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}
    theTitle = (UILabel *)[cell.contentView viewWithTag:1];
    theDate = (UILabel *)[cell.contentView viewWithTag:2];
    theAddress = (UILabel *)[cell.contentView viewWithTag:3];
    theOrganizer = (UILabel *)[cell.contentView viewWithTag:4];
    theButton = (DataButton *)[cell.contentView viewWithTag:5];
    theImage = (UIImageView *)[cell.contentView viewWithTag:6];
    theButton.selectIndex = indexPath;
    
    Exhibition *e;
    
    if(activeTab == MainViewActiveTabAppliedExhibitions){
        NSMutableArray *array = [typeVSExhibitions objectForKey:[typeGroup objectAtIndex:indexPath.section]];
        //NSMutableArray *array = self.AppliedExhibitions;
        e = (Exhibition *)[array objectAtIndex:indexPath.row];
        
    } else {
        e = (Exhibition *)[unAppliedExhibitions objectAtIndex:indexPath.row];
    }
    
    if ([e.status isEqualToString:EXHIBITION_STATUS_N]) {
        theButton.hidden = NO;
        cell.ApplyStatus.hidden = YES;
        [theButton setImage:[UIImage imageNamed:@"baoming.png"] forState:UIControlStateNormal];
    }else{
        theButton.hidden = YES;
        cell.ApplyStatus.hidden = NO;
        [cell setApplyStatusWithString:e.status];
    }
    NSLog(@"count = %d",e.messageUnRead);
    if (e.messageUnRead != 0) {
        cell.NumOfMessageUnRead.hidden = NO;
    }else{
        cell.NumOfMessageUnRead.hidden = YES;
    }
	theTitle.text = e.name;
    theDate.text = e.date;
    theAddress.text = e.address;
    theOrganizer.text = e.organizer;
    [theImage setImage:e.icon];
    //theImage.image = [UIImage imagewith]
    /*
    if([e.status isEqualToString:EXHIBITION_STATUS_N]){
        [theButton setBackgroundImage:[UIImage imageNamed:@"sign-unfocus.png"] forState:UIControlStateNormal];
        [theButton setBackgroundImage:[UIImage imageNamed:@"sign-focus.png"] forState:UIControlStateHighlighted];
    } else {
        [theButton setBackgroundImage:[UIImage imageNamed:@"enter-unfocus.png"] forState:UIControlStateNormal];
        [theButton setBackgroundImage:[UIImage imageNamed:@"enter-focus.png"] forState:UIControlStateHighlighted];
    }*/
    
    // Set up the cell...
    
    // Only load cached images; defer new downloads until scrolling ends
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Exhibition *e;
    if(activeTab == MainViewActiveTabAppliedExhibitions){
        NSMutableArray *array = [typeVSExhibitions objectForKey:[typeGroup objectAtIndex:indexPath.section]];
        e = (Exhibition *)[array objectAtIndex:indexPath.row];
        
    } else {
        e = (Exhibition *)[unAppliedExhibitions objectAtIndex:indexPath.row];
    }
    if ([self.searchInput canResignFirstResponder]){
        [self.searchInput resignFirstResponder];
    }
    
    [Model sharedModel].selectExhibition = e;
    
    ExhibitionDetailViewController *edvc = [[[ExhibitionDetailViewController alloc] init] autorelease];

    //[[Model sharedModel] pushView:edvc option:ViewTrasitionEffectMoveLeft];
    [self.navigationController pushViewController:edvc animated:YES];
    
}

- (BOOL)AppliedExhibitions:(NSArray*)exhibitions ContentsObject:(NSObject*)object
{
    Exhibition *e = (Exhibition*)object;
    for (Exhibition * elem in exhibitions) {
        if ([e.exKey isEqualToString:elem.exKey]) {
            return YES;
        }
    }
    return NO;
}


#pragma mark - ASIHTTPRequestDelegate  default handler
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSInteger requestType = [[request.userInfo objectForKey:@"MainViewRequestType"]integerValue];
    [super requestFinished:request];
    if (!unAppliedExhibitions) {
        unAppliedExhibitions = [[NSMutableArray alloc]init];
    }
    
    if (requestType == RequestApplyExhibitionList) {
        NSArray *ApplyList = [[request responseString]JSONValue];
        for (NSDictionary *dic in ApplyList) {
            
            Exhibition *e = [[Exhibition alloc]init];
            e.exKey = [dic objectForKey:@"exKey"];
            e.name = [dic objectForKey:@"name"];
            e.status = [dic objectForKey:@"status"];
            [self.AppliedExhibitions addObject:e];
        }
    }else if (requestType == RequestApplyStatus){
        
        Exhibition *e = (Exhibition*)[request.userInfo objectForKey:@"Exhibition"];
        NSDictionary *dic = [[request responseString] JSONValue];
        e.status = [dic objectForKey:@"status"];
        NSArray *logsArray = [dic objectForKey:@"logs"];
        NSMutableString *logs = [[NSMutableString alloc]init];
        for (NSString *str in logsArray) {
            [logs appendString:str];
            if (!(logsArray.lastObject == str)) {
                [logs appendString:@"\n"];
            }
        }
        e.logs = logs;
    }else if (requestType == RequestExhibitonIcon){
        UIImage *image = [UIImage imageWithData:[request responseData]];
        Exhibition *e = (Exhibition*)[request.userInfo objectForKey:@"Exhibition"];
        e.icon = image;
    }else{
        if (!unAppliedExhibitions) {
            unAppliedExhibitions = [[NSMutableArray alloc]init];
        }
        [unAppliedExhibitions removeAllObjects];
        
        NSString *responseString = [request responseString];
        
        NSDictionary *result = [responseString JSONValue];
        
        NSArray *exhibitorArray = [result objectForKey:@"list"];
        
        if ([exhibitorArray count] == 0) {
            [_theTableView reloadData];
            /*
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"未找到结果\n请重新设置关键字" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];*/
        }else{
            for (NSDictionary *exhibitionData in exhibitorArray)
            {
                Exhibition *e = [[Exhibition alloc] initWithJSONData:exhibitionData];
                
                [unAppliedExhibitions addObject:e];
                /*test data
                 if([e.exKey isEqualToString:@"1107"])
                 e.status = EXHIBITION_STATUS_A;
                 else if([e.exKey isEqualToString:@"1108"])
                 e.status = EXHIBITION_STATUS_D;
                 else
                 e.status = EXHIBITION_STATUS_P;
                 
                 [[Model sharedModel].appliedExhibitionList addObject:e];
                 [[PlistProxy sharedPlistProxy] updateAppliedExhibitions];
                 */
                
                NSString *statusString = [ServerURL stringByAppendingString:@"/rest/applies/get"];
                statusString = [statusString stringByAppendingFormat:@"?token=%@&exKey=%@",[Model sharedModel].systemConfig.token,e.exKey];
                NSDictionary *statusUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:RequestApplyStatus],@"MainViewRequestType",
                                                e,                                              @"Exhibition",
                                                nil];
                ASIHTTPRequest *statusRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:statusString]];
                [statusRequest setUserInfo:statusUserInfo];
                [self.requestQueue addOperation:statusRequest];
                
                
                NSString *iconString = [[Model sharedModel].systemConfig.assetServer stringByAppendingFormat:@"/%@/icon.png",e.exKey];
                NSDictionary *iconUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:RequestExhibitonIcon],@"MainViewRequestType",
                                              e,                                               @"Exhibition",
                                              nil];
                ASIHTTPRequest *iconRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:iconString]];
                [iconRequest setUserInfo:iconUserInfo];
                [self.requestQueue addOperation:iconRequest];
                
                [e release];
            }
        }
        [self.theTableView reloadData];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [super requestFinished:request];
    
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.theTableView];
    [self reloadData];
}

- (void)dealloc {
    [_theTableView release];
    [_searchInput release];
    [_tabImage release];
    [_appliedBtn release];
    [_unAppliedBtn release];
    self.AppliedExhibitions = nil;
    self.requestQueue       = nil;
    self.SearchArray        = nil;
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTheTableView:nil];
    [self setSearchInput:nil];
    [self setTabImage:nil];
    [self setAppliedBtn:nil];
    [self setUnAppliedBtn:nil];
    [super viewDidUnload];
}

#pragma mark - Drop_down to refresh

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    if ([self.searchInput canResignFirstResponder]){
        [self.searchInput resignFirstResponder];
    }
    
}
/*
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
 
}*/

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    
    NSLog(@"loading~~~");
    if ([self.searchInput canResignFirstResponder]){
        [self.searchInput resignFirstResponder];
    }
    
    [self requestExhibitions];
}

- (void)RefreshStop
{
    self.reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.theTableView];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return self.reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date]; 
}

#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(Exhibition *)exhibition forIndexPath:(NSIndexPath *)indexPath
{
    /*
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.exhibition = exhibition;
        [iconDownloader setCompletionHandler:^{
            
            UITableViewCell *cell = [_theTableView cellForRowAtIndexPath:indexPath];
            UIImageView *theImage = (UIImageView *)[cell viewWithTag:6];
            // Display the newly loaded image
            theImage.image = exhibition.icon;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }*/
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if ([unAppliedExhibitions count] > 0)
    {
        NSArray *visiblePaths = [_theTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Exhibition *e = [unAppliedExhibitions objectAtIndex:indexPath.row];
            
            if (e.icon)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:e forIndexPath:indexPath];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!self.reloading) {
        [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    if (!decelerate)
	{
        //[self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[self loadImagesForOnscreenRows];
}
- (IBAction)searchExhibition:(id)sender {
    if ([self.searchInput canResignFirstResponder]) {
        [self.searchInput resignFirstResponder];
    }
    if (activeTab == MainViewActiveTabExhibitions) {
        [self UnAppliedViewShouldSearchExhibition];
    }else
        [self AppliedViewShouldSearchExhibition];
}

- (void)UnAppliedViewShouldSearchExhibition
{
    if ([self.searchInput canResignFirstResponder]) {
        [self.searchInput resignFirstResponder];
    }
    [self requestExhibitions];
}

- (void)AppliedViewShouldSearchExhibition
{
    if (!self.SearchArray) {
        SearchArray = [[NSMutableArray alloc]init];
    }
    if (self.searchInput.text && ![self.searchInput.text isEqualToString:@""]) {
        [typeGroup removeAllObjects];
        [typeVSExhibitions removeAllObjects];
        NSString *group;
        NSMutableArray *array;
        for (Exhibition *e in [Model sharedModel].appliedExhibitionList) {
            group = e.status;
            array = [typeVSExhibitions objectForKey:group];
            if (array == nil)
            {
                array = [NSMutableArray array];
                [typeVSExhibitions setObject:array forKey:group];
                [typeGroup addObject:group];
            }
            NSRange rang = [e.name rangeOfString:self.searchInput.text];
            if (rang.location != NSNotFound) {
                [array addObject:e];
            }
        }
        [self.theTableView reloadData];
    }else{
        [typeGroup removeAllObjects];
        [typeVSExhibitions removeAllObjects];
        NSString *group;
        NSMutableArray *array;
        for (Exhibition *e in [Model sharedModel].appliedExhibitionList) {
            group = e.status;
            array = [typeVSExhibitions objectForKey:group];
            if (array == nil)
            {
                array = [NSMutableArray array];
                [typeVSExhibitions setObject:array forKey:group];
                [typeGroup addObject:group];
            }
            [array addObject:e];
        }
        [self updateData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField canResignFirstResponder]) {
        [textField resignFirstResponder];
    }
    if (activeTab == MainViewActiveTabExhibitions) {
        [self UnAppliedViewShouldSearchExhibition];
    }else
        [self AppliedViewShouldSearchExhibition];
    return YES;
}

- (IBAction)appliedTapped:(id)sender {
    if ([self.searchInput canResignFirstResponder]) {
        [self.searchInput resignFirstResponder];
    }
    [self ApplyListShow];
}

- (void)ApplyListShow
{
    if(activeTab == MainViewActiveTabAppliedExhibitions)
        return;
    [_tabImage setImage:[UIImage imageNamed:@"2.png"]];
    [_appliedBtn setTitleColor:[UIColor colorWithRed:20 green:20 blue:18 alpha:1] forState:UIControlStateNormal];
    [_appliedBtn setTitleColor:[UIColor colorWithRed:20 green:20 blue:18 alpha:1] forState:UIControlStateHighlighted];
    
    [_unAppliedBtn setTitleColor:[UIColor colorWithRed:66 green:155 blue:221 alpha:1] forState:UIControlStateNormal];
    [_unAppliedBtn setTitleColor:[UIColor colorWithRed:66 green:155 blue:221 alpha:1] forState:UIControlStateHighlighted];
    
    activeTab = MainViewActiveTabAppliedExhibitions;
    [_theTableView reloadData];
}

- (IBAction)unAppliedTapped:(id)sender {
    if ([self.searchInput canResignFirstResponder]) {
        [self.searchInput resignFirstResponder];
    }
    [self UnApplyListShow];
}

- (void)UnApplyListShow
{
    if(activeTab == MainViewActiveTabExhibitions)
        return;
    [_tabImage setImage:[UIImage imageNamed:@"1.png"]];
    [_appliedBtn setTitleColor:[UIColor colorWithRed:66 green:155 blue:221 alpha:1] forState:UIControlStateNormal];
    [_appliedBtn setTitleColor:[UIColor colorWithRed:66 green:155 blue:221 alpha:1] forState:UIControlStateHighlighted];
    
    [_unAppliedBtn setTitleColor:[UIColor colorWithRed:20 green:20 blue:18 alpha:1] forState:UIControlStateNormal];
    [_unAppliedBtn setTitleColor:[UIColor colorWithRed:20 green:20 blue:18 alpha:1] forState:UIControlStateHighlighted];
    
    activeTab = MainViewActiveTabExhibitions;
    [_theTableView reloadData];
}



@end
