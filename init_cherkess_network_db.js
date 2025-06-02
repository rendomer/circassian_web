// init_cherkess_network_db.js

// Подключаемся к базе cherkess_app (если в mongosh не указано - переключаемся)
use cherkess_app;

// Создаем коллекции (MongoDB создаст их автоматически при вставке, но явно для порядка)
db.createCollection('users');
db.createCollection('polls');
db.createCollection('children');

// Создаем индексы для пользователей (email и phone уникальные для удобства поиска)
db.users.createIndex({ email: 1 }, { unique: true });
db.users.createIndex({ phone: 1 }, { unique: true, sparse: true }); // sparse, чтобы разрешить отсутствие телефона

// Индексы для опросов по дате и названию
db.polls.createIndex({ date: -1 });
db.polls.createIndex({ title: 1 });

// Вставляем тестовые документы в users
db.users.insertMany([
  {
    _id: ObjectId("683c8ef6fb14690fc86c4bd0"),
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
    _id: ObjectId("683c8f19fb14690fc86c4bd4"),
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

// Вставляем тестовые документы в polls
db.polls.insertMany([
  {
    _id: ObjectId("683cb12bfb14690fc86c4bd1"),
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
    _id: ObjectId("683cb5f3fb14690fc86c4bd2"),
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

// Вставляем пример детей в children
db.children.insertMany([
  {
    _id: ObjectId(),
    userId: 1,
    firstName: "Ali",
    lastName: "Kumaxov",
    birthDate: ISODate("2010-05-15T00:00:00Z"),
    photoUrl: "/photos/children/ali.jpg"
  },
  {
    _id: ObjectId(),
    userId: 1,
    firstName: "Amina",
    lastName: "Kumaxova",
    birthDate: ISODate("2012-07-20T00:00:00Z"),
    photoUrl: "/photos/children/amina.jpg"
  }
]);

print("Init script executed successfully!");
