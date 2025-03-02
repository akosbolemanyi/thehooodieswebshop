import 'package:flutter/cupertino.dart';

abstract class PageContent {
  PreferredSizeWidget buildAppBar(BuildContext context);
  Widget buildBody(BuildContext context);
}
