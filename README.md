
![LogoType](https://raw.githubusercontent.com/guilhermetog/flutter_view_controller/main/assets/logotype.png)

Complexes interfaces with no effort at all. <br/>
Reusable componentes with full control of its states ans layout. <br/>
Bidirectional comunication between parents and child easily. <br/>
UI update direct from your business logics. <br/>
All of it and much more with a elegant and simple sintaxe.


<br/>

## Table of Contents

- [ Hierarchy of Components](#hierarchy)
- [ View ](#view)
- [ Controller](#controller)
- [ Plug](#plug)
   - [ Plug with signal](#plug-signal)
   - [ Plug with data](#plug-data)
- [ Notifier](#notifier)
   - [ View updates](#notifier-view)
   - [ Listen to changes inside the controllers](#notifier-controller)
   - [ Connecting Notifiers](#notifier-connect)
   - [ Notifing Lists](#notifier-list)
   - [ Notifing signals](#notifier-ticker)
 - [Themes](#theme)
   - [Defining a theme](#theme-define)
   - [Consuming a theme](#theme-consume)
   - [Changing a theme](#theme-change)
   - [Segmenting themes components](#theme-components)
 - [Sizes](#size)

##
<br/>
<br/>

<a name="hierarchy"></a>
![Hierarchy](https://raw.githubusercontent.com/guilhermetog/flutter_view_controller/main/assets/hierarchy.png)

The controller is composed of child controllers, which are passed as arguments to their corresponding child views.

app.dart
```dart
class AppController extends Controller {
  ChildController child = ChildController();

  @override
  onInit() {}

  @override
  onClose() {}
}

class AppView extends ViewOf<AppController> {
  const AppView({required super.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ChildView(controller: controller.child)
        )
    );
  }
}
```
<br/><br/>

child.dart
```dart
class ChildController extends Controller {
  @override
  onInit() {}

  @override
  onClose() {}
}

class ChildView extends ViewOf<ChildController> {
  const ChildView({required super.controller});

  @override
  Widget build(BuildContext context) {
    return Text("Child");
  }
}
```
##
<br/><br/><br/>

<a name="view"></a>
![View](https://raw.githubusercontent.com/guilhermetog/flutter_view_controller/main/assets/view.png)

The view part is responsible for building the layout. 
By default, every view is static. 
Reactivity is achieved through notifiers. 

It can be used for the entire page or just a component.<br/> 
Every view needs a controller, even if it's not used

view.dart
```dart

class ExampleView extends ViewOf<ExampleController> {
  const ExampleView({required super.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      color: Colors.red,
      child: ...
    );
  }
}
```
##
<br/><br/><br/>

<a name="controller"></a>
![Controller](https://raw.githubusercontent.com/guilhermetog/flutter_view_controller/main/assets/controller.png)

The Controller class is responsible for the behavior of the view. 
It contains all the actions and attributes of the view, and every view 
has direct access to its corresponding controller. 
The controller includes methods and properties.

controller.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class ExampleController extends Controller {
  ButtonController _buttonController;
  int counter = 0;
  
  @override
  onInit(){
    _configButtonController();
  }

  _configButtonController(){
    _buttonController.onClick.then(incrementCounter);
  }

  incrementCounter(){
    counter++;
  }

  @override
  onClose(){}
}
```
##
<br/><br/><br/>
<a name="plug"></a>
![Plug](https://raw.githubusercontent.com/guilhermetog/flutter_view_controller/main/assets/plug.png)

Best way to think in "Plug" is as a callback with super powers.
You define it in the child object, and listen to updates from the parent.

<a name="plug-signal"></a>
## Plug with signal

child.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class ChildController extends Controller {

  Plug onClick = Plug();

  @override
  onInit(){}

  _clickEvent(){
    onClick();
  }

  @override
  onClose(){}
}
```

parent.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'child.dart';

class ParentController extends Controller {
  ChildController child = ChildController();

  @override
  onInit(){
    child.onClick.then(() => print("clicked!"));
  }

  @override
  onClose(){}
}
```
<br/><br/>

<a name="plug-data"></a>
## Plug with data

Plugs can also carry data.
In these cases you need 3 things: 

- to declare it with a type 
- listen in the parent with the 'take' method.
- call it through the method 'send'

child.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class ChildController extends Controller {

  Plug<String> onSendMessage = Plug();

  @override
  onInit(){}

  clickEvent(){
    onSendMessage.send(" Hey there! ");
  }

  @override
  onClose(){}
}
```

parent.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'child.dart';

class ParentController extends Controller {
  ChildController child = ChildController();

  @override
  onInit(){
    child.onSendMessage.take((message) => print(message.trim()));
  }

  @override
  onClose(){}
}
```
##
<br/><br/><br/>
<a name="notifier"></a>
![Notifier](https://raw.githubusercontent.com/guilhermetog/flutter_view_controller/main/assets/notifier.png)

Notifiers are fundamental to the state management of a Flutter View Controller component. 
They are responsible for notifying the view about property changes. 
If you have a data that will affect the layout, you need to use a Notifier.

You need to declare the Notifier in the controller, and all Notifiers must have a type.
<br/><br/>

<a name="notifier-view"></a>
## View updates

You listen to it's changes with method "show" in the view.<br/>
To change the value of the notifier, you just need to put a new value in it.

app.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class AppController extends Controller {

  Notifier<String> message = Notifier("Default Message");
  Notifier<int> number = Notifier(0)

  @override
  onInit(){
    message.value = "New message";
    number.value++;
  }

  @override
  onClose(){}
}

class AppView extends View<AppController> {
  AppView({required super.controller});

  @override
  Widget build(BuildContext context) {
    return Column(children:[
      Container(
        child: controller.message.show((snapshotMessage)=> Text(snapshotMessage))
      ),
      Container(
        child: controller.number.show((snapshotNumber)=> Text(snapshotNumber.toString()))
      ),
    ]);
  }
}
```
<br/><br/>
<a name="notifier-controller"></a>

## Listen to change inside the controllers

You can also listen to changes inside controller.

controller.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class MessageController extends Controller {
  Notifier<String> message = Notifier('Default Message');

  @override
  onInit(){
    message.listen((snapshotMessage)=>  print(snapshotMessage));
  }

  @override
  onClose(){}
}
```
<br/><br/>
<a name="notifier-connect"></a>

## Connecting notifiers

You can also connect to another Notifier to propagate the change. 
This is very useful when you have complex structures.

child.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class ChildController extends Controller {

  Notifier<String> message = Notifier("Default Message");

  @override
  onInit(){
    //This will take effect when parent message updates
    message.listen((newMessage) => print(newMessage));
  }

  @override
  onClose(){}
}
```

parent.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'child.dart';

class ParentController extends Controller {
  ChildController child = ChildController();
  Notifier<String> message = Notifier("Default Message");

  @override
  onInit(){
    message.connect(child.message);
    message.value = "New message";
  }

  @override
  onClose(){}
}
```
<br/><br/>
<a name="notifier-list"></a>

## Notifing lists

You can also use a NotifierList to create reactive lists in your layout. 
NotifierList is still in the early stages, but it has the necessary methods to change its reactivity.

app.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class AppController extends Controller {

  NotifierList<String> messages = NotifierList();

  @override
  onInit(){}

  addMessage(){
    messages.add('Message');
  }

  @override
  onClose(){}
}

class AppView extends View<AppController> {
  AppView({required super.controller});

  @override
  Widget build(BuildContext context) {
    return controller.messages.show((messages) => 
      Column(
        children:[
          GestureDetector(
            onTap: controller.addMessage,
            child: Container(
                child: Text('Add message')
            ),
          ),
          ...messages.map((message)=> Text(message))
          )
        ]
      ),
    );
  }
}
```

Note that the show method returns a single Widget because it always returns a NotifierListener. 
Therefore, to use it in a list, you need to wrap the entire list with it. 
After that, you can spread the items as you like.
<br/><br/>
<a name="notifier-ticker"></a>

## Notifiers without value

If you want to notify some event without changing any value, you can use a NotifierTicker. 
It can generate a pulse with all the capabilities of a Notifier. 

However, instead of adding a new value to it, it comes with a tick() method that triggers it. 
Also, its show method does not receive any value

app.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class AppController extends Controller {

  String message = 'Default Message',
  NotifierTicker ticker = NotifierTicker();

  @override
  onInit(){}

  pulse(){
    message = 'New Message';
    ticker.tick();
  }

  @override
  onClose(){}
}

class AppView extends View<AppController> {
  AppView({required AppController controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    return controller.ticker.show(() => 
      GestureDetector(
        onTap: controller.pulse,
        child: Container(
            child: Text(controller.message)
        ),
      ),
    );
  }
}
```

The NotifierTicker is used in the built-in update method that all controllers have. It is used to refresh all the pages controlled by it.

##
<br/><br/><br/>
<a name="theme"></a>
![Theme](https://raw.githubusercontent.com/guilhermetog/flutter_view_controller/main/assets/theme.png)

With Flutter View Controller, you can easily develop dynamic themes using a GlobalState. 
A GlobalState is a map of objects whose changes have an effect globally on your aplication during runtime. 
You can define a theme with a simple abstract class.


<a name="theme-define"></a>

## Defining themes
Here is an example of how to create a theme file for your app or component.

contract.dart
```dart
abstract class ThemeContract{
  late Color backgroundColor;
  late Color foregroundColor;
}
```

light.dart
```dart
class LightTheme implements ThemeContract{
  Color backgroundColor = Colors.white;
  Color foregroundColor = Colors.grey;
}
```

dark.dart
```dart
class LightTheme implements ThemeContract{
  Color backgroundColor = Colors.black;
  Color foregroundColor = Colors.blueGrey;
}
```

main.dart
```dart
...
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalState<ThemeContract>().register(LightTheme());
    ...
    return MaterialApp(
      ...
    );
  }
}
```
<br/><br/>
<a name="theme-consume"></a>

## Consuming themes
You can consume any properties of your theme in any view or controller like this:

app.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class AppController extends Controller {

  Color consumedFromController;

  @override
  onInit(){
    consumedFromController = GlobalState<ThemeContract>().current.backgroundColor;
  }

  @override
  onClose(){}
}

class AppView extends View<AppController> {
  AppView({required AppController controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: GlobalState<ThemeContract>().current.foregroundColor,
        ...
    );
  }
}
```
<br/><br/>
<a name="theme-change"></a>

## Changing themes
To change the state of the GlobalState, you just need to update the corresponding property.

app.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

...

class AppView extends View<AppController> {
  AppView({required AppController controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(GlobalState<ThemeContract>().current is LightTheme){
          GlobalState<ThemeContract>().current = DarkTheme();
        }else{
          GlobalState<ThemeContract>().current = LightTheme();
        }
      },
      child: Container(
        color: GlobalState<ThemeContract>().current.foregroundColor,
        ...
    );
  }
}
```
<br/><br/>
<a name="theme-components"></a>

## Segmenting themes components
You can use as many GlobalStates as you want to do different things.

main.dart
```dart
...
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalState<ThemeContract>().register(LightTheme());
    GlobalState<FontContract>().register(ComicsFonts());
    GlobalState<ShapeContract>().register(RoundedComponents());

    ...
    return MaterialApp(
      ...
    );
  }
}
```
<br/><br/><br/>
<a name="size"></a>

![ScreenSize](https://raw.githubusercontent.com/guilhermetog/flutter_view_controller/main/assets/screensize.png)

As a way to simplify the calculation of widget sizes, Flutter View Controller comes with a built-in property in its views. 
You can access the screen width and height at any time and even calculate a percentage of the view to dimension your components.

app.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class AppView extends View<AppController> {
  AppView({required AppController controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height(55.2),
      width: size.width(10),
      ...
    )
  }
}
```

In this example we built a Container with 55.2% of screen height and 10% of screen width.

## Contribute
If you have some improvement or correction to make, please feel free to open an issue or pull request on the github project. All feedback are very welcome.


<a href="https://www.buymeacoffee.com/guilhermetog" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174">
</a>
