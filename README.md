![LogoType](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/logotype.png)

A StateManagement Flutter Framework that builds together view e controller.
The premisse is to use OOP composition to build a stable comunication between components.

There is a video where I explain how it works
[![Intro Video] 
(https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/video_intro.png)]
(https://www.youtube.com/watch?v=SbK5sb_Oinc "Intro Video")


# CONTENT

[Hierarchy](#hierarchy)
[View](#view)
[Controller](#controller)
[Plug](#hierarchy)
[Notifier](#hierarchy)
[Theme](#theme)
[ScreenSize](#screensize)



![Hierarchy](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/hierarchy.png){#hierarchy}

The lib works better with a composition.
The controller is composed of child controllers. These are passed as arguments for the correspondents child views.

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

Here is another video explaining how the component hierarchy can be designed
![Hierarchy Video](https://www.youtube.com/watch?v=3dWHU4ptYx0)
[![Hierarchy Video] 
(https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/video_hierarchy.png)]
(https://www.youtube.com/watch?v=3dWHU4ptYx0 "Hierarchy Video")




![View](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/view.png){#view}

The view part is responsable for build the layout.
Every view is static as default. 
The reactivity is made by Notifiers. 

It can be use for the intire page or just a component.
All View needs a controller. Even if it's not used.

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


![Controller](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/controller.png){#controller}

The Controller class is responsable for the behavior of the view.
It contains all actions and atributes of the view.
All view has direct access of it's corresponded controller.
It includes methods and properties.

The controller is located in the state of a Stateful Widget. So it preserve it's state.
It's lifecycle is corresponded to the State lifecycle.

This way the onInit method is executed at initState time;
The onClose method is executed at dispose time;

It has a onUpdate optional method that is called when the update method is executed.
 
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

![Plug](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/plug.png){#plug}

Best way to think in Plug is as a callback with super powers.
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


![Notifier](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/notifier.png){#notifier}

Notifiers are fundamental to the state management in a flutter view controller component.
They are responsable for notify the view about some property change.
If you have some value that will have effect in the layout, so you gonna use a Notifier.

You need to declare it in the controller.
All Notifier must to have a type.


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
It is very useful when you have complex structures.


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

You also have NotifierList to make reactive lists in your layout.
A NotifierList is still in eary stages just has the necessary methods to change it reactivitly.

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

Note that the show method returns a single Widget.
That's because it returns a NotifierListener aways.
So to you in a lista, it needs to wrap the entire list. After you can spread the items as you like.


## Notifiers without value

You also want to notify some event without change any value.
For this we have a NotifierTicker that can generate a pulse with all capabilities a notifier has.

But instead of add a new value to It, It comes with a method 'tick()' that fires up it.
And also it's show method not recieves any value.


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


NotifierTicker is used in the in the built-in method 'update' that all controller has.
It is used to refresh all the page controlled by it.


![Theme](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/theme.png){#theme}

With Flutter View Controller you can develop dynamic themes easely with a GlobalState.

A GlobalState is a map of objects which their changes make effect in the layout.
You can define a theme with a simple abstract class.


Here is a example of how to create a theme file for your app or component.

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


You can consume any properties of your theme at any view or controller like this:


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


To change the state you just need to change the current property;

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

You can use as many global states you want, to do differents things

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

![ScreenSize](https://github.com/guilhermetog/flutter_view_controller/blob/main/assets/screensize.png){#screensize}

As a way to simplify the calculation of sizes to build the widgets, Flutter View Controller comes with a built-in propertie
in it's views.
You can access the size of screen witdh and heigth at any time, and even calculate a percentage of the view, to dimension
your component.



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