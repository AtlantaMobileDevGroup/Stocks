//
//  StockMonitor.h
//  Stocks
//
//  Created by Jon Cobb on 11/8/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    Decreasing = -1,
    Level      =  0,
    Increasing =  1
    
} StockTrend;

////////////////////////////////////////////////////////////////////////////

#pragma mark StockMonitorDelegate Protocol

@protocol StockMonitorDelegate <NSObject>

#pragma mark Required Methods
@required
-(void) stockMonitorValueUpdated: (NSUInteger) value;

#pragma mark Optional Methods
@optional
-(void) stockMonitorTrendChanged: (StockTrend) trend;

@end

////////////////////////////////////////////////////////////////////////////

#pragma mark StockMonitor Interface

@interface StockMonitor : NSObject {
    @private
    id<StockMonitorDelegate> _delegate;
    NSUInteger               _value;
    StockTrend               _trend;
    NSMutableArray*          _recentChanges;
    NSUInteger               _recentChangeLimit;
}

#pragma mark Properties

@property (nonatomic, readwrite, assign) id<StockMonitorDelegate> delegate;
@property (nonatomic, readwrite, assign) NSUInteger value;
@property (nonatomic, readonly,  assign) StockTrend trend;
@property (nonatomic, readonly,  retain) NSArray* recentChanges;

#pragma mark Factories and Initializers

+(id) stockMonitorWithStockValue: (NSUInteger) stockValue;

-(id) initWithStockValue: (NSUInteger) value;
-(id) initWithStockValue: (NSUInteger) value andRecentChangeLimit: (NSUInteger) recentChangeLimit;

@end