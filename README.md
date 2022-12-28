# Flutter View Controller

![Logo] ('./assets/logo.png')

Um estilo de arquitetura reativo que visa isolar a o comportamento dos componentes de sua vizualização. Focado no reaproveitamento,
e composição recursiva de componentes.


### Criando um componente

Para cada componente crie dois arquivos. Um de controle e um de visualização.

controller.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class MyController extends Controller {
  @override
  onInit(){}

  @override
  onClose(){}
}
```

view.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'controller.dart';

class MyView extends View<MyController> {
  MyView({required MyController controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```



### Utilizando o componente
```dart
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyComponentView(controller: MyComponentController())
    );
  }
```


## Utilizando componentes em Hierarquia


### Componente Pai

controller.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class ParentController extends Controller {
  ChildController child = ChildController();

  @override
  onInit(){}

  @override
  onClose(){}
}
```

view.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'controller.dart';

class ParentView extends View<ParentController> {
  ParentView({required ParentController controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ChildView(controller: controller.child)
    );
  }
}
```


### Componente Filho

controller.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class ChildController extends Controller {
  @override
  onInit(){}

  @override
  onClose(){}
}
```

view.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'controller.dart';

class ChildView extends View<ChildController> {
  ChildView({required ChildController controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```



## Atualizando a view de forma reativa usando a classe Notifier


controller.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class MyController extends Controller {

  Notifier<bool> isLoading = Notifier(true);

  @override
  onInit(){
    ....someCode
    isLoading.value = false;
  }

  @override
  onClose(){}
}
```

view.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'controller.dart';

class MyView extends View<MyController> {
  MyView({required MyController controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    return controller.isLoading.show((isLoading)=>
      isLoading ? 
      Center(child: CircularProgressIndicator()):
      Text("Page has been loaded!")
    );
  }
}
```




## Comunicação entre controllers usando a classe Plug

### Button
controller.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class ButtonController extends Controller {

  Notifier<bool> isSelected = Notifier(false);

  Plug onClick = Plug();

  @override
  onInit(){}

  click(){
    onClick();
  }

  select(){
    isSelected.value = true;
  }

  unselect(){
    isSelected.value = false;
  }

  @override
  onClose(){}
}
```

view.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'controller.dart';

class ButtonView extends View<ButtonController> {
  MyView({required ButtonController controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.click,
      child: Container(
        child: controller.isSelected.show((isSelected)=> Text(isSelected ? "Selected": "Unselected"))
      )
    )
  }
}
```


### Button
controller.dart
```dart
import 'package:flutter_view_controller/flutter_view_controller.dart';

class PageController extends Controller {
  ButtonController button1 = ButtonController();
  ButtonController button2 = ButtonController();

  @override
  onInit(){
    button1.onClick.then(()=> selectButton(button1));
    button2.onClick.then(()=> selectButton(button2));
  }

  _selectButton(ButtonController button){
    button1.unselect();
    button2.unselect();
    button.select();
  }

  @override
  onClose(){}
}
```

view.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'controller.dart';

class ButtonView extends View<ButtonController> {
  MyView({required ButtonController controller}) : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    return Column(children:[
      ButtonView(controller: controller.button1),
      ButtonView(controller: controller.button2),
    ])
  }
}
```

