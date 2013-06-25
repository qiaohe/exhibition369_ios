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
    self.tableView = nil;
    self.NewsArray = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 6.0;
    self.view.layer.borderWidth = 1.0;
    self.view.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.view.backgroundColor = [UIColor clearColor];
    NewsArray = [[NSMutableArray alloc]init];
    [self updateData];
    // Do any additional setup after loading the view from its nib.
}

- (void)NewsDetailViewDisMiss:(UIView*)view
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
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IdentifierStr = @"cell";
    NewsTableCell *cell = [tableViews dequeueReusableCellWithIdentifier:IdentifierStr];
    if (cell == nil) {
        cell = [[NewsTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IdentifierStr];
    }
    ExhibitionsNews *new = [self.NewsArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = new.Title;
    [cell.theImage setImage:new.Icon];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailViewController *newsView = [[NewsDetailViewController alloc]initWithNibName:@"NewsDetailViewController" bundle:nil];
    newsView.delegate = self;
    newsView.aNew = [self.NewsArray objectAtIndex:indexPath.row];
    [self.delegate SuperViewPresentViewController:newsView];
    [newsView release];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSInteger RequestType = [[request.userInfo objectForKey:@"RequestType"]integerValue];
    if (RequestType == RequestNewsIcon) {
        ExhibitionsNews *new = [request.userInfo objectForKey:@"aNews"];
        new.Icon = [UIImage imageWithData:[request responseData]];
        
        [self reloadData];
    }else{
        NSString *responseStr = [request responseString];
        NSDictionary *dic = [responseStr JSONValue];
        NSArray *array = [dic objectForKey:@"list"];
        
        for (NSDictionary *resultDic in array) {
            ExhibitionsNews *new = [[ExhibitionsNews alloc]initWithEXKey:[Model sharedModel].selectExhibition.exKey];
            new.Title = [resultDic objectForKey:@"title"];
            new.NewsKey = [resultDic objectForKey:@"newsKey"];
            NSLog(@"newsTitle = %@",new.Title);
            
            [self.NewsArray addObject:new];
            [new release];
            
            NSString *urlStr = [[Model sharedModel].systemConfig.assetServer stringByAppendingFormat:@"/%@/news/%@.png",[Model sharedModel].selectExhibition.exKey,new.NewsKey];
            NSLog(@"url = %@",urlStr);
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:RequestNewsIcon] ,@"RequestType",
                                                                                 new ,@"aNews",
                                                                                 nil];
            [request setUserInfo:userInfo];
            request.delegate = self;
            [request startAsynchronous];
            [request release];
        }
        [self reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
