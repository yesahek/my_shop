import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  UserProductItem(this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Row(children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit),
        ),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
            color: Theme.of(context).primaryColor),
      ]),
    );
  }
}
