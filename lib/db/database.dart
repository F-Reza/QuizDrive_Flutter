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

      print("Sample questions inserted successfully.");
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) await db.close();
  }
}
