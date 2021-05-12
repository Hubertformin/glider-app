import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glider/bloc/ComplaintBloc.dart';
import 'package:glider/event/ComplaintEvent.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/widget/AuctionFormField.dart';
import 'package:glider/widget/ProgressDialog.dart';
import 'package:glider/widget/GliderRaisedButton.dart';

class ComplaintScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ComplaintScreenState();
  }
}

class ComplaintScreenState extends State<ComplaintScreen> {
  ComplaintBloc mBloc = ComplaintBloc();
  TextEditingController titleController = new TextEditingController();
  TextEditingController commentController = new TextEditingController();
  ProgressDialog dialog;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mBloc.listen((state) {
      if (state is ProgressDialogState) {
        dialog = ProgressDialog(context, isDismissible: true);
        dialog.show();
      } else {
        if (dialog != null && dialog.isShowing()) {
          dialog.hide();
        }
        if (state is DoneState) {
          Fluttertoast.showToast(msg: state.home.message);
          Navigator.of(context).pop();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuctionFormField(
                S.of(context).title,
                mController: titleController,
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: AuctionFormField(
                  S.of(context).writeYourComplaintHere,
                  maxline: 6,
                  disableContentPadding: false,
                  mController: commentController,
                ),
              ),
              BlocProvider(
                  create: (BuildContext context) => ComplaintBloc(),
                  child: BlocBuilder<ComplaintBloc, BaseState>(
                      bloc: mBloc,
                      builder: (BuildContext context, BaseState state) {
                        return Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: GliderRaisedButton(
                              onPressed: () {
                                addComplaint();
                              },
                              child: Text(
                                S.of(context).submit,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                            ));
                      }))
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(S.of(context).complaint),
        ));
  }

  void addComplaint() {
    String title = titleController.text.trim();
    String comment = commentController.text.trim();
    if (title.isEmpty) {
      Fluttertoast.showToast(msg: S.of(context).pleaseAddTitle);
    } else if (comment.isEmpty) {
      Fluttertoast.showToast(msg: S.of(context).pleaseAddDetails);
    } else {
      mBloc.add(ComplaintEvent(title, comment));
      titleController.clear();
      commentController.clear();
    }
  }
}
