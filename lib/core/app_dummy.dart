import 'package:plant_app/models/working_hour.dart';

final List<WorkingHoursModel> workingHoursData = [
  // const WorkingHoursModel(
  //   title:
  //       'Head Office (Hawalli), And our branches in Al-Rawdah and Khaitan Al-Jahra and Al-Fahaheel',
  //   days: 'Saturday to Thursday: \n 8:00 am to 8:00 pm',
  //   friday: 'Friday: Holiday',
  // ),
  const WorkingHoursModel(
    title: 'Sha’aban Working Hours',
    days: 'Saturday to Thursday: \n 8:00 am to 9:00 pm',
    friday: 'Friday: 1:00 pm to 9:00 pm',
  ),
  const WorkingHoursModel(
    title: 'Ramadan Working Hours',
    days:
        'Saturday to Thursday: \n 10:00 am to 5:30 pm and 9:00 pm to 12:00 am',
    friday: 'Friday: 1:00 pm to 5:30 pm and 9:00 pm to 12:00 am',
  ),
  const WorkingHoursModel(
    title: 'Hajj & Adahi Working Hours',
    days: 'Saturday to Thursday: \n 8:00 am to 9:30 pm',
    friday: 'Friday: 1:00 pm to 9:30 pm',
  ),
];