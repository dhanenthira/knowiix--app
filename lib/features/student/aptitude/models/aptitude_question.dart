class AptitudeQuestion {
  final String id;
  final String category;
  final String topic;
  final String difficulty;
  final String title;
  final String content;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String? formulaTip;
  final int marks;
  final int timeLimitSec;
  final List<String> tags;

  const AptitudeQuestion({
    required this.id,
    required this.category,
    required this.topic,
    required this.difficulty,
    required this.title,
    required this.content,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.formulaTip,
    this.marks = 1,
    this.timeLimitSec = 60,
    this.tags = const [],
  });

  factory AptitudeQuestion.fromJson(Map<String, dynamic> json) {
    return AptitudeQuestion(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Quantitative',
      topic: json['topic']?.toString() ?? 'Aptitude General',
      difficulty: json['difficulty']?.toString() ?? 'medium',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      options: (json['options'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      correctAnswer: json['correct_answer']?.toString() ?? '',
      explanation: json['explanation']?.toString() ?? '',
      formulaTip: json['formula_tip']?.toString(),
      marks: json['marks'] is int ? json['marks'] : 1,
      timeLimitSec: json['time_limit_sec'] is int ? json['time_limit_sec'] : 60,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

// Preloaded Comprehensive Question Bank matching Web Platform
final List<AptitudeQuestion> defaultAptitudeBank = [
  const AptitudeQuestion(
    id: "apt_q_01",
    category: "Quantitative",
    topic: "Time & Distance",
    difficulty: "easy",
    title: "Train Speed & Distance",
    content: "A train running at the speed of 60 km/hr crosses a pole in 9 seconds. What is the length of the train in meters?",
    options: ["120 metres", "150 metres", "180 metres", "324 metres"],
    correctAnswer: "150 metres",
    explanation: "Speed in m/sec = 60 × (5/18) = 50/3 m/sec.\nLength of the train = Speed × Time = (50/3) × 9 = 150 metres.",
    formulaTip: "To convert km/hr to m/sec, multiply by 5/18. Distance = Speed × Time.",
    marks: 1,
    tags: ["Trains", "Speed", "TCS NQT"],
  ),
  const AptitudeQuestion(
    id: "apt_q_02",
    category: "Quantitative",
    topic: "Profit & Loss",
    difficulty: "easy",
    title: "Cost Price from Selling Price",
    content: "A shopkeeper sells an article for \$240 and gains 20%. What was the cost price of the article?",
    options: ["\$190", "\$200", "\$210", "\$220"],
    correctAnswer: "\$200",
    explanation: "Gain% = 20%.\nSelling Price (SP) = CP × (100 + Gain%) / 100\n240 = CP × 120 / 100\nCP = (240 × 100) / 120 = \$200.",
    formulaTip: "Cost Price = (Selling Price × 100) / (100 + Gain%).",
    marks: 1,
    tags: ["Arithmetic", "Profit & Loss", "Infosys"],
  ),
  const AptitudeQuestion(
    id: "apt_q_03",
    category: "Quantitative",
    topic: "Time & Work",
    difficulty: "medium",
    title: "Joint Work Fraction",
    content: "A can complete a piece of work in 12 days, and B can complete it in 15 days. If they work together for 3 days, what fraction of work is left?",
    options: ["9/20", "11/20", "7/20", "13/20"],
    correctAnswer: "11/20",
    explanation: "A's 1-day work = 1/12.\nB's 1-day work = 1/15.\nTogether 1-day work = 1/12 + 1/15 = 9/60 = 3/20.\nWork done in 3 days = 3 × (3/20) = 9/20.\nWork remaining = 1 - 9/20 = 11/20.",
    formulaTip: "If X does work in 'a' days, X's 1-day rate is 1/a. Remaining work = 1 - (Total done).",
    marks: 2,
    tags: ["Time & Work", "Accenture"],
  ),
  const AptitudeQuestion(
    id: "apt_q_04",
    category: "Quantitative",
    topic: "Percentages",
    difficulty: "medium",
    title: "Successive Percentage Changes",
    content: "The price of petrol increased by 25%. By what percentage must a car owner reduce consumption so that expenditure remains unchanged?",
    options: ["20%", "25%", "16.66%", "30%"],
    correctAnswer: "20%",
    explanation: "Let original price = 100, consumption = 100. Original Expenditure = 10,000.\nNew price = 125. To keep expenditure 10,000, new consumption = 10,000 / 125 = 80.\nReduction = 100 - 80 = 20%.",
    formulaTip: "Reduction % = [r / (100 + r)] × 100%, where r is the increase percentage.",
    marks: 1,
    tags: ["Percentages", "Cognizant"],
  ),
  const AptitudeQuestion(
    id: "apt_q_05",
    category: "Logical",
    topic: "Blood Relations",
    difficulty: "easy",
    title: "Pointing to a Photograph",
    content: "Pointing to a photograph, Rohit said, 'She is the daughter of my grandfather's only son.' How is Rohit related to the girl?",
    options: ["Father", "Uncle", "Brother", "Cousin"],
    correctAnswer: "Brother",
    explanation: "Grandfather's only son = Rohit's Father.\nThe daughter of Rohit's father = Rohit's sister.\nTherefore, Rohit is the brother of the girl in the photograph.",
    formulaTip: "Break down relationships step by step starting from the referenced person ('grandfather's only son').",
    marks: 1,
    tags: ["Logical Reasoning", "Family Tree"],
  ),
  const AptitudeQuestion(
    id: "apt_q_06",
    category: "Logical",
    topic: "Number Series",
    difficulty: "medium",
    title: "Next Term in Prime Difference Series",
    content: "Find the next number in the series: 3, 5, 9, 17, 33, ?",
    options: ["49", "65", "63", "67"],
    correctAnswer: "65",
    explanation: "Difference pattern:\n5 - 3 = 2 (2¹)\n9 - 5 = 4 (2²)\n17 - 9 = 8 (2³)\n33 - 17 = 16 (2⁴)\nNext difference = 32 (2⁵).\nNext term = 33 + 32 = 65.",
    formulaTip: "Look for powers of 2, squares, cubes, or alternating differences.",
    marks: 1,
    tags: ["Number Series", "Wipro"],
  ),
  const AptitudeQuestion(
    id: "apt_q_07",
    category: "Logical",
    topic: "Syllogisms",
    difficulty: "medium",
    title: "Categorical Deduction",
    content: "Statements:\n1. All cats are animals.\n2. Some animals are wild.\nConclusions:\nI. Some cats are wild.\nII. Some animals are cats.",
    options: ["Only I follows", "Only II follows", "Both I and II follow", "Neither follows"],
    correctAnswer: "Only II follows",
    explanation: "Since 'All cats are animals', the subset of cats is inside animals. Therefore, some animals must be cats (Conclusion II holds).\nWe cannot conclude that any cat is wild without a direct link between cats and wild animals (Conclusion I does not necessarily follow).",
    formulaTip: "Use Venn diagrams to test if a conclusion MUST follow in all scenarios.",
    marks: 2,
    tags: ["Syllogisms", "TCS NQT"],
  ),
  const AptitudeQuestion(
    id: "apt_q_08",
    category: "Verbal",
    topic: "Sentence Correction",
    difficulty: "easy",
    title: "Subject-Verb Agreement",
    content: "Select the grammatically correct sentence:",
    options: [
      "Neither the teacher nor the students was present in the auditorium.",
      "Neither the teacher nor the students were present in the auditorium.",
      "Neither the teacher or the students was present in the auditorium.",
      "Neither the teacher nor the students is present in the auditorium."
    ],
    correctAnswer: "Neither the teacher nor the students were present in the auditorium.",
    explanation: "When subjects are joined by 'neither... nor', the verb agrees with the closer subject. 'Students' is plural, so the plural verb 'were' is correct.",
    formulaTip: "Proximity Rule: With 'either...or' / 'neither...nor', verb matches the closest subject.",
    marks: 1,
    tags: ["Grammar", "Verbal"],
  ),
  const AptitudeQuestion(
    id: "apt_q_09",
    category: "Verbal",
    topic: "Synonyms & Antonyms",
    difficulty: "medium",
    title: "Antonym Identification",
    content: "Choose the word most nearly OPPOSITE in meaning to 'METICULOUS':",
    options: ["Painstaking", "Careless", "Thorough", "Precise"],
    correctAnswer: "Careless",
    explanation: "'Meticulous' means showing great attention to detail; very careful and precise. The opposite is 'Careless'.",
    formulaTip: "Eliminate synonyms first: Painstaking, Thorough, and Precise all mean meticulous.",
    marks: 1,
    tags: ["Vocabulary", "Accenture"],
  ),
  const AptitudeQuestion(
    id: "apt_q_10",
    category: "Data Interpretation",
    topic: "Pie Charts & Tables",
    difficulty: "hard",
    title: "Sector Angle Allocation",
    content: "In a company budget pie chart, 30% of funds are allocated to R&D, 25% to Marketing, 20% to Operations, and the rest to HR. What central angle represents the HR allocation?",
    options: ["72°", "90°", "80°", "108°"],
    correctAnswer: "90°",
    explanation: "Total percentage = 100%.\nHR percentage = 100% - (30 + 25 + 20)% = 25%.\nCentral angle = 25% of 360° = (25 / 100) × 360° = 90°.",
    formulaTip: "Central Angle = (Percentage / 100) × 360°.",
    marks: 2,
    tags: ["Data Interpretation", "Charts"],
  ),
];
