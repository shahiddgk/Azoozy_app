import 'package:azoozyapp/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoaderWidget extends StatefulWidget {
   LoaderWidget(this.whiteColor,{Key? key}) : super(key: key);

   bool whiteColor;

  @override
  _LoaderWidgetState createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(child: LoadingAnimationWidget.fourRotatingDots(color:widget.whiteColor ? AppColors.whiteColor : AppColors.primarySwatch, size: MediaQuery.of(context).size.width/6) ,);
  }
}
