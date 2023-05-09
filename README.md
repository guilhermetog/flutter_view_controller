| Description                     |                            Index                                |
| ------------------------------- | --------------------------------------------------------------- |
| Plugs with signal               | [Plugs with signal](#plugs-with-signal)                         |
| Plug With Values                | [Plug With Values](#plug-with-values)                           |
| Listen on the view              | [Listen on the view](#listen-on-the-view)                       |
| Listen Inside The Controllers   | [Listen Inside The Controllers](#listen-inside-the-controllers) |
| Connect Notifiers               | [Connect Notifiers](#connect-notifiers)                         |
| Notify a Intire List            | [Notify a Intire List](#notify-a-intire-list)                   |
| Notifiers Without Value         | [Notifiers Without Value](#notifiers-without-value)             |
| Contribute                      | [Contribute](#contribute)                                       |



![LogoType](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/logotype.png)

A State Management Flutter framework that integrates views and controllers together. 
The premise is to use Object-Oriented Programming composition to establish stable communication between components. 
There is a video where I explain how it works.

https://www.youtube.com/watch?v=SbK5sb_Oinc

![Hierarchy](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/hierarchy.png)

The library works better with composition. 
The controller is composed of child controllers, which are passed as arguments to their corresponding child views.

app.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'child.dart';

class AppController extends Controller {
  ChildController childController = ChildController();

  @override
  onInit(){}

  @override
  onClose(){}
}

class AppView extends View<AppController> {
  AppView({required AppController controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    return Column(children:[
      ChildView(controller: controller.childController),
    ]);
  }
}
```

Here is another video explaining how the component hierarchy can be designed.

https://www.youtube.com/watch?v=3dWHU4ptYx0

![View](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/view.png)

The view part is responsible for building the layout. 
By default, every view is static. 
Reactivity is achieved through notifiers. 

It can be used for the entire page or just a component. 
Every view needs a controller, even if it's not used

view.dart
```dart

class ExampleView extends View<ExampleController> {
  ExampleView({required ExampleController controller}) : super(controller: controller);

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

![Controller](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/controller.png)

The Controller class is responsible for the behavior of the view. 
It contains all the actions and attributes of the view, and every view 
has direct access to its corresponding controller. 
The controller includes methods and properties.

The controller is located in the state of a Stateful Widget, 
so it preserves its state. 
Its lifecycle corresponds to the State lifecycle. 

This means that the onInit method is executed at initState time, 
and the onClose method is executed at dispose time. 
Additionally, 

it has an optional onUpdate method that is called when the update method is executed.

controller.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class ExampleController extends Controller {
  @override
  onInit(){}

  @override
  onClose(){}
}
```

![Plug](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/plug.png)

Best way to think in "Plug" is as a callback with super powers.
You define it in the child object, and listen to updates from the parent.

## Plugs with signal

child.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class ChildController extends Controller {

  Plug onClick = Plug();

  @override
  onInit(){}

  clickEvent(){
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

## Plug with Values

Plugs can also carry values.
In these cases you need 3 things: 

- to declare it with a type 
- listen in the parent with the 'get' method.
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
    child.onSendMessage.get((message) => print(message.trim()));
  }

  @override
  onClose(){}
}
```

![Notifier](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/notifier.png)

Notifiers are fundamental to the state management of a Flutter view controller component. 
They are responsible for notifying the view about property changes. 
If you have a value that will affect the layout, you need to use a Notifier.

You need to declare the Notifier in the controller, and all Notifiers must have a type.

## Listen on the view

You listen to it's changes with method "show" in the view.

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
  AppView({required AppController controller}) : super(controller: controller);

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

## Listen inside the controllers

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

## Connect notifiers

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

## Notify a intire list

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
  AppView({required AppController controller}) : super(controller: controller);

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

![Theme](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/theme.png)

With Flutter View Controller, you can easily develop dynamic themes using a GlobalState. 
A GlobalState is a map of objects whose changes have an effect on the layout. 
You can define a theme with a simple abstract class.

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

![ScreenSize](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/screensize.png)

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

If you have some improvement or correction to make, please open a Issue on github 
or leave a comment in any video of my youtube channel, 
so we can talk about and find the best way to progress.


<a href="https://www.buymeacoffee.com/guilhermetog" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174">
</a>
