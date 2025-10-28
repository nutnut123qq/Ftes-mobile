enum Semester { s1, s2, s3, s4, s5, s6, s7, s8 }

enum TargetMajor {
  javaDeep,
  feDev,
  beDev,
  fullstackDev,
  mobileDev,
}

class Skill {
  final String id;
  final String label;
  const Skill(this.id, this.label);
}