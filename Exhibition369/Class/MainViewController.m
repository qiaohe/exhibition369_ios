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
@synthesize appliedStateBtn;
@synthesize loadingMoreFooterView;


-(id)init
{
    if ((self = [super init]))
    {
        typeGroup = [[NSMutableArray alloc] init];
        typeVSExhibitions = [[NSMutableDictionary alloc] init];
        
        unAppliedExhibitions = [[NSMutableArray alloc] init];
        appliedExhibitions = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    [self setActiveTab:MainViewActiveTabExhibitions];
    
    [appliedExhibitions addObjectsFromArray:[[Model sharedModel].appliedExhibitionList sortedArrayUsingSelector:@selector(compare:)]];
    if ([Model sharedModel].HaveNetwork) {
        [self refreshExhibitions];
        [self refreshAppliedExhibitions];
    }else{
        /*
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"未连接网络" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];*/
        
        [[Model sharedModel] displayTip:@"未连接网络" modal:NO];
        [self setActiveTab:MainViewActiveTabAppliedExhibitions];
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
    
    if(self.loadingMoreFooterView == nil)
    {
        self.loadingMoreFooterView = [[LoadingMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 60)];
        
        self.loadingMoreFooterView.delegate = self;
        self.loadingMoreFooterView.backgroundColor = [UIColor clearColor];
    }
}

//load new Exhibitions data
- (void) refreshExhibitions{
    NSLog(@"text = %@",_searchInput.text);
    if([Model sharedModel].systemConfig){
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [Model sharedModel].systemConfig.token, @"token",
                                       [NSString stringWithFormat:@"%i", PAGE_LOAD_ITEM_SIZE], @"size",
                                       @"-1", @"last",
                                       _searchInput.text, @"name",
                                       nil];
        
        [self sendRequestWith:[NSString stringWithFormat:@"%@/rest/exhibitions/find", ServerURL] params:params method:RequestMethodGET requestTag:RequestUnApplyExhibitionsList];
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
    
    NSLog(@"Load more Exhibitions, size:%i last: %@", PAGE_LOAD_ITEM_SIZE, last);
    
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
        viewController.applyDelegate = self;
        [self presentViewController:viewController animated:YES completion:nil];
    }else{
        
    }
}

- (void)setActiveTab:(MainViewActiveTab)_activeTab
{
    activeTab = _activeTab;
    if (activeTab == MainViewActiveTabAppliedExhibitions) {
        self.appliedBtn.selected = YES;
        self.unAppliedBtn.selected = NO;
        [self.tabImage setImage:[UIImage imageNamed:@"2.png"]];
        [self.theTableView setTableFooterView:nil];
        
    }else{
        self.appliedBtn.selected = NO;
        self.unAppliedBtn.selected = YES;
        [self.tabImage setImage:[UIImage imageNamed:@"1.png"]];
        if(self.loadingMoreFooterView.haveMoreData){
            [self.theTableView setTableFooterView:self.loadingMoreFooterView];
        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(activeTab == MainViewActiveTabAppliedExhibitions){
        return [appliedExhibitions count];
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
    
    if([dataSource count] > indexPath.row){
        e = (Exhibition *)[dataSource objectAtIndex:indexPath.row];
    }
    if(e != nil){
        if ([e.applied isEqualToString:EXHIBITION_APPLIED_N]) {
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
        
        if(e.icon){
            [theImage setImage:e.icon];
        } else {
            [self startIconDownload:e];
        }
    }
    
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
        e = (Exhibition *)[unAppliedExhibitions objectAtIndex:indexPath.row];
        
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
- (void)done:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    
    if (request.tag == RequestApplyExhibitionList) {
        NSArray *result = [responseString JSONValue];
        [[Model sharedModel].appliedExhibitionList removeAllObjects];
        for (NSDictionary *dic in result) {
            Exhibition *e = [[Exhibition alloc] initWithJSONData:dic];
            e.applied = EXHIBITION_APPLIED_Y;
            [[Model sharedModel].appliedExhibitionList addObject:e];
        }
        [[PlistProxy sharedPlistProxy] updateAppliedExhibitions];
        [appliedExhibitions removeAllObjects];
        //init applied Exhibitions
        [appliedExhibitions addObjectsFromArray:[[Model sharedModel].appliedExhibitionList sortedArrayUsingSelector:@selector(compare:)]];
        
    } else if (request.tag == RequestUnApplyExhibitionsList || request.tag == RequestUnApplyExhibitionsLoadingMore){
        //refresh un apply exhibitions list
        if(request.tag == RequestUnApplyExhibitionsList)
            [unAppliedExhibitions removeAllObjects];
        
        NSDictionary *result = [responseString JSONValue];
        NSArray *exhibitorArray = [result objectForKey:@"list"];
        
        for (NSDictionary *exhibitionData in exhibitorArray)
        {
            Exhibition *e = [[Exhibition alloc] initWithJSONData:exhibitionData];
            
            [unAppliedExhibitions addObject:e];
            [e release];
        }
        
        if ([exhibitorArray count] < PAGE_LOAD_ITEM_SIZE) {
            //no more data
            self.loadingMoreFooterView.haveMoreData = NO;
            [self.theTableView setTableFooterView:nil];
        } else {
            [self.theTableView setTableFooterView:self.loadingMoreFooterView];
            self.loadingMoreFooterView.haveMoreData = YES;
        }
        
        if(request.tag == RequestUnApplyExhibitionsList)
            [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.theTableView];
        else if(request.tag == RequestUnApplyExhibitionsLoadingMore)
            [self.loadingMoreFooterView loadingMoreTableDataSourceDidFinishedLoading:self.theTableView];

        [self.theTableView reloadData];
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
    [_theTableView release];
    [_searchInput release];
    [_tabImage release];
    [_appliedBtn release];
    [_unAppliedBtn release];
    self.appliedExhibitions = nil;
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
    
    [self.loadingMoreFooterView loadingMoreTableScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    
    NSLog(@"loading~~~");
    if ([self.searchInput canResignFirstResponder]){
        [self.searchInput resignFirstResponder];
    }
    
    [self refreshExhibitions];
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
        iconDownloader = [[IconDownloader alloc] init];
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
    if(activeTab == MainViewActiveTabExhibitions){
        if (!self.reloading) {
            [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        }
        if(!self.loadingMoreFooterView.isLoading){
            [self.loadingMoreFooterView loadingMoreTableScrollViewDidEndDragging:scrollView];
        }
    }
    
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
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
    if ([self.searchInput canResignFirstResponder]) {
        [self.searchInput resignFirstResponder];
    }
    [self refreshExhibitions];
}

- (void)appliedViewShouldSearchExhibition
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    [appliedExhibitions removeAllObjects];
    if (self.searchInput.text && ![self.searchInput.text isEqualToString:@""]){
        for (Exhibition *e in [Model sharedModel].appliedExhibitionList) {
            NSRange rang = [e.name rangeOfString:self.searchInput.text];
            if (rang.location != NSNotFound) {
                [array addObject:e];
            }
        }
    } else {
        array = [Model sharedModel].appliedExhibitionList;
    }
    
    
    [appliedExhibitions addObjectsFromArray:[array sortedArrayUsingSelector:@selector(compare:)]];
    [self.theTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField canResignFirstResponder]) {
        [textField resignFirstResponder];
    }
    if (activeTab == MainViewActiveTabExhibitions) {
        [self unAppliedViewShouldSearchExhibition];
    }else
        [self appliedViewShouldSearchExhibition];
    return YES;
}

- (IBAction)appliedTapped:(id)sender {
    if ([self.searchInput canResignFirstResponder]) {
        [self.searchInput resignFirstResponder];
    }
    [self applyListShow];
}

- (void)applyListShow
{
    if(activeTab == MainViewActiveTabAppliedExhibitions)
        return;
    [self setActiveTab:MainViewActiveTabAppliedExhibitions];
    [_theTableView reloadData];
}

- (IBAction)unAppliedTapped:(id)sender {
    if ([self.searchInput canResignFirstResponder]) {
        [self.searchInput resignFirstResponder];
    }
    [self unApplyListShow];
}

- (void)unApplyListShow
{
    if(activeTab == MainViewActiveTabExhibitions)
        return;
    [self setActiveTab:MainViewActiveTabExhibitions];
    [_theTableView reloadData];
}

#pragma mark - LoadingMoreTableFooterDelegate

- (void)didTriggerLoadingMore:(LoadingMoreTableFooterView*)view{
    [self loadMoreExhibitions];
}



@end
