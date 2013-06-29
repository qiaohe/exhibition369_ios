//
//  Model.m
//  CCBN
//
//  Created by Jack Wang on 2/28/13.
//
//

#import "Model.h"
#import "PlistProxy.h"
#import "AppDelegate.h"
#import "Exhibition.h"
#import <AudioToolbox/AudioToolbox.h>

static Model *sharedModel;
@implementation Model
@synthesize appliedExhibitionList = _appliedExhibitionList;
@synthesize systemConfig = _systemConfig;
@synthesize documentDirectory = _documentDirectory;
@synthesize mainView = _mainView;
@synthesize selectExhibition = _selectExhibition;
@synthesize HaveNetwork;


+ (Model *)sharedModel
{
	if (!sharedModel)
	{
		sharedModel = [[Model alloc] init];
	}
	
	return sharedModel;
}

- (id)init
{
    if ((self = [super init]))
	{
        _appliedExhibitionList = [[NSMutableArray alloc] init];
        _documentDirectory = [[NSHomeDirectory() stringByAppendingString:@"/Documents"] retain];
        
        
        //init message sound
        /*NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"message" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &messageSound);*/
    }
    return self;
}

- (void)initWithPlist
{
    NSArray *array = [[PlistProxy sharedPlistProxy] getAppliedExhibitions];
    NSDictionary *item = nil;
	for (item in array)
	{
        Exhibition *e = [[Exhibition alloc] initWithPData:item];
        [_appliedExhibitionList addObject:e];
        [e release];
	}
    
    [self initSystemConfig];
    //_systemConfig = [[PlistProxy sharedPlistProxy] getAppliedExhibitions];
}

- (void)createFolder:(NSArray *)pathComponents
{
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSError *error;
    NSString *path = [self createPath:pathComponents];
    
    BOOL isDir;
    if ([fileManger fileExistsAtPath:path isDirectory:&isDir] && isDir)
    {
        
    }
    else
    {
        [fileManger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
}

- (NSString *)createPath:(NSArray *)pathComponents
{
    return [_documentDirectory stringByAppendingPathComponent:[pathComponents componentsJoinedByString:@"/"]];
}

- (void)displayTip:(NSString *)tip modal:(BOOL)modal{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.transitionController displayTip:tip modal:modal];
}


- (void)pushView:(UIViewController *)view option:(ViewTrasitionEffect)options{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.transitionController transitionToViewController:view withOptions:options];
}


-(void)dealloc {
    [_documentDirectory release];
    [_appliedExhibitionList release];
    if(_systemConfig)
        [_systemConfig release];
    //AudioServicesDisposeSystemSoundID(messageSound);
    [super dealloc];
}


- (void)initSystemConfig {
    if(_systemConfig == nil){
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        if([userInfo stringForKey:@"SystemConfig_assetServer"]){
            _systemConfig = [[[SystemConfig alloc] init] retain];
            _systemConfig.assetServer = [[userInfo stringForKey:@"SystemConfig_assetServer"] retain];
            _systemConfig.tel = [[userInfo stringForKey:@"SystemConfig_tel"] retain];
            _systemConfig.token = [[userInfo stringForKey:@"SystemConfig_token"] retain];
            _systemConfig.upgrade = [[userInfo stringForKey:@"SystemConfig_upgrade"] retain];
            _systemConfig.upgradeNote = [[userInfo stringForKey:@"SystemConfig_upgradeNote"] retain];
        }else{
            _systemConfig = nil;
        }
        
    }
}

- (void)updateSystemConfig
{
    if(_systemConfig){
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        [userInfo setValue:_systemConfig.assetServer forKey:@"SystemConfig_assetServer"];
        [userInfo setValue:_systemConfig.tel forKey:@"SystemConfig_tel"];
        [userInfo setValue:_systemConfig.token forKey:@"SystemConfig_token"];
        [userInfo setValue:_systemConfig.upgrade forKey:@"SystemConfig_upgrade"];
        [userInfo setValue:_systemConfig.upgradeNote forKey:@"SystemConfig_upgradeNote"];
        [userInfo synchronize];
    }
}

-(BaseUIViewController *)getMainViewController{
    if(![Model sharedModel].mainView){
        [Model sharedModel].mainView = [[[MainViewController alloc] init] autorelease];
    }
    return [Model sharedModel].mainView;
}

@end
