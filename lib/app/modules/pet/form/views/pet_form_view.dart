import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/widgets/app_bar.dart';
import 'package:pawpal/app/data/widgets/card_column.dart';
import 'package:pawpal/app/data/widgets/form_foto.dart';
import 'package:pawpal/app/data/widgets/main_container.dart';
import 'package:pawpal/app/data/widgets/text_field.dart';

import '../controllers/pet_form_controller.dart';

class PetFormView extends GetView<PetFormController> {
  const PetFormView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PPMainContainer(
        scrollable: true,
        children: [
          PPAppBar(title: "Add Pet"),
          16.height,
          PPFormFoto(),
          16.height,
          PPCardColumn(
            color: clrLightGrey,
            children: [
              Text(
                "Pet Identity",
                style: textTheme(context).titleMedium,
              ),
              16.height,
              PPTextfield(
                label: "Pet Category",
                icon: Icon(Icons.pets),
              ),
              16.height,
              PPTextfield(
                label: "Pet Name / Title",
                icon: Icon(Icons.drive_file_rename_outline),
              ),
              16.height,
              PPTextfield(
                label: "Gender",
                icon: Icon(Icons.transgender),
              ),
              16.height,
              PPTextfield(
                label: "Age",
                icon: Icon(Icons.show_chart),
              ),
              16.height,
              PPTextfield(
                label: "Weight",
                icon: Icon(Icons.monitor_weight_rounded),
              ),
              16.height,
              PPTextfield(
                label: "Price",
                icon: Icon(Icons.price_change),
              ),
              16.height,
              PPTextfield(
                label: "Description",
                icon: Icon(Icons.description),
              ),
            ],
          ),
          16.height,
          PPCardColumn(
            color: clrLightGrey,
            children: [
              Text(
                "Owner Information",
                style: textTheme(context).titleMedium,
              ),
              16.height,
              PPTextfield(
                label: "Name",
                icon: Icon(Icons.person),
              ),
              16.height,
              PPTextfield(
                label: "Phone Number",
                icon: Icon(Icons.phone_iphone_rounded),
              ),
              16.height,
              PPTextfield(
                label: "Address",
                icon: Icon(Icons.map_rounded),
              ),
            ],
          ),
          16.height,
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
          16.height,
        ],
      ),
    );
  }
}
