# Example 🛠

### An iOS app to demonstrate one possible way to construct larger complex apps, handling 3rd party dependancies, Unit Testing and UI Automation.

(Please note that this app is not too concerned with UI and focuses on those things mentioned above)

## Architecture

For this project I chose MVP, Model-View-Presenter.  If you are not too familia with this archetecture this is a quick intro.

Model - The Model represents a set of classes that describes the business logic and data. It also defines business rules for data and how the data can be retrieved, changed and manipulated.  The Model receives its input via the Presenter, communicating though an interface, deinfed in the model class, and passes its reponse again though the same interface.  The models these days are more often refered to as Controllers or Interactors.

View - View is a component which is directly interacts with user and for iOS this means the UIViewController, or UITableViewController etc

Presenter - The Presenter receives the input from users via View, requests data from the Model to facilitate the View request, manipulates the data received from the Model to a form that can be viewed.  Like the Model, the Presenter communicates through an interface defined in the presenter class. 


What is important here is that the View, Presenter and Model are completly decoupled from each other and only communicate through each other interfaces.  This forces a strict dependancy chain, e.g. the View knows only about the Presenter, and the Presenter only knows about the Model, so it becomes hard to accidentally couple the View with any business logic.  The Model and Presenter own most of the application logic leaving the Views to be almost dumb objects just doing what they are told to be by the Presenter.  The interfaces also make it easy to switch out objects completely.  For example you may want the iOS app to have a table but an tvOS app to have a Collection and you can simply reuse the Presenter and Model.  Or on long term projects it is likely that the backend API changes over time as neither the View or Presenter are aware of the internals of the Models due to the interface, so you can simply switch them without any other object in the system or related tests knowing about it.

Because of decoupling mocking of the view is easier and unit testing of applications that leverage the MVP design pattern over the MVC design pattern are much easier.
It is also possible to easily have several developers working on one feature allowing faster time to market.  This is achieved by first checking in the Interfaces, then allowing through the use of TDD, one developer can work on the Model, while others either work on the Presenter and or View in isolation.

In this Example, as it is a simple app, the power of MVP may not visible, but when you start to construct views out of several network requests working in parallel and incorporating larger teams that span years of refactoring, this archecture comes into it's own.  As the app grows and becomes ever more complex this pattern can naturally be configured to other deisgn patterns such as VIPER or Clean to meet different needs in the future.

A lot more detail here https://www.youtube.com/watch?v=HhNIttd87xs&t=966s.

## Router

Over time we may find that we can reuse the same ViewController thoughout the app, like TableViews, but a cell selection does not neccessarly navigate to the same ViewController.  Or we find ourselves creating new complex ViewControllers to replace existing ones, but need the new and old code to live along side each other and be easily switchable so we can avoid long term branching.

If we were to embed routing directly into the ViewController it becomes much harder to acheive any of the above goals.  It is best to have ViewControllers just focused on their job, to handle the views and user input.   

For this we introduce the idea of an AppRouter, whos job it is to manage the routing throughout the app and provide the actions to the ViewController for when the user selects a table cell.  In this project the AppRouter is very simple, only that which is required for this project, but as it is seperated out we can easily evolve over time to use a Coordinator pattern without needing to refactor ViewControllers.

## Common / 3rd Party Dependancies

It is important for longer term apps to be more concerned with how we integrate 3rd party dependacies as it is likely over time that we will change such things as how we manage analytics events, load images, persistance storage.  For example it is common for projects to start off with a free analytics service but over time this might not suit the demands of the business and it becomes time to switch to another service.  If that first service is integrated directly into every ViewController then switching it will be a costly excersise.  

Another example is loading images, there are lots of 3rd party libraries out there, if the one that you are currently use is directly accessed in each view then it becomes very difficuly to simply switch it out and try another library to see if it is more performant.

In this example, we hide 3rd party dependacies behind facades, so that there is only one file we need to be concerned out when switching 3rd party libraries, look at `AnalyticsReporterFacade` and `UIImageView+URL` as ways to hide those dependancies.


## UI Automation

Even though we have introduced a good seperation of concerns using MVP and Routing, making it easier to test it well, it is still possible that the system as a whole does not work.  We need some way to test that all the objects, ViewControllers, Routing etc work together.  One way to do this is to use UI Automation tests.

However we need to be aware that there our downsides to these form of tests (there is always a balance).  

Firstly they are slow, so we should try to limit them to only those things that are essential.  Have the majority of tests cover the interfaces in the Presenters and Models, you can easily run a 1000 unit tests in the time it takes one UI test to complete, we need the feedback loop to be as quick as possible, there is nothing more fustrating than waiting 30mins for the tests to run.

They can also be brittle for several reasons.  UI tends to evolve more over time than other areas like business logic, resulting in constant updating of tests, plus, if we are not careful one change to the first ViewController can break every UI test.  UI tests are typically integrated with the backend and so the UI test may simple fail as the network requests fail for any reason, we can work around this issue and provide static files within the app or using a mock server, but then we incur an extra cost in having to maintain this extra system which came become a source of fustration for some teams.

In this project, UI Automation is structured around a Screen Model design pattern, inspirsation for this is taken from a collegue, Michael Vong, that was used on one of the project we worked together on. This design pattern has one ScreenModel for each ViewController, and that screen model only contains verifications and actions that belong to the ViewController is it paired with.  Each ScreenModel method for veriy/action returns another ScreenModel so it is possible to chain these actions together making it much easier understand the general flow of the test.

Have a look at `ExampleUITests`, to get an idea of how a general test could be structured, and check out `AssetSearchViewControllerModel` as an example of how a ScreenModel is structured.


## Bonus

As a developer several of the projects I've worked on have a reasonalble percentage of time take up with random bug fixes or crashes, +90% of those are caused in some way through variance, e.g variables. So the more we can remove variables the more consistent the code will behave, less random stuff to fix.  With UIKit we cannot remove all the variables, we will need IBOutlets and Delegates, but for those variables that contain some sort of state we can remove a large percantage of those and drive then to the outskirts of the code where they can affect less logic.

Check out the `AssetCollectionViewController` along with `AssetCollectionPresenter` and `AssetCollectionInteractor`, notice all properties are `let`s, the only variable source of truth for this area of the code is contained within `CollectionViewDataSource`.

### Further Work

Error handling for failed API calls.
Creating modules for specific areas of the app, speeds up build time and enforces good dependancies (but only required as the projects get much bigger)
Acceptance tests to cover the entire ViewController and their Presenter and Models.
Localisations
UI
