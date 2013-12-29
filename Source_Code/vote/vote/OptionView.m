//
//  OptionView.m
//  vote
//
//  Created by kuaijianghua on 12/24/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "OptionView.h"
#import "CellIndexCircle.h"

@interface OptionView (){
    NSArray *selectionTitleArray;
}

@end

@implementation OptionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        selectionTitleArray = [NSArray arrayWithObjects:@"Password Setting",@"Sign Out",@"About",nil];
        
        UITableView *selectionTableView = [[UITableView alloc] initWithFrame:CGRectMake(160, 0, 160, ScreenHeigh) style:UITableViewStylePlain];
        selectionTableView.backgroundColor = RGBColor(80, 130, 227, 1);
        selectionTableView.separatorColor = RGBColor(80, 130, 227, 1);
        selectionTableView.dataSource = self;
        selectionTableView.delegate = self;
        selectionTableView.scrollEnabled = NO;
        
        [self addSubview:selectionTableView];
    }
    return self;
}

#pragma mark - Tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.delegate ||
        ![self.delegate respondsToSelector:@selector(signoutButtonTapped)] ||
        ![self.delegate respondsToSelector:@selector(setPasswordButtonTapped)] ||
        ![self.delegate respondsToSelector:@selector(aboutButtonTapped)]) {
        return;
    }
    
    switch (indexPath.row) {
        case 0:
            //Set password
            [self.delegate setPasswordButtonTapped];
            break;
            
        case 1:
            //Sign Out
            [self.delegate signoutButtonTapped];
            break;
            
        case 2:
            //About page
            [self.delegate aboutButtonTapped];
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

#pragma mark - Tableview datasource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"OptionViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor =  RGBColor(80, 130, 227, 1);
        
        CellIndexCircle *indexCircle = [[CellIndexCircle alloc] initWithNumber:indexPath.row+1 location:CGPointMake(7, 7)];
        [indexCircle setCircleColorWhile];
        indexCircle.indexLabel.textColor = [UIColor whiteColor];
        [cell addSubview:indexCircle];
        
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 116, 44)];
        cellLabel.textColor = [UIColor whiteColor];
        cellLabel.text = [selectionTitleArray objectAtIndex:indexPath.row];
        cellLabel.font = [UIFont systemFontOfSize:10];
        [cell addSubview:cellLabel];
    }
    
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 80)];
    headView.backgroundColor =  RGBColor(80, 130, 227, 1);
    
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [selectionTitleArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
