import 'package:skate/Base/BaseViewModel.dart';
import 'package:skate/Base/BaseViewWidget.dart';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/Api.dart';
import 'package:skate/Base/BaseQueryWidget.dart';
import 'package:flutter/material.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skate/Widgets/MyAppBar.dart';

class ChatView extends StatefulWidget {
  final String id;

  const ChatView({
    this.id,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ChatView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    if (!profileService.authorized) {
      return (Text("Unauthorized"));
    }
    TextEditingController chatController = TextEditingController(text: "");
    return BaseViewWidget(
        model: BaseViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: myAppBar(context, '/chat'),
              body: model.busy
                  ? Center(child: CircularProgressIndicator())
                  : BaseQueryWidget(
                      query: """{
                        user(id: "${profileService.user.id}") {
                          username
                          chat
                        }
                      }""",
                      builder: (QueryResult result,
                          {VoidCallback refetch, FetchMore fetchMore}) {
                        User user = User.fromJson(result.data['user']);
                        return ListView(
                          padding: EdgeInsets.all(10.0),
                          children: [
                            Text("Chat:"),
                            ...user.chat.map((e) => Text(e)),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: chatController,
                                    decoration: InputDecoration(
                                      labelText: "Message",

                                    ),
                                  ),
                                ),
                                TextButton(
                                  child: Text("Send"),
                                  onPressed: () async {
                                    model.setBusy(true);
                                    APIResponse apiResponse =
                                        await profileService.postMessage(
                                            profileService.user,
                                            chatController.text);
                                    model.setBusy(false);
                                    if (apiResponse.success) {
                                      chatController.text = "";
                                      refetch();
                                    }
                                  },
                                )
                              ],
                            )
                          ],
                        );
                      },
                    ),
            ));
  }
}
