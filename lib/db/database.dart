import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:math';

class QuizDatabase {
  static final QuizDatabase instance = QuizDatabase._init();
  static Database? _database;

  QuizDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quiz.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        question TEXT NOT NULL,
        option1 TEXT NOT NULL,
        option2 TEXT NOT NULL,
        option3 TEXT NOT NULL,
        option4 TEXT NOT NULL,
        answer INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE leaderboard (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        score INTEGER NOT NULL,
        timestamp TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      );
    ''');

    // Automatically seed categories and questions after creating the database
    await _seedCategories(db);
    await _insertSampleQuestions(db);  // Insert sample questions
  }

  Future<void> _seedCategories(Database db) async {
    final existing = await db.query('categories');
    if (existing.isEmpty) {
      await db.insert('categories', {'name': 'Physics'});
      await db.insert('categories', {'name': 'Chemistry'});
      await db.insert('categories', {'name': 'Biology'});
      await db.insert('categories', {'name': 'Environmental Science'});
      await db.insert('categories', {'name': 'Earth Science'});
      await db.insert('categories', {'name': 'Math'});
      await db.insert('categories', {'name': 'Bangla'});
      await db.insert('categories', {'name': 'English'});
      await db.insert('categories', {'name': 'ICT'});
      await db.insert('categories', {'name': 'General Knowledge'});
      await db.insert('categories', {'name': 'Bangladesh History'});
      await db.insert('categories', {'name': 'World History'});
      await db.insert('categories', {'name': 'Sports'});
      await db.insert('categories', {'name': 'Physical Fitness and Exercises'});
      await db.insert('categories', {'name': 'Health and Nutrition'});
    }
  }

  // This method will handle inserting the sample questions with shuffled options
  Future<void> _insertSampleQuestions(Database db) async {
    final existing = await db.query('questions');

    if (existing.isEmpty) {
      // List of 50 physics questions
      final physics = [
        {'category_id': 1, 'question': 'What is the SI unit of force?', 'option1': 'Newton', 'option2': 'Pascal', 'option3': 'Joule', 'option4': 'Watt', 'answer': 1},
        {'category_id': 1, 'question': 'What is the formula for acceleration?', 'option1': 'a = (v - u) / t', 'option2': 'a = v * t', 'option3': 'a = v / t', 'option4': 'a = u / t', 'answer': 1},
        {'category_id': 1, 'question': 'What is the unit of work?', 'option1': 'Joule', 'option2': 'Newton', 'option3': 'Watt', 'option4': 'Pascal', 'answer': 1},
        {'category_id': 1, 'question': 'What is the speed of light in vacuum?', 'option1': '3.0 × 10^8 m/s', 'option2': '2.99 × 10^8 m/s', 'option3': '3.0 × 10^7 m/s', 'option4': '3.0 × 10^6 m/s', 'answer': 1},
        {'category_id': 1, 'question': 'What is the law of inertia?', 'option1': 'An object will stay at rest or in uniform motion unless acted upon by an external force', 'option2': 'For every action, there is an equal and opposite reaction', 'option3': 'Force equals mass times acceleration', 'option4': 'Energy cannot be created or destroyed', 'answer': 1},
        {'category_id': 1, 'question': 'What is the formula for kinetic energy?', 'option1': 'KE = 1/2 mv^2', 'option2': 'KE = mgh', 'option3': 'KE = mv', 'option4': 'KE = 1/2 m^2 v^2', 'answer': 1},
        {'category_id': 1, 'question': 'What is the SI unit of power?', 'option1': 'Watt', 'option2': 'Joule', 'option3': 'Newton', 'option4': 'Pascal', 'answer': 1},
        {'category_id': 1, 'question': 'What is the principle of conservation of energy?', 'option1': 'Energy cannot be created or destroyed, only transformed', 'option2': 'Energy is lost over time', 'option3': 'Energy is only created by the sun', 'option4': 'Energy is destroyed when heat is produced', 'answer': 1},
        {'category_id': 1, 'question': 'What is the value of gravitational acceleration on Earth?', 'option1': '9.8 m/s²', 'option2': '10 m/s²', 'option3': '8.9 m/s²', 'option4': '12 m/s²', 'answer': 1},
        {'category_id': 1, 'question': 'What is the force that pulls objects towards Earth?', 'option1': 'Gravity', 'option2': 'Magnetism', 'option3': 'Inertia', 'option4': 'Electromagnetism', 'answer': 1},
        {'category_id': 1, 'question': 'Who is known as the father of modern physics?', 'option1': 'Isaac Newton', 'option2': 'Albert Einstein', 'option3': 'Galileo Galilei', 'option4': 'Nikola Tesla', 'answer': 2},
        {'category_id': 1, 'question': 'What is the term for the rate of change of velocity?', 'option1': 'Acceleration', 'option2': 'Speed', 'option3': 'Force', 'option4': 'Momentum', 'answer': 1},
        {'category_id': 1, 'question': 'What is the law of conservation of momentum?', 'option1': 'Momentum is conserved in an isolated system', 'option2': 'Momentum increases in a closed system', 'option3': 'Momentum is always zero', 'option4': 'Momentum cannot be conserved', 'answer': 1},
        {'category_id': 1, 'question': 'Which particle is responsible for carrying a negative charge?', 'option1': 'Electron', 'option2': 'Proton', 'option3': 'Neutron', 'option4': 'Photon', 'answer': 1},
        {'category_id': 1, 'question': 'Which form of energy is stored in the bonds of atoms?', 'option1': 'Kinetic energy', 'option2': 'Thermal energy', 'option3': 'Chemical energy', 'option4': 'Potential energy', 'answer': 3},
        {'category_id': 1, 'question': 'What is the term for the bending of light as it passes from one medium to another?', 'option1': 'Reflection', 'option2': 'Refraction', 'option3': 'Diffraction', 'option4': 'Dispersion', 'answer': 2},
        {'category_id': 1, 'question': 'What is the SI unit of electric current?', 'option1': 'Volt', 'option2': 'Ohm', 'option3': 'Ampere', 'option4': 'Coulomb', 'answer': 3},
        {'category_id': 1, 'question': 'What is the energy possessed by an object due to its position?', 'option1': 'Kinetic energy', 'option2': 'Potential energy', 'option3': 'Thermal energy', 'option4': 'Chemical energy', 'answer': 2},
        {'category_id': 1, 'question': 'What is the principle of buoyancy?', 'option1': 'An object sinks if its density is greater than the fluid', 'option2': 'An object floats if its density is less than the fluid', 'option3': 'An object cannot float', 'option4': 'An object floats regardless of its density', 'answer': 2},
        {'category_id': 1, 'question': 'Which of the following is a non-contact force?', 'option1': 'Friction', 'option2': 'Tension', 'option3': 'Magnetic force', 'option4': 'Normal force', 'answer': 3},
        {'category_id': 1, 'question': 'What is the value of the universal gravitational constant?', 'option1': '6.67 × 10^-11 N·m²/kg²', 'option2': '9.8 N/kg', 'option3': '8.31 J/mol·K', 'option4': '1.23 × 10^8 N·m²/kg²', 'answer': 1},
        {'category_id': 1, 'question': 'What is the frequency of a wave?', 'option1': 'Number of waves passing a point per second', 'option2': 'Speed of the wave', 'option3': 'Amplitude of the wave', 'option4': 'Wavelength of the wave', 'answer': 1},
        {'category_id': 1, 'question': 'Which of the following best describes the relationship between force and mass?', 'option1': 'Force is directly proportional to mass', 'option2': 'Force is inversely proportional to mass', 'option3': 'Force and mass are unrelated', 'option4': 'Force is constant for all masses', 'answer': 1},
        {'category_id': 1, 'question': 'What is the term for the distance light travels in one year?', 'option1': 'Parsec', 'option2': 'Light year', 'option3': 'Astronomical unit', 'option4': 'Kilometer', 'answer': 2},
        {'category_id': 1, 'question': 'What is the law that describes the relationship between voltage, current, and resistance?', 'option1': 'Ohm’s Law', 'option2': 'Newton’s Law', 'option3': 'Faraday’s Law', 'option4': 'Coulomb’s Law', 'answer': 1},
        {'category_id': 1, 'question': 'Which type of wave requires a medium to travel?', 'option1': 'Electromagnetic waves', 'option2': 'Transverse waves', 'option3': 'Longitudinal waves', 'option4': 'Mechanical waves', 'answer': 4},
        {'category_id': 1, 'question': 'What is the SI unit of frequency?', 'option1': 'Hertz', 'option2': 'Joule', 'option3': 'Ampere', 'option4': 'Newton', 'answer': 1},
        {'category_id': 1, 'question': 'What is the speed of sound in air at 20°C?', 'option1': '343 m/s', 'option2': '300 m/s', 'option3': '500 m/s', 'option4': '400 m/s', 'answer': 1},
        {'category_id': 1, 'question': 'What is the main cause of tides on Earth?', 'option1': 'The gravitational pull of the moon', 'option2': 'The rotation of the Earth', 'option3': 'Earth’s distance from the sun', 'option4': 'Wind patterns', 'answer': 1},
        {'category_id': 1, 'question': 'What is the law of universal gravitation?', 'option1': 'Every particle in the universe attracts every other particle', 'option2': 'Gravity only works on large objects', 'option3': 'Gravity is inversely proportional to the square of distance', 'option4': 'Gravity only affects the Earth', 'answer': 1},
        {'category_id': 1, 'question': 'What type of energy is stored in a stretched spring?', 'option1': 'Elastic potential energy', 'option2': 'Kinetic energy', 'option3': 'Chemical energy', 'option4': 'Thermal energy', 'answer': 1},
        {'category_id': 1, 'question': 'What is the effect of a balanced force on an object?', 'option1': 'It causes the object to accelerate', 'option2': 'It causes the object to remain at rest or move with constant velocity', 'option3': 'It causes the object to stop moving', 'option4': 'It causes the object to explode', 'answer': 2},
        {'category_id': 1, 'question': 'What is the momentum of an object with a mass of 5 kg and a velocity of 10 m/s?', 'option1': '50 kg·m/s', 'option2': '10 kg·m/s', 'option3': '15 kg·m/s', 'option4': '5 kg·m/s', 'answer': 1},
        {'category_id': 1, 'question': 'What is the phenomenon where light bends around the edges of an object?', 'option1': 'Diffraction', 'option2': 'Refraction', 'option3': 'Reflection', 'option4': 'Dispersion', 'answer': 1},
        {'category_id': 1, 'question': 'Which of the following is an example of a scalar quantity?', 'option1': 'Speed', 'option2': 'Velocity', 'option3': 'Force', 'option4': 'Acceleration', 'answer': 1},
        {'category_id': 1, 'question': 'What is the force that resists the relative motion of two surfaces in contact?', 'option1': 'Friction', 'option2': 'Tension', 'option3': 'Gravity', 'option4': 'Elastic force', 'answer': 1},
        {'category_id': 1, 'question': 'What is the term for the measure of the disorder of a system?', 'option1': 'Entropy', 'option2': 'Energy', 'option3': 'Work', 'option4': 'Momentum', 'answer': 1},
        {'category_id': 1, 'question': 'What is the wavelength of visible light?', 'option1': '400 nm to 700 nm', 'option2': '100 nm to 300 nm', 'option3': '500 nm to 1000 nm', 'option4': '1 nm to 50 nm', 'answer': 1},
        {'category_id': 1, 'question': 'What is the effect of an unbalanced force on an object?', 'option1': 'It causes the object to accelerate', 'option2': 'It causes the object to stay at rest', 'option3': 'It causes the object to maintain constant velocity', 'option4': 'It has no effect', 'answer': 1},
      ];

      final chemistry = [
        {'category_id': 2, 'question': 'What is the chemical symbol for water?', 'option1': 'H2O', 'option2': 'O2', 'option3': 'CO2', 'option4': 'H2O2', 'answer': 1},
        {'category_id': 2, 'question': 'What is the chemical symbol for sodium?', 'option1': 'Na', 'option2': 'S', 'option3': 'Sn', 'option4': 'N', 'answer': 1},
        {'category_id': 2, 'question': 'What is the pH value of pure water?', 'option1': '7', 'option2': '6', 'option3': '8', 'option4': '9', 'answer': 1},
        {'category_id': 2, 'question': 'Which element is found in all organic compounds?', 'option1': 'Carbon', 'option2': 'Hydrogen', 'option3': 'Oxygen', 'option4': 'Nitrogen', 'answer': 1},
        {'category_id': 2, 'question': 'What is the chemical formula for table salt?', 'option1': 'NaCl', 'option2': 'KCl', 'option3': 'NaF', 'option4': 'MgCl2', 'answer': 1},
        {'category_id': 2, 'question': 'What is the main component of natural gas?', 'option1': 'Methane', 'option2': 'Ethane', 'option3': 'Propane', 'option4': 'Butane', 'answer': 1},
        {'category_id': 2, 'question': 'What is the process by which plants make glucose?', 'option1': 'Photosynthesis', 'option2': 'Respiration', 'option3': 'Transpiration', 'option4': 'Fermentation', 'answer': 1},
        {'category_id': 2, 'question': 'Which gas is most abundant in the Earth’s atmosphere?', 'option1': 'Nitrogen', 'option2': 'Oxygen', 'option3': 'Carbon Dioxide', 'option4': 'Argon', 'answer': 1},
        {'category_id': 2, 'question': 'What is the name of the chemical reaction between an acid and a base?', 'option1': 'Neutralization', 'option2': 'Oxidation', 'option3': 'Reduction', 'option4': 'Combustion', 'answer': 1},
        {'category_id': 2, 'question': 'What is the common name for acetic acid?', 'option1': 'Vinegar', 'option2': 'Baking soda', 'option3': 'Bleach', 'option4': 'Salt', 'answer': 1},
        {'category_id': 2, 'question': 'What is the chemical symbol for gold?', 'option1': 'Au', 'option2': 'Ag', 'option3': 'Gd', 'option4': 'Ga', 'answer': 1},
        {'category_id': 2, 'question': 'What type of bond involves the sharing of electron pairs between atoms?', 'option1': 'Covalent bond', 'option2': 'Ionic bond', 'option3': 'Hydrogen bond', 'option4': 'Metallic bond', 'answer': 1},
        {'category_id': 2, 'question': 'What is the molecular formula of glucose?', 'option1': 'C6H12O6', 'option2': 'C6H6', 'option3': 'C2H4O2', 'option4': 'C3H8O', 'answer': 1},
        {'category_id': 2, 'question': 'What is the chemical formula of ammonia?', 'option1': 'NH3', 'option2': 'CH4', 'option3': 'HCl', 'option4': 'H2S', 'answer': 1},
        {'category_id': 2, 'question': 'Which element is represented by the symbol "Fe"?', 'option1': 'Iron', 'option2': 'Fluorine', 'option3': 'Francium', 'option4': 'Ferrium', 'answer': 1},
        {'category_id': 2, 'question': 'Which substance is known as the universal solvent?', 'option1': 'Water', 'option2': 'Ethanol', 'option3': 'Acetone', 'option4': 'Methanol', 'answer': 1},
        {'category_id': 2, 'question': 'What is the charge of an electron?', 'option1': 'Negative', 'option2': 'Positive', 'option3': 'Neutral', 'option4': 'Variable', 'answer': 1},
        {'category_id': 2, 'question': 'What is the name of the process in which a liquid changes to a gas?', 'option1': 'Evaporation', 'option2': 'Condensation', 'option3': 'Freezing', 'option4': 'Sublimation', 'answer': 1},
        {'category_id': 2, 'question': 'What is the process of solid turning directly into a gas?', 'option1': 'Sublimation', 'option2': 'Evaporation', 'option3': 'Condensation', 'option4': 'Melting', 'answer': 1},
        {'category_id': 2, 'question': 'Which acid is commonly found in car batteries?', 'option1': 'Sulfuric acid', 'option2': 'Hydrochloric acid', 'option3': 'Nitric acid', 'option4': 'Acetic acid', 'answer': 1},
        {'category_id': 2, 'question': 'What is the name for a substance that speeds up a chemical reaction without being consumed?', 'option1': 'Catalyst', 'option2': 'Reactant', 'option3': 'Product', 'option4': 'Enzyme', 'answer': 1},
        {'category_id': 2, 'question': 'What is the main chemical component of limestone?', 'option1': 'Calcium carbonate', 'option2': 'Calcium oxide', 'option3': 'Calcium sulfate', 'option4': 'Calcium chloride', 'answer': 1},
        {'category_id': 2, 'question': 'Which gas is produced when an acid reacts with a metal?', 'option1': 'Hydrogen', 'option2': 'Oxygen', 'option3': 'Carbon dioxide', 'option4': 'Nitrogen', 'answer': 1},
        {'category_id': 2, 'question': 'Which gas is produced when baking soda reacts with vinegar?', 'option1': 'Carbon dioxide', 'option2': 'Oxygen', 'option3': 'Hydrogen', 'option4': 'Nitrogen', 'answer': 1},
        {'category_id': 2, 'question': 'What is the primary component of rust?', 'option1': 'Iron oxide', 'option2': 'Iron sulfate', 'option3': 'Iron chloride', 'option4': 'Iron hydroxide', 'answer': 1},
        {'category_id': 2, 'question': 'What is the name of the simplest hydrocarbon?', 'option1': 'Methane', 'option2': 'Ethane', 'option3': 'Propane', 'option4': 'Butane', 'answer': 1},
        {'category_id': 2, 'question': 'Which type of chemical bond forms between metals and nonmetals?', 'option1': 'Ionic bond', 'option2': 'Covalent bond', 'option3': 'Hydrogen bond', 'option4': 'Metallic bond', 'answer': 1},
        {'category_id': 2, 'question': 'What is the chemical formula for sulfuric acid?', 'option1': 'H2SO4', 'option2': 'HNO3', 'option3': 'HCl', 'option4': 'H3PO4', 'answer': 1},
        {'category_id': 2, 'question': 'Which polymer is commonly used to make plastic bags?', 'option1': 'Polyethylene', 'option2': 'Polystyrene', 'option3': 'Polyvinyl chloride', 'option4': 'Polypropylene', 'answer': 1},
        {'category_id': 2, 'question': 'What is the pH range of acids?', 'option1': '0-6.9', 'option2': '7-14', 'option3': '0-14', 'option4': '7 only', 'answer': 1},
        {'category_id': 2, 'question': 'What type of reaction releases heat to the surroundings?', 'option1': 'Exothermic', 'option2': 'Endothermic', 'option3': 'Neutralization', 'option4': 'Redox', 'answer': 1},
        {'category_id': 2, 'question': 'Which process is used to separate crude oil into its components?', 'option1': 'Fractional distillation', 'option2': 'Filtration', 'option3': 'Crystallization', 'option4': 'Decantation', 'answer': 1},
        {'category_id': 2, 'question': 'What is the chemical formula for baking soda?', 'option1': 'NaHCO3', 'option2': 'NaCl', 'option3': 'Na2CO3', 'option4': 'NH4HCO3', 'answer': 1},
        {'category_id': 2, 'question': 'Which acid is present in lemons?', 'option1': 'Citric acid', 'option2': 'Lactic acid', 'option3': 'Acetic acid', 'option4': 'Formic acid', 'answer': 1},
        {'category_id': 2, 'question': 'What is the chemical name of chalk?', 'option1': 'Calcium carbonate', 'option2': 'Calcium sulfate', 'option3': 'Calcium oxide', 'option4': 'Calcium chloride', 'answer': 1},
        {'category_id': 2, 'question': 'What is the atomic number of hydrogen?', 'option1': '1', 'option2': '2', 'option3': '3', 'option4': '4', 'answer': 1},
        {'category_id': 2, 'question': 'What is the chemical formula for ethanol?', 'option1': 'C2H5OH', 'option2': 'CH3OH', 'option3': 'C3H7OH', 'option4': 'C4H9OH', 'answer': 1},
        {'category_id': 2, 'question': 'Which type of reaction involves the exchange of ions between two compounds?', 'option1': 'Double displacement', 'option2': 'Single displacement', 'option3': 'Synthesis', 'option4': 'Decomposition', 'answer': 1},
        {'category_id': 2, 'question': 'Which gas is used in fire extinguishers?', 'option1': 'Carbon dioxide', 'option2': 'Oxygen', 'option3': 'Nitrogen', 'option4': 'Methane', 'answer': 1},
        {'category_id': 2, 'question': 'What is the atomic number of carbon?', 'option1': '6', 'option2': '12', 'option3': '4', 'option4': '14', 'answer': 1},
        {'category_id': 2, 'question': 'Which element is used in thermometers?', 'option1': 'Mercury', 'option2': 'Silver', 'option3': 'Gold', 'option4': 'Platinum', 'answer': 1},
        {'category_id': 2, 'question': 'What is the chemical formula for hydrochloric acid?', 'option1': 'HCl', 'option2': 'H2SO4', 'option3': 'HNO3', 'option4': 'CH3COOH', 'answer': 1},
        {'category_id': 2, 'question': 'What is the common name for sodium hydroxide?', 'option1': 'Caustic soda', 'option2': 'Washing soda', 'option3': 'Baking soda', 'option4': 'Bleach', 'answer': 1},
        {'category_id': 2, 'question': 'Which type of reaction combines two or more substances to form one compound?', 'option1': 'Synthesis reaction', 'option2': 'Decomposition reaction', 'option3': 'Combustion reaction', 'option4': 'Double displacement reaction', 'answer': 1},
        {'category_id': 2, 'question': 'What is the main component of gunpowder?', 'option1': 'Potassium nitrate', 'option2': 'Sulfur', 'option3': 'Carbon', 'option4': 'Magnesium', 'answer': 1},
        {'category_id': 2, 'question': 'Which compound is commonly used to make soap?', 'option1': 'Sodium hydroxide', 'option2': 'Calcium hydroxide', 'option3': 'Potassium chloride', 'option4': 'Magnesium sulfate', 'answer': 1},
        {'category_id': 2, 'question': 'What is the process of heating an ore to remove impurities?', 'option1': 'Roasting', 'option2': 'Smelting', 'option3': 'Leaching', 'option4': 'Distillation', 'answer': 1},
        {'category_id': 2, 'question': 'Which element is most abundant in the Earth’s crust?', 'option1': 'Oxygen', 'option2': 'Silicon', 'option3': 'Aluminum', 'option4': 'Iron', 'answer': 1},
      ];

      final biology = [
        {'category_id': 3, 'question': 'What is the basic unit of life?', 'option1': 'Cell', 'option2': 'Tissue', 'option3': 'Organ', 'option4': 'Organism', 'answer': 1},
        {'category_id': 3, 'question': 'What is the powerhouse of the cell?', 'option1': 'Mitochondria', 'option2': 'Nucleus', 'option3': 'Ribosome', 'option4': 'Golgi apparatus', 'answer': 1},
        {'category_id': 3, 'question': 'What is the process by which plants make their food?', 'option1': 'Photosynthesis', 'option2': 'Respiration', 'option3': 'Fermentation', 'option4': 'Transpiration', 'answer': 1},
        {'category_id': 3, 'question': 'What is the molecule that carries genetic information?', 'option1': 'DNA', 'option2': 'RNA', 'option3': 'Protein', 'option4': 'Carbohydrate', 'answer': 1},
        {'category_id': 3, 'question': 'What is the primary function of red blood cells?', 'option1': 'Transport oxygen', 'option2': 'Fight infection', 'option3': 'Produce hormones', 'option4': 'Store energy', 'answer': 1},
        {'category_id': 3, 'question': 'What is the largest organ in the human body?', 'option1': 'Skin', 'option2': 'Liver', 'option3': 'Heart', 'option4': 'Lungs', 'answer': 1},
        {'category_id': 3, 'question': 'What is the name of the process by which cells divide?', 'option1': 'Mitosis', 'option2': 'Meiosis', 'option3': 'Binary fission', 'option4': 'Budding', 'answer': 1},
        {'category_id': 3, 'question': 'Which organ is responsible for filtering blood in the human body?', 'option1': 'Kidney', 'option2': 'Liver', 'option3': 'Heart', 'option4': 'Lungs', 'answer': 1},
        {'category_id': 3, 'question': 'What is the chemical compound that gives plants their green color?', 'option1': 'Chlorophyll', 'option2': 'Carotene', 'option3': 'Xanthophyll', 'option4': 'Anthocyanin', 'answer': 1},
        {'category_id': 3, 'question': 'Which part of the plant is responsible for photosynthesis?', 'option1': 'Leaf', 'option2': 'Root', 'option3': 'Stem', 'option4': 'Flower', 'answer': 1},
        {'category_id': 3, 'question': 'What type of biomolecule are enzymes?', 'option1': 'Proteins', 'option2': 'Carbohydrates', 'option3': 'Lipids', 'option4': 'Nucleic acids', 'answer': 1},
        {'category_id': 3, 'question': 'What is the main function of white blood cells?', 'option1': 'Fight infections', 'option2': 'Transport oxygen', 'option3': 'Store nutrients', 'option4': 'Regulate temperature', 'answer': 1},
        {'category_id': 3, 'question': 'Which part of the brain controls balance and coordination?', 'option1': 'Cerebellum', 'option2': 'Cerebrum', 'option3': 'Brainstem', 'option4': 'Hypothalamus', 'answer': 1},
        {'category_id': 3, 'question': 'What is the basic structural and functional unit of the nervous system?', 'option1': 'Neuron', 'option2': 'Axon', 'option3': 'Dendrite', 'option4': 'Synapse', 'answer': 1},
        {'category_id': 3, 'question': 'What is the main site of protein synthesis in a cell?', 'option1': 'Ribosome', 'option2': 'Nucleus', 'option3': 'Mitochondria', 'option4': 'Golgi apparatus', 'answer': 1},
        {'category_id': 3, 'question': 'What is the process by which organisms maintain a stable internal environment?', 'option1': 'Homeostasis', 'option2': 'Adaptation', 'option3': 'Evolution', 'option4': 'Symbiosis', 'answer': 1},
        {'category_id': 3, 'question': 'What is the organelle responsible for packaging and transporting materials in a cell?', 'option1': 'Golgi apparatus', 'option2': 'Endoplasmic reticulum', 'option3': 'Lysosome', 'option4': 'Mitochondria', 'answer': 1},
        {'category_id': 3, 'question': 'Which macronutrient is the primary source of energy for the human body?', 'option1': 'Carbohydrates', 'option2': 'Proteins', 'option3': 'Lipids', 'option4': 'Vitamins', 'answer': 1},
        {'category_id': 3, 'question': 'What is the process by which organisms produce offspring?', 'option1': 'Reproduction', 'option2': 'Evolution', 'option3': 'Growth', 'option4': 'Metabolism', 'answer': 1},
        {'category_id': 3, 'question': 'What is the main function of chloroplasts?', 'option1': 'Photosynthesis', 'option2': 'Protein synthesis', 'option3': 'Cell division', 'option4': 'Energy storage', 'answer': 1},
        {'category_id': 3, 'question': 'Which organ in the human body is responsible for producing insulin?', 'option1': 'Pancreas', 'option2': 'Liver', 'option3': 'Kidney', 'option4': 'Stomach', 'answer': 1},
        {'category_id': 3, 'question': 'What is the name of the pigment that absorbs light for photosynthesis?', 'option1': 'Chlorophyll', 'option2': 'Carotene', 'option3': 'Xanthophyll', 'option4': 'Anthocyanin', 'answer': 1},
        {'category_id': 3, 'question': 'What is the outermost layer of a plant cell?', 'option1': 'Cell wall', 'option2': 'Cell membrane', 'option3': 'Chloroplast', 'option4': 'Cytoplasm', 'answer': 1},
        {'category_id': 3, 'question': 'What is the process by which water moves through a semi-permeable membrane?', 'option1': 'Osmosis', 'option2': 'Diffusion', 'option3': 'Active transport', 'option4': 'Facilitated diffusion', 'answer': 1},
        {'category_id': 3, 'question': 'Which blood vessel carries oxygenated blood away from the heart?', 'option1': 'Artery', 'option2': 'Vein', 'option3': 'Capillary', 'option4': 'Aorta', 'answer': 1},
        {'category_id': 3, 'question': 'What is the largest bone in the human body?', 'option1': 'Femur', 'option2': 'Humerus', 'option3': 'Tibia', 'option4': 'Fibula', 'answer': 1},
        {'category_id': 3, 'question': 'What is the function of stomata in plants?', 'option1': 'Gas exchange', 'option2': 'Water absorption', 'option3': 'Nutrient transport', 'option4': 'Structural support', 'answer': 1},
        {'category_id': 3, 'question': 'What is the scientific name for the study of fungi?', 'option1': 'Mycology', 'option2': 'Botany', 'option3': 'Zoology', 'option4': 'Microbiology', 'answer': 1},
        {'category_id': 3, 'question': 'What is the primary function of the small intestine?', 'option1': 'Nutrient absorption', 'option2': 'Water absorption', 'option3': 'Digestion of food', 'option4': 'Excretion of waste', 'answer': 1},
        {'category_id': 3, 'question': 'What is the structural framework of a plant cell?', 'option1': 'Cellulose', 'option2': 'Chitin', 'option3': 'Collagen', 'option4': 'Keratin', 'answer': 1},
        {'category_id': 3, 'question': 'What is the genetic material in viruses?', 'option1': 'DNA or RNA', 'option2': 'Proteins', 'option3': 'Lipids', 'option4': 'Carbohydrates', 'answer': 1},
        {'category_id': 3, 'question': 'What is the name of the tube that connects the mouth to the stomach?', 'option1': 'Esophagus', 'option2': 'Trachea', 'option3': 'Pharynx', 'option4': 'Larynx', 'answer': 1},
        {'category_id': 3, 'question': 'Which part of the human body produces bile?', 'option1': 'Liver', 'option2': 'Gallbladder', 'option3': 'Pancreas', 'option4': 'Stomach', 'answer': 1},
        {'category_id': 3, 'question': 'What is the term for the process by which plants lose water through leaves?', 'option1': 'Transpiration', 'option2': 'Photosynthesis', 'option3': 'Respiration', 'option4': 'Osmosis', 'answer': 1},
        {'category_id': 3, 'question': 'Which type of blood cell is responsible for clotting?', 'option1': 'Platelets', 'option2': 'Red blood cells', 'option3': 'White blood cells', 'option4': 'Plasma', 'answer': 1},
        {'category_id': 3, 'question': 'What is the primary function of the large intestine?', 'option1': 'Water absorption', 'option2': 'Protein digestion', 'option3': 'Fat absorption', 'option4': 'Enzyme production', 'answer': 1},
        {'category_id': 3, 'question': 'What is the term for organisms that make their own food?', 'option1': 'Autotrophs', 'option2': 'Heterotrophs', 'option3': 'Parasites', 'option4': 'Decomposers', 'answer': 1},
        {'category_id': 3, 'question': 'What is the main excretory organ in humans?', 'option1': 'Kidneys', 'option2': 'Liver', 'option3': 'Skin', 'option4': 'Lungs', 'answer': 1},
        {'category_id': 3, 'question': 'Which type of muscle is found in the walls of internal organs?', 'option1': 'Smooth muscle', 'option2': 'Skeletal muscle', 'option3': 'Cardiac muscle', 'option4': 'Voluntary muscle', 'answer': 1},
        {'category_id': 3, 'question': 'Which biomolecule stores genetic information?', 'option1': 'DNA', 'option2': 'Protein', 'option3': 'Carbohydrate', 'option4': 'Lipid', 'answer': 1},
        {'category_id': 3, 'question': 'What is the main purpose of villi in the small intestine?', 'option1': 'Increase surface area for absorption', 'option2': 'Produce digestive enzymes', 'option3': 'Transport nutrients', 'option4': 'Neutralize stomach acid', 'answer': 1},
        {'category_id': 3, 'question': 'Which blood component carries oxygen to cells?', 'option1': 'Hemoglobin', 'option2': 'Plasma', 'option3': 'White blood cells', 'option4': 'Platelets', 'answer': 1},
        {'category_id': 3, 'question': 'What is the term for a permanent change in DNA?', 'option1': 'Mutation', 'option2': 'Adaptation', 'option3': 'Selection', 'option4': 'Evolution', 'answer': 1},
        {'category_id': 3, 'question': 'What is the role of the xylem in plants?', 'option1': 'Transport water', 'option2': 'Transport food', 'option3': 'Store nutrients', 'option4': 'Perform photosynthesis', 'answer': 1},
        {'category_id': 3, 'question': 'Which organ controls blood sugar levels?', 'option1': 'Pancreas', 'option2': 'Liver', 'option3': 'Kidney', 'option4': 'Stomach', 'answer': 1},
        {'category_id': 3, 'question': 'What is the process of breaking down glucose to release energy?', 'option1': 'Cellular respiration', 'option2': 'Photosynthesis', 'option3': 'Fermentation', 'option4': 'Osmosis', 'answer': 1},
        {'category_id': 3, 'question': 'What are the building blocks of proteins?', 'option1': 'Amino acids', 'option2': 'Nucleotides', 'option3': 'Monosaccharides', 'option4': 'Fatty acids', 'answer': 1},
        {'category_id': 3, 'question': 'Which part of the human body regulates temperature?', 'option1': 'Hypothalamus', 'option2': 'Liver', 'option3': 'Skin', 'option4': 'Kidneys', 'answer': 1},
        {'category_id': 3, 'question': 'Which group of organisms includes molds, yeasts, and mushrooms?', 'option1': 'Fungi', 'option2': 'Bacteria', 'option3': 'Protozoa', 'option4': 'Algae', 'answer': 1},
        {'category_id': 3, 'question': 'What is the function of the lymphatic system?', 'option1': 'Defend against infection', 'option2': 'Transport oxygen', 'option3': 'Regulate hormones', 'option4': 'Produce energy', 'answer': 1},
        {'category_id': 3, 'question': 'What is the term for animals that feed exclusively on plants?', 'option1': 'Herbivores', 'option2': 'Carnivores', 'option3': 'Omnivores', 'option4': 'Decomposers', 'answer': 1},
      ];


      final env_science = [
        {'category_id': 4, 'question': 'What is the primary cause of global warming?', 'option1': 'Greenhouse gases', 'option2': 'Deforestation', 'option3': 'Volcanic activity', 'option4': 'Solar flares', 'answer': 1},
        {'category_id': 4, 'question': 'What does the term "biodiversity" refer to?', 'option1': 'Variety of life forms', 'option2': 'Ecosystem stability', 'option3': 'Climate variations', 'option4': 'Forest density', 'answer': 1},
        {'category_id': 4, 'question': 'Which layer of the atmosphere contains the ozone layer?', 'option1': 'Stratosphere', 'option2': 'Troposphere', 'option3': 'Mesosphere', 'option4': 'Exosphere', 'answer': 1},
        {'category_id': 4, 'question': 'What is the main cause of acid rain?', 'option1': 'Sulfur dioxide and nitrogen oxides', 'option2': 'Carbon monoxide', 'option3': 'Methane emissions', 'option4': 'Water vapor', 'answer': 1},
        {'category_id': 4, 'question': 'Which of these is a renewable resource?', 'option1': 'Solar energy', 'option2': 'Coal', 'option3': 'Natural gas', 'option4': 'Uranium', 'answer': 1},
        {'category_id': 4, 'question': 'What is the term for the variety of ecosystems on Earth?', 'option1': 'Ecosystem diversity', 'option2': 'Population ecology', 'option3': 'Biomass', 'option4': 'Community dynamics', 'answer': 1},
        {'category_id': 4, 'question': 'What percentage of the Earth’s water is freshwater?', 'option1': '3%', 'option2': '10%', 'option3': '25%', 'option4': '50%', 'answer': 1},
        {'category_id': 4, 'question': 'Which process releases oxygen into the atmosphere?', 'option1': 'Photosynthesis', 'option2': 'Respiration', 'option3': 'Combustion', 'option4': 'Decomposition', 'answer': 1},
        {'category_id': 4, 'question': 'What is a major effect of deforestation?', 'option1': 'Loss of habitat', 'option2': 'Increased oxygen levels', 'option3': 'Decrease in soil fertility', 'option4': 'Increase in biodiversity', 'answer': 1},
        {'category_id': 4, 'question': 'What is the primary source of energy for Earth’s climate system?', 'option1': 'The Sun', 'option2': 'Volcanoes', 'option3': 'Geothermal heat', 'option4': 'Ocean currents', 'answer': 1},
        {'category_id': 4, 'question': 'Which gas is the most abundant greenhouse gas in the atmosphere?', 'option1': 'Carbon dioxide', 'option2': 'Methane', 'option3': 'Water vapor', 'option4': 'Nitrous oxide', 'answer': 3},
        {'category_id': 4, 'question': 'What is the largest contributor to ocean pollution?', 'option1': 'Plastic waste', 'option2': 'Oil spills', 'option3': 'Chemical runoff', 'option4': 'Fishing nets', 'answer': 1},
        {'category_id': 4, 'question': 'Which of these is a non-renewable resource?', 'option1': 'Coal', 'option2': 'Wind energy', 'option3': 'Geothermal energy', 'option4': 'Tidal energy', 'answer': 1},
        {'category_id': 4, 'question': 'What is the term for the increase in Earth’s average surface temperature?', 'option1': 'Global warming', 'option2': 'El Niño', 'option3': 'Acidification', 'option4': 'Climate stability', 'answer': 1},
        {'category_id': 4, 'question': 'Which practice can help conserve water?', 'option1': 'Drip irrigation', 'option2': 'Flood irrigation', 'option3': 'Industrial discharge', 'option4': 'Paving landscapes', 'answer': 1},
        {'category_id': 4, 'question': 'Which gas is essential for plant photosynthesis?', 'option1': 'Carbon dioxide', 'option2': 'Oxygen', 'option3': 'Nitrogen', 'option4': 'Hydrogen', 'answer': 1},
        {'category_id': 4, 'question': 'What is the primary benefit of afforestation?', 'option1': 'Increased carbon sequestration', 'option2': 'Improved urban development', 'option3': 'Higher energy consumption', 'option4': 'Increased industrial output', 'answer': 1},
        {'category_id': 4, 'question': 'Which human activity is the largest source of carbon dioxide emissions?', 'option1': 'Burning fossil fuels', 'option2': 'Deforestation', 'option3': 'Agriculture', 'option4': 'Construction', 'answer': 1},
        {'category_id': 4, 'question': 'What is an ecological footprint?', 'option1': 'Measure of human impact on the environment', 'option2': 'Size of a forest reserve', 'option3': 'Population density of a region', 'option4': 'Distance between ecosystems', 'answer': 1},
        {'category_id': 4, 'question': 'What is the main purpose of the Kyoto Protocol?', 'option1': 'Reduce greenhouse gas emissions', 'option2': 'Protect endangered species', 'option3': 'Combat deforestation', 'option4': 'Promote renewable energy', 'answer': 1},
        {'category_id': 4, 'question': 'Which process purifies water naturally in the water cycle?', 'option1': 'Evaporation', 'option2': 'Precipitation', 'option3': 'Condensation', 'option4': 'Runoff', 'answer': 1},
        {'category_id': 4, 'question': 'What is a significant impact of melting glaciers?', 'option1': 'Rising sea levels', 'option2': 'Increased volcanic activity', 'option3': 'Reduced desertification', 'option4': 'Decreased ocean salinity', 'answer': 1},
        {'category_id': 4, 'question': 'What is the term for the destruction of coral reefs due to temperature rise?', 'option1': 'Coral bleaching', 'option2': 'Oceanic erosion', 'option3': 'Reef degradation', 'option4': 'Aquatic desertification', 'answer': 1},
        {'category_id': 4, 'question': 'What is eutrophication?', 'option1': 'Excessive nutrient buildup in water bodies', 'option2': 'Soil erosion due to water flow', 'option3': 'Deforestation near water sources', 'option4': 'Rapid urbanization', 'answer': 1},
        {'category_id': 4, 'question': 'Which of these contributes to air pollution?', 'option1': 'Industrial emissions', 'option2': 'Plant growth', 'option3': 'Rainfall', 'option4': 'Soil conservation', 'answer': 1},
        {'category_id': 4, 'question': 'What is the main function of wetlands?', 'option1': 'Filter pollutants', 'option2': 'Increase salinity', 'option3': 'Promote urbanization', 'option4': 'Control volcanic activity', 'answer': 1},
        {'category_id': 4, 'question': 'Which type of energy is generated by moving water?', 'option1': 'Hydropower', 'option2': 'Solar power', 'option3': 'Geothermal energy', 'option4': 'Wind energy', 'answer': 1},
        {'category_id': 4, 'question': 'Which of these gases depletes the ozone layer?', 'option1': 'CFCs', 'option2': 'Oxygen', 'option3': 'Argon', 'option4': 'Helium', 'answer': 1},
        {'category_id': 4, 'question': 'What is composting?', 'option1': 'Decomposing organic waste', 'option2': 'Incinerating plastic waste', 'option3': 'Recycling metals', 'option4': 'Generating fossil fuels', 'answer': 1},
        {'category_id': 4, 'question': 'Which renewable energy source is derived from Earth’s heat?', 'option1': 'Geothermal energy', 'option2': 'Hydropower', 'option3': 'Solar power', 'option4': 'Wind power', 'answer': 1},
        {'category_id': 4, 'question': 'Which environmental law aims to regulate water pollution?', 'option1': 'Clean Water Act', 'option2': 'Endangered Species Act', 'option3': 'Resource Conservation Act', 'option4': 'Kyoto Protocol', 'answer': 1},
        {'category_id': 4, 'question': 'Which natural phenomenon is intensified by deforestation?', 'option1': 'Soil erosion', 'option2': 'Glacier formation', 'option3': 'Urban flooding', 'option4': 'Earthquake activity', 'answer': 1},
        {'category_id': 4, 'question': 'What is a consequence of overfishing?', 'option1': 'Marine ecosystem imbalance', 'option2': 'Increased fish population', 'option3': 'Decreased coral reef bleaching', 'option4': 'Stable biodiversity', 'answer': 1},
        {'category_id': 4, 'question': 'What is the term for energy from the Sun?', 'option1': 'Solar energy', 'option2': 'Thermal energy', 'option3': 'Geothermal energy', 'option4': 'Hydropower', 'answer': 1},
        {'category_id': 4, 'question': 'Which of these best describes the term “carbon footprint”?', 'option1': 'Total greenhouse gas emissions by an individual or activity', 'option2': 'Amount of carbon in a forest', 'option3': 'Rate of carbon absorption by oceans', 'option4': 'Volume of carbon stored in the soil', 'answer': 1},
        {'category_id': 4, 'question': 'Which practice can reduce deforestation?', 'option1': 'Agroforestry', 'option2': 'Monoculture farming', 'option3': 'Urbanization', 'option4': 'Open-pit mining', 'answer': 1},
        {'category_id': 4, 'question': 'What is the primary benefit of recycling?', 'option1': 'Reduces waste in landfills', 'option2': 'Increases resource extraction', 'option3': 'Accelerates industrial processes', 'option4': 'Promotes deforestation', 'answer': 1},
        {'category_id': 4, 'question': 'What is the primary cause of global warming?', 'option1': 'Greenhouse gases', 'option2': 'Deforestation', 'option3': 'Volcanic activity', 'option4': 'Solar flares', 'answer': 1},
        {'category_id': 4, 'question': 'What does the term "biodiversity" refer to?', 'option1': 'Variety of life forms', 'option2': 'Ecosystem stability', 'option3': 'Climate variations', 'option4': 'Forest density', 'answer': 1},
        {'category_id': 4, 'question': 'Which layer of the atmosphere contains the ozone layer?', 'option1': 'Stratosphere', 'option2': 'Troposphere', 'option3': 'Mesosphere', 'option4': 'Exosphere', 'answer': 1},
        {'category_id': 4, 'question': 'What is the main cause of acid rain?', 'option1': 'Sulfur dioxide and nitrogen oxides', 'option2': 'Carbon monoxide', 'option3': 'Methane emissions', 'option4': 'Water vapor', 'answer': 1},
        {'category_id': 4, 'question': 'Which of these is a renewable resource?', 'option1': 'Solar energy', 'option2': 'Coal', 'option3': 'Natural gas', 'option4': 'Uranium', 'answer': 1},
        {'category_id': 4, 'question': 'What percentage of the Earth’s water is freshwater?', 'option1': '3%', 'option2': '10%', 'option3': '25%', 'option4': '50%', 'answer': 1},
        {'category_id': 4, 'question': 'Which process releases oxygen into the atmosphere?', 'option1': 'Photosynthesis', 'option2': 'Respiration', 'option3': 'Combustion', 'option4': 'Decomposition', 'answer': 1},
        {'category_id': 4, 'question': 'What is the term for the variety of ecosystems on Earth?', 'option1': 'Ecosystem diversity', 'option2': 'Population ecology', 'option3': 'Biomass', 'option4': 'Community dynamics', 'answer': 1},
        {'category_id': 4, 'question': 'What is eutrophication?', 'option1': 'Excessive nutrient buildup in water bodies', 'option2': 'Soil erosion due to water flow', 'option3': 'Deforestation near water sources', 'option4': 'Rapid urbanization', 'answer': 1},
        {'category_id': 4, 'question': 'What is the term for the increase in Earth’s average surface temperature?', 'option1': 'Global warming', 'option2': 'El Niño', 'option3': 'Acidification', 'option4': 'Climate stability', 'answer': 1},
        {'category_id': 4, 'question': 'Which of these contributes to air pollution?', 'option1': 'Industrial emissions', 'option2': 'Plant growth', 'option3': 'Rainfall', 'option4': 'Soil conservation', 'answer': 1},
        {'category_id': 4, 'question': 'Which natural phenomenon is intensified by deforestation?', 'option1': 'Soil erosion', 'option2': 'Glacier formation', 'option3': 'Urban flooding', 'option4': 'Earthquake activity', 'answer': 1},
        {'category_id': 4, 'question': 'Which human activity is the largest source of carbon dioxide emissions?', 'option1': 'Burning fossil fuels', 'option2': 'Deforestation', 'option3': 'Agriculture', 'option4': 'Construction', 'answer': 1},
        {'category_id': 4, 'question': 'What is an ecological footprint?', 'option1': 'Measure of human impact on the environment', 'option2': 'Size of a forest reserve', 'option3': 'Population density of a region', 'option4': 'Distance between ecosystems', 'answer': 1},
        {'category_id': 4, 'question': 'Which renewable energy source is derived from Earth’s heat?', 'option1': 'Geothermal energy', 'option2': 'Hydropower', 'option3': 'Solar power', 'option4': 'Wind power', 'answer': 1},
        {'category_id': 4, 'question': 'What is the largest contributor to ocean pollution?', 'option1': 'Plastic waste', 'option2': 'Oil spills', 'option3': 'Chemical runoff', 'option4': 'Fishing nets', 'answer': 1},
        {'category_id': 4, 'question': 'Which practice can reduce deforestation?', 'option1': 'Agroforestry', 'option2': 'Monoculture farming', 'option3': 'Urbanization', 'option4': 'Open-pit mining', 'answer': 1},
        {'category_id': 4, 'question': 'What is the main purpose of the Kyoto Protocol?', 'option1': 'Reduce greenhouse gas emissions', 'option2': 'Protect endangered species', 'option3': 'Combat deforestation', 'option4': 'Promote renewable energy', 'answer': 1},
        {'category_id': 4, 'question': 'What is the term for energy from the Sun?', 'option1': 'Solar energy', 'option2': 'Thermal energy', 'option3': 'Geothermal energy', 'option4': 'Hydropower', 'answer': 1},
        {'category_id': 4, 'question': 'What is composting?', 'option1': 'Decomposing organic waste', 'option2': 'Incinerating plastic waste', 'option3': 'Recycling metals', 'option4': 'Generating fossil fuels', 'answer': 1},
        {'category_id': 4, 'question': 'Which gas is essential for plant photosynthesis?', 'option1': 'Carbon dioxide', 'option2': 'Oxygen', 'option3': 'Nitrogen', 'option4': 'Hydrogen', 'answer': 1},
        {'category_id': 4, 'question': 'Which gas is the most abundant greenhouse gas in the atmosphere?', 'option1': 'Water vapor', 'option2': 'Carbon dioxide', 'option3': 'Methane', 'option4': 'Nitrous oxide', 'answer': 1},
        {'category_id': 4, 'question': 'What is the primary source of energy for Earth’s climate system?', 'option1': 'The Sun', 'option2': 'Volcanoes', 'option3': 'Geothermal heat', 'option4': 'Ocean currents', 'answer': 1},
        {'category_id': 4, 'question': 'Which type of energy is generated by moving water?', 'option1': 'Hydropower', 'option2': 'Solar power', 'option3': 'Geothermal energy', 'option4': 'Wind energy', 'answer': 1},
        {'category_id': 4, 'question': 'Which environmental law aims to regulate water pollution?', 'option1': 'Clean Water Act', 'option2': 'Endangered Species Act', 'option3': 'Resource Conservation Act', 'option4': 'Kyoto Protocol', 'answer': 1},
        {'category_id': 4, 'question': 'What is the main function of wetlands?', 'option1': 'Filter pollutants', 'option2': 'Increase salinity', 'option3': 'Promote urbanization', 'option4': 'Control volcanic activity', 'answer': 1},
        {'category_id': 4, 'question': 'What is the primary benefit of afforestation?', 'option1': 'Increased carbon sequestration', 'option2': 'Improved urban development', 'option3': 'Higher energy consumption', 'option4': 'Increased industrial output', 'answer': 1},
        {'category_id': 4, 'question': 'What is the term for the destruction of coral reefs due to temperature rise?', 'option1': 'Coral bleaching', 'option2': 'Oceanic erosion', 'option3': 'Reef degradation', 'option4': 'Aquatic desertification', 'answer': 1},
        {'category_id': 4, 'question': 'Which practice can help conserve water?', 'option1': 'Drip irrigation', 'option2': 'Flood irrigation', 'option3': 'Industrial discharge', 'option4': 'Paving landscapes', 'answer': 1},
        {'category_id': 4, 'question': 'What is the main benefit of recycling?', 'option1': 'Reduces waste in landfills', 'option2': 'Increases resource extraction', 'option3': 'Accelerates industrial processes', 'option4': 'Promotes deforestation', 'answer': 1},
      ];


      final earth_science = [
        {'category_id': 5, 'question': 'What is the outermost layer of Earth called?', 'option1': 'Crust', 'option2': 'Mantle', 'option3': 'Core', 'option4': 'Lithosphere', 'answer': 1},
        {'category_id': 5, 'question': 'What is the study of earthquakes called?', 'option1': 'Seismology', 'option2': 'Volcanology', 'option3': 'Geomorphology', 'option4': 'Meteorology', 'answer': 1},
        {'category_id': 5, 'question': 'What type of rock is formed from cooled lava?', 'option1': 'Igneous', 'option2': 'Sedimentary', 'option3': 'Metamorphic', 'option4': 'Fossiliferous', 'answer': 1},
        {'category_id': 5, 'question': 'What is the main gas in Earth’s atmosphere?', 'option1': 'Nitrogen', 'option2': 'Oxygen', 'option3': 'Carbon dioxide', 'option4': 'Argon', 'answer': 1},
        {'category_id': 5, 'question': 'Which layer of Earth is liquid?', 'option1': 'Outer core', 'option2': 'Inner core', 'option3': 'Mantle', 'option4': 'Crust', 'answer': 1},
        {'category_id': 5, 'question': 'What are the three types of plate boundaries?', 'option1': 'Divergent, convergent, transform', 'option2': 'Vertical, lateral, rotational', 'option3': 'Static, dynamic, tectonic', 'option4': 'Oceanic, continental, terrestrial', 'answer': 1},
        {'category_id': 5, 'question': 'What is the process by which rocks are broken down by wind, water, or ice?', 'option1': 'Weathering', 'option2': 'Erosion', 'option3': 'Sedimentation', 'option4': 'Compaction', 'answer': 1},
        {'category_id': 5, 'question': 'What is the most abundant mineral in Earth’s crust?', 'option1': 'Feldspar', 'option2': 'Quartz', 'option3': 'Calcite', 'option4': 'Mica', 'answer': 1},
        {'category_id': 5, 'question': 'What is the age of Earth estimated to be?', 'option1': '4.5 billion years', 'option2': '3.5 billion years', 'option3': '5.5 billion years', 'option4': '2.5 billion years', 'answer': 1},
        {'category_id': 5, 'question': 'Which scale is used to measure the intensity of earthquakes?', 'option1': 'Richter scale', 'option2': 'Fujita scale', 'option3': 'Kelvin scale', 'option4': 'Mercalli scale', 'answer': 1},
        {'category_id': 5, 'question': 'What is the primary cause of ocean tides?', 'option1': 'Gravitational pull of the Moon and Sun', 'option2': 'Earth’s rotation', 'option3': 'Ocean currents', 'option4': 'Wind patterns', 'answer': 1},
        {'category_id': 5, 'question': 'What is the deepest part of the ocean called?', 'option1': 'Mariana Trench', 'option2': 'Challenger Deep', 'option3': 'Java Trench', 'option4': 'Tonga Trench', 'answer': 1},
        {'category_id': 5, 'question': 'What is the molten rock beneath the Earth’s surface called?', 'option1': 'Magma', 'option2': 'Lava', 'option3': 'Basalt', 'option4': 'Granite', 'answer': 1},
        {'category_id': 5, 'question': 'What causes a volcano to erupt?', 'option1': 'Pressure from gases and magma', 'option2': 'Earthquakes', 'option3': 'Ocean currents', 'option4': 'Atmospheric pressure', 'answer': 1},
        {'category_id': 5, 'question': 'Which gas is released in large quantities during a volcanic eruption?', 'option1': 'Carbon dioxide', 'option2': 'Oxygen', 'option3': 'Nitrogen', 'option4': 'Methane', 'answer': 1},
        {'category_id': 5, 'question': 'What is the term for the boundary where two tectonic plates meet?', 'option1': 'Plate boundary', 'option2': 'Fault line', 'option3': 'Subduction zone', 'option4': 'Rift valley', 'answer': 1},
        {'category_id': 5, 'question': 'What type of rock is formed from compacted layers of sediment?', 'option1': 'Sedimentary', 'option2': 'Igneous', 'option3': 'Metamorphic', 'option4': 'Fossiliferous', 'answer': 1},
        {'category_id': 5, 'question': 'Which type of rock is formed under heat and pressure?', 'option1': 'Metamorphic', 'option2': 'Igneous', 'option3': 'Sedimentary', 'option4': 'Granite', 'answer': 1},
        {'category_id': 5, 'question': 'What is the study of fossils called?', 'option1': 'Paleontology', 'option2': 'Archaeology', 'option3': 'Geomorphology', 'option4': 'Anthropology', 'answer': 1},
        {'category_id': 5, 'question': 'What is the term for the preserved remains of plants and animals?', 'option1': 'Fossils', 'option2': 'Artifacts', 'option3': 'Sediments', 'option4': 'Crystals', 'answer': 1},
        {'category_id': 5, 'question': 'What is the Earth’s innermost layer made of?', 'option1': 'Iron and nickel', 'option2': 'Silicon and aluminum', 'option3': 'Carbon and oxygen', 'option4': 'Magnesium and potassium', 'answer': 1},
        {'category_id': 5, 'question': 'What is the process of water cycling through the environment called?', 'option1': 'Water cycle', 'option2': 'Hydrosphere', 'option3': 'Runoff', 'option4': 'Evaporation', 'answer': 1},
        {'category_id': 5, 'question': 'What is the largest type of volcano by volume?', 'option1': 'Shield volcano', 'option2': 'Cinder cone', 'option3': 'Composite volcano', 'option4': 'Lava dome', 'answer': 1},
        {'category_id': 5, 'question': 'What is the name of the supercontinent that existed millions of years ago?', 'option1': 'Pangaea', 'option2': 'Laurasia', 'option3': 'Gondwana', 'option4': 'Eurasia', 'answer': 1},
        {'category_id': 5, 'question': 'Which process forms mountains?', 'option1': 'Orogeny', 'option2': 'Erosion', 'option3': 'Weathering', 'option4': 'Deposition', 'answer': 1},
        {'category_id': 5, 'question': 'What is the term for the movement of sediment by wind, water, or ice?', 'option1': 'Erosion', 'option2': 'Deposition', 'option3': 'Sedimentation', 'option4': 'Compaction', 'answer': 1},
        {'category_id': 5, 'question': 'What is the scientific study of Earth’s atmosphere called?', 'option1': 'Meteorology', 'option2': 'Geology', 'option3': 'Hydrology', 'option4': 'Ecology', 'answer': 1},
        {'category_id': 5, 'question': 'What is the process of breaking down rocks at Earth’s surface called?', 'option1': 'Weathering', 'option2': 'Erosion', 'option3': 'Lithification', 'option4': 'Metamorphism', 'answer': 1},
        {'category_id': 5, 'question': 'Which layer of Earth contains most of its mass?', 'option1': 'Mantle', 'option2': 'Crust', 'option3': 'Outer core', 'option4': 'Inner core', 'answer': 1},
        {'category_id': 5, 'question': 'What is the term for molten rock that reaches Earth’s surface?', 'option1': 'Lava', 'option2': 'Magma', 'option3': 'Basalt', 'option4': 'Obsidian', 'answer': 1},
        {'category_id': 5, 'question': 'Which natural disaster is caused by the movement of tectonic plates?', 'option1': 'Earthquake', 'option2': 'Flood', 'option3': 'Tornado', 'option4': 'Hurricane', 'answer': 1},
        {'category_id': 5, 'question': 'Which process describes the sinking of one tectonic plate under another?', 'option1': 'Subduction', 'option2': 'Divergence', 'option3': 'Transform faulting', 'option4': 'Crustal deformation', 'answer': 1},
        {'category_id': 5, 'question': 'What is the primary component of the Earth’s core?', 'option1': 'Iron', 'option2': 'Nickel', 'option3': 'Silicon', 'option4': 'Magnesium', 'answer': 1},
        {'category_id': 5, 'question': 'What type of boundary causes sea-floor spreading?', 'option1': 'Divergent boundary', 'option2': 'Convergent boundary', 'option3': 'Transform boundary', 'option4': 'Subduction zone', 'answer': 1},
        {'category_id': 5, 'question': 'What is the largest active volcano on Earth?', 'option1': 'Mauna Loa', 'option2': 'Mount Fuji', 'option3': 'Mount St. Helens', 'option4': 'Kilauea', 'answer': 1},
        {'category_id': 5, 'question': 'What is the primary cause of tides on Earth?', 'option1': 'Gravitational pull of the Moon and Sun', 'option2': 'Earth’s rotation', 'option3': 'Wind patterns', 'option4': 'Ocean currents', 'answer': 1},
        {'category_id': 5, 'question': 'Which is the deepest known point in Earth’s oceans?', 'option1': 'Challenger Deep', 'option2': 'Mariana Trench', 'option3': 'Java Trench', 'option4': 'Tonga Trench', 'answer': 1},
        {'category_id': 5, 'question': 'Which of the following is a type of sedimentary rock?', 'option1': 'Sandstone', 'option2': 'Granite', 'option3': 'Marble', 'option4': 'Obsidian', 'answer': 1},
        {'category_id': 5, 'question': 'What type of fault occurs when one block of rock slides horizontally past another?', 'option1': 'Strike-slip fault', 'option2': 'Normal fault', 'option3': 'Reverse fault', 'option4': 'Thrust fault', 'answer': 1},
        {'category_id': 5, 'question': 'Which layer of Earth is primarily composed of silicate rocks?', 'option1': 'Mantle', 'option2': 'Crust', 'option3': 'Outer core', 'option4': 'Inner core', 'answer': 1},
        {'category_id': 5, 'question': 'What type of plate boundary is responsible for the creation of new oceanic crust?', 'option1': 'Divergent boundary', 'option2': 'Convergent boundary', 'option3': 'Transform boundary', 'option4': 'Subduction zone', 'answer': 1},
        {'category_id': 5, 'question': 'Which mineral is commonly found in the Earth’s crust and used in the production of steel?', 'option1': 'Iron', 'option2': 'Gold', 'option3': 'Copper', 'option4': 'Diamond', 'answer': 1},
        {'category_id': 5, 'question': 'Which of the following layers is made of liquid iron and nickel?', 'option1': 'Outer core', 'option2': 'Mantle', 'option3': 'Inner core', 'option4': 'Crust', 'answer': 1},
        {'category_id': 5, 'question': 'What phenomenon causes the Earth’s magnetic field?', 'option1': 'Movement of molten iron in the outer core', 'option2': 'Gravitational forces from the Moon', 'option3': 'Tidal forces from the Sun', 'option4': 'Earth’s rotation on its axis', 'answer': 1},
        {'category_id': 5, 'question': 'Which process causes rocks to change form due to heat and pressure?', 'option1': 'Metamorphism', 'option2': 'Weathering', 'option3': 'Erosion', 'option4': 'Sedimentation', 'answer': 1},
        {'category_id': 5, 'question': 'Which natural event is most commonly associated with the movement of tectonic plates?', 'option1': 'Earthquake', 'option2': 'Volcanic eruption', 'option3': 'Flood', 'option4': 'Hurricane', 'answer': 1},
        {'category_id': 5, 'question': 'What is the phenomenon where one tectonic plate is forced beneath another called?', 'option1': 'Subduction', 'option2': 'Accretion', 'option3': 'Rifting', 'option4': 'Shearing', 'answer': 1},
        {'category_id': 5, 'question': 'What is the term for a large crack in Earth’s crust?', 'option1': 'Fault', 'option2': 'Rift', 'option3': 'Crevice', 'option4': 'Crater', 'answer': 1},
        {'category_id': 5, 'question': 'What is the solid innermost layer of Earth called?', 'option1': 'Inner core', 'option2': 'Outer core', 'option3': 'Mantle', 'option4': 'Crust', 'answer': 1}
      ];

      final math = [
        {'category_id': 6, 'question': 'What is the value of pi (π)?', 'option1': '3.14159', 'option2': '3.14', 'option3': '3.16', 'option4': '3.13', 'answer': 1},
        {'category_id': 6, 'question': 'What is 12 × 12?', 'option1': '144', 'option2': '142', 'option3': '146', 'option4': '140', 'answer': 1},
        {'category_id': 6, 'question': 'What is the square root of 64?', 'option1': '8', 'option2': '6', 'option3': '7', 'option4': '10', 'answer': 1},
        {'category_id': 6, 'question': 'What is 9 + 15?', 'option1': '24', 'option2': '25', 'option3': '23', 'option4': '26', 'answer': 1},
        {'category_id': 6, 'question': 'What is the value of 5^3?', 'option1': '125', 'option2': '100', 'option3': '150', 'option4': '110', 'answer': 1},
        {'category_id': 6, 'question': 'Which of the following is a prime number?', 'option1': '13', 'option2': '15', 'option3': '20', 'option4': '25', 'answer': 1},
        {'category_id': 6, 'question': 'What is 6 × 7?', 'option1': '42', 'option2': '40', 'option3': '45', 'option4': '41', 'answer': 1},
        {'category_id': 6, 'question': 'What is 100 ÷ 4?', 'option1': '25', 'option2': '20', 'option3': '30', 'option4': '35', 'answer': 1},
        {'category_id': 6, 'question': 'What is the area of a square with side length 5 cm?', 'option1': '25 cm²', 'option2': '20 cm²', 'option3': '30 cm²', 'option4': '15 cm²', 'answer': 1},
        {'category_id': 6, 'question': 'What is the perimeter of a rectangle with length 8 cm and width 5 cm?', 'option1': '26 cm', 'option2': '20 cm', 'option3': '25 cm', 'option4': '30 cm', 'answer': 1},
        {'category_id': 6, 'question': 'What is the volume of a cube with side length 4 cm?', 'option1': '64 cm³', 'option2': '60 cm³', 'option3': '70 cm³', 'option4': '80 cm³', 'answer': 1},
        {'category_id': 6, 'question': 'What is the hypotenuse of a right triangle with legs of 3 cm and 4 cm?', 'option1': '5 cm', 'option2': '6 cm', 'option3': '4 cm', 'option4': '3 cm', 'answer': 1},
        {'category_id': 6, 'question': 'What is the slope of a line with the equation y = 3x + 2?', 'option1': '3', 'option2': '2', 'option3': '1', 'option4': '4', 'answer': 1},
        {'category_id': 6, 'question': 'What is the value of x in the equation 2x + 4 = 12?', 'option1': '4', 'option2': '5', 'option3': '6', 'option4': '3', 'answer': 1},
        {'category_id': 6, 'question': 'What is the area of a circle with radius 7 cm?', 'option1': '153.94 cm²', 'option2': '144.22 cm²', 'option3': '149.57 cm²', 'option4': '158.79 cm²', 'answer': 1},
        {'category_id': 6, 'question': 'What is 15% of 200?', 'option1': '30', 'option2': '25', 'option3': '35', 'option4': '40', 'answer': 1},
        {'category_id': 6, 'question': 'What is the equation of a line parallel to y = 2x + 3?', 'option1': 'y = 2x + 5', 'option2': 'y = 3x + 3', 'option3': 'y = 2x + 4', 'option4': 'y = 4x + 3', 'answer': 1},
        {'category_id': 6, 'question': 'What is the product of 13 and 17?', 'option1': '221', 'option2': '210', 'option3': '230', 'option4': '215', 'answer': 1},
        {'category_id': 6, 'question': 'What is the value of 7! (factorial)?', 'option1': '5040', 'option2': '5030', 'option3': '5000', 'option4': '5070', 'answer': 1},
        {'category_id': 6, 'question': 'What is the distance between two points (3, 4) and (6, 8)?', 'option1': '5', 'option2': '4', 'option3': '6', 'option4': '3', 'answer': 1},
        {'category_id': 6, 'question': 'What is the sum of angles in a triangle?', 'option1': '180°', 'option2': '90°', 'option3': '360°', 'option4': '270°', 'answer': 1},
        {'category_id': 6, 'question': 'What is the product of 12 and 8?', 'option1': '96', 'option2': '94', 'option3': '90', 'option4': '92', 'answer': 1},
        {'category_id': 6, 'question': 'What is the derivative of x²?', 'option1': '2x', 'option2': 'x', 'option3': '3x', 'option4': 'x²', 'answer': 1},
        {'category_id': 6, 'question': 'What is the integral of 1/x?', 'option1': 'ln|x|', 'option2': 'x²', 'option3': '1/x²', 'option4': 'x', 'answer': 1},
        {'category_id': 6, 'question': 'What is the cosine of 0°?', 'option1': '1', 'option2': '0', 'option3': '−1', 'option4': 'undefined', 'answer': 1},
        {'category_id': 6, 'question': 'What is the sum of the first 10 prime numbers?', 'option1': '129', 'option2': '130', 'option3': '131', 'option4': '120', 'answer': 1},
        {'category_id': 6, 'question': 'What is the least common multiple of 6 and 8?', 'option1': '24', 'option2': '12', 'option3': '18', 'option4': '36', 'answer': 1},
        {'category_id': 6, 'question': 'What is the greatest common divisor of 12 and 15?', 'option1': '3', 'option2': '6', 'option3': '5', 'option4': '2', 'answer': 1},
        {'category_id': 6, 'question': 'What is the value of 2 + 2 × 2?', 'option1': '6', 'option2': '8', 'option3': '4', 'option4': '7', 'answer': 1},
        {'category_id': 6, 'question': 'What is the value of 3x - 5 = 16?', 'option1': '7', 'option2': '5', 'option3': '8', 'option4': '6', 'answer': 1},
        {'category_id': 6, 'question': 'What is the sum of 25 and 35?', 'option1': '60', 'option2': '50', 'option3': '55', 'option4': '65', 'answer': 1},
        {'category_id': 6, 'question': 'What is the area of a triangle with base 10 cm and height 6 cm?', 'option1': '30 cm²', 'option2': '60 cm²', 'option3': '50 cm²', 'option4': '40 cm²', 'answer': 1},
        {'category_id': 6, 'question': 'What is the value of 3^4?', 'option1': '81', 'option2': '84', 'option3': '80', 'option4': '75', 'answer': 1},
        {'category_id': 6, 'question': 'What is the formula to calculate the area of a circle?', 'option1': 'πr²', 'option2': '2πr', 'option3': 'r²', 'option4': 'πr', 'answer': 1},
        {'category_id': 6, 'question': 'What is the total sum of interior angles of a quadrilateral?', 'option1': '360°', 'option2': '180°', 'option3': '270°', 'option4': '400°', 'answer': 1},
        {'category_id': 6, 'question': 'What is 7 × 6 ÷ 2?', 'option1': '21', 'option2': '20', 'option3': '22', 'option4': '18', 'answer': 1},
        {'category_id': 6, 'question': 'What is the decimal equivalent of 1/4?', 'option1': '0.25', 'option2': '0.5', 'option3': '0.75', 'option4': '0.1', 'answer': 1},
        {'category_id': 6, 'question': 'What is the value of tan(45°)?', 'option1': '1', 'option2': '0', 'option3': '√3', 'option4': '√2', 'answer': 1},
        {'category_id': 6, 'question': 'What is the product of 5 and 9?', 'option1': '45', 'option2': '40', 'option3': '50', 'option4': '42', 'answer': 1},
        {'category_id': 6, 'question': 'What is the sum of 12, 15, and 18?', 'option1': '45', 'option2': '40', 'option3': '50', 'option4': '55', 'answer': 1},
        {'category_id': 6, 'question': 'What is the perimeter of a circle?', 'option1': '2πr', 'option2': 'πr²', 'option3': 'r²π', 'option4': 'πr', 'answer': 1},
        {'category_id': 6, 'question': 'What is the sum of the angles in a quadrilateral?', 'option1': '360°', 'option2': '270°', 'option3': '180°', 'option4': '90°', 'answer': 1},
        {'category_id': 6, 'question': 'What is the next prime number after 13?', 'option1': '17', 'option2': '19', 'option3': '16', 'option4': '15', 'answer': 1},
        {'category_id': 6, 'question': 'What is the median of the numbers 5, 8, 3, 7, and 2?', 'option1': '5', 'option2': '6', 'option3': '4', 'option4': '7', 'answer': 1},
        {'category_id': 6, 'question': 'What is the derivative of 3x²?', 'option1': '6x', 'option2': '3x', 'option3': '9x', 'option4': '2x', 'answer': 1},
        {'category_id': 6, 'question': 'What is the integral of 2x?', 'option1': 'x² + C', 'option2': '2x² + C', 'option3': 'x²', 'option4': '2x + C', 'answer': 1},
        {'category_id': 6, 'question': 'What is the value of log₁₀ 100?', 'option1': '2', 'option2': '1', 'option3': '3', 'option4': '10', 'answer': 1},
        {'category_id': 6, 'question': 'What is the greatest common divisor of 36 and 48?', 'option1': '12', 'option2': '6', 'option3': '18', 'option4': '24', 'answer': 1},
        {'category_id': 6, 'question': 'What is the least common multiple of 9 and 12?', 'option1': '36', 'option2': '72', 'option3': '18', 'option4': '24', 'answer': 1},
        {'category_id': 6, 'question': 'What is the value of 2³ × 3²?', 'option1': '72', 'option2': '60', 'option3': '54', 'option4': '48', 'answer': 1},
        {'category_id': 6, 'question': 'What is the solution to the equation 4x + 5 = 21?', 'option1': '4', 'option2': '3', 'option3': '2', 'option4': '5', 'answer': 1},
        {'category_id': 6, 'question': 'What is the area of a rectangle with width 7 cm and length 10 cm?', 'option1': '70 cm²', 'option2': '65 cm²', 'option3': '75 cm²', 'option4': '80 cm²', 'answer': 1},
        {'category_id': 6, 'question': 'What is the perimeter of a triangle with sides 3 cm, 4 cm, and 5 cm?', 'option1': '12 cm', 'option2': '14 cm', 'option3': '13 cm', 'option4': '11 cm', 'answer': 1},
        {'category_id': 6, 'question': 'What is the value of 2x - 5 = 9?', 'option1': '7', 'option2': '6', 'option3': '5', 'option4': '8', 'answer': 1},
        {'category_id': 6, 'question': 'What is the sum of 1/4 and 3/4?', 'option1': '1', 'option2': '2/4', 'option3': '1/2', 'option4': '2', 'answer': 1},
        {'category_id': 6, 'question': 'What is the value of (5 + 3)²?', 'option1': '64', 'option2': '72', 'option3': '81', 'option4': '50', 'answer': 1}
      ];

      final bangla = [
        {'category_id': 7, 'question': 'আমার সোনার বাংলা” গানটি কে রচনা করেছেন?', 'option1': 'রবীন্দ্রনাথ ঠাকুর', 'option2': 'কাজী নজরুল ইসলাম', 'option3': 'কুণাল সেন', 'option4': 'জসীম উদ্দিন', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের জাতীয় ফুল কি?', 'option1': 'শাপলা ফুল', 'option2': 'গোলাপ', 'option3': 'কমলালেবু', 'option4': 'বকুল', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের জাতীয় পাখি কি?', 'option1': 'ময়না', 'option2': 'সীসা', 'option3': 'হলদে পাখি', 'option4': 'দুপুরে বাদুড়', 'answer': 1},
        {'category_id': 7, 'question': 'কোন কবি “জাগো, তুমি জাগো” গানের রচয়িতা?', 'option1': 'কাজী নজরুল ইসলাম', 'option2': 'রবীন্দ্রনাথ ঠাকুর', 'option3': 'জসীম উদ্দিন', 'option4': 'শামসুর রাহমান', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের স্বাধীনতা ঘোষণা করার প্রথম দিনে শহীদ হন?', 'option1': 'বীর মুক্তিযোদ্ধা', 'option2': 'তাহেরী আলী', 'option3': 'সিরাজুল হক', 'option4': 'কিশোর কুমার', 'answer': 1},
        {'category_id': 7, 'question': '“বঙ্গবন্ধু” কে আখ্যা দেওয়া হয়েছিল?', 'option1': 'বঙ্গবন্ধু শেখ মুজিবুর রহমান', 'option2': 'রবীন্দ্রনাথ ঠাকুর', 'option3': 'জসীম উদ্দিন', 'option4': 'মুক্তিযুদ্ধ', 'answer': 1},
        {'category_id': 7, 'question': 'কোন রাজনীতি সংগঠনটির প্রথম সভাপতি ছিলেন শেখ মুজিবুর রহমান?', 'option1': 'আওয়ামী লীগ', 'option2': 'বাংলাদেশ জাতীয় পার্টি', 'option3': 'কমিউনিস্ট পার্টি', 'option4': 'জামায়াত', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের জাতীয় সঙ্গীতের রচয়িতা কে?', 'option1': 'রবীন্দ্রনাথ ঠাকুর', 'option2': 'কাজী নজরুল ইসলাম', 'option3': 'শামসুর রাহমান', 'option4': 'জীবনানন্দ দাশ', 'answer': 1},
        {'category_id': 7, 'question': 'কোন সেরা গ্রন্থ “তিন ঘর” এর রচয়িতা?', 'option1': 'বিভূতিভূষণ বন্দ্যোপাধ্যায়', 'option2': 'সেলিনা হোসেন', 'option3': 'এমরান খান', 'option4': 'বিলু দাশ', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের স্বাধীনতা যুদ্ধের সর্বোচ্চ নায়ক কে?', 'option1': 'বঙ্গবন্ধু শেখ মুজিবুর রহমান', 'option2': 'জিয়াউর রহমান', 'option3': 'আলাউদ্দিন', 'option4': 'কাজী নজরুল ইসলাম', 'answer': 1},
        {'category_id': 7, 'question': 'কোন মৌলিক শিক্ষা কোর্স “মিলেনিয়াম তরুণ” থেকে রচনা হয়েছে?', 'option1': 'ফেলীসিটি মিত্র', 'option2': 'মলিনা মোহন্ত', 'option3': 'শামসুর রাহমান', 'option4': 'জগদানন্দ দত্ত', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের প্রথম প্রধান মন্ত্রী কে?', 'option1': 'তাজউদ্দিন আহমেদ', 'option2': 'মোহাম্মদ আলী', 'option3': 'আল্লামা আখতার হোসেন', 'option4': 'শাহাবুদ্দিন স্যার', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের রাষ্ট্রপতির প্রথম প্রধান পদ নাম কি?', 'option1': 'রাষ্ট্রপতি', 'option2': 'অধিকারী মন্ত্রী', 'option3': 'প্রধানমন্ত্রী', 'option4': 'সুবিধা', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশে সাহিত্যের কোন ধরণ লিখেছেন “নাটক”?', 'option1': 'জসীম উদ্দিন', 'option2': 'শাহাবুদ্দিন স্যার', 'option3': 'শাওয়া', 'option4': 'তারেক', 'answer': 1},
        {'category_id': 7, 'question': 'শাহরুখ খান যে ফিল্ম প্রযোজন করেছে, তা কি?', 'option1': 'বলিউড', 'option2': 'হলিউড', 'option3': 'ইন্ডি', 'option4': 'বিরোধী কাজ', 'answer': 1},
        {'category_id': 7, 'question': '“আজি আমাদের শান্তি এসেছিল” এই রচনা তৈরি কে?', 'option1': 'শিল্পী শিল্পীরা', 'option2': 'কাজী নজরুল ইসলাম', 'option3': 'শান্তি তরুণ বাল' , 'option4': 'মোফাজল আছেন', 'answer': 1},
        {'category_id': 7, 'question': 'বিশ্ববিদ্যালয়ের প্রতিষ্ঠাতা উপন্যাসকারের নাম কি?', 'option1': 'কাজী নজরুল ইসলাম', 'option2': 'কিশোরী মিত্র', 'option3': 'আলী রহমত', 'option4': 'অমিতাভ ঘোষ', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের জাতীয় সঙ্গীত কী নাম?', 'option1': 'আমার সোনার বাংলা', 'option2': 'ও আমার বাংলা', 'option3': 'তোমার হিন্দু দেশ', 'option4': 'দ্বীনমঙ্গল', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের জাতীয় পাখি কোন পাখি?', 'option1': 'ময়না', 'option2': 'রাজহাঁস', 'option3': 'লাল মাচর', 'option4': 'কুলু', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের জাতীয় ফুল কোন ফুল?', 'option1': 'শাপলা', 'option2': 'দামগাছ', 'option3': 'দোলাচিতি', 'option4': 'ধনিয়া', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের সবচেয়ে জনপ্রিয় শিক্ষকের নাম কি?', 'option1': 'মাহমুদুল হাসান', 'option2': 'তারিকুল ইসলাম', 'option3': 'জিয়াউর রহমান', 'option4': 'জালালুন্নেসা', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের গুরত্বপূর্ণ উল্লিখিত গণনা তি কি?', 'option1': 'ডি জি স্যাম', 'option2': 'চুম্বক', 'option3': 'সংবিধান', 'option4': 'পলির', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের স্বাধীনতা যুদ্ধের সময় কে প্রধান সেনাপতি ছিলেন?', 'option1': 'জিয়াউর রহমান', 'option2': 'শেখ মুজিবুর রহমান', 'option3': 'মোহাম্মদ আলী', 'option4': 'মোশাররফ হোসেন', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের প্রথম রাষ্ট্রপতি কে?', 'option1': 'শেখ মুজিবুর রহমান', 'option2': 'সিরাজুল ইসলাম', 'option3': 'জিয়াউর রহমান', 'option4': 'হুসেইন মুহম্মদ এরশাদ', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের জাতীয় পতাকার ডিজাইনার কে?', 'option1': 'কাজী নজরুল ইসলাম', 'option2': 'শাহাবুদ্দিন', 'option3': 'রফিকুল ইসলাম', 'option4': 'আবদুল কাদির', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের প্রথম মহিলা প্রধানমন্ত্রী কে?', 'option1': 'বেগম খালেদা জিয়া', 'option2': 'শেখ হাসিনা', 'option3': 'শামসুন্নাহার', 'option4': 'নূর জাহান', 'answer': 1},
        {'category_id': 7, 'question': 'কোন দিগন্তে বঙ্গবন্ধুর ছবি সর্বপ্রথম প্রকাশিত হয়?', 'option1': 'বাংলাদেশের প্রথম মুদ্রিত পত্রিকা', 'option2': 'মুক্তিযুদ্ধের ঘোষণা', 'option3': 'একটি স্বাধীন বাংলাদেশ', 'option4': 'খোলে বাংলা', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের গণমাধ্যমের প্রথম রেডিও লাইসেন্স কোন বছর দেওয়া হয়?', 'option1': '১৯৫৮', 'option2': '১৯৪৭', 'option3': '১৯৭১', 'option4': '১৯৬৯', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের প্রথম মহিলার সংগঠন প্রতিষ্ঠাতা কে?', 'option1': 'ফাতেমা জামাল', 'option2': 'কাজী নজরুল ইসলাম', 'option3': 'রাবেয়া বানু', 'option4': 'কামাল হোসেন', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের মুক্তিযুদ্ধের প্রথম সেনা যুদ্ধ কী?', 'option1': 'বাংলাদেশ মুক্তিযুদ্ধ', 'option2': 'প্রথম বিশ্বযুদ্ধ', 'option3': 'দ্বিতীয় বিশ্বযুদ্ধ', 'option4': 'মুক্তিযুদ্ধের প্রথম যুদ্ধ', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশে প্রথম বিদ্যালয়ের প্রতিষ্ঠা কোন স্থানে?', 'option1': 'ঢাকা', 'option2': 'বরিশাল', 'option3': 'চট্টগ্রাম', 'option4': 'খুলনা', 'answer': 1},
        {'category_id': 7, 'question': '“সোহারাব” কাব্যগ্রন্থটির লেখক কে?', 'option1': 'কাজী নজরুল ইসলাম', 'option2': 'শাহাবুদ্দিন', 'option3': 'রবীন্দ্রনাথ ঠাকুর', 'option4': 'হুমায়ুন আহমেদ', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশে নারী মুক্তির জন্য যিনি কাজ করেছেন, তার নাম?', 'option1': 'বেগম রোকেয়া', 'option2': 'শাহাবুদ্দিন', 'option3': 'তারেক রহমান', 'option4': 'মাহবুবা', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের সবচেয়ে বড় নদী কোনটি?', 'option1': 'পদ্মা', 'option2': 'যমুনা', 'option3': 'মেঘনা', 'option4': 'গঙ্গা', 'answer': 1},
        {'category_id': 7, 'question': 'বঙ্গবন্ধু শেখ মুজিবুর রহমান কোন বছর মৃত্যুবরণ করেন?', 'option1': '১৯৭৫', 'option2': '১৯৭১', 'option3': '১৯৬৯', 'option4': '১৯৮১', 'answer': 1},
        {'category_id': 7, 'question': 'কোন তত্ত্ব মেনে বঙ্গবন্ধু স্বাধীনতার আন্দোলনে সক্রিয় ছিলেন?', 'option1': 'বিশ্বজনীন মানবাধিকার', 'option2': 'বাংলাদেশের মুক্তির জন্য শাসন', 'option3': 'আঞ্চলিক ক্ষমতা', 'option4': 'অর্থনীতি', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশে ইতিহাসের প্রথম রাজনৈতিক দল কটি?', 'option1': 'আওয়ামী লীগ', 'option2': 'বাংলাদেশ জাতীয় পার্টি', 'option3': 'কমিউনিস্ট পার্টি', 'option4': 'জামায়াত', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশে গ্রামীণ আন্দোলনকারীরা তাদের আন্দোলনের জন্য কি দাবি করেছিলেন?', 'option1': 'স্বাধীনতা', 'option2': 'সামাজিক পরিবর্তন', 'option3': 'মুক্তিযুদ্ধ', 'option4': 'নির্বাচন', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশে স্কুল জীবনের আদর্শ শিক্ষক হিসেবে পরিচিত?', 'option1': 'নিরবুজা', 'option2': 'মোছলেমা', 'option3': 'খোন্দকার', 'option4': 'ওবায়দুল', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের হ্যারি পটার চরিত্রের গল্প কে লিখেছেন?', 'option1': 'জেএ কেআ রাও', 'option2': 'হুমায়ুন আহমেদ', 'option3': 'ইসমাইল সেলিম', 'option4': 'তানভির', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশে বাংলাদেশের প্রথম মহিলার ডাক নিয়ে মৌলিক শিক্ষা কর্মী ও শিক্ষকের উদ্যোগের পদ্ধতিতে প্রতিবন্ধী বা সাধারণ স্কুলে শিশুদের কাজ ঘোষণা।', 'option1': 'পেটার মেজো', 'option2': 'অশোক চন্দ্র', 'option3': 'হুমায়ুন', 'option4': 'সেলিনা মুশারাফ', 'answer': 1},
        {'category_id': 7, 'question': '“উপকূলীয় এলাকার রাজনীতি” লেখক কে?', 'option1': 'বিশ্বজিৎ চৌধুরী', 'option2': 'রাজীব দত্ত', 'option3': 'রকীব', 'option4': 'অধিকারী', 'answer': 1},
        {'category_id': 7, 'question': 'বিশ্বের সবচেয়ে বড় বিপর্যয়ের এলাকা কোনটি?', 'option1': 'মোহিনী', 'option2': 'ইন্ডিয়া', 'option3': 'বাংলাদেশ', 'option4': 'ভারত', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের বর্তমান প্রশাসনিক ব্যবস্থা কিসের উপর নির্ভর করে?', 'option1': 'বাংলাদেশের মানবাধিকার', 'option2': 'বাংলাদেশের শিক্ষা', 'option3': 'গবেষণার কোর্স', 'option4': 'আর্থিক সামগ্রী', 'answer': 1},
        {'category_id': 7, 'question': 'যে তারকা জাতীয় ভাষায় বিজ্ঞাপন সম্পর্কে গুরুত্বপূর্ণ মন্তব্য করেছিলেন?', 'option1': 'খলিল', 'option2': 'আদিত্য', 'option3': 'রোহান', 'option4': 'সৌরভ', 'answer': 1},
        {'category_id': 7, 'question': '“স্বরবিন্যাস” শব্দটি যে বিশাল বইয়ের তালিকা, বেরিয়েছিল। সৃষ্টিকারী ব্যক্তি?', 'option1': 'আবদুল করিম', 'option2': 'জাহিদ', 'option3': 'মাহমুদ', 'option4': 'রাবেয়া', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের স্বাধীনতা যুদ্ধের সময় পাকিস্তানি বাহিনী কোন রাজ্যে প্রথম আক্রমণ করেছিল?', 'option1': 'পূর্ব পাকিস্তান', 'option2': 'পশ্চিম পাকিস্তান', 'option3': 'দক্ষিণ পাকিস্তান', 'option4': 'উত্তর পাকিস্তান', 'answer': 1},
        {'category_id': 7, 'question': 'বঙ্গবন্ধু শেখ মুজিবুর রহমানের সেরা বক্তৃতা কোনটি?', 'option1': 'স্বাধীনতার ঘোষণা', 'option2': 'নতুন দিনের শপথ', 'option3': 'জাতীয় স্বাধীনতা', 'option4': 'সমাজতন্ত্রের ভিশন', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের সংবিধান কোন সালে গৃহীত হয়?', 'option1': '১৯৭২', 'option2': '১৯৭১', 'option3': '১৯৭৩', 'option4': '১৯৭০', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের ২০ তম প্রধানমন্ত্রী কে?', 'option1': 'শেখ হাসিনা', 'option2': 'বেগম খালেদা জিয়া', 'option3': 'অধ্যাপক গোলাম আযম', 'option4': 'মো. আব্দুল হামিদ', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের স্বাধীনতা যুদ্ধের প্রধান সেনাপতি কে ছিলেন?', 'option1': 'মেজর জেনারেল আতাউল গনি ওসমানী', 'option2': 'মেজর জেনারেল আ. স. ম. মাহবুব', 'option3': 'শেখ মুজিব', 'option4': 'মহবুব আলী', 'answer': 1},
        {'category_id': 7, 'question': 'কোন খেলার জন্য “বিশ্বকাপ” নামক খ্যাতি অর্জন করা হয়েছে?', 'option1': 'ক্রিকেট', 'option2': 'ফুটবল', 'option3': 'হকি', 'option4': 'টেনিস', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশে কোন নদী “মহান” নামে পরিচিত?', 'option1': 'পদ্মা', 'option2': 'গঙ্গা', 'option3': 'মেঘনা', 'option4': 'যমুনা', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের বৃহত্তম ভ্রমণ স্থান কোনটি?', 'option1': 'কক্সবাজার', 'option2': 'সুন্দরবন', 'option3': 'চট্টগ্রাম', 'option4': 'রাঙ্গামাটি', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের ইতিহাসে সবচেয়ে বড় যুদ্ধের অংশ হিসেবে পরিচিত কি?', 'option1': 'মুক্তিযুদ্ধ', 'option2': '১৯৭১ সালে পাকিস্তানের সাথে যুদ্ধ', 'option3': 'ভারত পাকিস্তান যুদ্ধ', 'option4': 'বিশ্ব যুদ্ধ', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের প্রথম রাষ্ট্রীয় সম্মেলন কোথায় অনুষ্ঠিত হয়?', 'option1': 'ঢাকা', 'option2': 'রাজশাহী', 'option3': 'চট্টগ্রাম', 'option4': 'বরিশাল', 'answer': 1},
        {'category_id': 7, 'question': 'বাংলাদেশের প্রথম আকাশযান কোথায় পাঠানো হয়?', 'option1': 'মহাকাশ', 'option2': 'পৃথিবী', 'option3': 'সাধারণ বিমান', 'option4': 'এশিয়া', 'answer': 1}
      ];


      final english = [
        {'category_id': 8, 'question': 'Who wrote the play "Romeo and Juliet"?', 'option1': 'William Shakespeare', 'option2': 'Charles Dickens', 'option3': 'Jane Austen', 'option4': 'Mark Twain', 'answer': 1},
        {'category_id': 8, 'question': 'Which of the following words is an antonym of "happy"?', 'option1': 'Sad', 'option2': 'Excited', 'option3': 'Joyful', 'option4': 'Content', 'answer': 1},
        {'category_id': 8, 'question': 'What is the synonym of "big"?', 'option1': 'Large', 'option2': 'Small', 'option3': 'Tiny', 'option4': 'Narrow', 'answer': 1},
        {'category_id': 8, 'question': 'In which year was the English language officially standardized?', 'option1': '1604', 'option2': '1500', 'option3': '1700', 'option4': '1800', 'answer': 1},
        {'category_id': 8, 'question': 'Who is known as the father of the English language?', 'option1': 'Geoffrey Chaucer', 'option2': 'William Shakespeare', 'option3': 'John Milton', 'option4': 'T.S. Eliot', 'answer': 1},
        {'category_id': 8, 'question': 'What is the plural of the word "child"?', 'option1': 'Children', 'option2': 'Childs', 'option3': 'Childes', 'option4': 'Childeren', 'answer': 1},
        {'category_id': 8, 'question': 'Which one of these words is a noun?', 'option1': 'Freedom', 'option2': 'Quickly', 'option3': 'Run', 'option4': 'Beautiful', 'answer': 1},
        {'category_id': 8, 'question': 'What does the word "benevolent" mean?', 'option1': 'Kind', 'option2': 'Cruel', 'option3': 'Selfish', 'option4': 'Laziness', 'answer': 1},
        {'category_id': 8, 'question': 'What is the opposite of the word "brave"?', 'option1': 'Coward', 'option2': 'Strong', 'option3': 'Bold', 'option4': 'Mighty', 'answer': 1},
        {'category_id': 8, 'question': 'Which of the following is a type of punctuation?', 'option1': 'Comma', 'option2': 'Verb', 'option3': 'Adverb', 'option4': 'Noun', 'answer': 1},
        {'category_id': 8, 'question': 'What does the term "antonym" mean?', 'option1': 'Opposite meaning', 'option2': 'Similar meaning', 'option3': 'Rhyming words', 'option4': 'Spelling variant', 'answer': 1},
        {'category_id': 8, 'question': 'What is the correct past tense of the verb "go"?', 'option1': 'Went', 'option2': 'Gone', 'option3': 'Goes', 'option4': 'Going', 'answer': 1},
        {'category_id': 8, 'question': 'Which of the following words is a verb?', 'option1': 'Run', 'option2': 'Beautiful', 'option3': 'Apple', 'option4': 'Fast', 'answer': 1},
        {'category_id': 8, 'question': 'Which sentence is correct?', 'option1': 'She is going to the market.', 'option2': 'She going to the market.', 'option3': 'She is go to the market.', 'option4': 'She will to the market.', 'answer': 1},
        {'category_id': 8, 'question': 'Which of the following is a synonym for "quick"?', 'option1': 'Fast', 'option2': 'Slow', 'option3': 'Lazy', 'option4': 'Heavy', 'answer': 1},
        {'category_id': 8, 'question': 'Which of these is an example of a simile?', 'option1': 'As brave as a lion', 'option2': 'Brave lion', 'option3': 'The lion is brave', 'option4': 'Bravery like a lion', 'answer': 1},
        {'category_id': 8, 'question': 'What does the phrase "to break the ice" mean?', 'option1': 'To start a conversation', 'option2': 'To break something frozen', 'option3': 'To make someone cry', 'option4': 'To cause tension', 'answer': 1},
        {'category_id': 8, 'question': 'Which of these words is a preposition?', 'option1': 'Under', 'option2': 'Dog', 'option3': 'Sing', 'option4': 'Happy', 'answer': 1},
        {'category_id': 8, 'question': 'What does the term "synonym" mean?', 'option1': 'Same meaning', 'option2': 'Opposite meaning', 'option3': 'Different pronunciation', 'option4': 'Different spelling', 'answer': 1},
        {'category_id': 8, 'question': 'Which of these is a correct sentence?', 'option1': 'She reads books every day.', 'option2': 'She read books every day.', 'option3': 'She reading books every day.', 'option4': 'She is books every day.', 'answer': 1},
        {'category_id': 8, 'question': 'Which word is a conjunction?', 'option1': 'And', 'option2': 'Cat', 'option3': 'Jump', 'option4': 'Purple', 'answer': 1},
        {'category_id': 8, 'question': 'Which is the correct form of the word "run" in past continuous tense?', 'option1': 'Was running', 'option2': 'Ran', 'option3': 'Running', 'option4': 'Will run', 'answer': 1},
        {'category_id': 8, 'question': 'What is the opposite of "beautiful"?', 'option1': 'Ugly', 'option2': 'Bright', 'option3': 'Handsome', 'option4': 'Pretty', 'answer': 1},
        {'category_id': 8, 'question': 'Which of the following is a proper noun?', 'option1': 'London', 'option2': 'city', 'option3': 'mountain', 'option4': 'car', 'answer': 1},
        {'category_id': 8, 'question': 'What is the past tense of the verb "eat"?', 'option1': 'Ate', 'option2': 'Eaten', 'option3': 'Eating', 'option4': 'Eats', 'answer': 1},
        {'category_id': 8, 'question': 'What does the idiom "piece of cake" mean?', 'option1': 'Easy', 'option2': 'Hard', 'option3': 'Delicious', 'option4': 'Boring', 'answer': 1},
        {'category_id': 8, 'question': 'What is the superlative form of "good"?', 'option1': 'Best', 'option2': 'Better', 'option3': 'Gooder', 'option4': 'Most good', 'answer': 1},
        {'category_id': 8, 'question': 'Which word is a preposition?', 'option1': 'On', 'option2': 'Dog', 'option3': 'Run', 'option4': 'Jump', 'answer': 1},
        {'category_id': 8, 'question': 'What is the antonym of "friendly"?', 'option1': 'Hostile', 'option2': 'Brave', 'option3': 'Kind', 'option4': 'Happy', 'answer': 1},
        {'category_id': 8, 'question': 'Which of these is an adverb?', 'option1': 'Quickly', 'option2': 'Cat', 'option3': 'Jump', 'option4': 'Sky', 'answer': 1},
        {'category_id': 8, 'question': 'What is the plural form of "fox"?', 'option1': 'Foxes', 'option2': 'Fox', 'option3': 'Foxy', 'option4': 'Foxen', 'answer': 1},
        {'category_id': 8, 'question': 'Which of the following is a compound sentence?', 'option1': 'I went to the store, and I bought some bread.', 'option2': 'I went to the store.', 'option3': 'I bought some bread.', 'option4': 'The bread was delicious.', 'answer': 1},
        {'category_id': 8, 'question': 'What is the past tense of the verb "sing"?', 'option1': 'Sang', 'option2': 'Sung', 'option3': 'Sings', 'option4': 'Singing', 'answer': 1},
        {'category_id': 8, 'question': 'Which word is an example of a possessive noun?', 'option1': 'John\'s', 'option2': 'John', 'option3': 'Running', 'option4': 'Happiness', 'answer': 1},
        {'category_id': 8, 'question': 'Which word is a preposition in the sentence: "The book is on the table"?', 'option1': 'On', 'option2': 'Book', 'option3': 'Table', 'option4': 'Is', 'answer': 1},
        {'category_id': 8, 'question': 'What is the opposite of "generous"?', 'option1': 'Selfish', 'option2': 'Kind', 'option3': 'Loving', 'option4': 'Caring', 'answer': 1},
        {'category_id': 8, 'question': 'Which word is an adverb?', 'option1': 'Quickly', 'option2': 'Fast', 'option3': 'Rapid', 'option4': 'Speed', 'answer': 1},
        {'category_id': 8, 'question': 'What does the word "empathy" mean?', 'option1': 'Understanding another\'s feelings', 'option2': 'Understanding your own feelings', 'option3': 'Feeling happy', 'option4': 'Feeling sad', 'answer': 1},
        {'category_id': 8, 'question': 'Which is the correct sentence?', 'option1': 'He plays the guitar every day.', 'option2': 'He play the guitar every day.', 'option3': 'He playing the guitar every day.', 'option4': 'He is play the guitar every day.', 'answer': 1},
        {'category_id': 8, 'question': 'What is the plural form of the word "child"?', 'option1': 'Children', 'option2': 'Childs', 'option3': 'Childeren', 'option4': 'Chilren', 'answer': 1},
        {'category_id': 8, 'question': 'Which of these is an example of an interrogative sentence?', 'option1': 'What time is it?', 'option2': 'I am going to the park.', 'option3': 'She is reading a book.', 'option4': 'They went home.', 'answer': 1},
        {'category_id': 8, 'question': 'Which of the following is a comparative adjective?', 'option1': 'Faster', 'option2': 'Fastest', 'option3': 'Fast', 'option4': 'Fasterly', 'answer': 1},
        {'category_id': 8, 'question': 'What is the correct form of the verb in the sentence: "She ____ to the store every morning."', 'option1': 'goes', 'option2': 'going', 'option3': 'gone', 'option4': 'go', 'answer': 1},
        {'category_id': 8, 'question': 'What is the meaning of the word "eclectic"?', 'option1': 'Diverse', 'option2': 'Confused', 'option3': 'Complex', 'option4': 'Simple', 'answer': 1},
        {'category_id': 8, 'question': 'What does the idiom "let the cat out of the bag" mean?', 'option1': 'To reveal a secret', 'option2': 'To get in trouble', 'option3': 'To clean up mess', 'option4': 'To avoid something', 'answer': 1},
        {'category_id': 8, 'question': 'What is the synonym of "angry"?', 'option1': 'Furious', 'option2': 'Sad', 'option3': 'Happy', 'option4': 'Excited', 'answer': 1},
        {'category_id': 8, 'question': 'Which of these words is an adjective?', 'option1': 'Beautiful', 'option2': 'Run', 'option3': 'Quickly', 'option4': 'Laugh', 'answer': 1},
        {'category_id': 8, 'question': 'What is the correct plural form of the word "man"?', 'option1': 'Men', 'option2': 'Mans', 'option3': 'Manes', 'option4': 'Mens', 'answer': 1},
        {'category_id': 8, 'question': 'Which of these sentences is correct?', 'option1': 'She has never been to Paris.', 'option2': 'She never has been to Paris.', 'option3': 'She to Paris has never been.', 'option4': 'Never she has been to Paris.', 'answer': 1},
        {'category_id': 8, 'question': 'What is the past tense of "begin"?', 'option1': 'Began', 'option2': 'Beginned', 'option3': 'Beginning', 'option4': 'Begun', 'answer': 1},
        {'category_id': 8, 'question': 'Which of these words is a preposition?', 'option1': 'Under', 'option2': 'Sing', 'option3': 'Beautiful', 'option4': 'Jump', 'answer': 1},
        {'category_id': 8, 'question': 'What is the opposite of "hard"?', 'option1': 'Soft', 'option2': 'Tough', 'option3': 'Stiff', 'option4': 'Heavy', 'answer': 1},
        {'category_id': 8, 'question': 'Which of these sentences is in the passive voice?', 'option1': 'The book was read by her.', 'option2': 'She read the book.', 'option3': 'She is reading the book.', 'option4': 'She has read the book.', 'answer': 1},
        {'category_id': 8, 'question': 'Which sentence uses the correct verb tense?', 'option1': 'They will arrive tomorrow.', 'option2': 'They arrive tomorrow.', 'option3': 'They arriving tomorrow.', 'option4': 'They to arrive tomorrow.', 'answer': 1},
        {'category_id': 8, 'question': 'Which of the following is a conjunction?', 'option1': 'But', 'option2': 'Go', 'option3': 'Blue', 'option4': 'Fast', 'answer': 1},
        {'category_id': 8, 'question': 'Which of these words is a compound word?', 'option1': 'Notebook', 'option2': 'Book', 'option3': 'Table', 'option4': 'Pen', 'answer': 1},
        {'category_id': 8, 'question': 'What is the meaning of the word "magnificent"?', 'option1': 'Wonderful', 'option2': 'Bad', 'option3': 'Average', 'option4': 'Horrible', 'answer': 1},
        {'category_id': 8, 'question': 'Which of the following is an example of a declarative sentence?', 'option1': 'I am going to school.', 'option2': 'Is she going to school?', 'option3': 'Go to school!', 'option4': 'Do you go to school?', 'answer': 1},
        {'category_id': 8, 'question': 'What is the synonym of "elaborate"?', 'option1': 'Detailed', 'option2': 'Simple', 'option3': 'Quick', 'option4': 'Obscure', 'answer': 1},
        {'category_id': 8, 'question': 'Which word is the correct past form of "swim"?', 'option1': 'Swam', 'option2': 'Swimmed', 'option3': 'Swamned', 'option4': 'Swim', 'answer': 1},
        {'category_id': 8, 'question': 'Which is the correct form of the sentence?', 'option1': 'He is playing the piano.', 'option2': 'He is play the piano.', 'option3': 'He play the piano.', 'option4': 'He are playing the piano.', 'answer': 1},
        {'category_id': 8, 'question': 'What does the word "innovative" mean?', 'option1': 'Creative', 'option2': 'Old', 'option3': 'Boring', 'option4': 'Traditional', 'answer': 1},
        {'category_id': 8, 'question': 'Which sentence is in the future tense?', 'option1': 'She will travel to Japan.', 'option2': 'She travels to Japan.', 'option3': 'She is traveling to Japan.', 'option4': 'She traveled to Japan.', 'answer': 1},
        {'category_id': 8, 'question': 'Which is the correct definition of the word "serene"?', 'option1': 'Calm', 'option2': 'Angry', 'option3': 'Excited', 'option4': 'Noisy', 'answer': 1},
        {'category_id': 8, 'question': 'What is the opposite of "successful"?', 'option1': 'Unsuccessful', 'option2': 'Powerful', 'option3': 'Competent', 'option4': 'Motivated', 'answer': 1},
        {'category_id': 8, 'question': 'What is the synonym of "beautiful"?', 'option1': 'Attractive', 'option2': 'Ugly', 'option3': 'Dirty', 'option4': 'Boring', 'answer': 1},
        {'category_id': 8, 'question': 'Which word is an adverb?', 'option1': 'Quickly', 'option2': 'Quick', 'option3': 'Fast', 'option4': 'Speed', 'answer': 1},
        {'category_id': 8, 'question': 'Which of these words is an antonym of "hot"?', 'option1': 'Cold', 'option2': 'Warm', 'option3': 'Spicy', 'option4': 'Hotter', 'answer': 1}
      ];


      final ict = [
        {'category_id': 9, 'question': 'What does CPU stand for?', 'option1': 'Central Processing Unit', 'option2': 'Central Process Unit', 'option3': 'Computer Processing Unit', 'option4': 'Central Program Unit', 'answer': 1},
        {'category_id': 9, 'question': 'What is the main function of the CPU?', 'option1': 'Perform calculations', 'option2': 'Store data', 'option3': 'Display information', 'option4': 'Connect to internet', 'answer': 1},
        {'category_id': 9, 'question': 'What does RAM stand for?', 'option1': 'Random Access Memory', 'option2': 'Read Access Memory', 'option3': 'Run Access Memory', 'option4': 'Reversible Access Memory', 'answer': 1},
        {'category_id': 9, 'question': 'What is the primary function of RAM?', 'option1': 'To store data temporarily', 'option2': 'To store data permanently', 'option3': 'To execute instructions', 'option4': 'To display graphics', 'answer': 1},
        {'category_id': 9, 'question': 'Which programming language is known as the "mother of all languages"?', 'option1': 'Assembly Language', 'option2': 'C Language', 'option3': 'FORTRAN', 'option4': 'Java', 'answer': 1},
        {'category_id': 9, 'question': 'Which of the following is not an operating system?', 'option1': 'Windows', 'option2': 'Linux', 'option3': 'Java', 'option4': 'macOS', 'answer': 3},
        {'category_id': 9, 'question': 'What does URL stand for?', 'option1': 'Uniform Resource Locator', 'option2': 'Uniform Resource Language', 'option3': 'Uniform Resolved Locator', 'option4': 'Uniform Rendered Locator', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a web browser?', 'option1': 'Chrome', 'option2': 'Microsoft Word', 'option3': 'Photoshop', 'option4': 'Excel', 'answer': 1},
        {'category_id': 9, 'question': 'What does HTML stand for?', 'option1': 'Hyper Text Markup Language', 'option2': 'Hyper Tool Markup Language', 'option3': 'Home Tool Markup Language', 'option4': 'Hyperlink Text Markup Language', 'answer': 1},
        {'category_id': 9, 'question': 'Which of the following is used to create websites?', 'option1': 'HTML', 'option2': 'C++', 'option3': 'Java', 'option4': 'Python', 'answer': 1},
        {'category_id': 9, 'question': 'What does an IP address stand for?', 'option1': 'Internet Protocol address', 'option2': 'International Protocol address', 'option3': 'Internal Processing address', 'option4': 'Internet Public address', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a type of computer memory?', 'option1': 'RAM', 'option2': 'HTML', 'option3': 'Java', 'option4': 'CSS', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a type of software?', 'option1': 'Operating System', 'option2': 'Motherboard', 'option3': 'RAM', 'option4': 'CPU', 'answer': 1},
        {'category_id': 9, 'question': 'What does VPN stand for?', 'option1': 'Virtual Private Network', 'option2': 'Virtual Public Network', 'option3': 'Virtual Protected Network', 'option4': 'Visual Private Network', 'answer': 1},
        {'category_id': 9, 'question': 'Which of the following is used to store data permanently?', 'option1': 'Hard Disk Drive (HDD)', 'option2': 'RAM', 'option3': 'Cache Memory', 'option4': 'CPU', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a database management system?', 'option1': 'MySQL', 'option2': 'Windows', 'option3': 'Python', 'option4': 'JavaScript', 'answer': 1},
        {'category_id': 9, 'question': 'What does "GUI" stand for?', 'option1': 'Graphical User Interface', 'option2': 'General User Interface', 'option3': 'Graphical Universal Interface', 'option4': 'Global User Interface', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a programming language?', 'option1': 'Python', 'option2': 'Google', 'option3': 'Firefox', 'option4': 'Linux', 'answer': 1},
        {'category_id': 9, 'question': 'What is the full form of "USB"?', 'option1': 'Universal Serial Bus', 'option2': 'United Serial Bus', 'option3': 'Universal System Bus', 'option4': 'United System Bus', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is the world’s largest search engine?', 'option1': 'Google', 'option2': 'Yahoo', 'option3': 'Bing', 'option4': 'DuckDuckGo', 'answer': 1},
        {'category_id': 9, 'question': 'Which protocol is used to send emails?', 'option1': 'SMTP', 'option2': 'FTP', 'option3': 'HTTP', 'option4': 'POP3', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is used to display websites?', 'option1': 'Web Browser', 'option2': 'Word Processor', 'option3': 'Spreadsheet', 'option4': 'Database', 'answer': 1},
        {'category_id': 9, 'question': 'What does the term "cloud computing" mean?', 'option1': 'Storing and accessing data over the internet', 'option2': 'Storing data in a local hard drive', 'option3': 'Storing data on a floppy disk', 'option4': 'Data storage via email', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is an example of open-source software?', 'option1': 'Linux', 'option2': 'Windows', 'option3': 'Mac OS', 'option4': 'iOS', 'answer': 1},
        {'category_id': 9, 'question': 'Which programming language is mainly used for web development?', 'option1': 'JavaScript', 'option2': 'C++', 'option3': 'Java', 'option4': 'Python', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a software development framework?', 'option1': 'Angular', 'option2': 'Excel', 'option3': 'Photoshop', 'option4': 'Google Chrome', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a cloud-based storage service?', 'option1': 'Google Drive', 'option2': 'Windows 10', 'option3': 'MS Office', 'option4': 'Notepad', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is an example of system software?', 'option1': 'Windows OS', 'option2': 'Microsoft Word', 'option3': 'Photoshop', 'option4': 'Google Chrome', 'answer': 1},
        {'category_id': 9, 'question': 'What does "IoT" stand for?', 'option1': 'Internet of Things', 'option2': 'Internet on Terminals', 'option3': 'Internal Operating Technology', 'option4': 'Integrated Online Tools', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is used for secure online transactions?', 'option1': 'HTTPS', 'option2': 'HTTP', 'option3': 'FTP', 'option4': 'SMTP', 'answer': 1},
        {'category_id': 9, 'question': 'Which of the following is used for graphical data representation?', 'option1': 'Charts and Graphs', 'option2': 'Text Files', 'option3': 'Word Documents', 'option4': 'Emails', 'answer': 1},
        {'category_id': 9, 'question': 'What does "SEO" stand for?', 'option1': 'Search Engine Optimization', 'option2': 'Search Email Optimization', 'option3': 'System Engineering Optimization', 'option4': 'Systematic Entry Optimization', 'answer': 1},
        {'category_id': 9, 'question': 'What is the purpose of a "firewall" in a computer system?', 'option1': 'To protect against unauthorized access', 'option2': 'To increase processing speed', 'option3': 'To store data', 'option4': 'To create backups', 'answer': 1},
        {'category_id': 9, 'question': 'What does the acronym "HTML" stand for?', 'option1': 'HyperText Markup Language', 'option2': 'High Text Management Language', 'option3': 'Hyper Transfer Markup Language', 'option4': 'High Text Markup Language', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a form of computer security?', 'option1': 'Antivirus software', 'option2': 'Text editing software', 'option3': 'Web browsers', 'option4': 'Video conferencing software', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is used for managing tasks in project management?', 'option1': 'Trello', 'option2': 'Adobe Photoshop', 'option3': 'Google Chrome', 'option4': 'MS Word', 'answer': 1},
        {'category_id': 9, 'question': 'Which of the following is an example of an open-source software?', 'option1': 'Linux', 'option2': 'Windows', 'option3': 'macOS', 'option4': 'iOS', 'answer': 1},
        {'category_id': 9, 'question': 'What does "B2B" stand for?', 'option1': 'Business to Business', 'option2': 'Business to Buyer', 'option3': 'Buyer to Business', 'option4': 'Buyers and Business', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a component of a computer?', 'option1': 'Motherboard', 'option2': 'Google Chrome', 'option3': 'WordPad', 'option4': 'JavaScript', 'answer': 1},
        {'category_id': 9, 'question': 'Which software is used for word processing?', 'option1': 'Microsoft Word', 'option2': 'Photoshop', 'option3': 'PowerPoint', 'option4': 'Excel', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a feature of a "cloud" service?', 'option1': 'Data storage over the internet', 'option2': 'Physical disk storage', 'option3': 'Installation on local servers', 'option4': 'Dedicated local servers', 'answer': 1},
        {'category_id': 9, 'question': 'What does "FTP" stand for?', 'option1': 'File Transfer Protocol', 'option2': 'File Transfer Process', 'option3': 'File Transmission Protocol', 'option4': 'File Transfer Procedure', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these programming languages is used for Android app development?', 'option1': 'Java', 'option2': 'Swift', 'option3': 'Objective-C', 'option4': 'HTML', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a popular website for online storage?', 'option1': 'Dropbox', 'option2': 'Microsoft Word', 'option3': 'Photoshop', 'option4': 'Excel', 'answer': 1},
        {'category_id': 9, 'question': 'Which programming language is known for its use in data analysis?', 'option1': 'Python', 'option2': 'Java', 'option3': 'HTML', 'option4': 'CSS', 'answer': 1},
        {'category_id': 9, 'question': 'What is a "URL"?', 'option1': 'Uniform Resource Locator', 'option2': 'Universal Resource Locator', 'option3': 'Universal Running Locator', 'option4': 'Uniform Running Locator', 'answer': 1},
        {'category_id': 9, 'question': 'What is an example of a search engine?', 'option1': 'Google', 'option2': 'Word', 'option3': 'Excel', 'option4': 'Photoshop', 'answer': 1},
        {'category_id': 9, 'question': 'What is a "backup" in computing?', 'option1': 'A duplicate copy of data', 'option2': 'A type of computer virus', 'option3': 'A data compression technique', 'option4': 'A type of programming language', 'answer': 1},
        {'category_id': 9, 'question': 'What is a common file extension for images?', 'option1': '.jpg', 'option2': '.txt', 'option3': '.html', 'option4': '.exe', 'answer': 1},
        {'category_id': 9, 'question': 'What is a "byte" in computer terminology?', 'option1': 'A unit of digital information', 'option2': 'A type of data storage', 'option3': 'A type of program', 'option4': 'A type of software', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a cloud-based email service?', 'option1': 'Gmail', 'option2': 'Microsoft Word', 'option3': 'Excel', 'option4': 'PowerPoint', 'answer': 1},
        {'category_id': 9, 'question': 'What is a "router" in networking?', 'option1': 'A device that forwards data packets between networks', 'option2': 'A device that stores data', 'option3': 'A device for inputting text', 'option4': 'A device used for file transfer', 'answer': 1},
        {'category_id': 9, 'question': 'What does "DNS" stand for?', 'option1': 'Domain Name System', 'option2': 'Data Network Service', 'option3': 'Domain Networking Service', 'option4': 'Data Name Service', 'answer': 1},
        {'category_id': 9, 'question': 'What does "HTTP" stand for?', 'option1': 'HyperText Transfer Protocol', 'option2': 'HyperText Tracking Protocol', 'option3': 'Home Text Transfer Protocol', 'option4': 'Hyper Transfer Text Protocol', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a form of cyber attack?', 'option1': 'Phishing', 'option2': 'Word Processing', 'option3': 'Spreadsheet', 'option4': 'Photo Editing', 'answer': 1},
        {'category_id': 9, 'question': 'What is the primary function of an operating system?', 'option1': 'Manage hardware and software resources', 'option2': 'Run applications only', 'option3': 'Create documents', 'option4': 'Store files', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is an example of system software?', 'option1': 'Windows', 'option2': 'Google Chrome', 'option3': 'Photoshop', 'option4': 'Microsoft Word', 'answer': 1},
        {'category_id': 9, 'question': 'Which of the following is a version control system?', 'option1': 'Git', 'option2': 'Java', 'option3': 'Python', 'option4': 'Linux', 'answer': 1},
        {'category_id': 9, 'question': 'What does "Wi-Fi" stand for?', 'option1': 'Wireless Fidelity', 'option2': 'Wide Fidelity', 'option3': 'Wireless Functionality', 'option4': 'Wireless Frequency', 'answer': 1},
        {'category_id': 9, 'question': 'What is a "cookie" in terms of web browsing?', 'option1': 'A small piece of data stored by a web browser', 'option2': 'A form of encryption', 'option3': 'A type of software', 'option4': 'A web page layout', 'answer': 1},
        {'category_id': 9, 'question': 'What is an IP address?', 'option1': 'A unique identifier for devices on a network', 'option2': 'A type of password', 'option3': 'A type of firewall', 'option4': 'A type of encryption method', 'answer': 1},
        {'category_id': 9, 'question': 'Which of the following is used to store large amounts of data?', 'option1': 'Hard Drive', 'option2': 'Web Browser', 'option3': 'Operating System', 'option4': 'Word Processor', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is an example of a search engine optimization (SEO) technique?', 'option1': 'Keyword optimization', 'option2': 'Spam', 'option3': 'Clickbait', 'option4': 'Social media posts', 'answer': 1},
        {'category_id': 9, 'question': 'What does "RAM" stand for in computer terminology?', 'option1': 'Random Access Memory', 'option2': 'Read Access Memory', 'option3': 'Rapid Access Memory', 'option4': 'Read-Only Memory', 'answer': 1},
        {'category_id': 9, 'question': 'What is the purpose of a "firewall" in networking?', 'option1': 'To monitor and control incoming and outgoing network traffic', 'option2': 'To store data securely', 'option3': 'To create a network connection', 'option4': 'To allow all internet traffic', 'answer': 1},
        {'category_id': 9, 'question': 'What does "USB" stand for?', 'option1': 'Universal Serial Bus', 'option2': 'Universal System Bus', 'option3': 'United Serial Bus', 'option4': 'Universal Storage Bus', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a programming language used to create websites?', 'option1': 'JavaScript', 'option2': 'Photoshop', 'option3': 'Excel', 'option4': 'WordPad', 'answer': 1},
        {'category_id': 9, 'question': 'What is "Cloud Computing"?', 'option1': 'Storing and processing data on remote servers over the internet', 'option2': 'Storing data on local hard drives', 'option3': 'Processing data with local servers', 'option4': 'None of the above', 'answer': 1},
        {'category_id': 9, 'question': 'What is the primary purpose of an antivirus software?', 'option1': 'To detect and remove malware', 'option2': 'To optimize system performance', 'option3': 'To manage system updates', 'option4': 'To manage files and folders', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a cloud storage service?', 'option1': 'Google Drive', 'option2': 'MS Word', 'option3': 'PowerPoint', 'option4': 'Excel', 'answer': 1},
        {'category_id': 9, 'question': 'Which of the following is a method of encryption?', 'option1': 'AES (Advanced Encryption Standard)', 'option2': 'HTML (Hypertext Markup Language)', 'option3': 'CSS (Cascading Style Sheets)', 'option4': 'JavaScript', 'answer': 1},
        {'category_id': 9, 'question': 'What does "URL" stand for?', 'option1': 'Uniform Resource Locator', 'option2': 'Universal Resource Locator', 'option3': 'User-Ready Locator', 'option4': 'Universal Return Locator', 'answer': 1},
        {'category_id': 9, 'question': 'What is the purpose of "Two-factor authentication"?', 'option1': 'To provide extra security by requiring two forms of verification', 'option2': 'To provide more storage', 'option3': 'To make websites more responsive', 'option4': 'To reduce the use of passwords', 'answer': 1},
        {'category_id': 9, 'question': 'Which of the following is a web development language?', 'option1': 'HTML', 'option2': 'C++', 'option3': 'Java', 'option4': 'Python', 'answer': 1},
        {'category_id': 9, 'question': 'What does "Wi-Fi" stand for?', 'option1': 'Wireless Fidelity', 'option2': 'Wireless Frequency', 'option3': 'Wide Fidelity', 'option4': 'Wide Frequency', 'answer': 1},
        {'category_id': 9, 'question': 'Which of these is a method of online file sharing?', 'option1': 'FTP (File Transfer Protocol)', 'option2': 'PDF (Portable Document Format)', 'option3': 'JPEG (Image Format)', 'option4': 'GIF (Image Format)', 'answer': 1},
        {'category_id': 9, 'question': 'What is the primary function of a "router"?', 'option1': 'Directs data between different networks', 'option2': 'Connects to the internet', 'option3': 'Stores files', 'option4': 'Displays websites', 'answer': 1},
        {'category_id': 9, 'question': 'Which of the following is a version control system?', 'option1': 'Git', 'option2': 'Java', 'option3': 'JavaScript', 'option4': 'MySQL', 'answer': 1},
        {'category_id': 9, 'question': 'What is the function of the "CPU" in a computer?', 'option1': 'To process instructions', 'option2': 'To store data', 'option3': 'To display images', 'option4': 'To input commands', 'answer': 1},
        {'category_id': 9, 'question': 'Which of the following is a component of a computer?', 'option1': 'Motherboard', 'option2': 'Google Chrome', 'option3': 'Windows', 'option4': 'Photoshop', 'answer': 1},
        {'category_id': 9, 'question': 'What does the acronym "RAM" stand for?', 'option1': 'Random Access Memory', 'option2': 'Read-Only Memory', 'option3': 'Remote Access Memory', 'option4': 'Rapid Access Memory', 'answer': 1},
      ];

      final g_knowledge = [
        {'category_id': 10, 'question': 'Who invented the telephone?', 'option1': 'Alexander Graham Bell', 'option2': 'Thomas Edison', 'option3': 'Nikola Tesla', 'option4': 'Benjamin Franklin', 'answer': 1},
        {'category_id': 10, 'question': 'What is the capital of Japan?', 'option1': 'Seoul', 'option2': 'Beijing', 'option3': 'Tokyo', 'option4': 'Osaka', 'answer': 3},
        {'category_id': 10, 'question': 'Which planet is known as the Red Planet?', 'option1': 'Earth', 'option2': 'Mars', 'option3': 'Jupiter', 'option4': 'Venus', 'answer': 2},
        {'category_id': 10, 'question': 'Who painted the Mona Lisa?', 'option1': 'Vincent van Gogh', 'option2': 'Leonardo da Vinci', 'option3': 'Pablo Picasso', 'option4': 'Claude Monet', 'answer': 2},
        {'category_id': 10, 'question': 'In which year did the Titanic sink?', 'option1': '1912', 'option2': '1905', 'option3': '1920', 'option4': '1898', 'answer': 1},
        {'category_id': 10, 'question': 'What is the largest ocean on Earth?', 'option1': 'Atlantic Ocean', 'option2': 'Indian Ocean', 'option3': 'Arctic Ocean', 'option4': 'Pacific Ocean', 'answer': 4},
        {'category_id': 10, 'question': 'Which country is known as the Land of the Rising Sun?', 'option1': 'South Korea', 'option2': 'China', 'option3': 'Japan', 'option4': 'Thailand', 'answer': 3},
        {'category_id': 10, 'question': 'Who wrote the play "Romeo and Juliet"?', 'option1': 'George Orwell', 'option2': 'Mark Twain', 'option3': 'William Shakespeare', 'option4': 'Charles Dickens', 'answer': 3},
        {'category_id': 10, 'question': 'Which element has the chemical symbol "O"?', 'option1': 'Oxygen', 'option2': 'Osmium', 'option3': 'Ozone', 'option4': 'Oganesson', 'answer': 1},
        {'category_id': 10, 'question': 'In which year did World War II end?', 'option1': '1945', 'option2': '1940', 'option3': '1918', 'option4': '1950', 'answer': 1},
        {'category_id': 10, 'question': 'What is the smallest country in the world?', 'option1': 'Monaco', 'option2': 'Vatican City', 'option3': 'San Marino', 'option4': 'Liechtenstein', 'answer': 2},
        {'category_id': 10, 'question': 'Which continent is known as the "Dark Continent"?', 'option1': 'Asia', 'option2': 'Africa', 'option3': 'Australia', 'option4': 'Europe', 'answer': 2},
        {'category_id': 10, 'question': 'What is the tallest mountain in the world?', 'option1': 'Mount Kilimanjaro', 'option2': 'Mount Everest', 'option3': 'Mount Fuji', 'option4': 'K2', 'answer': 2},
        {'category_id': 10, 'question': 'What is the national sport of Canada?', 'option1': 'Hockey', 'option2': 'Football', 'option3': 'Basketball', 'option4': 'Baseball', 'answer': 1},
        {'category_id': 10, 'question': 'Which animal is known as the King of the Jungle?', 'option1': 'Elephant', 'option2': 'Lion', 'option3': 'Tiger', 'option4': 'Bear', 'answer': 2},
        {'category_id': 10, 'question': 'In which country would you find the pyramids of Giza?', 'option1': 'Italy', 'option2': 'Greece', 'option3': 'Egypt', 'option4': 'Turkey', 'answer': 3},
        {'category_id': 10, 'question': 'Which is the largest desert in the world?', 'option1': 'Sahara Desert', 'option2': 'Gobi Desert', 'option3': 'Atacama Desert', 'option4': 'Antarctic Desert', 'answer': 4},
        {'category_id': 10, 'question': 'What is the longest river in the world?', 'option1': 'Amazon River', 'option2': 'Nile River', 'option3': 'Yangtze River', 'option4': 'Mississippi River', 'answer': 2},
        {'category_id': 10, 'question': 'Which country is home to the Great Barrier Reef?', 'option1': 'Australia', 'option2': 'United States', 'option3': 'Mexico', 'option4': 'South Africa', 'answer': 1},
        {'category_id': 10, 'question': 'Who is known as the Father of the Nation in India?', 'option1': 'Jawaharlal Nehru', 'option2': 'Mahatma Gandhi', 'option3': 'Subhas Chandra Bose', 'option4': 'B.R. Ambedkar', 'answer': 2},
        {'category_id': 10, 'question': 'What is the currency of the United Kingdom?', 'option1': 'Euro', 'option2': 'Pound Sterling', 'option3': 'Dollar', 'option4': 'Yen', 'answer': 2},
        {'category_id': 10, 'question': 'Who discovered gravity?', 'option1': 'Isaac Newton', 'option2': 'Albert Einstein', 'option3': 'Nikola Tesla', 'option4': 'Galileo Galilei', 'answer': 1},
        {'category_id': 10, 'question': 'Which country is known as the "Land of the Midnight Sun"?', 'option1': 'Finland', 'option2': 'Norway', 'option3': 'Sweden', 'option4': 'Denmark', 'answer': 2},
        {'category_id': 10, 'question': 'Which human organ is capable of regenerating tissue?', 'option1': 'Liver', 'option2': 'Heart', 'option3': 'Lungs', 'option4': 'Kidney', 'answer': 1},
        {'category_id': 10, 'question': 'What is the square root of 144?', 'option1': '10', 'option2': '12', 'option3': '14', 'option4': '16', 'answer': 2},
        {'category_id': 10, 'question': 'Who was the first man to walk on the moon?', 'option1': 'Buzz Aldrin', 'option2': 'Yuri Gagarin', 'option3': 'Neil Armstrong', 'option4': 'Michael Collins', 'answer': 3},
        {'category_id': 10, 'question': 'Which city is known as the Big Apple?', 'option1': 'Los Angeles', 'option2': 'Chicago', 'option3': 'New York City', 'option4': 'San Francisco', 'answer': 3},
        {'category_id': 10, 'question': 'In which country would you find the ancient city of Petra?', 'option1': 'Egypt', 'option2': 'Jordan', 'option3': 'Israel', 'option4': 'Lebanon', 'answer': 2},
        {'category_id': 10, 'question': 'Who wrote the novel "1984"?', 'option1': 'Aldous Huxley', 'option2': 'George Orwell', 'option3': 'J.K. Rowling', 'option4': 'F. Scott Fitzgerald', 'answer': 2},
        {'category_id': 10, 'question': 'Which city is known as the "City of Lights"?', 'option1': 'Rome', 'option2': 'London', 'option3': 'Paris', 'option4': 'New York City', 'answer': 3},
        {'category_id': 10, 'question': 'Which country has the longest coastline in the world?', 'option1': 'Australia', 'option2': 'Canada', 'option3': 'United States', 'option4': 'Russia', 'answer': 2},
        {'category_id': 10, 'question': 'What is the chemical symbol for gold?', 'option1': 'Au', 'option2': 'Ag', 'option3': 'Pb', 'option4': 'Fe', 'answer': 1},
        {'category_id': 10, 'question': 'Which is the fastest land animal?', 'option1': 'Cheetah', 'option2': 'Lion', 'option3': 'Elephant', 'option4': 'Kangaroo', 'answer': 1},
        {'category_id': 10, 'question': 'Who invented the lightbulb?', 'option1': 'Nikola Tesla', 'option2': 'Thomas Edison', 'option3': 'Alexander Graham Bell', 'option4': 'James Watt', 'answer': 2},
        {'category_id': 10, 'question': 'Which ocean is located to the east of Africa?', 'option1': 'Atlantic Ocean', 'option2': 'Indian Ocean', 'option3': 'Arctic Ocean', 'option4': 'Pacific Ocean', 'answer': 2},
        {'category_id': 10, 'question': 'What is the national animal of India?', 'option1': 'Lion', 'option2': 'Tiger', 'option3': 'Elephant', 'option4': 'Peacock', 'answer': 2},
        {'category_id': 10, 'question': 'Which country has the largest population?', 'option1': 'India', 'option2': 'China', 'option3': 'United States', 'option4': 'Indonesia', 'answer': 2},
        {'category_id': 10, 'question': 'Which element has the atomic number 1?', 'option1': 'Helium', 'option2': 'Hydrogen', 'option3': 'Lithium', 'option4': 'Oxygen', 'answer': 2},
        {'category_id': 10, 'question': 'Who was the first president of the United States?', 'option1': 'Abraham Lincoln', 'option2': 'George Washington', 'option3': 'Thomas Jefferson', 'option4': 'John Adams', 'answer': 2},
        {'category_id': 10, 'question': 'In which year did the Berlin Wall fall?', 'option1': '1989', 'option2': '1991', 'option3': '1985', 'option4': '1979', 'answer': 1},
        {'category_id': 10, 'question': 'Who is known as the "Father of the Internet"?', 'option1': 'Tim Berners-Lee', 'option2': 'Vint Cerf', 'option3': 'Bill Gates', 'option4': 'Steve Jobs', 'answer': 2},
        {'category_id': 10, 'question': 'Which animal is the largest mammal?', 'option1': 'African Elephant', 'option2': 'Blue Whale', 'option3': 'Giraffe', 'option4': 'Whale Shark', 'answer': 2},
        {'category_id': 10, 'question': 'What is the capital of Canada?', 'option1': 'Vancouver', 'option2': 'Ottawa', 'option3': 'Toronto', 'option4': 'Montreal', 'answer': 2},
        {'category_id': 10, 'question': 'Which country is the largest in size?', 'option1': 'United States', 'option2': 'Canada', 'option3': 'China', 'option4': 'Russia', 'answer': 4},
        {'category_id': 10, 'question': 'Which country is known as the "Pearl of the Indian Ocean"?', 'option1': 'India', 'option2': 'Sri Lanka', 'option3': 'Maldives', 'option4': 'Bangladesh', 'answer': 2},
        {'category_id': 10, 'question': 'What is the chemical symbol for silver?', 'option1': 'Au', 'option2': 'Ag', 'option3': 'Fe', 'option4': 'Pb', 'answer': 2},
        {'category_id': 10, 'question': 'What is the hardest natural substance on Earth?', 'option1': 'Gold', 'option2': 'Iron', 'option3': 'Diamond', 'option4': 'Platinum', 'answer': 3},
        {'category_id': 10, 'question': 'Which animal is known for its ability to change color?', 'option1': 'Chameleon', 'option2': 'Octopus', 'option3': 'Lizard', 'option4': 'Snake', 'answer': 1},
        {'category_id': 10, 'question': 'Which gas do plants absorb from the atmosphere for photosynthesis?', 'option1': 'Oxygen', 'option2': 'Carbon Dioxide', 'option3': 'Nitrogen', 'option4': 'Hydrogen', 'answer': 2},
        {'category_id': 10, 'question': 'What is the tallest waterfall in the world?', 'option1': 'Niagara Falls', 'option2': 'Angel Falls', 'option3': 'Victoria Falls', 'option4': 'Iguazu Falls', 'answer': 2},
        {'category_id': 10, 'question': 'What is the currency of Japan?', 'option1': 'Yuan', 'option2': 'Won', 'option3': 'Yen', 'option4': 'Ringgit', 'answer': 3},
        {'category_id': 10, 'question': 'Which planet has the most moons?', 'option1': 'Earth', 'option2': 'Saturn', 'option3': 'Mars', 'option4': 'Jupiter', 'answer': 2},
        {'category_id': 10, 'question': 'What is the name of the largest coral reef system in the world?', 'option1': 'Great Barrier Reef', 'option2': 'Belize Barrier Reef', 'option3': 'Andros Barrier Reef', 'option4': 'Red Sea Coral Reef', 'answer': 1},
        {'category_id': 10, 'question': 'Who developed the theory of general relativity?', 'option1': 'Isaac Newton', 'option2': 'Albert Einstein', 'option3': 'Galileo Galilei', 'option4': 'Niels Bohr', 'answer': 2},
        {'category_id': 10, 'question': 'Which element is used in the production of nuclear energy?', 'option1': 'Iron', 'option2': 'Uranium', 'option3': 'Copper', 'option4': 'Gold', 'answer': 2},
        {'category_id': 10, 'question': 'What is the longest-running television show in the world?', 'option1': 'The Simpsons', 'option2': 'Friends', 'option3': 'The Tonight Show', 'option4': 'The Today Show', 'answer': 4},
        {'category_id': 10, 'question': 'What is the smallest planet in our solar system?', 'option1': 'Mercury', 'option2': 'Mars', 'option3': 'Venus', 'option4': 'Pluto', 'answer': 1},
        {'category_id': 10, 'question': 'What is the chemical symbol for potassium?', 'option1': 'K', 'option2': 'P', 'option3': 'Na', 'option4': 'Cl', 'answer': 1},
        {'category_id': 10, 'question': 'Who is known as the "Father of Modern Physics"?', 'option1': 'Albert Einstein', 'option2': 'Isaac Newton', 'option3': 'Galileo Galilei', 'option4': 'Max Planck', 'answer': 1},
        {'category_id': 10, 'question': 'What is the capital of Australia?', 'option1': 'Sydney', 'option2': 'Melbourne', 'option3': 'Brisbane', 'option4': 'Canberra', 'answer': 4},
        {'category_id': 10, 'question': 'Which ocean is the largest?', 'option1': 'Atlantic Ocean', 'option2': 'Indian Ocean', 'option3': 'Pacific Ocean', 'option4': 'Arctic Ocean', 'answer': 3},
        {'category_id': 10, 'question': 'What is the main ingredient in guacamole?', 'option1': 'Tomato', 'option2': 'Avocado', 'option3': 'Lemon', 'option4': 'Chili', 'answer': 2},
        {'category_id': 10, 'question': 'What is the capital city of France?', 'option1': 'Rome', 'option2': 'Paris', 'option3': 'Berlin', 'option4': 'Madrid', 'answer': 2},
        {'category_id': 10, 'question': 'Which country is the largest producer of coffee in the world?', 'option1': 'Brazil', 'option2': 'Colombia', 'option3': 'Vietnam', 'option4': 'Ethiopia', 'answer': 1},
        {'category_id': 10, 'question': 'What is the most spoken language in the world?', 'option1': 'Spanish', 'option2': 'English', 'option3': 'Mandarin Chinese', 'option4': 'Hindi', 'answer': 3},
        {'category_id': 10, 'question': 'What is the name of the first artificial Earth satellite?', 'option1': 'Apollo 11', 'option2': 'Sputnik 1', 'option3': 'Hubble', 'option4': 'Explorer 1', 'answer': 2},
        {'category_id': 10, 'question': 'Which organ is primarily responsible for producing insulin?', 'option1': 'Kidney', 'option2': 'Liver', 'option3': 'Pancreas', 'option4': 'Lungs', 'answer': 3},
        {'category_id': 10, 'question': 'In which country was the first successful human organ transplant performed?', 'option1': 'United States', 'option2': 'France', 'option3': 'Germany', 'option4': 'South Africa', 'answer': 1},
        {'category_id': 10, 'question': 'Which famous scientist developed the theory of evolution?', 'option1': 'Isaac Newton', 'option2': 'Charles Darwin', 'option3': 'Albert Einstein', 'option4': 'Marie Curie', 'answer': 2},
        {'category_id': 10, 'question': 'What is the largest continent by area?', 'option1': 'Africa', 'option2': 'Europe', 'option3': 'Asia', 'option4': 'North America', 'answer': 3},
        {'category_id': 10, 'question': 'Who was the first woman to win a Nobel Prize?', 'option1': 'Marie Curie', 'option2': 'Rosalind Franklin', 'option3': 'Dorothy Hodgkin', 'option4': 'Barbara McClintock', 'answer': 1},
        {'category_id': 10, 'question': 'Which is the longest river in Europe?', 'option1': 'Danube', 'option2': 'Rhine', 'option3': 'Volga', 'option4': 'Seine', 'answer': 3},
        {'category_id': 10, 'question': 'Who was the first woman to fly solo across the Atlantic Ocean?', 'option1': 'Amelia Earhart', 'option2': 'Bessie Coleman', 'option3': 'Harriet Quimby', 'option4': 'Jacqueline Cochran', 'answer': 1},
        {'category_id': 10, 'question': 'Which instrument is used to measure temperature?', 'option1': 'Barometer', 'option2': 'Thermometer', 'option3': 'Hygrometer', 'option4': 'Anemometer', 'answer': 2},
        {'category_id': 10, 'question': 'Which country is the origin of the Olympic Games?', 'option1': 'France', 'option2': 'United States', 'option3': 'Greece', 'option4': 'Italy', 'answer': 3},
        {'category_id': 10, 'question': 'What is the name of the largest moon of Saturn?', 'option1': 'Titan', 'option2': 'Ganymede', 'option3': 'Europa', 'option4': 'Callisto', 'answer': 1},
        {'category_id': 10, 'question': 'Which famous structure was originally a temporary exhibit for the 1889 World\'s Fair?', 'option1': 'Eiffel Tower', 'option2': 'Statue of Liberty', 'option3': 'Great Wall of China', 'option4': 'Colosseum', 'answer': 1},
        {'category_id': 10, 'question': 'What is the most abundant gas in the Earth’s atmosphere?', 'option1': 'Oxygen', 'option2': 'Carbon Dioxide', 'option3': 'Nitrogen', 'option4': 'Argon', 'answer': 3},
        {'category_id': 10, 'question': 'What is the tallest man-made structure in the world?', 'option1': 'Eiffel Tower', 'option2': 'Burj Khalifa', 'option3': 'Shanghai Tower', 'option4': 'CN Tower', 'answer': 2},
        {'category_id': 10, 'question': 'Which country is the largest producer of oil?', 'option1': 'Saudi Arabia', 'option2': 'Russia', 'option3': 'United States', 'option4': 'China', 'answer': 3},
        {'category_id': 10, 'question': 'Who was the first man to walk on the moon?', 'option1': 'Buzz Aldrin', 'option2': 'Neil Armstrong', 'option3': 'Yuri Gagarin', 'option4': 'John Glenn', 'answer': 2},
        {'category_id': 10, 'question': 'What is the hardest mineral on the Mohs scale of hardness?', 'option1': 'Diamond', 'option2': 'Ruby', 'option3': 'Sapphire', 'option4': 'Emerald', 'answer': 1},
      ];

      final bd_history = [
        {'category_id': 11, 'question': 'Who was the first President of Bangladesh?', 'option1': 'Ziaur Rahman', 'option2': 'Sheikh Mujibur Rahman', 'option3': 'Abul Mansur Ahmed', 'option4': 'Hussain Shaheed Suhrawardy', 'answer': 2},
        {'category_id': 11, 'question': 'In which year did Bangladesh gain independence?', 'option1': '1970', 'option2': '1971', 'option3': '1972', 'option4': '1973', 'answer': 2},
        {'category_id': 11, 'question': 'What is the name of the war that led to Bangladesh\'s independence?', 'option1': 'Liberation War', 'option2': 'Indo-Pak War', 'option3': 'Bangladesh War of Liberation', 'option4': 'War of Independence', 'answer': 3},
        {'category_id': 11, 'question': 'Who was the founding leader of Bangladesh?', 'option1': 'Ziaur Rahman', 'option2': 'Sheikh Mujibur Rahman', 'option3': 'Hussain Shaheed Suhrawardy', 'option4': 'Kazi Nazrul Islam', 'answer': 2},
        {'category_id': 11, 'question': 'Which event triggered the Bangladesh Liberation War?', 'option1': 'The Language Movement', 'option2': 'The Six-Point Movement', 'option3': 'The Military Coup', 'option4': 'The Mass Upsurge of 1969', 'answer': 2},
        {'category_id': 11, 'question': 'What was the date when Sheikh Mujibur Rahman declared Bangladesh\'s independence?', 'option1': 'March 25, 1971', 'option2': 'March 26, 1971', 'option3': 'April 1, 1971', 'option4': 'December 16, 1971', 'answer': 2},
        {'category_id': 11, 'question': 'Where did the first official flag of Bangladesh fly?', 'option1': 'Dhaka', 'option2': 'Chittagong', 'option3': 'Khulna', 'option4': 'Rajshahi', 'answer': 1},
        {'category_id': 11, 'question': 'Who is known as the \'Father of the Nation\' in Bangladesh?', 'option1': 'Sheikh Mujibur Rahman', 'option2': 'Ziaur Rahman', 'option3': 'Hussain Shaheed Suhrawardy', 'option4': 'Kazi Nazrul Islam', 'answer': 1},
        {'category_id': 11, 'question': 'Which country supported Bangladesh in the Liberation War?', 'option1': 'United States', 'option2': 'China', 'option3': 'India', 'option4': 'Pakistan', 'answer': 3},
        {'category_id': 11, 'question': 'What was the first language movement of Bangladesh?', 'option1': 'Bengali Language Movement', 'option2': 'Six-Point Movement', 'option3': 'Independence Movement', 'option4': 'Mass Rebellion Movement', 'answer': 1},
        {'category_id': 11, 'question': 'Which battle marked the end of the Bangladesh Liberation War?', 'option1': 'Battle of Garibpur', 'option2': 'Battle of Jalalabad', 'option3': 'Battle of Hilli', 'option4': 'Battle of Srirampur', 'answer': 1},
        {'category_id': 11, 'question': 'Which political party did Sheikh Mujibur Rahman belong to?', 'option1': 'Awami League', 'option2': 'Bangladesh Nationalist Party', 'option3': 'Communist Party', 'option4': 'Jamaat-e-Islami', 'answer': 1},
        {'category_id': 11, 'question': 'Who was the first Prime Minister of Bangladesh?', 'option1': 'Sheikh Mujibur Rahman', 'option2': 'Khandaker Mushtaq Ahmed', 'option3': 'Ziaur Rahman', 'option4': 'Abul Mansur Ahmed', 'answer': 1},
        {'category_id': 11, 'question': 'Who led the Pakistani army during the Bangladesh Liberation War?', 'option1': 'Yahya Khan', 'option2': 'Tikka Khan', 'option3': 'Zia-ul-Haq', 'option4': 'Hamid Gul', 'answer': 2},
        {'category_id': 11, 'question': 'Which country’s army invaded Bangladesh during the Liberation War?', 'option1': 'India', 'option2': 'Pakistan', 'option3': 'China', 'option4': 'Nepal', 'answer': 2},
        {'category_id': 11, 'question': 'What was the main reason for the Bangladesh Liberation War?', 'option1': 'Religious Discrimination', 'option2': 'Economic disparity', 'option3': 'Political disenfranchisement', 'option4': 'Language Discrimination', 'answer': 4},
        {'category_id': 11, 'question': 'When did Bangladesh formally gain independence from Pakistan?', 'option1': 'March 25, 1972', 'option2': 'April 14, 1972', 'option3': 'December 16, 1971', 'option4': 'March 26, 1971', 'answer': 3},
        {'category_id': 11, 'question': 'Who was the Prime Minister of India during Bangladesh\'s Liberation War?', 'option1': 'Indira Gandhi', 'option2': 'Rajiv Gandhi', 'option3': 'Nehru', 'option4': 'Atal Bihari Vajpayee', 'answer': 1},
        {'category_id': 11, 'question': 'Which famous leader was assassinated in 1975 in Bangladesh?', 'option1': 'Ziaur Rahman', 'option2': 'Sheikh Mujibur Rahman', 'option3': 'Hussain Shaheed Suhrawardy', 'option4': 'Kazi Nazrul Islam', 'answer': 2},
        {'category_id': 11, 'question': 'In which year did the Liberation War of Bangladesh end?', 'option1': '1971', 'option2': '1970', 'option3': '1972', 'option4': '1973', 'answer': 1},
        {'category_id': 11, 'question': 'Which city is known as the birthplace of the Bengali Language Movement?', 'option1': 'Chittagong', 'option2': 'Dhaka', 'option3': 'Sylhet', 'option4': 'Rajshahi', 'answer': 2},
        {'category_id': 11, 'question': 'Which movement was initiated in 1969 to demand the release of Sheikh Mujibur Rahman?', 'option1': 'The Six-Point Movement', 'option2': 'The Mass Rebellion Movement', 'option3': 'The Agartala Conspiracy Case', 'option4': 'The Language Movement', 'answer': 2},
        {'category_id': 11, 'question': 'What was the name of the Pakistani military operation against the Bangladesh Liberation movement?', 'option1': 'Operation Thunderbolt', 'option2': 'Operation Searchlight', 'option3': 'Operation Barbarossa', 'option4': 'Operation Cyclone', 'answer': 2},
        {'category_id': 11, 'question': 'Which year did Bangladesh officially join the United Nations?', 'option1': '1972', 'option2': '1971', 'option3': '1973', 'option4': '1975', 'answer': 1},
        {'category_id': 11, 'question': 'In which year did Ziaur Rahman become the President of Bangladesh?', 'option1': '1976', 'option2': '1975', 'option3': '1980', 'option4': '1981', 'answer': 1},
        {'category_id': 11, 'question': 'Who led the first Bangladesh Nationalist Party government?', 'option1': 'Hussain Shaheed Suhrawardy', 'option2': 'Ziaur Rahman', 'option3': 'Sheikh Mujibur Rahman', 'option4': 'Abdul Hamid Khan Bhashani', 'answer': 2},
        {'category_id': 11, 'question': 'Which event marked the beginning of the Bangladesh Liberation War?', 'option1': 'Massacre in Dhaka', 'option2': 'Operation Searchlight', 'option3': 'Battle of Hilli', 'option4': 'Independence Declaration', 'answer': 2},
        {'category_id': 11, 'question': 'Which city is the birthplace of Sheikh Mujibur Rahman?', 'option1': 'Chittagong', 'option2': 'Khulna', 'option3': 'Barisal', 'option4': 'Tungipara', 'answer': 4},
        {'category_id': 11, 'question': 'Which date is celebrated as the National Victory Day of Bangladesh?', 'option1': 'March 26', 'option2': 'December 16', 'option3': 'August 15', 'option4': 'October 10', 'answer': 2},
        {'category_id': 11, 'question': 'What was the name of the Pakistani dictator during the Bangladesh Liberation War?', 'option1': 'Yahya Khan', 'option2': 'Zia-ul-Haq', 'option3': 'Nawaz Sharif', 'option4': 'Benazir Bhutto', 'answer': 1},
        {'category_id': 11, 'question': 'In which year was the first victory day celebrated in Bangladesh?', 'option1': '1971', 'option2': '1972', 'option3': '1973', 'option4': '1975', 'answer': 2},
        {'category_id': 11, 'question': 'In which year was the Dhaka University massacre?', 'option1': '1952', 'option2': '1971', 'option3': '1947', 'option4': '1969', 'answer': 1},
        {'category_id': 11, 'question': 'Which was the first language of the majority of Bangladeshis?', 'option1': 'Hindi', 'option2': 'Bengali', 'option3': 'Urdu', 'option4': 'English', 'answer': 2},
        {'category_id': 11, 'question': 'What is the significance of March 7, 1971 in Bangladesh?', 'option1': 'Independence Day', 'option2': 'Sheikh Mujibur Rahman’s historic speech', 'option3': 'Victory Day', 'option4': 'Language Movement Day', 'answer': 2},
        {'category_id': 11, 'question': 'Which agreement was signed to end the Bangladesh Liberation War?', 'option1': 'Indo-Pakistani Agreement', 'option2': 'Shimla Agreement', 'option3': 'Instrument of Surrender', 'option4': 'Dhaka Peace Accord', 'answer': 3},
        {'category_id': 11, 'question': 'Who was the Commander-in-Chief of the Bangladesh Liberation Army?', 'option1': 'General Ziaur Rahman', 'option2': 'Lieutenant General Jagjit Singh Aurora', 'option3': 'Major General M A G Osmany', 'option4': 'Brigadier General Mohammad Ataul Gani Osmani', 'answer': 4},
        {'category_id': 11, 'question': 'Which famous sports personality played a key role in the Bangladesh Liberation War?', 'option1': 'Kazi Salahuddin', 'option2': 'Mohammad Ashraful', 'option3': 'Shakib Al Hasan', 'option4': 'Akram Khan', 'answer': 1},
        {'category_id': 11, 'question': 'Which political party was formed in 1978 by Ziaur Rahman?', 'option1': 'Awami League', 'option2': 'Bangladesh Nationalist Party (BNP)', 'option3': 'Jamaat-e-Islami', 'option4': 'Communist Party of Bangladesh', 'answer': 2},
        {'category_id': 11, 'question': 'Who was the first woman to serve as the Prime Minister of Bangladesh?', 'option1': 'Sheikh Hasina', 'option2': 'Khaleda Zia', 'option3': 'Begum Khaleda Zia', 'option4': 'Fatima Jinnah', 'answer': 2},
        {'category_id': 11, 'question': 'What was the name of the Pakistani military operation carried out to suppress the Bangladesh Liberation War?', 'option1': 'Operation Searchlight', 'option2': 'Operation Thunder', 'option3': 'Operation Cyclone', 'option4': 'Operation Barbet', 'answer': 1},
        {'category_id': 11, 'question': 'Who was the first woman president of Bangladesh?', 'option1': 'Khaleda Zia', 'option2': 'Sheikh Hasina', 'option3': 'Fatema Begum', 'option4': 'Sultana Kamal', 'answer': 1},
        {'category_id': 11, 'question': 'In what year was the National Museum of Bangladesh established?', 'option1': '1971', 'option2': '1974', 'option3': '1980', 'option4': '1992', 'answer': 2},
        {'category_id': 11, 'question': 'Which event triggered the 1969 uprising in East Pakistan?', 'option1': 'The resignation of Yahya Khan', 'option2': 'Operation Searchlight', 'option3': 'The Agartala Conspiracy Case', 'option4': 'The imprisonment of Sheikh Mujibur Rahman', 'answer': 3},
        {'category_id': 11, 'question': 'What is the term for the first constitution of Bangladesh?', 'option1': 'The Constitution of the People’s Republic of Bangladesh', 'option2': 'The Declaration of Independence', 'option3': 'The Proclamation of Freedom', 'option4': 'The Charter of Rights', 'answer': 1},
        {'category_id': 11, 'question': 'Who was the leader of the All-India Muslim League during the partition of Bengal?', 'option1': 'Allama Iqbal', 'option2': 'Liaquat Ali Khan', 'option3': 'Hussain Shaheed Suhrawardy', 'option4': 'Muhammad Ali Jinnah', 'answer': 4},
        {'category_id': 11, 'question': 'In what year did Sheikh Mujibur Rahman pass away?', 'option1': '1980', 'option2': '1975', 'option3': '1976', 'option4': '1977', 'answer': 2},
        {'category_id': 11, 'question': 'What was the major outcome of the 1970 elections in Bangladesh?', 'option1': 'The Awami League won an overwhelming victory', 'option2': 'The Pakistan Peoples Party won majority', 'option3': 'The military took control', 'option4': 'The Communist Party of Bangladesh emerged victorious', 'answer': 1},
        {'category_id': 11, 'question': 'Which famous battle during the Bangladesh Liberation War is known for the surrender of Pakistani forces?', 'option1': 'Battle of Hilli', 'option2': 'Battle of Garibpur', 'option3': 'Battle of Dhaka', 'option4': 'Battle of Chittagong', 'answer': 3},
        {'category_id': 11, 'question': 'In which year did the Bangladesh Liberation War officially begin?', 'option1': '1970', 'option2': '1971', 'option3': '1965', 'option4': '1972', 'answer': 2},
        {'category_id': 11, 'question': 'Which notable Bengali poet’s writings contributed to the Language Movement?', 'option1': 'Nazrul Islam', 'option2': 'Kazi Nazrul Islam', 'option3': 'Rabindranath Tagore', 'option4': 'Jasimuddin', 'answer': 2},
        {'category_id': 11, 'question': 'In which city did the mass protests for language rights occur in 1952?', 'option1': 'Chittagong', 'option2': 'Dhaka', 'option3': 'Rajshahi', 'option4': 'Khulna', 'answer': 2},
        {'category_id': 11, 'question': 'What is the name of the historic site where the Bangladesh Liberation War ended?', 'option1': 'Narayanganj', 'option2': 'Bangabandhu Avenue', 'option3': 'Sundarbans', 'option4': 'Shahid Minar', 'answer': 2},
        {'category_id': 11, 'question': 'Who was the first president of Bangladesh?', 'option1': 'Khandaker Mushtaq Ahmed', 'option2': 'Sheikh Mujibur Rahman', 'option3': 'Ziaur Rahman', 'option4': 'Abul Kalam Azad', 'answer': 2},
        {'category_id': 11, 'question': 'Which military operation by the Pakistani army began on March 25, 1971?', 'option1': 'Operation Sword', 'option2': 'Operation Searchlight', 'option3': 'Operation Thunder', 'option4': 'Operation Eclipse', 'answer': 2},
        {'category_id': 11, 'question': 'Which political figure led Bangladesh to independence?', 'option1': 'Sheikh Mujibur Rahman', 'option2': 'Ziaur Rahman', 'option3': 'Khaleda Zia', 'option4': 'Begum Khaleda Zia', 'answer': 1},
        {'category_id': 11, 'question': 'What year did the 7th Amendment of the Bangladesh Constitution come into effect?', 'option1': '1982', 'option2': '1986', 'option3': '1981', 'option4': '1980', 'answer': 1},
        {'category_id': 11, 'question': 'In which year did Bangladesh formally join the United Nations?', 'option1': '1974', 'option2': '1975', 'option3': '1971', 'option4': '1981', 'answer': 1},
        {'category_id': 11, 'question': 'What event led to the declaration of independence of Bangladesh on March 26, 1971?', 'option1': 'The arrest of Sheikh Mujibur Rahman', 'option2': 'The defeat of the Pakistani military', 'option3': 'Operation Searchlight', 'option4': 'The signing of the Instrument of Surrender', 'answer': 1},
        {'category_id': 11, 'question': 'What was the original name of the Bangladesh Liberation War in 1971?', 'option1': 'Independence War', 'option2': 'Bangabandhu Movement', 'option3': 'Bangladesh War for Liberation', 'option4': 'Liberation Movement', 'answer': 3},
        {'category_id': 11, 'question': 'Which language is officially spoken in Bangladesh?', 'option1': 'English', 'option2': 'Hindi', 'option3': 'Bengali', 'option4': 'Urdu', 'answer': 3},
        {'category_id': 11, 'question': 'What was the name of the East Bengal regiment during British rule in India?', 'option1': 'Royal Bengal Army', 'option2': 'Bengal Light Infantry', 'option3': 'Bengal Engineers', 'option4': 'East Bengal Regiment', 'answer': 2},
        {'category_id': 11, 'question': 'Which major event in Bangladesh history occurred on December 16, 1971?', 'option1': 'Independence Day', 'option2': 'Victory Day', 'option3': 'National Liberation Day', 'option4': 'Surrender of Pakistani Army', 'answer': 2},
        {'category_id': 11, 'question': 'In which year did the assassination of Sheikh Mujibur Rahman take place?', 'option1': '1975', 'option2': '1980', 'option3': '1972', 'option4': '1974', 'answer': 1},
        {'category_id': 11, 'question': 'Which former Indian Prime Minister played a key role in Bangladesh’s independence?', 'option1': 'Indira Gandhi', 'option2': 'Jawaharlal Nehru', 'option3': 'Rajiv Gandhi', 'option4': 'Atal Bihari Vajpayee', 'answer': 1},
        {'category_id': 11, 'question': 'Which year was the Bangladesh Liberation War memorial, the National Memorial in Savar, inaugurated?', 'option1': '1971', 'option2': '1975', 'option3': '1991', 'option4': '1999', 'answer': 3},
      ];

      final world_history = [
        {'category_id': 12, 'question': 'Who was the first Emperor of China?', 'option1': 'Qin Shi Huang', 'option2': 'Sun Tzu', 'option3': 'Wang Mang', 'option4': 'Liu Bang', 'answer': 1},
        {'category_id': 12, 'question': 'Which ancient civilization built the pyramids?', 'option1': 'Mesopotamians', 'option2': 'Egyptians', 'option3': 'Romans', 'option4': 'Greeks', 'answer': 2},
        {'category_id': 12, 'question': 'Who was the leader of the Mongol Empire during its peak?', 'option1': 'Genghis Khan', 'option2': 'Kublai Khan', 'option3': 'Tamerlane', 'option4': 'Alexander the Great', 'answer': 1},
        {'category_id': 12, 'question': 'Which year did Christopher Columbus first arrive in the Americas?', 'option1': '1492', 'option2': '1485', 'option3': '1500', 'option4': '1460', 'answer': 1},
        {'category_id': 12, 'question': 'Who was the first woman to fly solo across the Atlantic Ocean?', 'option1': 'Amelia Earhart', 'option2': 'Bessie Coleman', 'option3': 'Harriet Quimby', 'option4': 'Eleanor Roosevelt', 'answer': 1},
        {'category_id': 12, 'question': 'Which war was fought between the Allies and the Axis powers between 1939 and 1945?', 'option1': 'World War I', 'option2': 'The Korean War', 'option3': 'World War II', 'option4': 'The Cold War', 'answer': 3},
        {'category_id': 12, 'question': 'Who was the famous leader of the Indian independence movement?', 'option1': 'Subhas Chandra Bose', 'option2': 'Jawaharlal Nehru', 'option3': 'Mahatma Gandhi', 'option4': 'Bhagat Singh', 'answer': 3},
        {'category_id': 12, 'question': 'Which country was the first to grant women the right to vote?', 'option1': 'United States', 'option2': 'New Zealand', 'option3': 'Canada', 'option4': 'United Kingdom', 'answer': 2},
        {'category_id': 12, 'question': 'What event triggered the start of World War I?', 'option1': 'The invasion of Poland', 'option2': 'The assassination of Archduke Franz Ferdinand', 'option3': 'The bombing of Pearl Harbor', 'option4': 'The signing of the Versailles Treaty', 'answer': 2},
        {'category_id': 12, 'question': 'In which year did the Berlin Wall fall?', 'option1': '1989', 'option2': '1979', 'option3': '1991', 'option4': '1987', 'answer': 1},
        {'category_id': 12, 'question': 'Who was the leader of the Soviet Union during World War II?', 'option1': 'Joseph Stalin', 'option2': 'Leon Trotsky', 'option3': 'Vladimir Lenin', 'option4': 'Mikhail Gorbachev', 'answer': 1},
        {'category_id': 12, 'question': 'Which empire was known for its road system and vast territorial expansion in the Americas?', 'option1': 'Maya Empire', 'option2': 'Inca Empire', 'option3': 'Aztec Empire', 'option4': 'Olmec Civilization', 'answer': 2},
        {'category_id': 12, 'question': 'Who was the first king of the Roman Empire?', 'option1': 'Julius Caesar', 'option2': 'Augustus', 'option3': 'Nero', 'option4': 'Constantine', 'answer': 2},
        {'category_id': 12, 'question': 'The Magna Carta was signed in which country?', 'option1': 'France', 'option2': 'Germany', 'option3': 'England', 'option4': 'Italy', 'answer': 3},
        {'category_id': 12, 'question': 'In which year did the United States declare independence?', 'option1': '1776', 'option2': '1781', 'option3': '1800', 'option4': '1765', 'answer': 1},
        {'category_id': 12, 'question': 'Which famous scientist developed the theory of evolution by natural selection?', 'option1': 'Isaac Newton', 'option2': 'Albert Einstein', 'option3': 'Charles Darwin', 'option4': 'Galileo Galilei', 'answer': 3},
        {'category_id': 12, 'question': 'What year did the French Revolution begin?', 'option1': '1789', 'option2': '1793', 'option3': '1776', 'option4': '1812', 'answer': 1},
        {'category_id': 12, 'question': 'Which empire was the largest in terms of land area in history?', 'option1': 'Roman Empire', 'option2': 'Mongol Empire', 'option3': 'British Empire', 'option4': 'Ottoman Empire', 'answer': 2},
        {'category_id': 12, 'question': 'Who was the first Emperor of Rome?', 'option1': 'Julius Caesar', 'option2': 'Augustus', 'option3': 'Nero', 'option4': 'Tiberius', 'answer': 2},
        {'category_id': 12, 'question': 'The Great Wall of China was built primarily to protect China from which group?', 'option1': 'The Mongols', 'option2': 'The Huns', 'option3': 'The Japanese', 'option4': 'The Russians', 'answer': 1},
        {'category_id': 12, 'question': 'Which conflict is often referred to as “The Great War”?', 'option1': 'World War I', 'option2': 'World War II', 'option3': 'The Vietnam War', 'option4': 'The Korean War', 'answer': 1},
        {'category_id': 12, 'question': 'Who was the first man to land on the moon?', 'option1': 'Buzz Aldrin', 'option2': 'Yuri Gagarin', 'option3': 'Neil Armstrong', 'option4': 'Alan Shepard', 'answer': 3},
        {'category_id': 12, 'question': 'The Cold War primarily took place between which two superpowers?', 'option1': 'USA and USSR', 'option2': 'USA and China', 'option3': 'USA and UK', 'option4': 'USSR and China', 'answer': 1},
        {'category_id': 12, 'question': 'Which famous structure was completed in 1889 for the 1889 Exposition Universelle in Paris?', 'option1': 'Eiffel Tower', 'option2': 'Colosseum', 'option3': 'Great Pyramid of Giza', 'option4': 'Statue of Liberty', 'answer': 1},
        {'category_id': 12, 'question': 'Which battle marked the turning point of the American Civil War?', 'option1': 'Battle of Gettysburg', 'option2': 'Battle of Lexington', 'option3': 'Battle of Fort Sumter', 'option4': 'Battle of Antietam', 'answer': 1},
        {'category_id': 12, 'question': 'Which explorer is credited with discovering the New World in 1492?', 'option1': 'Ferdinand Magellan', 'option2': 'Christopher Columbus', 'option3': 'Marco Polo', 'option4': 'Vasco da Gama', 'answer': 2},
        {'category_id': 12, 'question': 'Who was the first king of England?', 'option1': 'Alfred the Great', 'option2': 'Henry VIII', 'option3': 'Egbert', 'option4': 'William the Conqueror', 'answer': 3},
        {'category_id': 12, 'question': 'Who became the first President of the United States?', 'option1': 'Thomas Jefferson', 'option2': 'Abraham Lincoln', 'option3': 'George Washington', 'option4': 'John Adams', 'answer': 3},
        {'category_id': 12, 'question': 'What major event took place in 1066 in England?', 'option1': 'The Battle of Hastings', 'option2': 'The signing of the Magna Carta', 'option3': 'The beginning of the Hundred Years’ War', 'option4': 'The coronation of King Henry VIII', 'answer': 1},
        {'category_id': 12, 'question': 'What year did the Soviet Union collapse?', 'option1': '1989', 'option2': '1991', 'option3': '1990', 'option4': '1993', 'answer': 2},
        {'category_id': 12, 'question': 'What year did the US Civil War end?', 'option1': '1861', 'option2': '1865', 'option3': '1870', 'option4': '1859', 'answer': 2},
        {'category_id': 12, 'question': 'Which battle is considered Napoleon’s first significant defeat?', 'option1': 'Battle of Waterloo', 'option2': 'Battle of Austerlitz', 'option3': 'Battle of Leipzig', 'option4': 'Battle of Trafalgar', 'answer': 3},
        {'category_id': 12, 'question': 'Which philosopher is known for his work on the "Social Contract" and the philosophy of democracy?', 'option1': 'Jean-Jacques Rousseau', 'option2': 'John Locke', 'option3': 'Karl Marx', 'option4': 'Plato', 'answer': 1},
        {'category_id': 12, 'question': 'Which was the first country to grant women the right to vote?', 'option1': 'New Zealand', 'option2': 'Australia', 'option3': 'United States', 'option4': 'United Kingdom', 'answer': 1},
        {'category_id': 12, 'question': 'The Treaty of Versailles, which ended World War I, was signed in which year?', 'option1': '1919', 'option2': '1918', 'option3': '1920', 'option4': '1921', 'answer': 1},
        {'category_id': 12, 'question': 'What year did the Titanic sink?', 'option1': '1910', 'option2': '1912', 'option3': '1914', 'option4': '1908', 'answer': 2},
        {'category_id': 12, 'question': 'Which country was ruled by the Pharaohs?', 'option1': 'Greece', 'option2': 'Rome', 'option3': 'Egypt', 'option4': 'Persia', 'answer': 3},
        {'category_id': 12, 'question': 'What empire was known for its vast network of roads and military prowess in Europe and Asia?', 'option1': 'Roman Empire', 'option2': 'Ottoman Empire', 'option3': 'Mongol Empire', 'option4': 'Byzantine Empire', 'answer': 1},
        {'category_id': 12, 'question': 'Who was the last Tsar of Russia?', 'option1': 'Ivan IV', 'option2': 'Catherine the Great', 'option3': 'Tsar Nicholas II', 'option4': 'Peter the Great', 'answer': 3},
        {'category_id': 12, 'question': 'Which European country was known for its explorers during the Age of Exploration?', 'option1': 'Portugal', 'option2': 'Spain', 'option3': 'France', 'option4': 'England', 'answer': 1},
        {'category_id': 12, 'question': 'The Cold War was primarily a conflict between which two nations?', 'option1': 'USA and USSR', 'option2': 'USA and China', 'option3': 'USA and UK', 'option4': 'USSR and China', 'answer': 1},
        {'category_id': 12, 'question': 'Who was the first king of the Persian Empire?', 'option1': 'Cyrus the Great', 'option2': 'Darius the Great', 'option3': 'Xerxes I', 'option4': 'Cambyses II', 'answer': 1},
        {'category_id': 12, 'question': 'In which century did the Industrial Revolution begin?', 'option1': '16th Century', 'option2': '17th Century', 'option3': '18th Century', 'option4': '19th Century', 'answer': 3},
        {'category_id': 12, 'question': 'Who was the leader of the French Revolution?', 'option1': 'Napoleon Bonaparte', 'option2': 'Maximilien Robespierre', 'option3': 'Louis XVI', 'option4': 'Jean-Paul Marat', 'answer': 2},
        {'category_id': 12, 'question': 'The Great Depression began in which country?', 'option1': 'USA', 'option2': 'Germany', 'option3': 'France', 'option4': 'United Kingdom', 'answer': 1},
        {'category_id': 12, 'question': 'Which Roman emperor famously converted to Christianity?', 'option1': 'Julius Caesar', 'option2': 'Constantine', 'option3': 'Augustus', 'option4': 'Nero', 'answer': 2},
        {'category_id': 12, 'question': 'Which country was the center of the Ancient Mayan civilization?', 'option1': 'Mexico', 'option2': 'Guatemala', 'option3': 'Honduras', 'option4': 'Peru', 'answer': 2},
        {'category_id': 12, 'question': 'In what year did the Berlin Wall fall?', 'option1': '1987', 'option2': '1990', 'option3': '1989', 'option4': '1991', 'answer': 3},
        {'category_id': 12, 'question': 'Who was the first emperor of China?', 'option1': 'Qin Shi Huang', 'option2': 'Han Wudi', 'option3': 'Kublai Khan', 'option4': 'Sun Yat-sen', 'answer': 1},
        {'category_id': 12, 'question': 'Which famous battle occurred in 1066 between the Saxons and Normans?', 'option1': 'Battle of Hastings', 'option2': 'Battle of Agincourt', 'option3': 'Battle of Waterloo', 'option4': 'Battle of Gettysburg', 'answer': 1},
        {'category_id': 12, 'question': 'Who invented the printing press?', 'option1': 'Leonardo da Vinci', 'option2': 'Johannes Gutenberg', 'option3': 'Thomas Edison', 'option4': 'Albert Einstein', 'answer': 2},
        {'category_id': 12, 'question': 'Which war was fought between the Northern and Southern states of the United States?', 'option1': 'World War I', 'option2': 'World War II', 'option3': 'American Civil War', 'option4': 'Korean War', 'answer': 3},
        {'category_id': 12, 'question': 'Which empire was known for its pyramids and sphinx?', 'option1': 'Roman Empire', 'option2': 'Egyptian Empire', 'option3': 'Greek Empire', 'option4': 'Persian Empire', 'answer': 2},
        {'category_id': 12, 'question': 'Who was the leader of the Soviet Union during the Cuban Missile Crisis?', 'option1': 'Nikita Khrushchev', 'option2': 'Leonid Brezhnev', 'option3': 'Joseph Stalin', 'option4': 'Mikhail Gorbachev', 'answer': 1},
        {'category_id': 12, 'question': 'Which country was the birthplace of the Renaissance?', 'option1': 'France', 'option2': 'Germany', 'option3': 'Italy', 'option4': 'England', 'answer': 3},
        {'category_id': 12, 'question': 'In which battle did Napoleon Bonaparte meet his final defeat?', 'option1': 'Battle of Waterloo', 'option2': 'Battle of Leipzig', 'option3': 'Battle of Austerlitz', 'option4': 'Battle of Trafalgar', 'answer': 1},
        {'category_id': 12, 'question': 'Who was the first female Prime Minister of the United Kingdom?', 'option1': 'Margaret Thatcher', 'option2': 'Theresa May', 'option3': 'Queen Elizabeth I', 'option4': 'Emmeline Pankhurst', 'answer': 1},
        {'category_id': 12, 'question': 'What was the name of the first manned space mission to land on the Moon?', 'option1': 'Apollo 11', 'option2': 'Apollo 13', 'option3': 'Sputnik 1', 'option4': 'Gemini 4', 'answer': 1},
        {'category_id': 12, 'question': 'Which empire had the famous leader, Alexander the Great?', 'option1': 'Roman Empire', 'option2': 'Macedonian Empire', 'option3': 'Persian Empire', 'option4': 'Ottoman Empire', 'answer': 2},
        {'category_id': 12, 'question': 'Who was the first African-American president of the United States?', 'option1': 'Barack Obama', 'option2': 'Martin Luther King Jr.', 'option3': 'Colin Powell', 'option4': 'George Washington Carver', 'answer': 1},
        {'category_id': 12, 'question': 'Which ancient civilization created the first known system of writing?', 'option1': 'Egyptians', 'option2': 'Mesopotamians', 'option3': 'Indus Valley', 'option4': 'Mayans', 'answer': 2},
        {'category_id': 12, 'question': 'What was the main cause of the Opium Wars?', 'option1': 'Economic inequality', 'option2': 'China’s isolationism', 'option3': 'Opium trade', 'option4': 'Religion', 'answer': 3},
        {'category_id': 12, 'question': 'Which famous conflict occurred from 1914 to 1918?', 'option1': 'The Vietnam War', 'option2': 'The Korean War', 'option3': 'World War I', 'option4': 'The Gulf War', 'answer': 3},
        {'category_id': 12, 'question': 'Which event triggered the start of World War I?', 'option1': 'Assassination of Archduke Franz Ferdinand', 'option2': 'German invasion of Belgium', 'option3': 'Russian Revolution', 'option4': 'Treaty of Versailles', 'answer': 1},
        {'category_id': 12, 'question': 'Who was the first female leader of the United Kingdom?', 'option1': 'Margaret Thatcher', 'option2': 'Queen Elizabeth II', 'option3': 'Theresa May', 'option4': 'Emmeline Pankhurst', 'answer': 1},
        {'category_id': 12, 'question': 'Which conflict was known as "The Great War"?', 'option1': 'World War II', 'option2': 'World War I', 'option3': 'Vietnam War', 'option4': 'Korean War', 'answer': 2},
        {'category_id': 12, 'question': 'Who was the leader of the Bolshevik Revolution in 1917?', 'option1': 'Joseph Stalin', 'option2': 'Vladimir Lenin', 'option3': 'Leon Trotsky', 'option4': 'Nikita Khrushchev', 'answer': 2},
        {'category_id': 12, 'question': 'In what year did the French Revolution begin?', 'option1': '1789', 'option2': '1793', 'option3': '1804', 'option4': '1776', 'answer': 1},
        {'category_id': 12, 'question': 'What was the purpose of the Berlin Conference of 1884-1885?', 'option1': 'To divide Africa among European powers', 'option2': 'To form the League of Nations', 'option3': 'To resolve World War I', 'option4': 'To discuss the abolition of slavery', 'answer': 1},
        {'category_id': 12, 'question': 'Who was the first president of the United States?', 'option1': 'Thomas Jefferson', 'option2': 'George Washington', 'option3': 'Abraham Lincoln', 'option4': 'James Madison', 'answer': 2},
        {'category_id': 12, 'question': 'What was the purpose of the Marshall Plan?', 'option1': 'To promote democracy in the Middle East', 'option2': 'To assist in the recovery of post-World War II Europe', 'option3': 'To establish NATO', 'option4': 'To increase U.S. military presence in Asia', 'answer': 2},
        {'category_id': 12, 'question': 'Who was the first emperor of the Roman Empire?', 'option1': 'Julius Caesar', 'option2': 'Nero', 'option3': 'Augustus Caesar', 'option4': 'Trajan', 'answer': 3},
        {'category_id': 12, 'question': 'What ancient civilization built the famous Machu Picchu?', 'option1': 'Aztecs', 'option2': 'Incas', 'option3': 'Mayans', 'option4': 'Olmecs', 'answer': 2},
        {'category_id': 12, 'question': 'Who was the leader of the Nazi Party during World War II?', 'option1': 'Benito Mussolini', 'option2': 'Adolf Hitler', 'option3': 'Joseph Stalin', 'option4': 'Winston Churchill', 'answer': 2},
        {'category_id': 12, 'question': 'Which empire was known for its massive road network and aqueducts?', 'option1': 'Roman Empire', 'option2': 'Ottoman Empire', 'option3': 'Greek Empire', 'option4': 'Byzantine Empire', 'answer': 1},
        {'category_id': 12, 'question': 'Who led the Allied forces during the D-Day invasion of Normandy?', 'option1': 'General Dwight D. Eisenhower', 'option2': 'Winston Churchill', 'option3': 'General Patton', 'option4': 'Field Marshal Bernard Montgomery', 'answer': 1},
        {'category_id': 12, 'question': 'Which was the first country to grant women the right to vote?', 'option1': 'United States', 'option2': 'New Zealand', 'option3': 'United Kingdom', 'option4': 'Sweden', 'answer': 2},
        {'category_id': 12, 'question': 'In which year did the American Civil War end?', 'option1': '1863', 'option2': '1865', 'option3': '1870', 'option4': '1880', 'answer': 2},
        {'category_id': 12, 'question': 'Which event marked the end of the Cold War?', 'option1': 'The Fall of the Berlin Wall', 'option2': 'The Cuban Missile Crisis', 'option3': 'The Vietnam War', 'option4': 'The Yalta Conference', 'answer': 1},
        {'category_id': 12, 'question': 'Which country did the United States fight against in the Vietnam War?', 'option1': 'North Korea', 'option2': 'China', 'option3': 'South Vietnam', 'option4': 'North Vietnam', 'answer': 4},
        {'category_id': 12, 'question': 'What was the major reason behind the start of World War II?', 'option1': 'German aggression', 'option2': 'Japanese expansion', 'option3': 'The signing of the Treaty of Versailles', 'option4': 'The assassination of Archduke Franz Ferdinand', 'answer': 1},
        {'category_id': 12, 'question': 'Which Roman emperor is famous for initiating the persecution of Christians?', 'option1': 'Nero', 'option2': 'Augustus', 'option3': 'Tiberius', 'option4': 'Caligula', 'answer': 1},
        {'category_id': 12, 'question': 'What was the name of the first human to walk on the Moon?', 'option1': 'Neil Armstrong', 'option2': 'Buzz Aldrin', 'option3': 'Yuri Gagarin', 'option4': 'Alan Shepard', 'answer': 1},
        {'category_id': 12, 'question': 'Which king built the Great Wall of China?', 'option1': 'Emperor Qin Shi Huang', 'option2': 'Emperor Wu of Han', 'option3': 'Emperor Kangxi', 'option4': 'Emperor Taizong of Tang', 'answer': 1},
        {'category_id': 12, 'question': 'Who was the leader of the Mongol Empire?', 'option1': 'Kublai Khan', 'option2': 'Genghis Khan', 'option3': 'Tamerlane', 'option4': 'Attila the Hun', 'answer': 2},
        {'category_id': 12, 'question': 'In what year did the United States declare independence?', 'option1': '1775', 'option2': '1776', 'option3': '1783', 'option4': '1789', 'answer': 2},
      ];

      final sports = [
        {'category_id': 13, 'question': 'Who won the 2018 FIFA World Cup?', 'option1': 'France', 'option2': 'Germany', 'option3': 'Brazil', 'option4': 'Argentina', 'answer': 1},
        {'category_id': 13, 'question': 'Which country hosted the 2008 Summer Olympics?', 'option1': 'China', 'option2': 'Greece', 'option3': 'USA', 'option4': 'Australia', 'answer': 1},
        {'category_id': 13, 'question': 'In tennis, what is the term for a score of 40-40?', 'option1': 'Deuce', 'option2': 'Advantage', 'option3': 'Game point', 'option4': 'Set point', 'answer': 1},
        {'category_id': 13, 'question': 'Who holds the record for most goals in World Cup history?', 'option1': 'Marta', 'option2': 'Pele', 'option3': 'Cristiano Ronaldo', 'option4': 'Miroslav Klose', 'answer': 4},
        {'category_id': 13, 'question': 'What is the length of a standard marathon race?', 'option1': '42.195 kilometers', 'option2': '26 miles', 'option3': '40 kilometers', 'option4': '21.195 kilometers', 'answer': 1},
        {'category_id': 13, 'question': 'Which country won the most gold medals in the 2020 Summer Olympics?', 'option1': 'China', 'option2': 'USA', 'option3': 'Japan', 'option4': 'Germany', 'answer': 2},
        {'category_id': 13, 'question': 'Who holds the record for the fastest 100m sprint?', 'option1': 'Usain Bolt', 'option2': 'Tyson Gay', 'option3': 'Asafa Powell', 'option4': 'Carl Lewis', 'answer': 1},
        {'category_id': 13, 'question': 'In which sport is the Ryder Cup contested?', 'option1': 'Golf', 'option2': 'Tennis', 'option3': 'Cricket', 'option4': 'Football', 'answer': 1},
        {'category_id': 13, 'question': 'Which basketball player is known as "The King"?', 'option1': 'Kobe Bryant', 'option2': 'LeBron James', 'option3': 'Michael Jordan', 'option4': 'Shaquille O\'Neal', 'answer': 2},
        {'category_id': 13, 'question': 'Which country has won the most FIFA Women\'s World Cup titles?', 'option1': 'Germany', 'option2': 'USA', 'option3': 'Brazil', 'option4': 'Norway', 'answer': 2},
        {'category_id': 13, 'question': 'Who holds the record for the most home runs in MLB history?', 'option1': 'Barry Bonds', 'option2': 'Babe Ruth', 'option3': 'Hank Aaron', 'option4': 'Alex Rodriguez', 'answer': 1},
        {'category_id': 13, 'question': 'Which country won the first Rugby World Cup in 1987?', 'option1': 'New Zealand', 'option2': 'Australia', 'option3': 'South Africa', 'option4': 'England', 'answer': 1},
        {'category_id': 13, 'question': 'Who is known as the "Fastest Man in the World"?', 'option1': 'Usain Bolt', 'option2': 'Carl Lewis', 'option3': 'Tyson Gay', 'option4': 'Asafa Powell', 'answer': 1},
        {'category_id': 13, 'question': 'Which NFL team has the most Super Bowl victories?', 'option1': 'New England Patriots', 'option2': 'Dallas Cowboys', 'option3': 'Pittsburgh Steelers', 'option4': 'San Francisco 49ers', 'answer': 1},
        {'category_id': 13, 'question': 'Which swimmer is considered the greatest of all time with 23 Olympic gold medals?', 'option1': 'Michael Phelps', 'option2': 'Ian Thorpe', 'option3': 'Caeleb Dressel', 'option4': 'Mark Spitz', 'answer': 1},
        {'category_id': 13, 'question': 'In which sport is the term "ace" used?', 'option1': 'Tennis', 'option2': 'Golf', 'option3': 'Football', 'option4': 'Badminton', 'answer': 1},
        {'category_id': 13, 'question': 'Which tennis player has won the most Grand Slam singles titles?', 'option1': 'Roger Federer', 'option2': 'Rafael Nadal', 'option3': 'Serena Williams', 'option4': 'Novak Djokovic', 'answer': 4},
        {'category_id': 13, 'question': 'In which year was the first modern Olympic Games held?', 'option1': '1896', 'option2': '1900', 'option3': '1912', 'option4': '1924', 'answer': 1},
        {'category_id': 13, 'question': 'Which country is home to the sport of sumo wrestling?', 'option1': 'China', 'option2': 'Japan', 'option3': 'South Korea', 'option4': 'India', 'answer': 2},
        {'category_id': 13, 'question': 'What is the highest score possible in a single frame of bowling?', 'option1': '10', 'option2': '50', 'option3': '300', 'option4': '150', 'answer': 3},
        {'category_id': 13, 'question': 'Which football club won the UEFA Champions League in 2021?', 'option1': 'Manchester City', 'option2': 'Chelsea', 'option3': 'Bayern Munich', 'option4': 'Paris Saint-Germain', 'answer': 2},
        {'category_id': 13, 'question': 'Which country is known as the birthplace of cricket?', 'option1': 'Australia', 'option2': 'England', 'option3': 'India', 'option4': 'South Africa', 'answer': 2},
        {'category_id': 13, 'question': 'Who is the only player to win the FIFA World Cup three times?', 'option1': 'Pele', 'option2': 'Diego Maradona', 'option3': 'Cristiano Ronaldo', 'option4': 'Lionel Messi', 'answer': 1},
        {'category_id': 13, 'question': 'Which football player is known as "CR7"?', 'option1': 'Cristiano Ronaldo', 'option2': 'David Beckham', 'option3': 'Lionel Messi', 'option4': 'Neymar', 'answer': 1},
        {'category_id': 13, 'question': 'Which country won the first Rugby World Cup in 1987?', 'option1': 'New Zealand', 'option2': 'Australia', 'option3': 'South Africa', 'option4': 'England', 'answer': 1},
        {'category_id': 13, 'question': 'In which sport is the term "alley-oop" used?', 'option1': 'Basketball', 'option2': 'Football', 'option3': 'Volleyball', 'option4': 'Baseball', 'answer': 1},
        {'category_id': 13, 'question': 'Which country won the 2016 ICC T20 World Cup?', 'option1': 'India', 'option2': 'Sri Lanka', 'option3': 'West Indies', 'option4': 'Australia', 'answer': 3},
        {'category_id': 13, 'question': 'What is the national sport of Japan?', 'option1': 'Baseball', 'option2': 'Sumo', 'option3': 'Football', 'option4': 'Basketball', 'answer': 2},
        {'category_id': 13, 'question': 'Who is known as the "Greatest of All Time" (GOAT) in basketball?', 'option1': 'Kobe Bryant', 'option2': 'Michael Jordan', 'option3': 'LeBron James', 'option4': 'Magic Johnson', 'answer': 2},
        {'category_id': 13, 'question': 'Which country has the most Formula 1 World Drivers\' Championships?', 'option1': 'Germany', 'option2': 'Brazil', 'option3': 'United Kingdom', 'option4': 'Italy', 'answer': 3},
        {'category_id': 13, 'question': 'Who holds the record for the most goals in Premier League history?', 'option1': 'Wayne Rooney', 'option2': 'Sergio Aguero', 'option3': 'Thierry Henry', 'option4': 'Alan Shearer', 'answer': 4},
        {'category_id': 13, 'question': 'Which golfer is known as the "Golden Bear"?', 'option1': 'Tiger Woods', 'option2': 'Jack Nicklaus', 'option3': 'Arnold Palmer', 'option4': 'Phil Mickelson', 'answer': 2},
        {'category_id': 13, 'question': 'Which country won the first Rugby World Cup in 1987?', 'option1': 'New Zealand', 'option2': 'Australia', 'option3': 'South Africa', 'option4': 'England', 'answer': 1},
        {'category_id': 13, 'question': 'Who won the 2021 Formula 1 World Championship?', 'option1': 'Max Verstappen', 'option2': 'Lewis Hamilton', 'option3': 'Sebastian Vettel', 'option4': 'Valtteri Bottas', 'answer': 1},
        {'category_id': 13, 'question': 'In baseball, how many players are on the field for each team at a time?', 'option1': '7', 'option2': '9', 'option3': '10', 'option4': '11', 'answer': 2},
        {'category_id': 13, 'question': 'What is the term for a score of zero in tennis?', 'option1': 'Love', 'option2': 'Zero', 'option3': 'Nil', 'option4': 'Deuce', 'answer': 1},
        {'category_id': 13, 'question': 'Who is the all-time highest run-scorer in Test cricket?', 'option1': 'Sachin Tendulkar', 'option2': 'Ricky Ponting', 'option3': 'Jacques Kallis', 'option4': 'Brian Lara', 'answer': 1},
        {'category_id': 13, 'question': 'Which football player holds the record for the most goals in a calendar year?', 'option1': 'Lionel Messi', 'option2': 'Cristiano Ronaldo', 'option3': 'Pele', 'option4': 'David Villa', 'answer': 1},
        {'category_id': 13, 'question': 'Which sport is associated with the Stanley Cup?', 'option1': 'Basketball', 'option2': 'Football', 'option3': 'Ice Hockey', 'option4': 'Baseball', 'answer': 3},
        {'category_id': 13, 'question': 'Who is the first woman to win an Olympic boxing gold medal?', 'option1': 'Nicola Adams', 'option2': 'Clarissa Shields', 'option3': 'Katie Taylor', 'option4': 'Michaela Walsh', 'answer': 1},
        {'category_id': 13, 'question': 'Who holds the record for the most goals in the history of the UEFA Champions League?', 'option1': 'Cristiano Ronaldo', 'option2': 'Lionel Messi', 'option3': 'Raul', 'option4': 'Karim Benzema', 'answer': 1},
        {'category_id': 13, 'question': 'Which country won the 2015 ICC Cricket World Cup?', 'option1': 'India', 'option2': 'Australia', 'option3': 'South Africa', 'option4': 'New Zealand', 'answer': 2},
        {'category_id': 13, 'question': 'Who won the 2022 FIFA World Cup?', 'option1': 'Argentina', 'option2': 'France', 'option3': 'Brazil', 'option4': 'Germany', 'answer': 1},
        {'category_id': 13, 'question': 'Which country won the 2021 ICC T20 World Cup?', 'option1': 'India', 'option2': 'Australia', 'option3': 'West Indies', 'option4': 'New Zealand', 'answer': 2},
        {'category_id': 13, 'question': 'What is the maximum number of players allowed on a football (soccer) team?', 'option1': '11', 'option2': '12', 'option3': '10', 'option4': '14', 'answer': 1},
        {'category_id': 13, 'question': 'Who won the 2016 NBA Finals?', 'option1': 'Miami Heat', 'option2': 'Golden State Warriors', 'option3': 'Cleveland Cavaliers', 'option4': 'San Antonio Spurs', 'answer': 3},
        {'category_id': 13, 'question': 'Which country has the most Olympic gold medals in swimming?', 'option1': 'USA', 'option2': 'Australia', 'option3': 'China', 'option4': 'Germany', 'answer': 1},
        {'category_id': 13, 'question': 'In which year did Usain Bolt break the 100m world record?', 'option1': '2008', 'option2': '2009', 'option3': '2010', 'option4': '2012', 'answer': 2},
        {'category_id': 13, 'question': 'Which team has won the most NBA championships?', 'option1': 'Los Angeles Lakers', 'option2': 'Boston Celtics', 'option3': 'Chicago Bulls', 'option4': 'Miami Heat', 'answer': 1},
        {'category_id': 13, 'question': 'Who is the only player to have won the Ballon d\'Or five times?', 'option1': 'Cristiano Ronaldo', 'option2': 'Lionel Messi', 'option3': 'Zinedine Zidane', 'option4': 'Ronaldo Nazario', 'answer': 2},
        {'category_id': 13, 'question': 'Which sport is the Tour de France associated with?', 'option1': 'Cycling', 'option2': 'Tennis', 'option3': 'Football', 'option4': 'Golf', 'answer': 1},
        {'category_id': 13, 'question': 'Which country is known for having the best ice hockey team?', 'option1': 'Russia', 'option2': 'Canada', 'option3': 'USA', 'option4': 'Sweden', 'answer': 2},
        {'category_id': 13, 'question': 'Who holds the record for the most points in an NBA game?', 'option1': 'Kobe Bryant', 'option2': 'Michael Jordan', 'option3': 'Wilt Chamberlain', 'option4': 'LeBron James', 'answer': 3},
        {'category_id': 13, 'question': 'Which country has won the most Rugby World Cups?', 'option1': 'New Zealand', 'option2': 'Australia', 'option3': 'South Africa', 'option4': 'England', 'answer': 1},
        {'category_id': 13, 'question': 'Which player is known as the "Fastest Man Alive" in the world of athletics?', 'option1': 'Usain Bolt', 'option2': 'Tyson Gay', 'option3': 'Asafa Powell', 'option4': 'Yohan Blake', 'answer': 1},
        {'category_id': 13, 'question': 'Which athlete has the most Olympic gold medals in history?', 'option1': 'Michael Phelps', 'option2': 'Larisa Latynina', 'option3': 'Paavo Nurmi', 'option4': 'Carl Lewis', 'answer': 1},
        {'category_id': 13, 'question': 'In which sport would you use a shuttlecock?', 'option1': 'Badminton', 'option2': 'Tennis', 'option3': 'Ping Pong', 'option4': 'Volleyball', 'answer': 1},
        {'category_id': 13, 'question': 'Which country hosted the 2014 FIFA World Cup?', 'option1': 'Germany', 'option2': 'Brazil', 'option3': 'South Africa', 'option4': 'Russia', 'answer': 2},
        {'category_id': 13, 'question': 'Who won the 2018 Wimbledon tennis tournament men\'s singles?', 'option1': 'Novak Djokovic', 'option2': 'Roger Federer', 'option3': 'Rafael Nadal', 'option4': 'Andy Murray', 'answer': 1},
        {'category_id': 13, 'question': 'Which country has won the most Cricket World Cup titles?', 'option1': 'Australia', 'option2': 'India', 'option3': 'West Indies', 'option4': 'England', 'answer': 1},
        {'category_id': 13, 'question': 'Which tennis player has won the most career Grand Slam singles titles?', 'option1': 'Rafael Nadal', 'option2': 'Serena Williams', 'option3': 'Novak Djokovic', 'option4': 'Roger Federer', 'answer': 3},
        {'category_id': 13, 'question': 'Which athlete is known as "The Greatest" in boxing?', 'option1': 'Mike Tyson', 'option2': 'Muhammad Ali', 'option3': 'George Foreman', 'option4': 'Floyd Mayweather', 'answer': 2},
        {'category_id': 13, 'question': 'Which NBA team won the 2020 NBA Finals?', 'option1': 'Los Angeles Lakers', 'option2': 'Miami Heat', 'option3': 'Golden State Warriors', 'option4': 'Toronto Raptors', 'answer': 1},
        {'category_id': 13, 'question': 'Which player won the 2021 US Open men\'s singles title?', 'option1': 'Novak Djokovic', 'option2': 'Rafael Nadal', 'option3': 'Daniil Medvedev', 'option4': 'Alexander Zverev', 'answer': 3},
        {'category_id': 13, 'question': 'Who won the 2020 Tour de France?', 'option1': 'Chris Froome', 'option2': 'Egan Bernal', 'option3': 'Tadej Pogacar', 'option4': 'Geraint Thomas', 'answer': 3},
        {'category_id': 13, 'question': 'Who won the 2020 NFL MVP Award?', 'option1': 'Patrick Mahomes', 'option2': 'Aaron Rodgers', 'option3': 'Derrick Henry', 'option4': 'Russell Wilson', 'answer': 2},
        {'category_id': 13, 'question': 'Who is the top scorer in NFL history?', 'option1': 'Tom Brady', 'option2': 'Peyton Manning', 'option3': 'Adam Vinatieri', 'option4': 'Jerry Rice', 'answer': 3},
        {'category_id': 13, 'question': 'Which country has the most Olympic gold medals in football (soccer)?', 'option1': 'Brazil', 'option2': 'Argentina', 'option3': 'Germany', 'option4': 'Mexico', 'answer': 1},
        {'category_id': 13, 'question': 'In which city were the 2008 Summer Olympics held?', 'option1': 'Beijing', 'option2': 'Athens', 'option3': 'London', 'option4': 'Sydney', 'answer': 1},
        {'category_id': 13, 'question': 'Which baseball player hit the first-ever home run in MLB history?', 'option1': 'Babe Ruth', 'option2': 'Jackie Robinson', 'option3': 'Lou Gehrig', 'option4': 'Mickey Mantle', 'answer': 1},
        {'category_id': 13, 'question': 'Who holds the record for most Grand Slam singles titles in women\'s tennis?', 'option1': 'Serena Williams', 'option2': 'Steffi Graf', 'option3': 'Venus Williams', 'option4': 'Martina Navratilova', 'answer': 1},
        {'category_id': 13, 'question': 'Which country won the 2019 Rugby World Cup?', 'option1': 'New Zealand', 'option2': 'South Africa', 'option3': 'England', 'option4': 'Wales', 'answer': 2},
        {'category_id': 13, 'question': 'Who won the 2022 Winter Olympics in the women\'s singles figure skating?', 'option1': 'Kamila Valieva', 'option2': 'Alina Zagitova', 'option3': 'Yuzuru Hanyu', 'option4': 'Anna Shcherbakova', 'answer': 4},
        {'category_id': 13, 'question': 'Which athlete holds the record for the most gold medals in Olympic history?', 'option1': 'Michael Phelps', 'option2': 'Carl Lewis', 'option3': 'Larisa Latynina', 'option4': 'Paavo Nurmi', 'answer': 1},
        {'category_id': 13, 'question': 'Who won the 2021 UEFA Champions League?', 'option1': 'Manchester City', 'option2': 'Chelsea', 'option3': 'Paris Saint-Germain', 'option4': 'Bayern Munich', 'answer': 2},
        {'category_id': 13, 'question': 'Which country won the most gold medals in the 2020 Summer Olympics?', 'option1': 'China', 'option2': 'USA', 'option3': 'Japan', 'option4': 'Great Britain', 'answer': 2},
        {'category_id': 13, 'question': 'Which player scored the most goals in the 2014 FIFA World Cup?', 'option1': 'Lionel Messi', 'option2': 'Neymar', 'option3': 'James Rodríguez', 'option4': 'Cristiano Ronaldo', 'answer': 3},
        {'category_id': 13, 'question': 'Which tennis player has won the most titles at Wimbledon?', 'option1': 'Roger Federer', 'option2': 'Rafael Nadal', 'option3': 'Novak Djokovic', 'option4': 'Pete Sampras', 'answer': 1},
        {'category_id': 13, 'question': 'Who is the only player to have won the Ballon d\'Or five times?', 'option1': 'Cristiano Ronaldo', 'option2': 'Lionel Messi', 'option3': 'Zinedine Zidane', 'option4': 'Ronaldo Nazario', 'answer': 2},
        {'category_id': 13, 'question': 'Who won the 2019 ICC Cricket World Cup?', 'option1': 'India', 'option2': 'England', 'option3': 'Australia', 'option4': 'New Zealand', 'answer': 2},
        {'category_id': 13, 'question': 'Which country is the birthplace of tennis legend Serena Williams?', 'option1': 'United Kingdom', 'option2': 'USA', 'option3': 'France', 'option4': 'Australia', 'answer': 2},
        {'category_id': 13, 'question': 'What sport does the term "home run" belong to?', 'option1': 'Baseball', 'option2': 'Basketball', 'option3': 'Football', 'option4': 'Hockey', 'answer': 1},
        {'category_id': 13, 'question': 'Which country has won the most Rugby World Cup titles?', 'option1': 'New Zealand', 'option2': 'South Africa', 'option3': 'Australia', 'option4': 'England', 'answer': 1},
        {'category_id': 13, 'question': 'Which tennis player holds the record for the most Grand Slam singles titles?', 'option1': 'Roger Federer', 'option2': 'Serena Williams', 'option3': 'Novak Djokovic', 'option4': 'Rafael Nadal', 'answer': 3},
        {'category_id': 13, 'question': 'Who won the 2020 US Open women\'s singles title?', 'option1': 'Serena Williams', 'option2': 'Naomi Osaka', 'option3': 'Venus Williams', 'option4': 'Simona Halep', 'answer': 2},
        {'category_id': 13, 'question': 'Which football team has won the most Super Bowl titles?', 'option1': 'Dallas Cowboys', 'option2': 'New England Patriots', 'option3': 'Pittsburgh Steelers', 'option4': 'San Francisco 49ers', 'answer': 2},
        {'category_id': 13, 'question': 'Who was the first player to win five NBA MVP awards?', 'option1': 'Kareem Abdul-Jabbar', 'option2': 'Michael Jordan', 'option3': 'LeBron James', 'option4': 'Magic Johnson', 'answer': 1},
        {'category_id': 13, 'question': 'Which country won the 2016 Rugby World Cup?', 'option1': 'New Zealand', 'option2': 'South Africa', 'option3': 'Australia', 'option4': 'England', 'answer': 1},
        {'category_id': 13, 'question': 'Which athlete set the world record in the 100 meters in 2009?', 'option1': 'Usain Bolt', 'option2': 'Tyson Gay', 'option3': 'Asafa Powell', 'option4': 'Justin Gatlin', 'answer': 1},
        {'category_id': 13, 'question': 'Which country won the 2021 Copa América?', 'option1': 'Brazil', 'option2': 'Argentina', 'option3': 'Chile', 'option4': 'Colombia', 'answer': 2},
        {'category_id': 13, 'question': 'Who holds the record for the most goals in a single FIFA World Cup tournament?', 'option1': 'Pele', 'option2': 'Marta', 'option3': 'Just Fontaine', 'option4': 'Miroslav Klose', 'answer': 3},
        {'category_id': 13, 'question': 'Which team won the 2015 UEFA Champions League?', 'option1': 'Bayern Munich', 'option2': 'Barcelona', 'option3': 'Real Madrid', 'option4': 'Chelsea', 'answer': 2},
        {'category_id': 13, 'question': 'Who won the 2012 Wimbledon men\'s singles title?', 'option1': 'Roger Federer', 'option2': 'Andy Murray', 'option3': 'Novak Djokovic', 'option4': 'Rafael Nadal', 'answer': 2},
        {'category_id': 13, 'question': 'Which country hosted the 2018 Winter Olympics?', 'option1': 'United States', 'option2': 'Canada', 'option3': 'South Korea', 'option4': 'Russia', 'answer': 3},
        {'category_id': 13, 'question': 'Who holds the record for the most goals scored in a single La Liga season?', 'option1': 'Lionel Messi', 'option2': 'Cristiano Ronaldo', 'option3': 'Karim Benzema', 'option4': 'Luis Suárez', 'answer': 1},
        {'category_id': 13, 'question': 'Which country won the 2021 UEFA Euro Championship?', 'option1': 'France', 'option2': 'Portugal', 'option3': 'Italy', 'option4': 'England', 'answer': 3},
        {'category_id': 13, 'question': 'Which player holds the record for the most home runs in Major League Baseball?', 'option1': 'Barry Bonds', 'option2': 'Hank Aaron', 'option3': 'Babe Ruth', 'option4': 'Alex Rodriguez', 'answer': 1},
        {'category_id': 13, 'question': 'Which athlete is known as "The King" in basketball?', 'option1': 'Shaquille O\'Neal', 'option2': 'Michael Jordan', 'option3': 'Kareem Abdul-Jabbar', 'option4': 'LeBron James', 'answer': 4},
      ];

      final physical_fit_exercises = [
        {'category_id': 14, 'question': 'Which exercise is best for strengthening the core?', 'option1': 'Crunches', 'option2': 'Squats', 'option3': 'Push-ups', 'option4': 'Deadlifts', 'answer': 1},
        {'category_id': 14, 'question': 'What is the recommended duration for a moderate-intensity workout?', 'option1': '10 minutes', 'option2': '30 minutes', 'option3': '60 minutes', 'option4': '90 minutes', 'answer': 2},
        {'category_id': 14, 'question': 'Which exercise helps to improve flexibility?', 'option1': 'Running', 'option2': 'Yoga', 'option3': 'Cycling', 'option4': 'Push-ups', 'answer': 2},
        {'category_id': 14, 'question': 'What type of exercise is swimming?', 'option1': 'Aerobic', 'option2': 'Strength training', 'option3': 'Flexibility', 'option4': 'Balance training', 'answer': 1},
        {'category_id': 14, 'question': 'Which of the following is a benefit of aerobic exercise?', 'option1': 'Improves bone density', 'option2': 'Increases heart rate', 'option3': 'Builds muscle mass', 'option4': 'Increases flexibility', 'answer': 2},
        {'category_id': 14, 'question': 'What is the main purpose of strength training exercises?', 'option1': 'Improve cardiovascular health', 'option2': 'Increase muscle strength', 'option3': 'Increase flexibility', 'option4': 'Burn fat', 'answer': 2},
        {'category_id': 14, 'question': 'Which of the following exercises is a form of resistance training?', 'option1': 'Running', 'option2': 'Swimming', 'option3': 'Weight lifting', 'option4': 'Cycling', 'answer': 3},
        {'category_id': 14, 'question': 'Which exercise is most effective for building leg muscles?', 'option1': 'Leg press', 'option2': 'Bicep curls', 'option3': 'Pull-ups', 'option4': 'Crunches', 'answer': 1},
        {'category_id': 14, 'question': 'How many times per week is it recommended to perform strength training?', 'option1': 'Once', 'option2': 'Twice', 'option3': 'Three to four times', 'option4': 'Every day', 'answer': 3},
        {'category_id': 14, 'question': 'Which of these exercises primarily targets the chest?', 'option1': 'Pull-ups', 'option2': 'Push-ups', 'option3': 'Squats', 'option4': 'Leg raises', 'answer': 2},
        {'category_id': 14, 'question': 'What is the best time to do cardio workouts?', 'option1': 'In the morning', 'option2': 'In the evening', 'option3': 'Any time of the day', 'option4': 'After dinner', 'answer': 3},
        {'category_id': 14, 'question': 'Which of the following exercises targets the biceps?', 'option1': 'Leg press', 'option2': 'Push-ups', 'option3': 'Bicep curls', 'option4': 'Planks', 'answer': 3},
        {'category_id': 14, 'question': 'What is the primary benefit of doing aerobic exercise?', 'option1': 'Builds muscle mass', 'option2': 'Improves cardiovascular health', 'option3': 'Increases flexibility', 'option4': 'Improves posture', 'answer': 2},
        {'category_id': 14, 'question': 'What should you drink after an intense workout?', 'option1': 'Water', 'option2': 'Fruit juice', 'option3': 'Coffee', 'option4': 'Soft drinks', 'answer': 1},
        {'category_id': 14, 'question': 'How many days per week should you perform flexibility exercises?', 'option1': 'Once', 'option2': 'Twice', 'option3': 'Three times', 'option4': 'Every day', 'answer': 4},
        {'category_id': 14, 'question': 'Which muscle group is worked when performing squats?', 'option1': 'Chest', 'option2': 'Arms', 'option3': 'Legs', 'option4': 'Back', 'answer': 3},
        {'category_id': 14, 'question': 'What is a benefit of interval training?', 'option1': 'Increases endurance', 'option2': 'Improves flexibility', 'option3': 'Builds muscle', 'option4': 'Increases metabolism', 'answer': 1},
        {'category_id': 14, 'question': 'What is the recommended amount of sleep for recovery after intense exercise?', 'option1': '5-6 hours', 'option2': '7-9 hours', 'option3': '10-12 hours', 'option4': '3-4 hours', 'answer': 2},
        {'category_id': 14, 'question': 'What type of exercise is jogging?', 'option1': 'Strength training', 'option2': 'Aerobic exercise', 'option3': 'Flexibility exercise', 'option4': 'Balance exercise', 'answer': 2},
        {'category_id': 14, 'question': 'What is the main goal of doing a warm-up before exercise?', 'option1': 'To increase muscle mass', 'option2': 'To prepare the body for exercise and prevent injury', 'option3': 'To increase body fat', 'option4': 'To cool down the body', 'answer': 2},
        {'category_id': 14, 'question': 'What type of exercise can help in weight loss?', 'option1': 'Cardio exercises', 'option2': 'Strength training', 'option3': 'Both cardio and strength training', 'option4': 'Flexibility exercises', 'answer': 3},
        {'category_id': 14, 'question': 'Which exercise is best for improving posture?', 'option1': 'Push-ups', 'option2': 'Planks', 'option3': 'Leg curls', 'option4': 'Squats', 'answer': 2},
        {'category_id': 14, 'question': 'Which muscle is primarily targeted by push-ups?', 'option1': 'Triceps', 'option2': 'Biceps', 'option3': 'Chest', 'option4': 'Shoulders', 'answer': 3},
        {'category_id': 14, 'question': 'Which exercise helps to improve balance?', 'option1': 'Planks', 'option2': 'Yoga', 'option3': 'Crunches', 'option4': 'Running', 'answer': 2},
        {'category_id': 14, 'question': 'Which type of workout helps improve aerobic capacity?', 'option1': 'Weight lifting', 'option2': 'HIIT (High-Intensity Interval Training)', 'option3': 'Yoga', 'option4': 'Pilates', 'answer': 2},
        {'category_id': 14, 'question': 'What is the most important part of a workout routine?', 'option1': 'Cardio', 'option2': 'Strength training', 'option3': 'Rest and recovery', 'option4': 'Consistency', 'answer': 4},
        {'category_id': 14, 'question': 'How long should a stretching session last?', 'option1': '2-5 minutes', 'option2': '10-15 minutes', 'option3': '30 minutes', 'option4': '1 hour', 'answer': 2},
        {'category_id': 14, 'question': 'What is the best way to stay hydrated during a workout?', 'option1': 'Drinking only water', 'option2': 'Drinking water and sports drinks', 'option3': 'Drinking water before and after the workout', 'option4': 'Drinking only energy drinks', 'answer': 3},
        {'category_id': 14, 'question': 'Which of these exercises helps to strengthen the back muscles?', 'option1': 'Squats', 'option2': 'Deadlifts', 'option3': 'Pull-ups', 'option4': 'Leg curls', 'answer': 2},
        {'category_id': 14, 'question': 'What is the primary benefit of performing high-intensity interval training (HIIT)?', 'option1': 'Increased strength', 'option2': 'Fat loss and improved cardiovascular health', 'option3': 'Improved flexibility', 'option4': 'Increased muscle mass', 'answer': 2},
        {'category_id': 14, 'question': 'What should you focus on during the cool-down period after a workout?', 'option1': 'Cardio exercises', 'option2': 'Strength training', 'option3': 'Stretching and relaxation', 'option4': 'Jumping jacks', 'answer': 3},
        {'category_id': 14, 'question': 'Which exercise targets the glutes and hamstrings?', 'option1': 'Squats', 'option2': 'Lunges', 'option3': 'Deadlifts', 'option4': 'Push-ups', 'answer': 3},
        {'category_id': 14, 'question': 'How often should flexibility exercises be performed to improve range of motion?', 'option1': 'Once a week', 'option2': 'Twice a week', 'option3': 'Three to four times a week', 'option4': 'Every day', 'answer': 3},
        {'category_id': 14, 'question': 'What type of exercise should you focus on to improve bone health?', 'option1': 'Cardio', 'option2': 'Strength training', 'option3': 'Flexibility', 'option4': 'Balance exercises', 'answer': 2},
        {'category_id': 14, 'question': 'What is a primary benefit of doing strength training exercises for seniors?', 'option1': 'Improves bone density and reduces fall risk', 'option2': 'Increases cardiovascular endurance', 'option3': 'Helps in weight loss', 'option4': 'Improves flexibility', 'answer': 1},
        {'category_id': 14, 'question': 'Which of the following is a great exercise for improving cardiovascular health?', 'option1': 'Walking', 'option2': 'Yoga', 'option3': 'Weight lifting', 'option4': 'Pilates', 'answer': 1},
        {'category_id': 14, 'question': 'What is the best exercise to build endurance?', 'option1': 'Running', 'option2': 'Weight lifting', 'option3': 'Cycling', 'option4': 'Both running and cycling', 'answer': 4},
        {'category_id': 14, 'question': 'What is an example of a plyometric exercise?', 'option1': 'Push-ups', 'option2': 'Box jumps', 'option3': 'Yoga poses', 'option4': 'Bicep curls', 'answer': 2},
        {'category_id': 14, 'question': 'How can you prevent injuries during a workout?', 'option1': 'By wearing comfortable clothes', 'option2': 'By warming up before exercise', 'option3': 'By doing high-intensity workouts only', 'option4': 'By working out every day', 'answer': 2},
        {'category_id': 14, 'question': 'What should you focus on when performing a deadlift?', 'option1': 'Hamstrings and glutes', 'option2': 'Chest and shoulders', 'option3': 'Core and back', 'option4': 'Legs and calves', 'answer': 1},
        {'category_id': 14, 'question': 'How can you measure the intensity of your workout?', 'option1': 'By the duration of the workout', 'option2': 'By heart rate or perceived exertion', 'option3': 'By the type of exercise', 'option4': 'By the calories burned', 'answer': 2},
        {'category_id': 14, 'question': 'What type of exercise is a burpee?', 'option1': 'Strength exercise', 'option2': 'Cardio exercise', 'option3': 'Flexibility exercise', 'option4': 'Balance exercise', 'answer': 2},
        {'category_id': 14, 'question': 'Which of these exercises helps improve leg strength?', 'option1': 'Push-ups', 'option2': 'Lunges', 'option3': 'Planks', 'option4': 'Crunches', 'answer': 2},
        {'category_id': 14, 'question': 'What is the primary purpose of cardiovascular exercise?', 'option1': 'To increase muscle size', 'option2': 'To improve heart and lung function', 'option3': 'To improve flexibility', 'option4': 'To increase balance and coordination', 'answer': 2},
        {'category_id': 14, 'question': 'Which of these exercises improves core stability?', 'option1': 'Squats', 'option2': 'Planks', 'option3': 'Lunges', 'option4': 'Deadlifts', 'answer': 2},
        {'category_id': 14, 'question': 'What is the main goal of doing high-intensity interval training (HIIT)?', 'option1': 'To build endurance', 'option2': 'To build muscle mass', 'option3': 'To improve flexibility', 'option4': 'To burn fat and improve cardiovascular health', 'answer': 4},
        {'category_id': 14, 'question': 'Which of these exercises is best for toning the arms?', 'option1': 'Push-ups', 'option2': 'Deadlifts', 'option3': 'Squats', 'option4': 'Leg raises', 'answer': 1},
        {'category_id': 14, 'question': 'Which of the following should be avoided during a warm-up?', 'option1': 'Gentle stretching', 'option2': 'Dynamic movements', 'option3': 'Heavy lifting', 'option4': 'Light cardio', 'answer': 3},
        {'category_id': 14, 'question': 'Which type of workout is best for improving agility?', 'option1': 'Running', 'option2': 'Yoga', 'option3': 'Plyometric exercises', 'option4': 'Weightlifting', 'answer': 3},
        {'category_id': 14, 'question': 'What is an example of a balance exercise?', 'option1': 'Jump rope', 'option2': 'Standing on one leg', 'option3': 'Lunges', 'option4': 'Push-ups', 'answer': 2},
        {'category_id': 14, 'question': 'What is the best exercise to improve cardiovascular endurance?', 'option1': 'Cycling', 'option2': 'Weight training', 'option3': 'Yoga', 'option4': 'Pilates', 'answer': 1},
        {'category_id': 14, 'question': 'Which muscle group is targeted by squats?', 'option1': 'Chest', 'option2': 'Legs', 'option3': 'Arms', 'option4': 'Back', 'answer': 2},
        {'category_id': 14, 'question': 'What type of exercise is push-up?', 'option1': 'Strength training', 'option2': 'Cardiovascular', 'option3': 'Balance training', 'option4': 'Flexibility', 'answer': 1},
        {'category_id': 14, 'question': 'How long should you rest between strength training sets?', 'option1': '30 seconds', 'option2': '1-2 minutes', 'option3': '3-4 minutes', 'option4': '5-6 minutes', 'answer': 2},
        {'category_id': 14, 'question': 'What is the purpose of stretching before a workout?', 'option1': 'To relax muscles', 'option2': 'To improve flexibility and prevent injury', 'option3': 'To build muscle', 'option4': 'To increase heart rate', 'answer': 2},
        {'category_id': 14, 'question': 'How can you improve your posture through exercise?', 'option1': 'By doing weightlifting exercises', 'option2': 'By focusing on chest exercises only', 'option3': 'By doing back and core strengthening exercises', 'option4': 'By doing leg exercises', 'answer': 3},
        {'category_id': 14, 'question': 'What type of exercise is yoga?', 'option1': 'Strength training', 'option2': 'Flexibility and balance training', 'option3': 'Cardiovascular exercise', 'option4': 'High-intensity interval training', 'answer': 2},
        {'category_id': 14, 'question': 'How often should aerobic exercises be performed for optimal health?', 'option1': '3-5 times a week', 'option2': 'Every day', 'option3': 'Once a week', 'option4': 'Twice a month', 'answer': 1},
        {'category_id': 14, 'question': 'What is the primary benefit of doing leg exercises?', 'option1': 'Improved cardiovascular health', 'option2': 'Increased leg strength and muscle tone', 'option3': 'Improved flexibility', 'option4': 'Increased endurance', 'answer': 2},
        {'category_id': 14, 'question': 'What is the key to a successful workout routine?', 'option1': 'Intensity', 'option2': 'Duration', 'option3': 'Variety and consistency', 'option4': 'Speed', 'answer': 3},
        {'category_id': 14, 'question': 'What is an example of a bodyweight exercise?', 'option1': 'Push-ups', 'option2': 'Leg press', 'option3': 'Deadlifts', 'option4': 'Bicep curls', 'answer': 1},
        {'category_id': 14, 'question': 'Which exercise is best for improving overall body strength?', 'option1': 'Squats', 'option2': 'Planks', 'option3': 'Deadlifts', 'option4': 'Push-ups', 'answer': 3},
        {'category_id': 14, 'question': 'What type of exercise helps to improve posture and reduce back pain?', 'option1': 'Weightlifting', 'option2': 'Core strengthening exercises', 'option3': 'Cardiovascular exercise', 'option4': 'Leg exercises', 'answer': 2},
        {'category_id': 14, 'question': 'How can you track your fitness progress?', 'option1': 'By tracking weight only', 'option2': 'By measuring performance improvements', 'option3': 'By checking body measurements', 'option4': 'All of the above', 'answer': 4},
        {'category_id': 14, 'question': 'Which of the following is an example of a cardiovascular exercise?', 'option1': 'Deadlifts', 'option2': 'Cycling', 'option3': 'Push-ups', 'option4': 'Lunges', 'answer': 2},
        {'category_id': 14, 'question': 'How often should you vary your workout routine?', 'option1': 'Every 1-2 weeks', 'option2': 'Every month', 'option3': 'Every 6 months', 'option4': 'Once a year', 'answer': 1},
        {'category_id': 14, 'question': 'What is the main function of the quadriceps?', 'option1': 'Flexing the knee', 'option2': 'Extending the knee', 'option3': 'Stabilizing the shoulder', 'option4': 'Flexing the hip', 'answer': 2},
        {'category_id': 14, 'question': 'What is the most effective way to prevent muscle soreness after a workout?', 'option1': 'Stretching after the workout', 'option2': 'Avoiding workouts completely', 'option3': 'Performing high-intensity workouts', 'option4': 'Drinking protein shakes immediately after exercise', 'answer': 1},
        {'category_id': 14, 'question': 'Which exercise works the triceps?', 'option1': 'Bicep curls', 'option2': 'Tricep dips', 'option3': 'Push-ups', 'option4': 'Squats', 'answer': 2},
        {'category_id': 14, 'question': 'How do you increase muscle endurance?', 'option1': 'By lifting heavy weights', 'option2': 'By performing more repetitions with lighter weights', 'option3': 'By only doing cardio', 'option4': 'By resting more between sets', 'answer': 2},
        {'category_id': 14, 'question': 'What is a benefit of doing regular stretching exercises?', 'option1': 'Increases muscle size', 'option2': 'Improves flexibility and range of motion', 'option3': 'Increases muscle endurance', 'option4': 'Improves cardiovascular health', 'answer': 2},
        {'category_id': 14, 'question': 'Which exercise primarily targets the abdominal muscles?', 'option1': 'Crunches', 'option2': 'Squats', 'option3': 'Push-ups', 'option4': 'Lunges', 'answer': 1},
        {'category_id': 14, 'question': 'What does BMI stand for?', 'option1': 'Body Mass Index', 'option2': 'Body Muscle Index', 'option3': 'Body Metabolism Index', 'option4': 'Basic Metabolic Index', 'answer': 1},
        {'category_id': 14, 'question': 'What is the main benefit of aerobic exercise?', 'option1': 'Increased muscle strength', 'option2': 'Improved lung capacity and cardiovascular health', 'option3': 'Increased bone density', 'option4': 'Improved flexibility', 'answer': 2},
        {'category_id': 14, 'question': 'Which of the following exercises is considered a low-impact exercise?', 'option1': 'Running', 'option2': 'Swimming', 'option3': 'Jumping jacks', 'option4': 'Burpees', 'answer': 2},
        {'category_id': 14, 'question': 'What is the main purpose of resistance training?', 'option1': 'To improve flexibility', 'option2': 'To increase muscle mass and strength', 'option3': 'To improve cardiovascular health', 'option4': 'To increase bone mass', 'answer': 2},
        {'category_id': 14, 'question': 'What does the term “repetition” mean in weight training?', 'option1': 'The number of times an exercise is done continuously', 'option2': 'The amount of rest between sets', 'option3': 'The weight lifted in a set', 'option4': 'The number of sets performed in an exercise', 'answer': 1},
        {'category_id': 14, 'question': 'Which of the following exercises is best for improving upper body strength?', 'option1': 'Push-ups', 'option2': 'Leg raises', 'option3': 'Deadlifts', 'option4': 'Squats', 'answer': 1},
        {'category_id': 14, 'question': 'What is the primary muscle group targeted by lunges?', 'option1': 'Back', 'option2': 'Chest', 'option3': 'Legs and glutes', 'option4': 'Arms', 'answer': 3},
        {'category_id': 14, 'question': 'What type of exercise is running?', 'option1': 'Strength training', 'option2': 'Cardio exercise', 'option3': 'Balance training', 'option4': 'Flexibility training', 'answer': 2},
        {'category_id': 14, 'question': 'Which of these exercises helps improve flexibility?', 'option1': 'Plank', 'option2': 'Squats', 'option3': 'Yoga', 'option4': 'Push-ups', 'answer': 3},
        {'category_id': 14, 'question': 'Which of these activities is considered a high-intensity interval training (HIIT) exercise?', 'option1': 'Walking', 'option2': 'Jogging', 'option3': 'Tabata sprints', 'option4': 'Cycling at a moderate pace', 'answer': 3},
        {'category_id': 14, 'question': 'What should be the focus during a warm-up?', 'option1': 'Increase muscle strength', 'option2': 'Increase body temperature and blood flow to muscles', 'option3': 'Burn fat', 'option4': 'Increase flexibility only', 'answer': 2},
        {'category_id': 14, 'question': 'What is the recommended frequency for strength training per week?', 'option1': '1-2 times a week', 'option2': '2-3 times a week', 'option3': '4-5 times a week', 'option4': 'Every day', 'answer': 2},
        {'category_id': 14, 'question': 'What is the purpose of cool-down exercises after a workout?', 'option1': 'To help muscles grow', 'option2': 'To lower heart rate and relax muscles', 'option3': 'To increase body temperature', 'option4': 'To burn more calories', 'answer': 2},
        {'category_id': 14, 'question': 'What type of exercise is best for improving endurance?', 'option1': 'Weightlifting', 'option2': 'Swimming', 'option3': 'Yoga', 'option4': 'Sprinting', 'answer': 2},
        {'category_id': 14, 'question': 'What is an example of a plyometric exercise?', 'option1': 'Jump squats', 'option2': 'Bicep curls', 'option3': 'Planks', 'option4': 'Lunges', 'answer': 1},
        {'category_id': 14, 'question': 'What does the term “set” mean in weight training?', 'option1': 'The amount of time spent resting between exercises', 'option2': 'A group of repetitions performed in a sequence', 'option3': 'The weight used for an exercise', 'option4': 'The number of exercises in a routine', 'answer': 2},
        {'category_id': 14, 'question': 'Which of the following exercises can help improve posture?', 'option1': 'Lunges', 'option2': 'Deadlifts', 'option3': 'Planks', 'option4': 'Bicep curls', 'answer': 3},
        {'category_id': 14, 'question': 'How long should an effective warm-up last?', 'option1': '5-10 minutes', 'option2': '15-20 minutes', 'option3': '30 minutes', 'option4': '1 hour', 'answer': 1},
        {'category_id': 14, 'question': 'Which of these exercises is effective for building leg muscles?', 'option1': 'Push-ups', 'option2': 'Squats', 'option3': 'Planks', 'option4': 'Pull-ups', 'answer': 2},
        {'category_id': 14, 'question': 'What is the recommended rest period between sets for strength training?', 'option1': '30-60 seconds', 'option2': '60-90 seconds', 'option3': '2-3 minutes', 'option4': '5-10 minutes', 'answer': 1},
        {'category_id': 14, 'question': 'What should be your focus during a workout for muscle building?', 'option1': 'Short and intense bursts of exercise', 'option2': 'Long-duration low-intensity exercise', 'option3': 'Moderate-intensity exercise with rest between sets', 'option4': 'Cardio exercises only', 'answer': 3}
      ];

      final health_nutrition = [
        {'category_id': 15, 'question': 'What is the recommended daily intake of water for an adult?', 'option1': '2 liters', 'option2': '3 liters', 'option3': '4 liters', 'option4': '1 liter', 'answer': 1},
        {'category_id': 15, 'question': 'What vitamin is mainly obtained from sunlight?', 'option1': 'Vitamin A', 'option2': 'Vitamin C', 'option3': 'Vitamin D', 'option4': 'Vitamin E', 'answer': 3},
        {'category_id': 15, 'question': 'Which nutrient is most important for building muscle?', 'option1': 'Carbohydrates', 'option2': 'Proteins', 'option3': 'Fats', 'option4': 'Vitamins', 'answer': 2},
        {'category_id': 15, 'question': 'Which food is a good source of Omega-3 fatty acids?', 'option1': 'Salmon', 'option2': 'Chicken', 'option3': 'Rice', 'option4': 'Spinach', 'answer': 1},
        {'category_id': 15, 'question': 'Which of the following is a carbohydrate?', 'option1': 'Olive oil', 'option2': 'Bread', 'option3': 'Chicken', 'option4': 'Cheese', 'answer': 2},
        {'category_id': 15, 'question': 'What is the main function of carbohydrates in the body?', 'option1': 'To build muscle', 'option2': 'To provide energy', 'option3': 'To support immune function', 'option4': 'To form hormones', 'answer': 2},
        {'category_id': 15, 'question': 'Which of the following is a rich source of Vitamin C?', 'option1': 'Orange', 'option2': 'Banana', 'option3': 'Apple', 'option4': 'Potato', 'answer': 1},
        {'category_id': 15, 'question': 'Which vitamin helps in the absorption of calcium for bone health?', 'option1': 'Vitamin D', 'option2': 'Vitamin C', 'option3': 'Vitamin A', 'option4': 'Vitamin E', 'answer': 1},
        {'category_id': 15, 'question': 'Which nutrient is responsible for repairing tissues and building muscles?', 'option1': 'Proteins', 'option2': 'Fats', 'option3': 'Carbohydrates', 'option4': 'Fiber', 'answer': 1},
        {'category_id': 15, 'question': 'What is the main source of protein for vegetarians?', 'option1': 'Eggs', 'option2': 'Lentils', 'option3': 'Chicken', 'option4': 'Fish', 'answer': 2},
        {'category_id': 15, 'question': 'Which food group is the richest source of dietary fiber?', 'option1': 'Fruits and vegetables', 'option2': 'Meat and poultry', 'option3': 'Dairy products', 'option4': 'Breads and cereals', 'answer': 1},
        {'category_id': 15, 'question': 'Which type of fat is considered healthy for the heart?', 'option1': 'Saturated fat', 'option2': 'Trans fat', 'option3': 'Unsaturated fat', 'option4': 'Cholesterol', 'answer': 3},
        {'category_id': 15, 'question': 'Which of the following is a common symptom of dehydration?', 'option1': 'Swelling', 'option2': 'Fatigue', 'option3': 'Diarrhea', 'option4': 'Nausea', 'answer': 2},
        {'category_id': 15, 'question': 'Which food is a rich source of calcium?', 'option1': 'Milk', 'option2': 'Pineapple', 'option3': 'Beef', 'option4': 'Eggs', 'answer': 1},
        {'category_id': 15, 'question': 'Which of these is a source of iron?', 'option1': 'Spinach', 'option2': 'Rice', 'option3': 'Cucumber', 'option4': 'Carrot', 'answer': 1},
        {'category_id': 15, 'question': 'What is the recommended percentage of daily calories that should come from fat?', 'option1': '30-35%', 'option2': '10-15%', 'option3': '50-60%', 'option4': '40-45%', 'answer': 1},
        {'category_id': 15, 'question': 'Which of the following is a high-calorie food?', 'option1': 'Carrot', 'option2': 'Olive oil', 'option3': 'Spinach', 'option4': 'Apple', 'answer': 2},
        {'category_id': 15, 'question': 'What is the main role of water in the body?', 'option1': 'Energy source', 'option2': 'Supports digestion and absorption', 'option3': 'Maintains body temperature and hydration', 'option4': 'Provides nutrients', 'answer': 3},
        {'category_id': 15, 'question': 'What type of diet is beneficial for weight loss?', 'option1': 'High-fat, low-carb diet', 'option2': 'High-protein, low-fat diet', 'option3': 'Calorie-controlled diet', 'option4': 'High-sugar, low-fat diet', 'answer': 3},
        {'category_id': 15, 'question': 'Which vitamin is important for skin health?', 'option1': 'Vitamin K', 'option2': 'Vitamin E', 'option3': 'Vitamin B12', 'option4': 'Vitamin A', 'answer': 2},
        {'category_id': 15, 'question': 'Which of the following is a good snack for a healthy diet?', 'option1': 'Fried chips', 'option2': 'Cookies', 'option3': 'Greek yogurt with berries', 'option4': 'Candy', 'answer': 3},
        {'category_id': 15, 'question': 'What is the primary function of antioxidants in the body?', 'option1': 'To provide energy', 'option2': 'To protect cells from damage', 'option3': 'To improve digestion', 'option4': 'To increase muscle mass', 'answer': 2},
        {'category_id': 15, 'question': 'Which nutrient is important for maintaining healthy eyesight?', 'option1': 'Vitamin A', 'option2': 'Vitamin B6', 'option3': 'Vitamin C', 'option4': 'Vitamin D', 'answer': 1},
        {'category_id': 15, 'question': 'Which food group provides the most energy?', 'option1': 'Proteins', 'option2': 'Carbohydrates', 'option3': 'Fats', 'option4': 'Vitamins', 'answer': 2},
        {'category_id': 15, 'question': 'What is the main function of dietary fiber?', 'option1': 'Provide energy', 'option2': 'Support digestion and prevent constipation', 'option3': 'Regulate blood sugar levels', 'option4': 'Build muscle', 'answer': 2},
        {'category_id': 15, 'question': 'Which of the following is a healthy way to lose weight?', 'option1': 'Skipping meals', 'option2': 'Eating smaller portions and exercising regularly', 'option3': 'Using fad diets', 'option4': 'Taking weight-loss supplements', 'answer': 2},
        {'category_id': 15, 'question': 'Which of the following foods is a source of good fats?', 'option1': 'Butter', 'option2': 'Avocados', 'option3': 'Cheese', 'option4': 'Fried chicken', 'answer': 2},
        {'category_id': 15, 'question': 'Which of the following is true about sugar?', 'option1': 'Sugar is essential for good health', 'option2': 'Too much sugar can lead to health problems', 'option3': 'Sugar has no effect on health', 'option4': 'Sugar is only harmful in processed foods', 'answer': 2},
        {'category_id': 15, 'question': 'Which vitamin is primarily obtained from animal products?', 'option1': 'Vitamin B12', 'option2': 'Vitamin A', 'option3': 'Vitamin C', 'option4': 'Vitamin D', 'answer': 1},
        {'category_id': 15, 'question': 'What is the best food for maintaining heart health?', 'option1': 'Red meat', 'option2': 'Whole grains, fruits, and vegetables', 'option3': 'Fried foods', 'option4': 'Sugary drinks', 'answer': 2},
        {'category_id': 15, 'question': 'What is a good source of hydration?', 'option1': 'Coffee', 'option2': 'Soda', 'option3': 'Water', 'option4': 'Alcohol', 'answer': 3},
        {'category_id': 15, 'question': 'What type of diet is low in fat and high in fruits and vegetables?', 'option1': 'Paleo diet', 'option2': 'Vegetarian diet', 'option3': 'Mediterranean diet', 'option4': 'Low-carb diet', 'answer': 3},
        {'category_id': 15, 'question': 'What food is high in potassium?', 'option1': 'Bananas', 'option2': 'Carrots', 'option3': 'Oranges', 'option4': 'Tomatoes', 'answer': 1},
        {'category_id': 15, 'question': 'What is the role of protein in the body?', 'option1': 'Build and repair tissues', 'option2': 'Provide energy', 'option3': 'Regulate metabolism', 'option4': 'Store nutrients', 'answer': 1},
        {'category_id': 15, 'question': 'What is an example of a whole grain?', 'option1': 'White bread', 'option2': 'Brown rice', 'option3': 'Pasta', 'option4': 'Potato', 'answer': 2},
        {'category_id': 15, 'question': 'Which of the following is the healthiest cooking oil?', 'option1': 'Olive oil', 'option2': 'Vegetable oil', 'option3': 'Canola oil', 'option4': 'Butter', 'answer': 1},
        {'category_id': 15, 'question': 'What is the function of the liver in relation to nutrients?', 'option1': 'Absorbs nutrients', 'option2': 'Stores excess nutrients', 'option3': 'Filters toxins from the body', 'option4': 'Produces insulin', 'answer': 3},
        {'category_id': 15, 'question': 'What nutrient is important for maintaining healthy red blood cells?', 'option1': 'Iron', 'option2': 'Calcium', 'option3': 'Vitamin C', 'option4': 'Vitamin D', 'answer': 1},
        {'category_id': 15, 'question': 'What food is high in antioxidants?', 'option1': 'Blueberries', 'option2': 'Pasta', 'option3': 'Cheese', 'option4': 'Bread', 'answer': 1},
        {'category_id': 15, 'question': 'Which of the following is a healthy snack?', 'option1': 'Potato chips', 'option2': 'Candy', 'option3': 'Carrot sticks with hummus', 'option4': 'Cookies', 'answer': 3},
        {'category_id': 15, 'question': 'What is the role of cholesterol in the body?', 'option1': 'Provides energy', 'option2': 'Supports cell structure and function', 'option3': 'Helps in digestion', 'option4': 'Breaks down fats', 'answer': 2},
        {'category_id': 15, 'question': 'Which of the following is a vegetarian protein source?', 'option1': 'Chicken', 'option2': 'Tofu', 'option3': 'Salmon', 'option4': 'Beef', 'answer': 2},
        {'category_id': 15, 'question': 'Which food should be avoided to reduce the risk of high cholesterol?', 'option1': 'Salmon', 'option2': 'Eggs', 'option3': 'Processed meats', 'option4': 'Green vegetables', 'answer': 3},
        {'category_id': 15, 'question': 'What is the function of fiber in the diet?', 'option1': 'Regulates blood sugar', 'option2': 'Boosts immunity', 'option3': 'Aids digestion and prevents constipation', 'option4': 'Helps in muscle repair', 'answer': 3},
        {'category_id': 15, 'question': 'Which of the following is a type of healthy fat?', 'option1': 'Trans fat', 'option2': 'Saturated fat', 'option3': 'Unsaturated fat', 'option4': 'Cholesterol', 'answer': 3},
        {'category_id': 15, 'question': 'Which of the following is a source of vitamin B12?', 'option1': 'Eggs', 'option2': 'Spinach', 'option3': 'Oranges', 'option4': 'Carrots', 'answer': 1},
        {'category_id': 15, 'question': 'Which of the following is considered a whole grain?', 'option1': 'White rice', 'option2': 'Oats', 'option3': 'Sugar', 'option4': 'Potato', 'answer': 2},
        {'category_id': 15, 'question': 'What is the primary function of fats in the body?', 'option1': 'Build muscle', 'option2': 'Provide energy and store vitamins', 'option3': 'Regulate hormones', 'option4': 'Support immune system', 'answer': 2},
        {'category_id': 15, 'question': 'Which food is known for boosting metabolism?', 'option1': 'Cucumber', 'option2': 'Cinnamon', 'option3': 'Potatoes', 'option4': 'Rice', 'answer': 2},
        {'category_id': 15, 'question': 'Which vitamin is found in large amounts in carrots?', 'option1': 'Vitamin A', 'option2': 'Vitamin D', 'option3': 'Vitamin C', 'option4': 'Vitamin E', 'answer': 1},
        {'category_id': 15, 'question': 'Which of these is a high-protein, plant-based food?', 'option1': 'Chicken', 'option2': 'Tofu', 'option3': 'Cheese', 'option4': 'Salmon', 'answer': 2},
        {'category_id': 15, 'question': 'Which type of nutrient is important for proper digestion and regular bowel movements?', 'option1': 'Vitamins', 'option2': 'Fiber', 'option3': 'Minerals', 'option4': 'Proteins', 'answer': 2},
        {'category_id': 15, 'question': 'Which food is rich in antioxidants?', 'option1': 'Tomatoes', 'option2': 'Bananas', 'option3': 'Oranges', 'option4': 'Chocolate', 'answer': 4},
        {'category_id': 15, 'question': 'Which food contains the highest amount of iron?', 'option1': 'Spinach', 'option2': 'Chicken', 'option3': 'Coconut', 'option4': 'Eggs', 'answer': 1},
        {'category_id': 15, 'question': 'What is a common consequence of vitamin D deficiency?', 'option1': 'Weak bones', 'option2': 'Anemia', 'option3': 'Fatigue', 'option4': 'Obesity', 'answer': 1},
        {'category_id': 15, 'question': 'What type of fat should be avoided to reduce the risk of heart disease?', 'option1': 'Saturated fat', 'option2': 'Polyunsaturated fat', 'option3': 'Trans fat', 'option4': 'Monounsaturated fat', 'answer': 3},
        {'category_id': 15, 'question': 'What is the best source of natural energy for athletes?', 'option1': 'Coffee', 'option2': 'Bananas', 'option3': 'Cookies', 'option4': 'Candy bars', 'answer': 2},
        {'category_id': 15, 'question': 'Which of these drinks is best for hydration?', 'option1': 'Soda', 'option2': 'Coffee', 'option3': 'Fruit juice', 'option4': 'Water', 'answer': 4},
        {'category_id': 15, 'question': 'What is a good source of healthy fats?', 'option1': 'Butter', 'option2': 'Olive oil', 'option3': 'Vegetable oil', 'option4': 'Cheese', 'answer': 2},
        {'category_id': 15, 'question': 'What is the purpose of probiotics in the body?', 'option1': 'Boost energy levels', 'option2': 'Regulate metabolism', 'option3': 'Improve digestion and gut health', 'option4': 'Strengthen bones', 'answer': 3},
        {'category_id': 15, 'question': 'Which of the following foods is high in potassium?', 'option1': 'Bananas', 'option2': 'Carrots', 'option3': 'Broccoli', 'option4': 'Apples', 'answer': 1},
        {'category_id': 15, 'question': 'Which nutrient is responsible for building and repairing tissues?', 'option1': 'Proteins', 'option2': 'Fats', 'option3': 'Carbohydrates', 'option4': 'Vitamins', 'answer': 1},
        {'category_id': 15, 'question': 'What is the main source of Vitamin C?', 'option1': 'Oranges', 'option2': 'Apples', 'option3': 'Carrots', 'option4': 'Broccoli', 'answer': 1},
        {'category_id': 15, 'question': 'Which type of sugar is naturally found in fruit?', 'option1': 'Glucose', 'option2': 'Fructose', 'option3': 'Sucrose', 'option4': 'Lactose', 'answer': 2},
        {'category_id': 15, 'question': 'Which food is a good source of omega-3 fatty acids?', 'option1': 'Salmon', 'option2': 'Pork', 'option3': 'Chicken', 'option4': 'Rice', 'answer': 1},
        {'category_id': 15, 'question': 'Which type of sugar should be consumed in moderation?', 'option1': 'Natural sugars', 'option2': 'Refined sugars', 'option3': 'Fructose', 'option4': 'Glucose', 'answer': 2},
        {'category_id': 15, 'question': 'Which of these is a healthy snack?', 'option1': 'Chips', 'option2': 'Candy bar', 'option3': 'Almonds', 'option4': 'Donuts', 'answer': 3},
        {'category_id': 15, 'question': 'Which vitamin helps the body absorb calcium?', 'option1': 'Vitamin A', 'option2': 'Vitamin B12', 'option3': 'Vitamin D', 'option4': 'Vitamin K', 'answer': 3},
        {'category_id': 15, 'question': 'Which of these foods is considered a good source of fiber?', 'option1': 'White bread', 'option2': 'Avocados', 'option3': 'Eggs', 'option4': 'Chicken', 'answer': 2},
        {'category_id': 15, 'question': 'What is a common consequence of excessive sugar intake?', 'option1': 'High blood pressure', 'option2': 'Tooth decay', 'option3': 'Headache', 'option4': 'Weakness', 'answer': 2},
        {'category_id': 15, 'question': 'Which of these is an essential mineral for bone health?', 'option1': 'Magnesium', 'option2': 'Calcium', 'option3': 'Iron', 'option4': 'Zinc', 'answer': 2},
        {'category_id': 15, 'question': 'What is the main benefit of drinking water?', 'option1': 'Boosts energy', 'option2': 'Hydrates the body', 'option3': 'Improves digestion', 'option4': 'Increases appetite', 'answer': 2},
        {'category_id': 15, 'question': 'What is the primary function of carbohydrates in the body?', 'option1': 'To build muscle', 'option2': 'To store vitamins', 'option3': 'To provide energy', 'option4': 'To repair tissues', 'answer': 3},
        {'category_id': 15, 'question': 'What does the term "BMI" stand for?', 'option1': 'Body Mass Index', 'option2': 'Body Movement Indicator', 'option3': 'Blood Mass Index', 'option4': 'Biological Mass Intake', 'answer': 1},
        {'category_id': 15, 'question': 'Which of the following is a good source of vitamin K?', 'option1': 'Spinach', 'option2': 'Bananas', 'option3': 'Milk', 'option4': 'Carrots', 'answer': 1},
        {'category_id': 15, 'question': 'Which type of fat is most commonly found in fish?', 'option1': 'Trans fat', 'option2': 'Saturated fat', 'option3': 'Monounsaturated fat', 'option4': 'Polyunsaturated fat', 'answer': 4},
        {'category_id': 15, 'question': 'Which of the following foods contains the most vitamin C?', 'option1': 'Kiwi', 'option2': 'Apple', 'option3': 'Potato', 'option4': 'Strawberry', 'answer': 1}
      ];







      for (var question in physics) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }
      for (var question in chemistry) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }
      for (var question in biology) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }
      for (var question in env_science) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }
      for (var question in earth_science) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }

      for (var question in math) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }
      for (var question in bangla) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }
      for (var question in english) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }
      for (var question in ict) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }
      for (var question in g_knowledge) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }
      for (var question in bd_history) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }
      for (var question in world_history) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }
      for (var question in sports) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }
      for (var question in physical_fit_exercises) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }
      for (var question in health_nutrition) {
        // Shuffle options
        final options = [question['option1'], question['option2'], question['option3'], question['option4']];
        final random = Random();
        options.shuffle(random);

        question['option1'] = options[0] as String;
        question['option2'] = options[1] as String;
        question['option3'] = options[2] as String;
        question['option4'] = options[3] as String;

        final correctAnswer = question['answer'];
        final shuffledIndex = options.indexOf(question['option$correctAnswer']) + 1;

        question['answer'] = shuffledIndex;
        await db.insert('questions', question);
      }


      print("All Sample questions inserted successfully.");
    }


  }

  Future<void> close() async {
    final db = _database;
    if (db != null) await db.close();
  }
}
