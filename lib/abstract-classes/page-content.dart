import 'package:flutter/cupertino.dart';

/**
 * This (parent) class is used as a structure for the UI page implementations.
 */
abstract class PageContent {
  PreferredSizeWidget buildAppBar(BuildContext context);
  Widget buildBody(BuildContext context);
}
