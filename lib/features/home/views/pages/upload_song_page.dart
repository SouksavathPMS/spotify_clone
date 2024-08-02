import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify_clone/core/theme/app_pallete.dart';
import 'package:spotify_clone/core/utils.dart';
import 'package:spotify_clone/core/widgets/custom_field.dart';
import 'package:spotify_clone/features/home/viewmodel/home_viewmodel.dart';
import 'package:spotify_clone/features/home/views/widgets/audio_wave.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  static const routeName = "uploadSong";
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  ValueNotifier<Color> seletedColor = ValueNotifier<Color>(Colors.blue);
  ValueNotifier<File?> selectedImage = ValueNotifier<File?>(null);
  ValueNotifier<File?> selectedAudio = ValueNotifier<File?>(null);

  Future<void> _selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage == null) {
      return;
    }
    selectedImage.value = pickedImage;
  }

  Future<void> _selectAudio() async {
    final (File? file, String? name) = await pickAudio();
    if (file != null && name != null) {
      selectedAudio.value = file;
      _formKey.currentState!.fields["pick_song"]!.didChange(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Song"),
        actions: [
          IconButton(
            onPressed: () async {
              final validated = _formKey.currentState!.validate();
              if (!validated ||
                  selectedAudio.value == null ||
                  selectedImage.value == null) {
                showSnackbar(context, content: "Missing fields");
                return;
              }
              final songName =
                  _formKey.currentState!.fields["song_name"]!.value;
              final artist =
                  _formKey.currentState!.fields["pick_artist"]!.value;

              await ref.read(homeViewModelProvider.notifier).uploadSong(
                    seletedAudio: selectedAudio.value!,
                    selectedThumbnail: selectedImage.value!,
                    songName: songName,
                    artist: artist,
                    seletedColor: seletedColor.value,
                  );
            },
            icon: const Icon(
              Icons.check_rounded,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 12, right: 12, left: 12),
        child: Column(
          children: [
            GestureDetector(
              onTap: _selectImage,
              child: ValueListenableBuilder(
                valueListenable: selectedImage,
                builder: (context, file, child) {
                  if (file != null) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        file,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  return DottedBorder(
                    color: Pallete.borderColor,
                    dashPattern: const [10, 4],
                    radius: const Radius.circular(10),
                    borderType: BorderType.RRect,
                    strokeCap: StrokeCap.round,
                    child: const SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 40,
                          ),
                          Text(
                            "Select thumbnail for your song",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  CustomField(
                    name: "pick_song",
                    hintText: "Pick song",
                    readOnly: true,
                    onTap: _selectAudio,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  ValueListenableBuilder(
                    valueListenable: selectedAudio,
                    builder: (context, value, child) {
                      if (selectedAudio.value == null) {
                        return const SizedBox();
                      } else {
                        return AudioWave(audioPath: value!.path);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomField(
                    name: "pick_artist",
                    hintText: "Artist",
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  CustomField(
                    name: "song_name",
                    hintText: "Song Name",
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListenableBuilder(
              listenable: seletedColor,
              builder: (context, _) => ColorPicker(
                pickersEnabled: const {
                  ColorPickerType.wheel: true,
                },
                color: seletedColor.value,
                padding: EdgeInsets.zero,
                onColorChanged: (Color newColor) =>
                    seletedColor.value = newColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
