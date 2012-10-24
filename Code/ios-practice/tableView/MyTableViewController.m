#import "MyTableViewController.h"

#define kCellIdentifier @"CellIdentifier"

@interface MyTableViewController ()

@property(nonatomic, retain, readwrite) NSArray *dataSource;

@end

@implementation MyTableViewController {
@private
    NSArray *_dataSource;
}

@synthesize dataSource = _dataSource;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (!self){
        return nil;
    }

    _dataSource = [NSArray arrayWithObjects:@"tableview", @"cell", @"custom cell", nil];

    return self;
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // deselect cell
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

    //  update visible cells
    [self updateVisibleCells];
}

#pragma mark - Cell Operation
- (void)updateVisibleCells {
    // 見えているセルの表示更新
    for (UITableViewCell *cell in [self.tableView visibleCells]){
        [self updateCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
    }
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Update Cells
    NSString *text = [self.dataSource objectAtIndex:(NSUInteger) indexPath.row];
    cell.textLabel.text = text;
}
//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//
- (NSInteger)tableView:(UITableView *)tableView
             numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
                     cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = kCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc]
                                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self updateCell:cell atIndexPath:indexPath];

    return cell;
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDelegate --
//--------------------------------------------------------------//

- (void)tableView:(UITableView *)tableView
        didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // ハイライトを外す
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
