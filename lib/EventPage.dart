import 'package:calendar_app/services/event_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/event.dart';
import 'tools.dart';

class Eventpage extends StatefulWidget {
  final Event? event;

  Eventpage({
    Key? key,
    this.event
  }): super(key: key);

  @override
  State<Eventpage> createState() => _EventpageState();
}

class _EventpageState extends State<Eventpage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime startDate;
  late DateTime endDate;

  @override
  //to init start and end date
  void initState() {
    super.initState();

    if (widget.event == null){
      startDate = DateTime.now();
      endDate = DateTime.now().add(const Duration(hours : 2));
    }else{
      // being able to modify an event
      final event = widget.event!;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child:Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // buildTitle is a widget that is responsible of a Textfield
              buildTitle(),
              SizedBox(height: 12),
              buildDateTimePickers()
            ],
          ),

        )

      ),
    );
  }
  List<Widget> buildEditingActions() => [
    ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent
        ),
        onPressed: saveEvent,
        icon: const Icon(Icons.done),
        label: const Text("SAVE"))
  ];
  Widget buildTitle() => TextFormField(
    style: const TextStyle(fontSize: 24),
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
      hintText: "Add Title"
    ),
    onFieldSubmitted: (_) => saveEvent(),
    validator: (name) =>
    name != null && name.isEmpty ? "Title can't be empty" : null ,
    controller: titleController,
  );

  Widget buildDateTimePickers() => Column(
    children: [
      buildStart(),
      buildEnd(),
    ],
  );

  Widget buildStart() => buildHeader(
    header : 'Start',
      child:Row(
    children: [
      Expanded(
        flex: 2, // it adds some space between date and arrow_drop_down
          child: buildDropdownField(
            text: Tools.toDate(startDate),
            onClicked: () => pickStartDateTime(pickDate: true),
          )
      ),
      Expanded(
          child: buildDropdownField(
            text: Tools.toTime(startDate),
            onClicked: () => pickStartDateTime(pickDate: false),
          )
      ),
    ],
      )
  );
  Widget buildEnd() => buildHeader(
      header : 'End',
      child:Row(
        children: [
          Expanded(
              flex: 2, // it adds some space between date and arrow_drop_down
              child: buildDropdownField(
                text: Tools.toDate(endDate),
                onClicked: () => pickEndDateTime(pickDate: true),
              )
          ),
          Expanded(
              child: buildDropdownField(
                text: Tools.toTime(endDate),
                onClicked: () => pickEndDateTime(pickDate: false),
              )
          ),
        ],
      )
  );

  Widget buildDropdownField({
    required String text,
    required  Function() onClicked
  }) => ListTile(
    title: Text(text),
    trailing: const Icon(Icons.arrow_drop_down),
    onTap: onClicked,
  );

  Widget buildHeader({
  required String header,
    required Widget child,
}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:[
      Text(header, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      child,
    ]
      );

  //pick Start date
  Future pickStartDateTime({required bool pickDate}) async {
    final date = await pickDateTime(startDate, pickDate: pickDate);
    if (date == null) return;
    if(date.isAfter(endDate)){
      endDate =
          DateTime(date.year, date.month, date.day, endDate.hour, endDate.minute);
    }

    setState(() =>startDate = date);
  }

  //pick End date
  Future pickEndDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
        endDate,
        pickDate: pickDate,
        firstDate:pickDate ? startDate : null);
    if (date == null) return;


    setState(() =>endDate = date);
  }

  Future<DateTime?> pickDateTime(
      DateTime initialDate, {
        required bool pickDate,
      DateTime? firstDate,
      }) async {
    //create the widget that is predefined by date_picker.dart
    if (pickDate){
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
    } else{
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;
      //combining hours with the picked date(day, month, year)
      final date = 
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }


  }
  Future saveEvent() async{
    final check = _formKey.currentState!.validate();

    if(check){
      final event = Event(
          id: '', // firestore will create an id automatically
          calendarName: 'ECAM',
          end: Timestamp.fromDate(endDate),
          location: 'location', // TODO: add the option to set location or we don't really care
          name: titleController.text,
          public: false,
          start: Timestamp.fromDate(startDate) // TODO: add the option to set a description
      );

      final isUpdating = widget.event != null;
      final provider = Provider.of<EventProvider>(context,listen: false );

      if(isUpdating){
        provider.editEvent(event, widget.event!);
        // TODO: call database.updateEvent()

      }else{
        provider.addEevent(event);
        // TODO: call database.createSingleEvent()
      }

      Navigator.of(context).pop();

    }
  }

}




