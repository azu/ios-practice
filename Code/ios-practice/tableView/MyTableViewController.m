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
    return self;
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // deselect cell
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    // update dataSource
    [self updateDataSource];
    // update visible cells
    [self updateVisibleCells];
}

- (void)updateDataSource {
    self.dataSource = [NSArray arrayWithObjects:@"tableview", @"cell", @"custom cell", nil];
}

#pragma mark - Cell Operation
- (void)updateVisibleCells {
    // 見えているセルの表示更新
    for (UITableViewCell *cell in [self.tableView visibleCells]){
        [self updateCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
    }
}

// Update Cells
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // imageView
    cell.imageView.image = [UIImage imageNamed:@"no_image.png"];
    // textLabel
    NSString *text = [self.dataSource objectAtIndex:(NSUInteger) indexPath.row];
    cell.textLabel.text = text;
    NSString *detailText = @"詳細のtextLabel";
    cell.detailTextLabel.text = detailText;
    // arrow accessoryView
    UIImage *arrowImage = [UIImage imageNamed:@"arrow.png"];
    cell.accessoryView = [[UIImageView alloc] initWithImage:arrowImage];
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
                                 initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
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
