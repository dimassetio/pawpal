import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/widgets/app_bar.dart';
import 'package:pawpal/app/data/widgets/card_column.dart';
import 'package:pawpal/app/data/widgets/main_container.dart';
import 'package:pawpal/app/data/widgets/text_field.dart';

import '../controllers/carousel_form_controller.dart';

class CarouselFormView extends GetView<CarouselFormController> {
  const CarouselFormView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PPMainContainer(
      scrollable: false,
      children: [
        PPAppBar(title: "Banner Form"),
        16.height,
        controller.formFoto,
        PPCardColumn(
          children: [
            PPTextfield(
              icon: Icon(Icons.numbers),
              label: "Index",
              controller: controller.indexC,
              textFieldType: TextFieldType.NUMBER,
              digitsOnly: true,
            ),
            16.height,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.formFoto.newPath.isEmpty ||
                          controller.indexC.text.isEmpty) {
                        Get.snackbar(
                            "Validation Error", "Fill all field first");
                      } else {
                        controller.save();
                      }
                    },
                    child: Text("Submit"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        )
      ],
    ));
  }
}
