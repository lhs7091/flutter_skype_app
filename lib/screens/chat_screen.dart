import 'package:flutter/material.dart';
import 'package:flutter_skype_app/export_path.dart';

class ChatScreen extends StatefulWidget {
  final SkypeUser receiver;
  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = TextEditingController();

  bool isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: [
          Flexible(
            child: messageList(),
          ),
          chatControls(),
        ],
      ),
    );
  }

  Widget messageList() {
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: 6,
      itemBuilder: (context, index) {
        return chatMessageItem();
      },
    );
  }

  Widget chatMessageItem() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        alignment: Alignment.centerRight,
        child: senderLayout(),
      ),
    );
  }

  Widget senderLayout() {
    Radius messageRadius = Radius.circular(10.0);
    return Container(
      margin: EdgeInsets.only(top: 12.0),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          'hello',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget receiverLayout() {
    Radius messageRadius = Radius.circular(10.0);
    return Container(
      margin: EdgeInsets.only(top: 12.0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          'hello',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      FlatButton(
                        child: Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Content and tools',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: [
                      ModalTile(
                        title: 'media',
                        subtitle: 'Share photos and video',
                        icon: Icons.image,
                      ),
                      ModalTile(
                          title: "File",
                          subtitle: "Share files",
                          icon: Icons.tab),
                      ModalTile(
                          title: "Contact",
                          subtitle: "Share contacts",
                          icon: Icons.contacts),
                      ModalTile(
                          title: "Location",
                          subtitle: "Share a location",
                          icon: Icons.add_location),
                      ModalTile(
                          title: "Schedule Call",
                          subtitle: "Arrange a skype call and get reminders",
                          icon: Icons.schedule),
                      ModalTile(
                          title: "Create Poll",
                          subtitle: "Share polls",
                          icon: Icons.poll),
                    ],
                  ),
                ),
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                gradient: UniversalVariables.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: TextField(
              controller: textEditingController,
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (val) {
                val.length > 0 && val.trim() != ""
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "type a message",
                hintStyle: TextStyle(
                  color: UniversalVariables.greyColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 5.0,
                ),
                filled: true,
                fillColor: UniversalVariables.separatorColor,
                suffixIcon: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.face,
                  ),
                ),
              ),
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(
                    Icons.record_voice_over,
                  ),
                ),
          isWriting
              ? Container()
              : Icon(
                  Icons.camera_alt,
                ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    gradient: UniversalVariables.fabGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15.0,
                    ),
                    onPressed: () {},
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.name,
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.video_call,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.phone,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
