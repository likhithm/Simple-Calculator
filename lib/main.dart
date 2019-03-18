import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Simple Calculator',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {



  String output = "";
  String input = "";
  Color outputColor = Colors.black;

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }



  /// Front end design of the Calculator App (Main Screen:Calculator)

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Container(
            child: new Column(
              children: <Widget>[
                new Container(
                    alignment: Alignment.centerRight,
                    padding: new EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0
                    ),
                    child: new Column(
                        children:[
                          new Row(
                            children:[
                              new Container(
                                  margin: const EdgeInsets.fromLTRB(10.0, 20.0,2.0, 0.0),
                                  constraints: BoxConstraints(
                                    minWidth: 10,
                                    maxWidth: MediaQuery.of(context).size.width*0.8,
                                  ),
                                child: Text(
                                         input,
                                         //softWrap: false,
                                         style: new TextStyle(
                                           fontSize: 32.0,
                                           fontWeight: FontWeight.w400,
                                         )
                                       )
                              )
                            ]
                          ),
                          new Row(
                              children:[
                                new Container(
                                    margin: const EdgeInsets.fromLTRB(15.0, 20.0,1.0, 0.0),
                                    constraints: BoxConstraints(
                                      minWidth: 10,
                                      maxWidth: MediaQuery.of(context).size.width*0.8,
                                    ),
                                    child:
                                    Text(
                                        output,
                                        style: new TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w300,
                                          color: outputColor
                                        )
                                    )
                                )
                              ]
                          ),
                        ]
                    )
                 ),
                new Expanded(
                  child: new Divider(color:Colors.transparent),
                ),


                new Column(children: [
                  new Row(children: [
                    buildButton("7"),
                    buildButton("8"),
                    buildButton("9"),
                    buildOperationButton("/")
                  ]),

                  new Row(children: [
                    buildButton("4"),
                    buildButton("5"),
                    buildButton("6"),
                    buildOperationButton("*")
                  ]),

                  new Row(children: [
                    buildButton("1"),
                    buildButton("2"),
                    buildButton("3"),
                    buildOperationButton("-")
                  ]),

                  new Row(children: [
                    buildButton("."),
                    buildButton("0"),
                    buildButton("DEL"),
                    buildOperationButton("+")
                  ]),

                  new Row(children: [
                    buildButton("CLR"),
                    buildResultButton("="),
                  ])
                ]),
              ],
            )));
  }

  /// Button design
  Widget buildButton(String buttonText) {
    return new Expanded(
      child: new OutlineButton(
        borderSide: BorderSide(color:Colors.transparent),
        padding: new EdgeInsets.all(24.0),
        child: new Text(buttonText,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w400
          ),
        ),
        onPressed: () =>
            onButtonPress(buttonText)
        ,
      ),
    );
  }

  /// Operator Button Design (+,-,*,/)
  Widget buildOperationButton(String buttonText) {
    return new Expanded(
      child: new RaisedButton(
        elevation: 0.1,
        onPressed: () =>
            onButtonPress(buttonText)
        ,
        color:Colors.white70,
        padding: new EdgeInsets.all(24.0),
        child: new Text(buttonText,
          style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w400
          ),
        ),

      ),
    );
  }

  /// Result Button Design (=)
  Widget buildResultButton(String buttonText) {
    return new Expanded(
      child: new RaisedButton(
        elevation: 0.1,
        onPressed: () =>
            onButtonPress(buttonText)
        ,
        color:Colors.white10,
        padding: new EdgeInsets.all(24.0),
        child: new Text(buttonText,
          style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }

  /// handle the Button press event here
  onButtonPress(String buttonText){

    if( input.length==0 &&(buttonText=='DEL'||buttonText=='+'||buttonText=='/'||buttonText=='*'))
        return;
    // Initial Check
    if(outputColor == Colors.red && output=="Can't divide by 0") {
      setState(() {
        output ="";
        outputColor= Colors.black;
        if(buttonText=="CLR"||buttonText=="="||buttonText=="DEL"||buttonText=='+'|| buttonText=='/'||buttonText=='*')
          input = "";
        else input=buttonText;

      });
      return;

    }

    if(input.length<=50|| buttonText=='DEL'|| buttonText=='CLR'|| buttonText=='=') {
      if (buttonText == "CLR") {
        setState(() {
          input = "";
          output = "";
        });
        return;
      }
      else if (buttonText == "DEL") {
        setState(() {
          input = input.substring(0, input.length - 1);
          output = getOutput(input);
        });
      }
      else if (buttonText == "=") {
        setState(() {
          if(!(input.endsWith("+")||input.endsWith("-")||input.endsWith("*")||input.endsWith("/"))){
          input = getOutput(input); // shift values
          output = "";
          }

        });
      }
      else {
        setState(() {
          if((input.endsWith("+")||input.endsWith("-")||input.endsWith("*")||input.endsWith("/")||(input.endsWith(".")))&&
              (buttonText=='+'||buttonText=='-'||buttonText=='*'||buttonText=='/'||(buttonText=='.'&&input.endsWith("."))))
            input = input+"";
          else {
            input = input + buttonText;
            output = getOutput(input);
          }

        });
      }
    }

    else
        print("limit reached");

  }


  /// evaluate user input
  String getOutput(String input){

    String output="";

    try {
      Parser p = new Parser();
      Expression exp = p.parse(input);
      ContextModel cm = new ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      output = eval.toString();
      if(output =="Infinity"||output=='NaN')
        {
          setState(() {
            output= "Can't divide by 0";
            outputColor = Colors.red;
          });
        }
    }
    catch (exception) {
      // display a toast message
      print("invalid output" + output);
    }

    return output;
  }
}
