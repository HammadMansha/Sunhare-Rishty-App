import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Config/theme.dart';
import 'package:matrimonial_app/Screens/PremiumPlanScreen.dart';
import 'package:matrimonial_app/Screens/PremiumUserScreen.dart';
import 'package:matrimonial_app/main.dart';

class AcceptInvitationScreen extends StatefulWidget {
  String? name,image;
  bool? isPremium;
  AcceptInvitationScreen({this.name, this.image, this.isPremium});

  @override
  State<AcceptInvitationScreen> createState() => _AcceptInvitationScreenState();
}

class _AcceptInvitationScreenState extends State<AcceptInvitationScreen> {
  double? height;
  double? width;
  @override
  void initState() {
    print("isPremium==>>>${widget.isPremium}");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(height: height! * 0.7,width: width,child: Image.asset("assets/accept_card.jpg",fit: BoxFit.fill)),
              Positioned(top: 50,right: 15,child: InkWell(onTap: (){
                Navigator.pop(context);
              },child: Icon(Icons.clear,color: white,size: 20))),
              Positioned(top: 90,child: Column(
                children: [
                  Text("You've got an Accept!",style: TextStyle(color: white,fontSize: 25)),
                  SizedBox(height: 10),
                  Text("${widget.name} has Accepted your invitation",style: TextStyle(color: white,fontSize: 15)),
                ],
              )),
              Positioned(
                bottom: 40,
                child: Column(
                  children: [
                    Container(
                      height: 100,width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage(widget.image!),fit: BoxFit.fill),
                          border: Border.all(color: white,width: 3)
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("${widget.name}",style: TextStyle(color: white,fontSize: 15)),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 40),
          Text("Take the next step now",style: TextStyle(fontSize: 18)),
          SizedBox(height: 5),
          Text("Upgrade to message or call her directly.",style: TextStyle(fontSize: 15)),
          SizedBox(height: 15),
          if(widget.isPremium! == false)
          InkWell(
            child: Container(
              height: 40,
              padding: EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
              width: width! * 0.6,
              decoration: BoxDecoration(
                color: theme.colorCompanion,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.crown,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(width:8),
                  Text("View Premium Plans",style: TextStyle(fontSize: 15,color: white,fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PremiuimPlanScreen()));
            },
          )
        ],
      ),
    );
  }
}
