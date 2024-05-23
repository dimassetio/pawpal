import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/formatter.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/models/pet_model.dart';
import 'package:pawpal/app/data/widgets/app_bar.dart';
import 'package:pawpal/app/data/widgets/card_column.dart';
import 'package:pawpal/app/data/widgets/dropdown_menu.dart';
import 'package:pawpal/app/data/widgets/main_container.dart';
import 'package:pawpal/app/data/widgets/text_field.dart';

import '../controllers/pet_form_controller.dart';

class PetFormView extends GetView<PetFormController> {
  const PetFormView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: controller.formKey,
        child: PPMainContainer(
          scrollable: true,
          children: [
            PPAppBar(title: "Add Pet"),
            16.height,
            controller.formFoto,
            16.height,
            PPCardColumn(
              color: clrLightGrey,
              children: [
                Text(
                  "Pet Identity",
                  style: textTheme(context).titleMedium,
                ),
                16.height,
                PPDropdown(
                  listValue: PetCategory.list,
                  onChanged: (value) => controller.categoryC = value,
                  label: "Pet Category",
                  initValue: controller.categoryC,
                  icon: Icon(Icons.pets),
                ),
                16.height,
                PPTextfield(
                  controller: controller.titleC,
                  label: "Pet Name / Title",
                  icon: Icon(Icons.drive_file_rename_outline),
                ),
                16.height,
                PPDropdown(
                  listValue: PetGender.list,
                  onChanged: (value) => controller.genderC = value,
                  label: "Gender",
                  icon: Icon(Icons.transgender),
                  initValue: controller.genderC,
                  titleFunction: (value) => petGenderName(value),
                ),
                16.height,
                PPTextfield(
                  controller: controller.ageC,
                  label: "Age",
                  icon: Icon(Icons.show_chart),
                  textFieldType: TextFieldType.NUMBER,
                ),
                16.height,
                Row(
                  children: [
                    Expanded(
                      child: PPTextfield(
                        controller: controller.sizeC,
                        label: "Size",
                        icon: Icon(Icons.monitor_weight_rounded),
                      ),
                    ),
                    16.width,
                    SizedBox(
                      width: Get.width / 4,
                      child: PPDropdown(
                        initValue: controller.unitC,
                        listValue: PetUnit.list,
                        onChanged: (value) => controller.unitC = value,
                        label: "Unit",
                      ),
                    ),
                  ],
                ),
                16.height,
                PPTextfield(
                  controller: controller.priceC,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrrencyInputFormatter(),
                  ],
                  textFieldType: TextFieldType.NUMBER,
                  label: "Price",
                  icon: Icon(Icons.price_change),
                ),
                16.height,
                PPTextfield(
                  controller: controller.descriptionC,
                  textFieldType: TextFieldType.MULTILINE,
                  label: "Description",
                  icon: Icon(Icons.description),
                ),
              ],
            ),
            16.height,
            PPCardColumn(
              color: clrLightGrey,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pet Location",
                      style: textTheme(context).titleMedium,
                    ),
                    Obx(
                      () => IconButton(
                        onPressed: controller.isLoading
                            ? null
                            : () {
                                controller.loadLocation();
                              },
                        icon: controller.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator())
                            : Icon(Icons.location_searching_rounded),
                        color: primaryColor(context),
                      ),
                    )
                  ],
                ),
                16.height,
                PPTextfield(
                  controller: controller.provinsiC,
                  isReadOnly: true,
                  label: "Province",
                  icon: Icon(Icons.person),
                ),
                16.height,
                PPTextfield(
                  isReadOnly: true,
                  controller: controller.kotaC,
                  label: "City",
                  icon: Icon(Icons.phone_iphone_rounded),
                ),
                16.height,
                PPTextfield(
                  isReadOnly: true,
                  controller: controller.kecamatanC,
                  label: "Locality",
                  icon: Icon(Icons.map_rounded),
                ),
                16.height,
                PPTextfield(
                  controller: controller.alamatC,
                  label: "Address Detail",
                  icon: Icon(Icons.map_rounded),
                ),
              ],
            ),
            16.height,
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36),
                        ),
                      ),
                      onPressed: controller.isLoading
                          ? null
                          : () {
                              if (controller.formKey.currentState?.validate() ??
                                  false) {
                                controller.save(context);
                              }
                            },
                      child: controller.isLoading
                          ? LinearProgressIndicator()
                          : Text("Submit"),
                    ),
                  ),
                ),
              ],
            ),
            16.height,
          ],
        ),
      ),
    );
  }
}
