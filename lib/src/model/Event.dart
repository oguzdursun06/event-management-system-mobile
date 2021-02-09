
class Event {
  Event({
    this.id,
    this.name,
    this.capacity,
    this.personCount,
    this.category,
    this.startEventDate,
    this.finishEventDate
  });

  int id;
  String name;
  int capacity;
  int personCount;
  String category;
  DateTime startEventDate;
  DateTime finishEventDate;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    name: json["name"],
    capacity: json["capacity"],
    personCount: json["person_count"],
    category: json["category"],
    startEventDate: DateTime.parse(json["start_event_date"]),
    finishEventDate: DateTime.parse(json["finish_event_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}

class EventList{
  List<Event> events=[];

  EventList.fromJsonList(Map value){
    value.forEach((key, value) {
      var post = Event.fromJson(value);
      events.add(post);
    });

  }
}