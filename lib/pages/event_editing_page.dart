import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/event.dart';
import '../services/event_provider.dart';
import '../tools.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;

  const EventEditingPage({Key? key, this.event}) : super(key: key);

  @override
  _EventEditingPageState createState() {
    return _EventEditingPageState();
  }
}

class _EventEditingPageState extends State<EventEditingPage> {
  late DateTime startDate;
  late DateTime endDate;
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  Color backgroundColor = Colors.blue;
  final Map<String, Color> colorMap = {
    "Tomato": Colors.red,
    "Pink": Colors.pink,
    "Purple": Colors.purple,
    "DeepPurple": Colors.deepPurple,
    "Indigo": Colors.indigo,
    "Blue": Colors.blue,
    "LightBlue": Colors.lightBlue,
    "Cyan": Colors.cyan,
    "Teal": Colors.teal,
    "Green": Colors.green,
    "LightGreen": Colors.lightGreen,
    "Lime": Colors.lime,
    "Yellow": Colors.yellow,
    "Amber": Colors.amber,
    "Orange": Colors.orange,
    "DeepOrange": Colors.deepOrange,
    "Brown": Colors.brown,
    "BlueGrey": Colors.blueGrey,
  };

  @override
  //to init start and end date
  void initState() {
    super.initState();

    if (widget.event == null) {
      startDate = DateTime.now();
      endDate = DateTime.now().add(const Duration(hours: 2));
    } else {
      // being able to modify an event
      final event = widget.event!;

      backgroundColor = event.backgroundColor ?? Colors.blue;
      titleController.text = event.name;
      startDate = event.start.toDate();
      endDate = event.end.toDate();
    }
  }

  @override
  //Clear the text editor ressources when we reload the page
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  // --------------SCAFFOLD--------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // buildTitle is a widget that is responsible of a Textfield
                buildTitle(),
                SizedBox(height: 12),
                buildDateTimePickers(),
                buildColor()
              ],
            ),
          )),
    );
  }

  // --------------TOP BAR--------------
  /// Top bar Save button
  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shadowColor: Colors.blue,
                elevation: 0),
            onPressed: saveEvent,
            icon: const Icon(Icons.done),
            label: const Text("SAVE"))
      ];

  // --------------TEXT FIELD--------------
  /// Title Text form = Event name
  Widget buildTitle() => TextFormField(
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            hintText: "Add a name to the event"),
        onFieldSubmitted: (_) => saveEvent(),
        validator: (name) =>
            name != null && name.isEmpty ? "Name can't be empty" : null,
        controller: titleController,
      );

  // --------------DATETIME WIDGETS--------------
  /// Time form widget
  Widget buildDateTimePickers() => Column(
        children: [
          buildStart(),
          buildEnd(),
        ],
      );

  /// Start date
  Widget buildStart() => buildHeader(
      header: 'Start',
      child: Row(
        children: [
          Expanded(
              flex: 2, // it adds some space between date and arrow_drop_down
              child: buildDropdownField(
                text: Tools.toDate(startDate),
                onClicked: () => pickStartDateTime(pickDate: true),
              )),
          Expanded(
              child: buildDropdownField(
            text: Tools.toTime(startDate),
            onClicked: () => pickStartDateTime(pickDate: false),
          )),
        ],
      ));
  Widget buildEnd() => buildHeader(
      header: 'End',
      child: Row(
        children: [
          Expanded(
              flex: 2, // it adds some space between date and arrow_drop_down
              child: buildDropdownField(
                text: Tools.toDate(endDate),
                onClicked: () => pickEndDateTime(pickDate: true),
              )),
          Expanded(
              child: buildDropdownField(
            text: Tools.toTime(endDate),
            onClicked: () => pickEndDateTime(pickDate: false),
          )),
        ],
      ));

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(header,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        child,
      ]);

  /// Field to select a date
  Widget buildDropdownField(
          {required String text, required Function() onClicked}) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  //pick Start date
  Future pickStartDateTime({required bool pickDate}) async {
    final date = await pickDateTime(startDate, pickDate: pickDate);
    if (date == null) return;

    // match endDate to the startDate time
    if (date.isAfter(endDate) || date.isAtSameMomentAs(endDate)) {
      endDate = date.add(const Duration(hours: 2));
    }

    setState(() => startDate = date);
  }

  //pick End date
  Future pickEndDateTime({required bool pickDate}) async {
    final date = await pickDateTime(endDate,
        pickDate: pickDate, firstDate: pickDate ? startDate : null);
    if (date == null) return;

    // match endDate to the startDate time
    if (date.isBefore(startDate) || date.isAtSameMomentAs(startDate)) {
      startDate = date.subtract(const Duration(hours: 2));
    }

    setState(() => endDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    //create the widget that is predefined by date_picker.dart
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: firstDate ?? DateTime(2021, 8),
        lastDate: DateTime(2100),
      );
      if (date == null) return null;
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialDate),
          builder: (context, childWidget) {
            return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: childWidget!);
          });

      if (timeOfDay == null) return null;
      //combining hours with the picked date(day, month, year)
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  // --------------PICK COLOR WIDGETS--------------
  /// popup Dialog to pick a color
  Widget showColorPickerDialog() => AlertDialog(
        title: const Text('Pick a color !'),
        content: SingleChildScrollView(
          child: BlockPicker(
              pickerColor: backgroundColor,
              availableColors: Colors.primaries,
              onColorChanged: (Color color) {
                //on color picked
                setState(() {
                  backgroundColor = color;
                });
              }),
        ),
        actions: [
          ElevatedButton(
            child: const Text('DONE'),
            onPressed: () {
              Navigator.of(context).pop(); //dismiss the color picker
            },
          ),
        ],
      );

  /// Color Header widget
  Widget buildColor() => buildHeader(
        header: 'Select color',
        child: Row(
          children: [
            Expanded(
                flex: 1, child: Icon(Icons.circle, color: backgroundColor)),
            Expanded(
              flex: 6, // it adds some space between date and arrow_drop_down
              child: buildDropdownField(
                  text: getColorName(),
                  onClicked: () => showDialog(
                      context: context,
                      builder: ((context) => showColorPickerDialog()))),
            )
          ],
        ),
      );

  /// get the name of the primary color selected
  String getColorName() {
    return colorMap.keys.firstWhere(
      (k) => colorMap[k]!.value == backgroundColor.value,
      orElse: () => "null");
  }

  // --------------SAVE OR UPDATE EVENT--------------
  /// Save Event method
  Future saveEvent() async {
    final check = _formKey.currentState!.validate();

    var id = "";
    if (widget.event != null) {
      id = widget.event!.id;
    }

    if (check) {
      final event = Event(
          // TODO: add the option to set location or we don't really care
          // TODO: add the option to set a description
          id: id,
          calendarName: 'ECAM',
          end: Timestamp.fromDate(endDate),
          location: 'location',
          name: titleController.text,
          public: false,
          start: Timestamp.fromDate(startDate),
          backgroundColor: backgroundColor);

      final isUpdating = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);

      if (isUpdating) {
        provider.editEvent(event, widget.event!);
      } else {
        provider.addEevent(event);
      }

      Navigator.of(context).pop();
    }
  }
}
