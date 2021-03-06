import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:Kide/models/ContactCategory.dart';
import 'package:Kide/pages/ContactsPage/ContactList.dart';


class CategoryCard extends StatelessWidget{
  const CategoryCard(this.contactCategory);
  final ContactCategory contactCategory;

  @override
  Widget build(BuildContext context){
    return Card(
      margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: new InkWell(
        onTap:(){
          Navigator.of(context).pushNamed(
            ContactList.routeName,
            arguments: contactCategory
          );
          print('Contact Card tapped');
        },
      child: Center(
        child: Text(contactCategory.name,
          textAlign: TextAlign.center,
          //overflow: TextOverflow.fade,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0
          )
          ),
        )
      )
    );
  }
}

