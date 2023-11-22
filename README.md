# AmadeusFlightBookingApp
## A simple app to book flights using Amadeus.

Create a basic flight booking app using [Amadeus SDK](https://developers.amadeus.com/self-service/category/flights).

### Models

Find here basic models to send and receive information using Amadeus API.

### Helpers

Files containing data that is relevant throughout the app: `AppDelegate`, `SceneDelegate` and `Constants`. The latter stores all important information and functions.

### Extensions

Extensions in this project:

- `Date`, to handle different date formats;
- `String`, to transform strings to date;
- `Int`, to handle integers in string format.

### Cells

Custom `UITableViewCell`s used for this project:

- `FlightDetailCell`, to display a flight's information;
- `SearchDetailsCell` to display text fields where the user can enter information and perform a flight search.

### Views

Custom `UIView`s used for `UITableViewCell`s for this project:

- `SegmentView`, to display a segment's departure or arrival information;
- `SegmentDetailView`, displays two `SegmentView`s to present the entire segment's information;
- `FlightInformationView`, displays one or more `SegmentDetailView`s to present the entire flight's information;
- `LoadingView`, to let the user know of ongoing background activity.

### View Controllers

The view controllers used in this app.

- ViewController, the main home page view controller;
- BookFlightViewController, page where users will see their selected flight and confirm booking;
- HistoryViewController, history of past flight bookings view controller.
