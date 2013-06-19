//
//  PlistProxy.m
//  CCBN
//
//  Created by Jack Wang on 3/24/13.
//  Copyright (c) 2013 MobileDaily. All rights reserved.
//

#import "PlistProxy.h"

#import "Model.h"
#import "Exhibition.h"

static PlistProxy *sharedPlistProxy;

@implementation PlistProxy

+ (PlistProxy *)sharedPlistProxy
{
	if (!sharedPlistProxy)
	{
		sharedPlistProxy = [[PlistProxy alloc] init];
	}
	
	return sharedPlistProxy;
}

- (id)init
{
	if ((self = [super init]))
	{
        appliedExhibitionsPlist = @"appliedExhibitions";
        
        paths = [[NSMutableDictionary alloc] init];
		datas = [[NSMutableDictionary alloc] init];
		dataObjects = [[NSMutableDictionary alloc] init];
        
        NSString *errorDesc = nil;
		NSError *error;
		NSPropertyListFormat format;
        
        NSArray *plists = [NSArray arrayWithObjects:
						   appliedExhibitionsPlist,
						   nil];
        
        [[Model sharedModel] createFolder:[NSArray arrayWithObject:@"plist"]];
		
		for (NSString *plistName in plists)
		{			
			// Look in Documents for an existing plist file
			NSString *plistPath = [[Model sharedModel].documentDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"plist/%@.plist", plistName]];
			[paths setObject:plistPath forKey:plistName];
			
			// If it's not there, copy it from the bundle
			NSFileManager *fileManger = [NSFileManager defaultManager];
			
			/*if ([fileManger fileExistsAtPath:plistPath])
            {
                [fileManger removeItemAtPath:plistPath error:&error];
            }*/
            
			if (![fileManger fileExistsAtPath:plistPath])
			{
				NSString *pathToSettingsInBundle = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
                
				[fileManger copyItemAtPath:pathToSettingsInBundle toPath:plistPath error:&error];
			}
			
			NSData *data = [[NSFileManager defaultManager] contentsAtPath:plistPath];
			[datas setObject:data forKey:plistName];
			
			NSMutableDictionary *dataObject = (NSMutableDictionary *)[NSPropertyListSerialization
																	  propertyListFromData:data
																	  mutabilityOption:NSPropertyListMutableContainersAndLeaves 
																	  format:&format 
																	  errorDescription:&errorDesc];
			[dataObjects setObject:dataObject forKey:plistName];
		}
	}
	
	return self;
}

- (void)dealloc
{	
	[paths release];
	[datas release];
	[dataObjects release];
	
	[super dealloc];
}

- (NSArray *)getAppliedExhibitions
{
    return [dataObjects objectForKey:appliedExhibitionsPlist];
}

- (void)updateAppliedExhibitions
{
    NSMutableArray *array = [NSMutableArray array];
    for (Exhibition *e in [Model sharedModel].appliedExhibitionList)
    {
        [array addObject:[e getPData]];
    }
    [array writeToFile:[paths objectForKey:appliedExhibitionsPlist] atomically:YES];
}

@end
