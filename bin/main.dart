import 'dart:io';

import 'package:xml/xml.dart';

void printHelp() {
  print('Usage: wgigen <directory_containing_wallpapers> <name_of_xml_file>');
}

Future<bool> validateArguments(List<String> arguments) async {
  if (arguments.length != 2) {
    return false;
  }

  if (!await FileSystemEntity.isDirectory(arguments[0])) {
    return false;
  }

  return true;
}

Future<List<String>> loadFilePaths(String path) async {
  var directory = Directory(path);
  var filePaths = <String>[];

  await directory.list().forEach((file) {
    if (file.absolute.path.endsWith('.jpg') ||
        file.absolute.path.endsWith('.png') ||
        file.absolute.path.endsWith('.jpeg')) {
      filePaths.add(file.absolute.path);
    }
  });

  return filePaths;
}

Future<String> buildXMLString(List<String> paths) async {
  final builder = XmlBuilder();

  builder.processing('xml', 'version="1.0"');
  builder.xml(XmlDoctype('wallpapers SYSTEM "gnome-wp-list.dtd"').toString());
  builder.element('wallpapers', nest: () {
    for (var path in paths) {
      builder.element('wallpaper', nest: () {
        builder.attribute('deleted', false);
        builder.element('name', nest: () {
          builder.text(path.split('/').last.split('.').first);
        });
        builder.element('filename', nest: () {
          builder.text(path);
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

  return builder.buildDocument().toXmlString(pretty: true);
}

Future<void> saveToFile(String fileName, String xmlString) async {
  fileName = fileName.endsWith('.xml') ? fileName : '$fileName.xml';

  var file = File(fileName);
  await file.writeAsString(xmlString);
}

void main(List<String> arguments) {
  validateArguments(arguments).then((value) {
    if (!value) {
      printHelp();
      exit(1);
    }

    loadFilePaths(arguments[0]).then((paths) {
      if (paths.isEmpty) {
        print('Could not find any wallpapers in the provided directory.');
        printHelp();
      }

      buildXMLString(paths).then((xmlString) {
        saveToFile(arguments[1], xmlString);
      });
    });
  });
}
