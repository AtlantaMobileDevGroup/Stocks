//
//  ViewController.m
//  Stocks
//
//  Created by Jon Cobb on 11/8/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

#pragma mark Initializers and Dealloc

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if(self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil]) {
        
        _stockMonitor = [[StockMonitor alloc] initWithStockValue: 50];
        _stockMonitor.delegate = self;        
    }
    
    return self;
}

-(void) dealloc {
    
    _stockMonitor.delegate = nil;
    
    [_exchangeStockValueSlider release];
    [_exchangeStockValueLabel  release];
    [_stockMonitor             release];
    [_clientStockValueLabel    release];
    [_clientRecentLabel0       release];
    [_clientRecentLabel1       release];
    [_clientRecentLabel2       release];
    [_clientRecentLabel3       release];
    
    [super dealloc];
}

#pragma mark UIViewController Overrides

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateEntireDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark UI Action Methods

-(IBAction) exchangeStockValueSliderValueChanged {
    [self updateExchangeStockValueLabel: _exchangeStockValueSlider.value];
}

-(IBAction) exchangeSetButtonTapped {
    _stockMonitor.value = (NSUInteger) _exchangeStockValueSlider.value;
}

#pragma StockMonitorDelegate Methods

-(void) stockMonitorValueUpdated:(NSUInteger) stockValue {
    [self updateClientStockValueLabel: stockValue];
    [self updateClientRecentChanges];
}

-(void) stockMonitorTrendChanged: (StockTrend) trend {
    [self updateClientStockTrendLabel: trend];
}

#pragma mark UI Update Methods

-(void) updateExchangeStockValueSlider: (NSUInteger) stockValue {
    [_exchangeStockValueSlider setValue: stockValue];
}
    
-(void) updateExchangeStockValueLabel: (NSUInteger) stockValue {
    [_exchangeStockValueLabel setText: [NSString stringWithFormat: @"$ %i", stockValue]];
}

-(void) updateExchangeDisplay {
    
    NSUInteger stockValue = _stockMonitor.value;
    [self updateExchangeStockValueSlider: stockValue];
    [self updateExchangeStockValueLabel:  stockValue];
}

-(void) updateClientStockValueLabel: (NSUInteger) stockValue {
    
    [_clientStockValueLabel setText: [NSString stringWithFormat: @"$ %i", stockValue]];
}

-(void) updateClientStockTrendLabel: (StockTrend) stockTrend {
    
    NSString* trendText = @"Unknown";
    
    switch (stockTrend) {
        case Decreasing:
            trendText = @"Decreasing";
            break;
        case Level:
            trendText = @"Holding";
            break;
        case Increasing:
            trendText = @"Increasing";
            break;
    }
    
    [_clientStockTrendLabel setText: trendText];
}

-(void) updateClientDisplay {

    [self updateClientStockValueLabel: _stockMonitor.value];
    [self updateClientStockTrendLabel: _stockMonitor.trend];
    [self updateClientRecentChanges];
}

-(void) updateClientRecentChanges {
    [self updateClientRecentChange: 0 displayLabel: _clientRecentLabel0];
    [self updateClientRecentChange: 1 displayLabel: _clientRecentLabel1];
    [self updateClientRecentChange: 2 displayLabel: _clientRecentLabel2];
    [self updateClientRecentChange: 3 displayLabel: _clientRecentLabel3];
}

-(void) updateClientRecentChange:(NSUInteger)changeIndex displayLabel:(UILabel *)displayLabel {
    
    NSString* displayText    = @"N/A";
    UIColor* backgroundColor = [UIColor whiteColor];
    UIColor* foregroundColor = [UIColor blackColor];
    
    NSArray* recentChanges = _stockMonitor.recentChanges;
    
    if(changeIndex < [recentChanges count]) {
        
        NSNumber* change      = [recentChanges objectAtIndex: changeIndex];
        NSInteger changeValue = [change integerValue];

        displayText = [NSString stringWithFormat: @"%i", changeValue];
        
        if(changeValue < 0) {
            backgroundColor = [UIColor redColor];
            foregroundColor = [UIColor whiteColor];
        }
        else if (0 < changeValue) {
            backgroundColor = [UIColor greenColor];
            foregroundColor = [UIColor blackColor];
        }    
    }
    
    [displayLabel setText:            displayText    ];
    [displayLabel setBackgroundColor: backgroundColor];
    [displayLabel setTextColor:       foregroundColor];
}

-(void) updateEntireDisplay {
    
    [self updateExchangeDisplay];
    [self updateClientDisplay];
}

@end