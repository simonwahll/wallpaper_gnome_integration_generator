import 'dart:io';

import 'package:xml/xml.dart';

void printHelp() {
  print('Usage: gwigen <directory_containing_wallpapers>');
}

void main(List<String> arguments) async {
  if (arguments.length != 1) {
    printHelp();
    exit(1);
  }

  if (!await FileSystemEntity.isDirectory(arguments[0])) {
    printHelp();
    exit(1);
  }

  var directory = Directory(arguments[0]);
  var wallpaperPaths = [];

  await directory.list().forEach((file) {
    if (file.absolute.path.endsWith('.jpg') ||
        file.absolute.path.endsWith('.png')) {
      wallpaperPaths.add(file.absolute.path);
    }
  });

  final builder = XmlBuilder();

  builder.processing('xml', 'version="1.0"');
  builder.xml(XmlDoctype('wallpapers SYSTEM "gnome-wp-list.dtd"').toString());
  builder.element('wallpapers', nest: () {
    for (var wallpaper in wallpaperPaths) {
      builder.element('wallpaper', nest: () {
        builder.attribute('deleted', false);
        builder.element('name', nest: () {
          builder.text(wallpaper.split('/').last.split('.').first);
        });
        builder.element('filename', nest: () {
          builder.text(wallpaper);
        });
        builder.element('options', nest: () {
          builder.text('zoom');
        });
        builder.element('pcolor', nest: () {
          builder.text('#fffff');
        });
        builder.element('scolor', nest: () {
          builder.text('#000000');
        });
      });
    }
  });

  var document = builder.buildDocument();

  print(document.toXmlString(pretty: true));
}
