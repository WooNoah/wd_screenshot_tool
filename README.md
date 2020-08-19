# wd_screenshot_tool
flutter screenshot tool

## Reference
According to the [third pub - screenshot]("https://github.com/SachinGanesh/screenshot"), I added some addational methods for long screen shot situations.

### Expecially for *ListView Widget* created by `ListView.builder`. 
I didn't fond solutions within `screenshot`, thus I decided to archive the goal by drawing widgets with real data and real layout widgets, and then combine every pieces together as a long picture.

### There are screenshot demos for several situations:
1. capture the picture of ListView widgets which created by method `ListView.builder`.
2. capture the picture who's height is higher than the screen height: usually `Column` wrap by the `SingleChildScrollView`
3. 


