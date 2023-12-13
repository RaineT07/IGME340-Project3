import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:proj_3_local/models/adventure.dart';


import 'package:provider/provider.dart';
import '../provider/adventure_provider.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(ChangeNotifierProvider<AdventureProvider>(
    child: const MyApp(),
    create: (_) => AdventureProvider(),
    ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 206, 234, 245)),
        useMaterial3: true,
      ),
      home: const MyHomeRoute(title: 'Pocket Adventure!'),
    );
  }
}

class MyHomeRoute extends StatefulWidget {
  const MyHomeRoute({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomeRoute> createState() => _MyHomePageState();
}

//debug test set for prototype
final List<List<String>> tempSets = [['text 1', 'text 2', 'text 3'],['text 4','text 5', 'text 6'], ['text 7', 'text 8', 'text 9']];

//full set of options to choose from
final List<List<dynamic>> textSets = [
 /*0*/ ['you see a frog.', 'you see a fox.', 'you see a bird.'], 
 /*1*/ [['you pick up the frog.', 'you ribbit at the frog.', 'you leave the frog alone.'], ['you follow the fox as it walks.', "you interupt the fox's walk.", "you walk away from the fox."], ['you track the bird down.', 'you whistle at the bird.', 'you leave the bird alone.']], 
 /*2*/ [[["you pet the frog.","you try to determine the frog's species.", 'you bring the frog to a pond.', ], ['the frog ribbits back at you.', 'the frog gives you a confused look.', 'the frog hops towards you.'], ['you watch a few different frogs.', "you go back to the frog pond.", "you watch where the frog goes."]],[['The fox leads you back to its den.', 'the fox leads you into a nice forest.', 'the fox stops at a lake.'],['the fox growls at you.','the fox looks at you curiously.', 'the fox tries to sneak past you.'],['the fox barks at you, and walks back towards you.', 'you make your way towards the ocean.', 'you walk back home.']],[['the bird leads you back to its nest.', 'the bird flies out towards the ocean.', 'you lose track of the bird in the forest.'],['the bird flies down at you, and you duck.', 'the bird flies down at you, and you try to catch it.', 'the bird flies down at you, and you make a platform for it to land on your hand.'],['you decide to chase after the bird again.', 'you walk in the direction the bird came from.', 'you try to find a different animal.']]]
  ];

String pageAdventure = '';
int _currentIndex =0;
List<dynamic> currentItems = textSets[0];
List<int> choices = [];
// final List<String> textList = ['text 1', 'text 2', 'text 3',];



class _MyHomePageState extends State<MyHomeRoute> {
  CarouselController buttonCarouselController = CarouselController();
  bool focusedOptions = true;

  @override
  Widget build(BuildContext context) {
    dynamic adventures = context.watch<AdventureProvider>().adventures;
    dynamic myList = context.watch<AdventureProvider>().myList;

    return MaterialApp(
      title: 'Choose Your Own Adventure',
      debugShowCheckedModeBanner: false,
      home:DefaultTabController(
        length: 3,
        child:Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.list_alt_rounded),
            titleTextStyle: GoogleFonts.lato(textStyle: TextStyle(letterSpacing: 2, fontSize: 20)),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)), //primary adventure page
                Tab(icon: Icon(Icons.list)), //stored adventure list page
                Tab(icon:Icon(Icons.info_outline)), //documentation page
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: TabBarView(
            children:[
              //primary adventure page
              Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      fit:StackFit.loose,
                      alignment: Alignment.center,
                      children:[
                        //this carousel object is given new values with each press of the submit button according to the option submitted
                        CarouselSlider(
                          carouselController: buttonCarouselController,
                          options:CarouselOptions(
                            height:200,
                            padEnds: true,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            enlargeFactor:0.4,
                            viewportFraction: 0.3,
                            enableInfiniteScroll: false,
                            autoPlay: false,
                            clipBehavior: Clip.antiAlias,
                            onPageChanged: (index,reason){
                              _currentIndex = index;
                              setState(() {});
                            },
                            ),
                            //builds boxes for each choice. currentItems is determined in processChoice
                          items: currentItems.map((i){
                            return Builder(builder: (BuildContext context){
                              return AnimatedContainer(
                                width:300,
                                // margin: EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color:Colors.white70,
                                  borderRadius:BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [  
                                    BoxShadow(
                                      color:Colors.grey,
                                      offset:Offset(5,5),
                                      blurRadius:5,
                                      spreadRadius:0.5,
                                    ),
                                  ],
                                ),
                                duration:Duration(milliseconds: 250),
                                child:Padding(padding:EdgeInsets.all(20),child:Center(child:Text(i,style: GoogleFonts.getFont('Montserrat')))),
                              );
                            });
                          }
                          ).toList(),                                
                        ),
                      ],
                    ),
                    SizedBox(height:50),
                    //this button locks in the selection 
                    GestureDetector(
                      onTap:processChoice,
                      child:Container(
                        width:100,
                        height:30,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color:Color.fromARGB(255, 212, 244, 245),
                          borderRadius:BorderRadius.all(Radius.circular(20)),
                          boxShadow: [  
                                BoxShadow(
                                  color:Colors.grey,
                                  offset:Offset(3,3),
                                  blurRadius:3,
                                  spreadRadius:0.3,
                                ),
                              ],
                        ),
                        child:Text("Submit choice",style:GoogleFonts.getFont('Lato'), 
                        textAlign: TextAlign.center,),
                      ),
                    )
                  ],
                )
              ),
              //adventure list page
              Center(
                child:Padding(
                  padding: EdgeInsets.all(50),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //list of previous adventures
                      Expanded(child:
                      ListView.builder(  
                        itemCount:myList.length,
                        itemBuilder:(_,index){
                          final currentAdventure = myList[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                key:ValueKey(currentAdventure.fullAdventure),
                                child: Container(
                                  width:200,
                                  height:50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular((10)),
                                    color: Color.fromARGB(255, 217, 241, 241),
                                    boxShadow: [
                                      BoxShadow(color:Colors.grey,
                                      offset:Offset(3,3),
                                      blurRadius:3,
                                      spreadRadius:0.3,)
                                    ]
                                  ),
                                  child: Text('Adventure # ${index}', style:GoogleFonts.getFont('Montserrat')),
                                ),
                                onTap:(){
                                  showDialog(
                                    context: context, 
                                    barrierDismissible:true,
                                    builder: ((context) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(  
                                          child:Text('${currentAdventure.fullAdventure}'),
                                        ),
                                      );
                                    }));
                                }
                              ),
                              GestureDetector(
                                child:const Icon(
                                  Icons.clear_outlined,
                                  color:Colors.redAccent
                                ),
                                onTap:() {
                                  context.read<AdventureProvider>().removeFromList(currentAdventure);
                                }
                              )
                            ],
                            );
                        }
                      ),
                      ),


                      //button rows
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.add), 
                            label: Text('save history',style:GoogleFonts.getFont('Lato', fontSize:12)), 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent
                            ),
                            onPressed: saveCurrentHistory
                          ),
                          SizedBox(width:5),
                          ElevatedButton.icon(
                            icon:Icon(Icons.clear), 
                            label:Text('clear all histories',style:GoogleFonts.getFont('Lato',fontSize:12)), 
                            style:ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent
                            ),
                            onPressed:clearAllHistories
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //documentation page
              Padding(
                padding:EdgeInsets.all(20),
                child: ListView(
                  children: [
                    Text('Developer',style:GoogleFonts.lato(textStyle: TextStyle(fontSize: 40))),
                    Text('Raine Taber',style:GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 20))),
                    Text('Concept', style:GoogleFonts.lato(textStyle: TextStyle(fontSize: 40))),
                    Text("I want to be able to create a mobile experience/game in a text-adventure format. For this experience, the interaction is swipe-gesture based. In order to switch between text decisions, you swipe left and right. To enter a decision you swipe down. Once you move through an adventure, you can save it to a separate tab and review it in a more traditional written format.",style:GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15))),
                    Text("Controls", style:GoogleFonts.lato(textStyle: TextStyle(fontSize: 40))),
                    Text("Options in each adventure will be chosen by swiping left and right. Then, a choice is confirmed by pressing on the 'Submit choice' button on the bottom of the screen. Once the player is done, they can view the whole adventure. If they want to view previous adventures, they can access them in the list page, which has a list of adventures in chronological order. a new adventure can be stored even if it is not done using the list page's 'save history' button and all history can be cleared via the button 'clear all histories'. An individual adventure can also be deleted via the X button next to the adventure in the list.", style:GoogleFonts.montserrat(fontSize: 15))

                  ],
                  )
              )
            ]
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      )
    );
  }

  void processChoice(){

    //third selection (27 potential choices)
    if(choices.length==2){
      choices.add(_currentIndex);
      pageAdventure = pageAdventure + textSets[2][choices[0]][choices[1]][_currentIndex];
      context.read<AdventureProvider>().addToList(Adventure(fullAdventure: pageAdventure));
      //now to show off the full adventure
      showDialog(
        context: context, 
        barrierDismissible:true,
        builder: ((context) {
          return AlertDialog(
            content: SingleChildScrollView(  
              child:Text('${pageAdventure}'),
            ),
          );
        })).then((val){
          //the adventure is then reset to its original.
          currentItems = textSets[0];
          choices = [];
          pageAdventure = '';
          setState(() { });
        });

    //second selection (9 potential choices)
    }else if(choices.length==1){
      currentItems = textSets[2][choices[0]][_currentIndex];
      choices.add(_currentIndex);
      pageAdventure = pageAdventure + textSets[1][choices[0]][_currentIndex] + " ";
    }
    //first selection (3 potential choices)
    else{
      currentItems = textSets[1][_currentIndex];
      choices.add(_currentIndex);
      pageAdventure = pageAdventure + textSets[0][_currentIndex]+ " ";
    }
    setState(() {});
  }

  void saveCurrentHistory(){
    context.read<AdventureProvider>().addToList(Adventure(fullAdventure: pageAdventure));
    setState(() {});
  }

  void clearAllHistories(){
    context.read<AdventureProvider>().removeAllFromList();
  }
}
