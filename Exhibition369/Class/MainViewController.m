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
#import "LoadingMoreTableFooterView.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize appliedExhibitions;
@synthesize scanArray;
@synthesize appliedStateBtn;
@synthesize applyListOldSearchKey;
@synthesize unapplyListOldSearchKey;
@synthesize userDefault;
@synthesize userDefaultURL;
@synthesize reader;
@synthesize exhibitionNonentity;
@synthesize editCell;

-(id)init
{
    if ((self = [super init]))
    {
        typeGroup = [[NSMutableArray alloc] init];
        typeVSExhibitions = [[NSMutableDictionary alloc] init];
        
        unAppliedExhibitions = [[NSMutableArray alloc] init];
        appliedExhibitions = [[NSMutableArray alloc]init];
        scanArray = [[NSMutableArray alloc]init];
        
        self.applyListOldSearchKey = nil;
        self.unapplyListOldSearchKey = nil;
        
        self.userDefault = [NSUserDefaults standardUserDefaults];
        self.userDefaultURL = [self.userDefault objectForKey:@"OpenWithURL"];
        
        self.requestQueue = [[ASINetworkQueue alloc]init];
        [self.requestQueue setDelegate:self];
        [self.requestQueue setRequestDidFinishSelector:@selector(done:)];
        [self.requestQueue setQueueDidFinishSelector:@selector(queueDidFinish)];
        [self.requestQueue go];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.unapplyListOldSearchKey = @"";
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.exhibitionNonentity = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, appFrame.size.width, appFrame.size.height - self.theTableView.frame.origin.x)];
    [self.exhibitionNonentity setImage:[UIImage imageNamed:@"no_message.png"]];
    self.exhibitionNonentity.backgroundColor = [UIColor clearColor];
    self.exhibitionNonentity.hidden = YES;
    [self.theTableView addSubview:self.exhibitionNonentity];
    
    if(self.refreshHeaderView == nil)
    {
        self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(5.0f, 0.0f - 67, self.view.frame.size.width - 10.0f, 60)];
        
        self.refreshHeaderView.delegate = self;
        self.refreshHeaderView.backgroundColor = [UIColor clearColor];
        [self.theTableView addSubview:self.refreshHeaderView];
        self.reloading = NO;
    }
    [self.refreshHeaderView refreshLastUpdatedDate];
    
    if(self.loadingMoreFooterView == nil)
    {
        self.loadingMoreFooterView = [[LoadingMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, 480.0f, self.view.frame.size.width, 60)];
        
        self.loadingMoreFooterView.delegate = self;
        self.loadingMoreFooterView.backgroundColor = [UIColor clearColor];
        [self.theTableView addSubview:self.loadingMoreFooterView];
    }
    
    
    [self setActiveTab:MainViewActiveTabExhibitions];
    [self getAppliedList];
    
    if ([[Model sharedModel] isConnectionAvailable]) {
        
        if ([Model sharedModel].openURL) {
            NSRange range = [[Model sharedModel].openURL rangeOfString:@"MEK://"];
            if (range.location != NSNotFound) {
                NSMutableString* qrcodeData = [NSMutableString stringWithString:[Model sharedModel].openURL];
                [qrcodeData deleteCharactersInRange:range];
                self.loadingMoreFooterView.haveMoreData = NO;
                [self analysisQRCodeData:[qrcodeData uppercaseString] WithObject:nil];
            }
        }
        else{
            [self refreshExhibitions];
            [self refreshAppliedExhibitions];
        }
    }
    else{
        //[[Model sharedModel] displayTip:@"未连接网络" modal:NO];
    }
    [self setActiveTab:MainViewActiveTabAppliedExhibitions];

    [[Model sharedModel] addObserver:self forKeyPath:@"openURL" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
}

- (void)getAppliedList
{
    [self.scanArray removeAllObjects];
    [self.appliedExhibitions removeAllObjects];
    for (Exhibition *e in [Model sharedModel].appliedExhibitionList) {
        if ([e.status isEqualToString:EXHIBITION_APPLIED_N]) {
            [self.scanArray addObject:e];
        }else{
            [self.appliedExhibitions addObject:e];
        }
    }
    [self.appliedExhibitions sortedArrayUsingSelector:@selector(compare:)];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"openURL"]) {
        NSString *QRCodeURL = [Model sharedModel].openURL;
        if (QRCodeURL) {
            NSRange range = [QRCodeURL rangeOfString:@"MEK://"];
            if (range.location != NSNotFound) {
                NSMutableString* qrcodeData = [NSMutableString stringWithString:QRCodeURL];
                [qrcodeData deleteCharactersInRange:range];
                if ([[Model sharedModel] isConnectionAvailable]) {
                    self.loadingMoreFooterView.haveMoreData = NO;
                    [self analysisQRCodeData:[qrcodeData uppercaseString] WithObject:nil];
                }else
                    [[Model sharedModel] displayTip:@"未连接网络" modal:NO];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self getAppliedList];
    //[self.theTableView reloadData];
}

//load new Exhibitions data
- (void) refreshExhibitions{
    if (activeTab == MainViewActiveTabExhibitions) {
        if([Model sharedModel].systemConfig){
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           [Model sharedModel].systemConfig.token, @"token",
                                           [NSString stringWithFormat:@"%i", PAGE_LOAD_ITEM_SIZE], @"size",
                                           @"-1", @"last",
                                           _searchInput.text, @"name",
                                           nil];
            
            [self sendRequestWith:[NSString stringWithFormat:@"%@/rest/exhibitions/find", ServerURL] params:params method:RequestMethodGET requestTag:RequestUnApplyExhibitionsList];
        }
    }else{
        [self refreshAppliedExhibitions];
    }
}

- (void)refreshScanExhibitions
{
    for (Exhibition *e in self.scanArray) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [Model sharedModel].systemConfig.token, @"token",
                                       e.exKey,@"exKey",
                                       @"-1", @"size",
                                       @"-1", @"last",
                                       nil];
        
        [self sendRequestWith:[NSString stringWithFormat:@"%@/rest/exhibitions/find", ServerURL] params:params method:RequestMethodGET requestTag:RequestScanExhibition];
    }
}

//load more Exhibitions data
- (void) loadMoreExhibitions{
    
    NSString *last = @"-1";
    //Loading More Exhibition Result
    if([unAppliedExhibitions count] > 0){
        Exhibition *e = (Exhibition *)[unAppliedExhibitions objectAtIndex:([unAppliedExhibitions count] - 1)];
        last = e.createdAt;
    }
    
    //NSLog(@"Load more Exhibitions, size:%i last: %@", PAGE_LOAD_ITEM_SIZE, last);
    
    //Exhibition *e lastExhibition;//[unAppliedExhibitions getob[unAppliedExhibitions count] - 1 ];
    if([Model sharedModel].systemConfig){
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [Model sharedModel].systemConfig.token, @"token",
                                       [NSString stringWithFormat:@"%i", PAGE_LOAD_ITEM_SIZE], @"size",
                                       last, @"last",
                                       _searchInput.text, @"name",
                                       nil];
        
        [self sendRequestWith:[NSString stringWithFormat:@"%@/rest/exhibitions/find", ServerURL] params:params method:RequestMethodGET requestTag:RequestUnApplyExhibitionsLoadingMore];
    }
}

- (void) refreshAppliedExhibitions{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   [Model sharedModel].systemConfig.token, @"token",
                                   nil];
    if (self.searchInput.text) {
        self.searchInput.text = @"";
    }
    
    [self sendRequestWith:[NSString stringWithFormat:@"%@/rest/exhibitions/find_applied", ServerURL] params:params method:RequestMethodGET requestTag:RequestApplyExhibitionList];
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
        viewController.mainViewDelegate = self;
        [self presentViewController:viewController animated:YES completion:nil];
    }else{
        
    }
}

- (void)setActiveTab:(MainViewActiveTab)_activeTab
{
    [self setRefreshViewShowWithNewWork];
    activeTab = _activeTab;
    if (activeTab == MainViewActiveTabAppliedExhibitions) {
        self.appliedBtn.selected = YES;
        self.unAppliedBtn.selected = NO;
        [self.tabImage setImage:[UIImage imageNamed:@"2.png"]];
        //[self.theTableView setTableFooterView:nil];
        self.loadingMoreFooterView.hidden = YES;
    }else{
        self.appliedBtn.selected = NO;
        self.unAppliedBtn.selected = YES;
        [self.tabImage setImage:[UIImage imageNamed:@"1.png"]];
        if(self.loadingMoreFooterView.haveMoreData){
            //[self.theTableView setTableFooterView:self.loadingMoreFooterView];
        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(activeTab == MainViewActiveTabAppliedExhibitions){
        return [appliedExhibitions count] + [self.scanArray count];
    } else {
        return [unAppliedExhibitions count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
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
    
    Exhibition *e = nil;
    NSMutableArray *dataSource = [self getDataSource];
    
    if (activeTab == MainViewActiveTabAppliedExhibitions) {
        if ([self.scanArray count]) {
            if (indexPath.row < [self.scanArray count]) {
                e = [self.scanArray objectAtIndex:indexPath.row];
            }else{
                e = [self.appliedExhibitions objectAtIndex:(indexPath.row - [self.scanArray count])];
            }
        }else{
            e = [self.appliedExhibitions objectAtIndex:indexPath.row];
        }
    }else{
        if([dataSource count] > indexPath.row){
            e = (Exhibition *)[dataSource objectAtIndex:indexPath.row];
        }
    }
    
    
    if(e != nil){
        if (activeTab == MainViewActiveTabAppliedExhibitions) {
            if ([e.applied isEqualToString:EXHIBITION_APPLIED_N]) {
                theButton.hidden = YES;
                cell.ApplyStatus.hidden = NO;
                [cell setApplyStatusWithString:e.applied];
                cell.ApplyStatus.selectIndex = indexPath;
                [cell.ApplyStatus addTarget:self action:@selector(editCell:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                theButton.hidden = YES;
                cell.ApplyStatus.hidden = NO;
                [cell setApplyStatusWithString:e.status];
            }
        }else{
            if ([e.applied isEqualToString:EXHIBITION_APPLIED_N]) {
                theButton.hidden = NO;
                cell.ApplyStatus.hidden = YES;
            }else {
                theButton.hidden = YES;
                cell.ApplyStatus.hidden = NO;
                [cell setApplyStatusWithString:e.status];
            }
        }
        
        //NSLog(@"count = %d",e.messageUnRead);
        if (e.messageUnRead != 0) {
            cell.NumOfMessageUnRead.hidden = NO;
        }else{
            cell.NumOfMessageUnRead.hidden = YES;
        }
        theTitle.text = e.name;
        theDate.text = e.date;
        theAddress.text = e.address;
        theOrganizer.text = e.organizer;
        
        if(e.icon){
            [theImage setImage:e.icon];
        }else if([[Model sharedModel].shareFileManager fileExistsAtPath:e.iconPath]){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                e.icon = [UIImage imageWithContentsOfFile:e.iconPath];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [theImage setImage:e.icon];
                });
            });
        }else{
            [self startIconDownload:e];
        }
    }else {
        [theImage setImage:[UIImage imageNamed:@"暂无图片.png"]];
    }
    
	return cell;
}

- (void)editCell:(DataButton*)sender
{
    self.editCell = sender.selectIndex;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"删除展会?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    alertView.tag = 203;
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 203) {
        if (buttonIndex == 1) {
            Exhibition *elem = [self.scanArray objectAtIndex:self.editCell.row];
            for (Exhibition *e in [Model sharedModel].appliedExhibitionList) {
                if ([elem.exKey isEqualToString:e.exKey]) {
                    [[Model sharedModel].appliedExhibitionList removeObject:e];
                    [[PlistProxy sharedPlistProxy]updateAppliedExhibitions];
                }
            }
            
            [self.scanArray removeObjectAtIndex:self.editCell.row];
            [self.theTableView reloadData];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Exhibition *e;
    if(activeTab == MainViewActiveTabAppliedExhibitions){
        if ([self.scanArray count]) {
            if (indexPath.row < [self.scanArray count]) {
                e = [self.scanArray objectAtIndex:indexPath.row];
            }else{
                e = [self.appliedExhibitions objectAtIndex:(indexPath.row - [self.scanArray count])];
            }
        }else{
            e = [self.appliedExhibitions objectAtIndex:indexPath.row];
        }
    } else {
        e = (Exhibition *)[unAppliedExhibitions objectAtIndex:indexPath.row];
    }
    if ([self.searchInput canResignFirstResponder]){
        [self.searchInput resignFirstResponder];
    }
    
    [Model sharedModel].selectExhibition = e;
    
    ExhibitionDetailViewController *edvc = [[[ExhibitionDetailViewController alloc] init] autorelease];
    
    [[Model sharedModel] pushView:edvc option:ViewTrasitionEffectMoveLeft];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


#pragma mark - ASIHTTPRequestDelegate  default handler
- (void)done:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSString *requestTpe = [request.userInfo objectForKey:@"tag"];
    if (request.tag == RequestApplyExhibitionList) {
        NSArray *result = [responseString JSONValue];
        [self getAppliedList];
        [[Model sharedModel].appliedExhibitionList removeAllObjects];
        for (NSDictionary *dic in result) {
            Exhibition *e = [[Exhibition alloc] initWithJSONData:dic];
            e.applied = EXHIBITION_APPLIED_Y;
            [[Model sharedModel].appliedExhibitionList addObject:e];
        }
        [[Model sharedModel].appliedExhibitionList addObjectsFromArray:self.scanArray];
        [[PlistProxy sharedPlistProxy] updateAppliedExhibitions];
        [appliedExhibitions removeAllObjects];
        //init applied Exhibitions
        [self getAppliedList];
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.theTableView];
        [self.theTableView reloadData];
        
    } else if (request.tag == RequestUnApplyExhibitionsList || request.tag == RequestUnApplyExhibitionsLoadingMore){
        //refresh un apply exhibitions list
        if(request.tag == RequestUnApplyExhibitionsList)
            [unAppliedExhibitions removeAllObjects];
        
        NSDictionary *result = [responseString JSONValue];
        NSArray *exhibitorArray = [result objectForKey:@"list"];
        
        for (NSDictionary *exhibitionData in exhibitorArray)
        {
            //NSLog(@"exdata = %@",exhibitionData);
            Exhibition *e = [[Exhibition alloc] initWithJSONData:exhibitionData];
            [unAppliedExhibitions addObject:e];
            
            [e release];
        }
        
        if ([exhibitorArray count] < PAGE_LOAD_ITEM_SIZE) {
            //no more data
            self.loadingMoreFooterView.haveMoreData = NO;
            //[self.theTableView setTableFooterView:nil];
            self.loadingMoreFooterView.hidden = YES;
        } else {
            //[self.theTableView setTableFooterView:self.loadingMoreFooterView];
            self.loadingMoreFooterView.hidden = NO;
            self.loadingMoreFooterView.haveMoreData = YES;
        }
        
        if(request.tag == RequestUnApplyExhibitionsList)
            [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.theTableView];
        else if(request.tag == RequestUnApplyExhibitionsLoadingMore)
            [self.loadingMoreFooterView loadingMoreTableDataSourceDidFinishedLoading:self.theTableView];
        
        [self unApplyListShow];
    }else if([requestTpe isEqualToString:@"101"]){
        //UIImagePickerController *_reader = [request.userInfo objectForKey:@"object"];
        [self.reader dismissViewControllerAnimated:YES completion:nil];
        NSDictionary *result = [responseString JSONValue];
        NSArray *exhibitorArray = [result objectForKey:@"list"];
        Exhibition *e = [[Exhibition alloc]initWithJSONData:(NSDictionary*)[exhibitorArray objectAtIndex:0]];
        e.shouldSaveIcon = YES;
        self.searchInput.text = e.name;
        [self setActiveTab:MainViewActiveTabAppliedExhibitions];
        [self setSearchKey:self.searchInput.text withActiveTab:activeTab];

        NSMutableArray *appliedDataSource = [Model sharedModel].appliedExhibitionList;
        if ([self exhibitionArray:appliedDataSource containsExhibition:e]) {
            [self addExhibition:e];
        }else{
            [[Model sharedModel].appliedExhibitionList addObject:e];
            [[PlistProxy sharedPlistProxy] updateAppliedExhibitions];
            [self addExhibition:e];
        }
        [self.theTableView reloadData];
    }else if (request.tag == RequestScanExhibition){
        NSLog(@"request scan");
    }
}

- (void)queueDidFinish
{
    
}

- (void)addExhibition:(Exhibition*)e
{
    [self.scanArray removeAllObjects];
    [self.appliedExhibitions removeAllObjects];
    if ([e.applied isEqualToString:EXHIBITION_APPLIED_N]) {
        [self.scanArray addObject:e];
    }else{
        [self.appliedExhibitions addObject:e];
    }
}

- (void)error:(ASIHTTPRequest *)request
{
    [super requestFinished:request];
    if(request.tag == RequestUnApplyExhibitionsList)
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.theTableView];
    else if(request.tag == RequestUnApplyExhibitionsLoadingMore)
        [self.loadingMoreFooterView loadingMoreTableDataSourceDidFinishedLoading:self.theTableView];
    
    [self.theTableView reloadData];
    
}

- (void)dealloc {
    [typeGroup release];
    [typeVSExhibitions release];
    [unAppliedExhibitions release];
    [_theTableView release];
    [_imageDownloadsInProgress release];
    [_searchInput release];
    [_tabImage release];
    [_appliedBtn release];
    [_unAppliedBtn release];
    [appliedStateBtn release];
    [self.appliedExhibitions release];
    [self.scanArray          release];
    [self.applyListOldSearchKey release];
    [self.unapplyListOldSearchKey release];
    if(self.reader)
        [self.reader              release];
    [self.exhibitionNonentity     release];
    if (self.reader)
        [self.reader              release];
    if (self.editCell) {
        [self.editCell                release];
    }
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
    [self setRefreshViewShowWithNewWork];
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    if ([self.searchInput canResignFirstResponder]){
        [self.searchInput resignFirstResponder];
    }
    
    [self.loadingMoreFooterView loadingMoreTableScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    //self.searchInput.text = @"";
    NSLog(@"loading~~~");
    if ([self.searchInput canResignFirstResponder]){
        [self.searchInput resignFirstResponder];
    }
    if ([[Model sharedModel] isConnectionAvailable]) {
        [self setSearchKey:nil withActiveTab:activeTab];
        [self refreshExhibitions];
    }
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
- (void)startIconDownload:(Exhibition *)exhibition
{
    
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:exhibition.exKey];
    if (iconDownloader == nil)
    {
        iconDownloader = [[[IconDownloader alloc] init]autorelease];
        iconDownloader.exhibition = exhibition;
        [iconDownloader setCompletionHandler:^{
            
            NSArray *visiblePaths = [_theTableView indexPathsForVisibleRows];
            for (NSIndexPath *indexPath in visiblePaths)
            {
                NSMutableArray *dataSource = [self getDataSource];
                if([dataSource count] > indexPath.row){
                    Exhibition *e = [dataSource objectAtIndex:indexPath.row];
                    if([e.exKey isEqualToString:exhibition.exKey]){
                        UITableViewCell *cell = [_theTableView cellForRowAtIndexPath:indexPath];
                        UIImageView *theImage = (UIImageView *)[cell viewWithTag:6];
                        // Display the newly loaded image
                        theImage.image = exhibition.icon;
                        
                        // Remove the IconDownloader from the in progress list.
                        // This will result in it being deallocated.
                        [self.imageDownloadsInProgress removeObjectForKey:exhibition.exKey];
                    }
                }
            }
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:exhibition.exKey];
        [iconDownloader startDownload];
    }
}

- (NSMutableArray *)getDataSource{
    if(activeTab == MainViewActiveTabExhibitions){
        return unAppliedExhibitions;
    } else {
        return appliedExhibitions;
    }
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if(activeTab == MainViewActiveTabExhibitions){
        
        NSArray *visiblePaths = [_theTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            NSMutableArray *dataSource = [self getDataSource];
            if([dataSource count] > indexPath.row){
                Exhibition *e = (Exhibition *)[dataSource objectAtIndex:indexPath.row];
                if (e.icon)
                {
                    [self startIconDownload:e];
                }else{
                    [self startIconDownload:e];
                }
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
    if ([[Model sharedModel] isConnectionAvailable]) {
        if(activeTab == MainViewActiveTabExhibitions){
            if (!self.reloading) {
                [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
            }
            if(!self.loadingMoreFooterView.isLoading){
                [self.loadingMoreFooterView loadingMoreTableScrollViewDidEndDragging:scrollView];
            }
        }else{
            if (!self.reloading) {
                [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
            }
        }
        if (!decelerate)
        {
            [self loadImagesForOnscreenRows];
        }
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}
- (IBAction)searchExhibition:(id)sender {
    if ([self.searchInput canResignFirstResponder]) {
        [self.searchInput resignFirstResponder];
    }
    if (activeTab == MainViewActiveTabExhibitions) {
        [self unAppliedViewShouldSearchExhibition];
    }else
        [self appliedViewShouldSearchExhibition];
}

- (void)unAppliedViewShouldSearchExhibition
{
    if (activeTab != MainViewActiveTabExhibitions) {
        activeTab = MainViewActiveTabExhibitions;
    }
    if ([self.searchInput canResignFirstResponder]) {
        [self.searchInput resignFirstResponder];
    }
    [self refreshExhibitions];
}

- (void)appliedViewShouldSearchExhibition
{
    if (activeTab != MainViewActiveTabAppliedExhibitions) {
        activeTab = MainViewActiveTabAppliedExhibitions;
    }
    [appliedExhibitions removeAllObjects];
    if (self.searchInput.text && ![self.searchInput.text isEqualToString:@""]){
        for (Exhibition *e in [Model sharedModel].appliedExhibitionList) {
            NSRange rang = [e.name rangeOfString:self.searchInput.text];
            if (rang.location != NSNotFound) {
                if ([e.applied isEqualToString:EXHIBITION_APPLIED_N]) {
                    [self.scanArray addObject:e];
                }else{
                    [self.appliedExhibitions addObject:e];
                }
            }
        }
        
    } else {
        [self getAppliedList];
    }
    
    [self applyListShow];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField canResignFirstResponder]) {
        [textField resignFirstResponder];
    }
    if (activeTab == MainViewActiveTabExhibitions) {
        if (![self.searchInput.text isEqualToString:self.unapplyListOldSearchKey]) {
            [self setSearchKey:self.searchInput.text withActiveTab:MainViewActiveTabExhibitions];
            [self unAppliedViewShouldSearchExhibition];
        }
    }else{
        if (![self.searchInput.text isEqualToString:self.applyListOldSearchKey]) {
            [self setSearchKey:self.searchInput.text withActiveTab:MainViewActiveTabAppliedExhibitions];
            [self appliedViewShouldSearchExhibition];
        }
    }
    return YES;
}

- (IBAction)appliedTapped:(id)sender {
    if (activeTab != MainViewActiveTabAppliedExhibitions) {
        activeTab = MainViewActiveTabAppliedExhibitions;
    }
        
    if ([self.searchInput canResignFirstResponder]) {
        [self.searchInput resignFirstResponder];
    }if (self.searchInput.text && ![self.searchInput.text isEqualToString:@""]) {
        if (![self.searchInput.text isEqualToString:self.applyListOldSearchKey]) {
            [self setSearchKey:self.searchInput.text withActiveTab:MainViewActiveTabAppliedExhibitions];
            [self appliedViewShouldSearchExhibition];
            return;
        }else{
            [self applyListShow];
        }
    }else{
        [self getAppliedList];
        [self applyListShow];
    }
}

- (void)applyListShow
{
    if(activeTab == MainViewActiveTabExhibitions)
        return;
    [self setActiveTab:MainViewActiveTabAppliedExhibitions];
    if (![self.appliedExhibitions count] && ![self.scanArray count]) {
        self.exhibitionNonentity.hidden = NO;
    }else
        self.exhibitionNonentity.hidden = YES;
    [_theTableView reloadData];
}

- (void)applySuccess
{
    activeTab = MainViewActiveTabAppliedExhibitions;
    [self applyListShow];
}

- (void)setRefreshViewShowWithNewWork
{
    if (![[Model sharedModel] isConnectionAvailable]) {
        self.theTableView.tableHeaderView.hidden = YES;
        //self.theTableView.tableFooterView.hidden = YES;
        self.loadingMoreFooterView.hidden = YES;
    }else {
        self.theTableView.tableHeaderView.hidden = NO;
        //self.theTableView.tableFooterView.hidden = NO;
        if (self.loadingMoreFooterView.haveMoreData) {
            self.loadingMoreFooterView.hidden = NO;
        }
    }
}

- (void) setSearchKey:(NSString*)searchKey withActiveTab:(MainViewActiveTab)_activeTab
{
    if (_activeTab == MainViewActiveTabAppliedExhibitions) {
        self.applyListOldSearchKey = searchKey;
    }else if (_activeTab == MainViewActiveTabExhibitions){
        self.unapplyListOldSearchKey = searchKey;
    }
}

- (IBAction)unAppliedTapped:(id)sender {
    if (activeTab != MainViewActiveTabExhibitions) {
        activeTab = MainViewActiveTabExhibitions;
    }
    if ([self.searchInput canResignFirstResponder]) {
        [self.searchInput resignFirstResponder];
    }if (self.searchInput.text && ![self.searchInput.text isEqualToString:@""]) {
        if (![self.searchInput.text isEqualToString:self.unapplyListOldSearchKey]) {
            [self setSearchKey:self.searchInput.text withActiveTab:MainViewActiveTabExhibitions];
            [self unAppliedViewShouldSearchExhibition];
            return;
        }else{
            [self unApplyListShow];
        }
    }else{
        if (![self.searchInput.text isEqualToString:self.unapplyListOldSearchKey]) {
            [self setSearchKey:self.searchInput.text withActiveTab:MainViewActiveTabExhibitions];
            [self refreshExhibitions];
        }else{
            [self unApplyListShow];
        }
    }
}

- (void)unApplyListShow
{
    if(activeTab == MainViewActiveTabAppliedExhibitions)
        return;
    [self setActiveTab:MainViewActiveTabExhibitions];
    CGFloat viewHeight = 70 * [unAppliedExhibitions count] + 5;
    if (viewHeight < self.theTableView.frame.size.height + 5) {
        viewHeight = self.theTableView.frame.size.height + 5;
    }
    self.loadingMoreFooterView.frame = CGRectMake(0, viewHeight, self.loadingMoreFooterView.frame.size.width, self.loadingMoreFooterView.frame.size.height);
    //[self.theTableView addSubview:self.loadingMoreFooterView];
    if (![unAppliedExhibitions count]) {
        self.exhibitionNonentity.hidden = NO;
    }else
        self.exhibitionNonentity.hidden = YES;
    [_theTableView reloadData];
}

#pragma mark - LoadingMoreTableFooterDelegate

- (void)didTriggerLoadingMore:(LoadingMoreTableFooterView*)view{
    [self loadMoreExhibitions];
}

#pragma mark - zbar

- (IBAction)qrcodeScan:(id)sender
{
    if (!reader) {
        self.reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        reader.showsZBarControls = NO;
        reader.wantsFullScreenLayout = NO;
        
        
        
        reader.readerView.scanCrop = [self getPortraitModeScanCropRect:CGRectMake(40, 120, 240, appFrame.size.height - 240) forOverlayView:reader.view];
        
        ZBarImageScanner *scanner = reader.scanner;
    
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        
        
        UIImageView *scanImage = [[UIImageView alloc]init];
        scanImage.frame = CGRectMake(0, 0, 320, appFrame.size.height);
        scanImage.tag = 201;
        //scanImage.hidden = YES;
        [reader.view addSubview:scanImage];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(0, 0, 320, appFrame.size.height);
        [imageView setImage:[UIImage imageNamed:@"QRCodeBackImage.png"]];
        [reader.view addSubview:imageView];
    
        UIImageView *titleView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];
        [titleView setImage:[UIImage imageNamed:@"ScanTitleImage.png"]];
        //titleView.autoresizingMask
        [reader.view addSubview:titleView];
        
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.frame = CGRectMake(0, 0, 44, 44);
        [cancleBtn setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
        [cancleBtn setBackgroundImage:[UIImage imageNamed:@"按下 返回.png"] forState:UIControlStateSelected];
        [cancleBtn setBackgroundImage:[UIImage imageNamed:@"按下 返回.png"] forState:UIControlStateHighlighted];
        [cancleBtn addTarget:self action:@selector(pressCancle:) forControlEvents:UIControlEventTouchUpInside];
        [self.reader.view addSubview:cancleBtn];
        
        UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(40, 120 + (appFrame.size.height - 240) + 10, 240, 40)]autorelease];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label setText:@"请将摄像头对准您的二维码"];
        [self.reader.view addSubview:label];
    }
    UIImageView *scanImage = (UIImageView*)[self.reader.view viewWithTag:201];
    scanImage.hidden = YES;
    [self presentViewController:self.reader animated:YES completion:^{
        [self scanAnomationWithState:YES];
    }];
    
}

- (void)scanAnomationWithState:(BOOL)begin
{
    UIImageView *imageView = (UIImageView*)[self.reader.view viewWithTag:202];
    if (!imageView) {
        imageView = [[[UIImageView alloc]init]autorelease];
        imageView.frame = CGRectMake(40, 120 + SCAN_BASE_HEADER_HEIGHT, 240, 10);
        imageView.tag = 202;
        [imageView setImage:[UIImage imageNamed:@"scanLine.png"]];
        [self.reader.view addSubview:imageView];
    }
    if (begin) {
        imageView.frame = CGRectMake(40, 120 + SCAN_BASE_HEADER_HEIGHT, 240, 10);
        [UIView beginAnimations:@"scan" context:nil];
        [UIView setAnimationDuration:2.0f];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationRepeatCount:HUGE_VALF];
        imageView.frame = CGRectMake(40, 345 + SCAN_BASE_FOOTER_HEIGHT, 240, 10);
        [UIView commitAnimations];
    }
}

- (void)beginToAnimation
{
    UIImageView *imageView = (UIImageView*)[self.reader.view viewWithTag:202];
    imageView.frame = CGRectMake(40, 125, 240, 10);
    [UIView beginAnimations:@"scan" context:nil];
    [UIView setAnimationDuration:3.0f];
    imageView.frame = CGRectMake(40, 360, 240, 10);
    [UIView commitAnimations];
}

- (CGRect)getPortraitModeScanCropRect:(CGRect)overlayCropRect
                       forOverlayView:(UIView*)readerView
{
    CGRect scanCropRect = CGRectMake(0, 0, 1, 1); /*default full screen*/
    
    float x = overlayCropRect.origin.x;
    float y = overlayCropRect.origin.y;
    float width = overlayCropRect.size.width;
    float height = overlayCropRect.size.height;
    
    
    float A = y / readerView.bounds.size.height;
    float B = 1 - (x + width) / readerView.bounds.size.width;
    float C = (y + height) / readerView.bounds.size.height;
    float D = 1 - x / readerView.bounds.size.width;
    
    scanCropRect = CGRectMake( A, B, C, D );
    
    return scanCropRect;
}

- (void)pressCancle:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController*) _reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info{
    
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    UIImageView *scanImage = (UIImageView*)[self.reader.view viewWithTag:201];
    [scanImage setImage:image];
    scanImage.hidden = NO;
    if (image.size.width != 320 || image.size.height != 480)
	{
        CGSize itemSize = CGSizeMake(320, 480);
		UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		[scanImage setImage:UIGraphicsGetImageFromCurrentImageContext()];
		UIGraphicsEndImageContext();
    }
    
    UIImageView *imageView = (UIImageView*)[self.reader.view viewWithTag:202];
    [self.reader.view.layer removeAllAnimations];
    [imageView removeFromSuperview];
    
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    AudioServicesPlaySystemSound(1002);
    
    //[_reader dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"data = %@",symbol.data);
    
    NSRange range = [symbol.data rangeOfString:@"MEK://"];
    if (range.location != NSNotFound) {
        NSMutableString* qrcodeData = [NSMutableString stringWithString:symbol.data];
        [qrcodeData deleteCharactersInRange:range];
        if ([[Model sharedModel] isConnectionAvailable]) {
            [self analysisQRCodeData:[qrcodeData uppercaseString] WithObject:_reader];
        }else
            [[Model sharedModel] displayTip:@"未连接网络" modal:NO];
    }else {
        [[Model sharedModel] displayTip:@"非官方二维码" modal:NO];
    }
}

- (void)analysisQRCodeData:(NSString*)QRCodedata WithObject:(NSObject*)object
{
    UIImagePickerController *_reader = (UIImagePickerController*)object;
    NSRange range;
    range.location = 3;
    range.length   = 1;
    NSString *lengthStr = [QRCodedata substringWithRange:range];

    NSInteger exkenLength = [self checkStringLength:lengthStr];
    range.location = 4;
    range.length = exkenLength*2;
    NSString *exkeyStr = [QRCodedata substringWithRange:range];
    NSString *exkeyString = [self transformStringFromASCII:exkeyStr stringLength:exkenLength];
    
    NSString *urlString = [ServerURL stringByAppendingFormat:@"/rest/exhibitions/find"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[Model sharedModel].systemConfig.token,@"token",
                                   exkeyString,                           @"exKey",
                                   @"-1",                                 @"size",
                                   @"-1",                                 @"last",
                                   nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"101",@"tag",_reader,@"object", nil];
    [self sendRequestWith:urlString params:params method:RequestMethodGET userInfo:userInfo];
}

- (NSString*)transformStringFromASCII:(NSString *)str stringLength:(NSInteger)length
{
    NSMutableString *exKeyString = [[NSMutableString alloc]init];
    NSArray *ASCIIArray = [_BASE_ASCII_ componentsSeparatedByString:@","];
    NSRange range;
    for (int i = 0; i<length; i++) {
        NSMutableString *exKeyChar= [[NSMutableString alloc]init];
        
        for (int j = 0; j<2; j++) {
            
            range.location = i*2 + j;
            range.length = 1;
            unichar c = [str characterAtIndex:(i*2 + j)];
            int v = (c - 'A'); //<< 4;
            [exKeyChar appendString:[ASCIIArray objectAtIndex:v]];
        }
        
        //const char *c = [exKeyChar cStringUsingEncoding:NSASCIIStringEncoding];
        //NSLog(@"str = %lu",strtoul([exKeyChar UTF8String], 0, 16));
        int value = strtoul([exKeyChar UTF8String], 0, 16);
        //NSData *data = [exKeyChar dataUsingEncoding:NSUTF8StringEncoding];
        //Byte *byte = (Byte*)[data bytes];
        //NSString *asd = [[NSString alloc]initWithUTF8String:c];
        //NSLog(@"asd = %@", asd);
        NSString *string = [NSString stringWithFormat:@"%c", value];
        [exKeyString appendString:string];
    }
    return exKeyString;
}

- (NSInteger)checkStringLength:(NSString*)str
{
    NSArray* array = [_BASE_STRING_ componentsSeparatedByString:@","];
    int i;
    for (i = 0; i<[array count]; i++) {
        NSString *objectStr = [array objectAtIndex:i];
        if ([str isEqualToString:objectStr]) {
            break;
        }
    }
    return i;
}

@end
