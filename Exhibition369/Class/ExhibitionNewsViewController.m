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

@synthesize tableView;
@synthesize NewsArray;
@synthesize index;

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
    NewsArray = [[NSMutableArray alloc]init];
    [self updateData];
    // Do any additional setup after loading the view from its nib.
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
    self.index = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.newsArray count = %u",[self.NewsArray count]);
    return [self.NewsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
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
    
    
    return cell;
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSInteger RequestType = [[request.userInfo objectForKey:@"RequestType"]integerValue];
    if (RequestType == RequestNewsIcon) {
        ExhibitionsNews *new = [self.NewsArray objectAtIndex:index];
        new.Icon = [UIImage imageWithData:[request responseData]];
        index ++;
    }else{
        NSString *responseStr = [request responseString];
        NSDictionary *dic = [responseStr JSONValue];
        NSArray *array = [dic objectForKey:@"list"];
        NSLog(@"array = %@",array);
        NSLog(@"count = %u",[array count]);
        
        for (NSDictionary *resultDic in array) {
            ExhibitionsNews *new = [[ExhibitionsNews alloc]initWithEXKey:[Model sharedModel].selectExhibition.exKey];
            new.Title = [resultDic objectForKey:@"title"];
            new.NewsKey = [[resultDic objectForKey:@"newsKey"]integerValue] ;
            
            [self.NewsArray addObject:new];
            NSLog(@"self.newsArray count = %u",[self.NewsArray count]);

            NSLog(@"dic = %@",resultDic);
            
            NSLog(@"title = %@",new.Title);
            
            NSString *urlStr = [[Model sharedModel].systemConfig.assetServer stringByAppendingFormat:@"/%@/news/%d.png",[Model sharedModel].selectExhibition.exKey,new.NewsKey];
            NSLog(@"%@",urlStr);
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:RequestNewsIcon] forKey:@"RequestType"];
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