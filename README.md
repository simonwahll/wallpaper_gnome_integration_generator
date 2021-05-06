# Wallpape GNOME Integration Generator

This program can generate the XML-file that defines the wallpapers GNOME can use. All wallpapers that should be added must be in a single folder and that folder is the first argument this program takes. 

Note that currently this only works with JPG and PNG files. More will come in the future.

## Compilation

```
dart compile exe bin/main.dart -o wgigen
```

## Usage

```
wgigen <path_to_folder_with_wallpapers> <name_of_xml_file>
```

Where `<path_to_folder_with_wallpapers>` is any folder that contains wallpapers and `<name_of_xml_file>` is the name of the file that will be generated.

If you have a GNOME installation you can test and inspect it with the follwing:

```
wgigen /usr/share/backgrounds/gnome gnome-backgrounds.xml
``` 

## Contribution

Contributions will be appreciated.