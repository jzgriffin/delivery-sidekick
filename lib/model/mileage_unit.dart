enum MileageUnit { run, delivery, mile, kilometer }

const mileageUnits = <String, MileageUnit>{
  'run': MileageUnit.run,
  'delivery': MileageUnit.delivery,
  'mile': MileageUnit.mile,
  'kilometer': MileageUnit.kilometer,
};

String mileageUnitToString(MileageUnit unit) =>
    mileageUnits.entries.where((e) => e.value == unit).map((e) => e.key).single;
MileageUnit mileageUnitFromString(String string) => mileageUnits.entries
    .where((e) => e.key == string)
    .map((e) => e.value)
    .single;
