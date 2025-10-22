import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PresentedSectionController extends GetxController {
  var selectedSection =
      0.obs; //1 = Downloads section, 0 = reciter & surah List section
  var selectSectionIcon = Icons.cloud_download.obs;

  void toggleSection() {
    selectedSection.value = selectedSection.value == 0 ? 1 : 0;
    selectSectionIcon.value =
        selectedSection.value == 0 ? Icons.cloud_download : Icons.headphones;
  }
}
