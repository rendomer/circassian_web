// init_cherkess_network_db.js

// Подключаемся к базе cherkess_app
const db = connect("mongodb://localhost:27017/cherkess_app");

// Очищаем базу (УДАЛЯЕТ ВСЁ ПРЕДЫДУЩЕЕ)
db.dropDatabase(); // Закомментируй, если не хочешь терять данные

// Создаем коллекции
db.createCollection('users');
db.createCollection('surveys');
db.createCollection('children');

// Индексы для уникальности
db.users.createIndex({ email: 1 }, { unique: true });
db.users.createIndex({ phone: 1 }, { unique: true, sparse: true });
db.survey.createIndex({ date: -1 });
db.survey.createIndex({ title: 1 });

// Вставка пользователей
db.users.insertMany([
  {
    firstName: "Aslan",
    lastName: "Kumaxov",
    email: "aslan@example.com",
    phone: "+905301234567",
    password: "hashed_password",
    photoUrl: "/photos/aslan.jpg",
    deactivationReports: 3,
    inactivityDays: 12,
    deathConfirmed: false,
    childrenCount: 2,
    fatherInfo: "Kumaxov Hasan",
    motherInfo: "Zukhra Kumahova",
    userId: 1
  },
  {
    firstName: "Zarema",
    lastName: "Tleuzheva",
    email: "zarema@example.com",
    phone: null,
    password: "hashed_password",
    photoUrl: "/photos/zarema.jpg",
    deactivationReports: 0,
    inactivityDays: 0,
    deathConfirmed: false,
    childrenCount: 1,
    fatherInfo: "Tleuzhev Murat",
    motherInfo: "Lana Tleuzheva",
    userId: 2
  }
]);

// Вставка опросов
db.surveys.insertMany([
  {
    title: "Какие функции нужны в приложении?",
    date: ISODate("2025-06-01T00:00:00Z"),
    question: "Что вы хотите видеть в следующем обновлении?",
    participants: 15,
    answers: [
      { option: "Уведомления", votes: 5 },
      { option: "Статистика", votes: 7 },
      { option: "Сообщения", votes: 3 }
    ]
  },
  {
    title: "Как часто вы заходите в приложение?",
    date: ISODate("2025-06-02T00:00:00Z"),
    question: "Сколько раз в неделю вы открываете приложение?",
    participants: 20,
    answers: [
      { option: "Каждый день", votes: 10 },
      { option: "Несколько раз в неделю", votes: 6 },
      { option: "Реже", votes: 4 }
    ]
  }
]);

// Вставка детей
db.children.insertMany([
  {
    userId: 1,
    firstName: "Ali",
    lastName: "Kumaxov",
    birthDate: ISODate("2010-05-15T00:00:00Z"),
    photoUrl: "/photos/children/ali.jpg"
  },
  {
    userId: 1,
    firstName: "Amina",
    lastName: "Kumaxova",
    birthDate: ISODate("2012-07-20T00:00:00Z"),
    photoUrl: "/photos/children/amina.jpg"
  }
]);

print("✅ Init script executed successfully!");
