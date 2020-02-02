import 'package:reflectable/reflectable.dart';
import 'main.reflectable.dart';
import 'dart:io';

//Required class for reflection use with the capabilities mentioned
class Reflect extends Reflectable {
  //Declarations capability for instance members
  //Inovking capability to invoke methods in class
  //Metadata capability to read custom annotations in class  
  const Reflect()
      : super(declarationsCapability,invokingCapability, metadataCapability);
}

//const instance to be used for annotation
const reflect = Reflect();

class Methods {
  final String methodType;

  const Methods(this.methodType);

  const Methods.a() : this('A');
  const Methods.b() : this('B');
}

@reflect
class SampleClass {

  SampleClass();

  @Methods.a() 
  void methodA() => print('Method A invoked');
  
  @Methods.b()
  void methodB() => print('Method B invoked');
}


void main(List<String> arguments) {
  //Available after running builder
  initializeReflectable();

  //returns an instance mirror
  var reflectedInstance = reflect.reflect(SampleClass());

  stdout.write('Enter method name: ');
  var methodName = stdin.readLineSync();

  reflectedInstance.type.instanceMembers.forEach((_,member) {

      //Check for the actual functions only
      if (member.isOperator || !member.isRegularMethod) return;
      
      var methodType = member.metadata.firstWhere((metaData) => metaData is Methods, orElse: () => null);

      //We now have the correct associated method type
      if (methodType != null && (methodName == (methodType as Methods).methodType)) {
        //Invoke that method
        reflectedInstance.invoke(member.simpleName, []);
      }
  });

}
