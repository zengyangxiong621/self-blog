# JavaScript 面向对象编程

## 面向对象基础概念

### 什么是面向对象编程？

面向对象编程（OOP）是一种编程范式，它将数据和操作数据的方法组织成对象。OOP 的核心思想包括：

- **封装**：将数据和方法封装在一起
- **继承**：子类可以继承父类的属性和方法
- **多态**：同一个接口可以有不同的实现

## 对象的创建方式

### 1. 对象字面量
```javascript
const person = {
    name: "张三",
    age: 25,
    greet: function() {
        return `你好，我是${this.name}`;
    }
};

console.log(person.greet()); // "你好，我是张三"
```

### 2. 构造函数
```javascript
function Person(name, age) {
    this.name = name;
    this.age = age;
    this.greet = function() {
        return `你好，我是${this.name}`;
    };
}

const person1 = new Person("张三", 25);
const person2 = new Person("李四", 30);

console.log(person1.greet()); // "你好，我是张三"
console.log(person2.greet()); // "你好，我是李四"
```

### 3. Object.create()
```javascript
const personPrototype = {
    greet: function() {
        return `你好，我是${this.name}`;
    }
};

const person = Object.create(personPrototype);
person.name = "张三";
person.age = 25;

console.log(person.greet()); // "你好，我是张三"
```

## 原型和原型链

### 原型基础
```javascript
function Person(name, age) {
    this.name = name;
    this.age = age;
}

// 在原型上添加方法
Person.prototype.greet = function() {
    return `你好，我是${this.name}`;
};

Person.prototype.getAge = function() {
    return this.age;
};

const person = new Person("张三", 25);
console.log(person.greet()); // "你好，我是张三"
console.log(person.getAge()); // 25
```

### 原型链
```javascript
function Animal(name) {
    this.name = name;
}

Animal.prototype.speak = function() {
    return `${this.name} 发出了声音`;
};

function Dog(name, breed) {
    Animal.call(this, name);
    this.breed = breed;
}

// 设置原型链
Dog.prototype = Object.create(Animal.prototype);
Dog.prototype.constructor = Dog;

Dog.prototype.bark = function() {
    return `${this.name} 汪汪叫`;
};

const dog = new Dog("旺财", "金毛");
console.log(dog.speak()); // "旺财 发出了声音"
console.log(dog.bark());  // "旺财 汪汪叫"
```

## ES6 类语法

### 基本类语法
```javascript
class Person {
    constructor(name, age) {
        this.name = name;
        this.age = age;
    }
    
    greet() {
        return `你好，我是${this.name}`;
    }
    
    getAge() {
        return this.age;
    }
    
    // 静态方法
    static getSpecies() {
        return "智人";
    }
}

const person = new Person("张三", 25);
console.log(person.greet()); // "你好，我是张三"
console.log(Person.getSpecies()); // "智人"
```

### 类的继承
```javascript
class Animal {
    constructor(name) {
        this.name = name;
    }
    
    speak() {
        return `${this.name} 发出了声音`;
    }
}

class Dog extends Animal {
    constructor(name, breed) {
        super(name); // 调用父类构造函数
        this.breed = breed;
    }
    
    speak() {
        return `${this.name} 汪汪叫`;
    }
    
    getBreed() {
        return this.breed;
    }
}

const dog = new Dog("旺财", "金毛");
console.log(dog.speak()); // "旺财 汪汪叫"
console.log(dog.getBreed()); // "金毛"
```

## 封装

### 私有属性和方法
```javascript
class BankAccount {
    #balance = 0; // 私有属性
    
    constructor(initialAmount) {
        this.#balance = initialAmount;
    }
    
    // 私有方法
    #validateAmount(amount) {
        return amount > 0 && typeof amount === 'number';
    }
    
    deposit(amount) {
        if (this.#validateAmount(amount)) {
            this.#balance += amount;
            return true;
        }
        return false;
    }
    
    withdraw(amount) {
        if (this.#validateAmount(amount) && amount <= this.#balance) {
            this.#balance -= amount;
            return true;
        }
        return false;
    }
    
    getBalance() {
        return this.#balance;
    }
}

const account = new BankAccount(1000);
account.deposit(500);
console.log(account.getBalance()); // 1500
account.withdraw(200);
console.log(account.getBalance()); // 1300
```

### 使用 getter 和 setter
```javascript
class Rectangle {
    constructor(width, height) {
        this._width = width;
        this._height = height;
    }
    
    get width() {
        return this._width;
    }
    
    set width(value) {
        if (value > 0) {
            this._width = value;
        }
    }
    
    get height() {
        return this._height;
    }
    
    set height(value) {
        if (value > 0) {
            this._height = value;
        }
    }
    
    get area() {
        return this._width * this._height;
    }
}

const rect = new Rectangle(10, 5);
console.log(rect.area); // 50
rect.width = 20;
console.log(rect.area); // 100
```

## 继承

### 原型继承
```javascript
function Vehicle(brand) {
    this.brand = brand;
}

Vehicle.prototype.start = function() {
    return `${this.brand} 启动了`;
};

function Car(brand, model) {
    Vehicle.call(this, brand);
    this.model = model;
}

Car.prototype = Object.create(Vehicle.prototype);
Car.prototype.constructor = Car;

Car.prototype.drive = function() {
    return `${this.brand} ${this.model} 在行驶`;
};

const car = new Car("丰田", "凯美瑞");
console.log(car.start()); // "丰田 启动了"
console.log(car.drive()); // "丰田 凯美瑞 在行驶"
```

### 类继承
```javascript
class Vehicle {
    constructor(brand) {
        this.brand = brand;
    }
    
    start() {
        return `${this.brand} 启动了`;
    }
}

class Car extends Vehicle {
    constructor(brand, model) {
        super(brand);
        this.model = model;
    }
    
    drive() {
        return `${this.brand} ${this.model} 在行驶`;
    }
}

class ElectricCar extends Car {
    constructor(brand, model, batteryCapacity) {
        super(brand, model);
        this.batteryCapacity = batteryCapacity;
    }
    
    charge() {
        return `${this.brand} ${this.model} 正在充电`;
    }
    
    start() {
        return `${this.brand} 静默启动`;
    }
}

const tesla = new ElectricCar("特斯拉", "Model 3", 75);
console.log(tesla.start()); // "特斯拉 静默启动"
console.log(tesla.drive()); // "特斯拉 Model 3 在行驶"
console.log(tesla.charge()); // "特斯拉 Model 3 正在充电"
```

## 多态

### 方法重写
```javascript
class Shape {
    area() {
        throw new Error("子类必须实现 area 方法");
    }
    
    perimeter() {
        throw new Error("子类必须实现 perimeter 方法");
    }
}

class Circle extends Shape {
    constructor(radius) {
        super();
        this.radius = radius;
    }
    
    area() {
        return Math.PI * this.radius ** 2;
    }
    
    perimeter() {
        return 2 * Math.PI * this.radius;
    }
}

class Rectangle extends Shape {
    constructor(width, height) {
        super();
        this.width = width;
        this.height = height;
    }
    
    area() {
        return this.width * this.height;
    }
    
    perimeter() {
        return 2 * (this.width + this.height);
    }
}

// 多态的使用
function printShapeInfo(shape) {
    console.log(`面积: ${shape.area()}`);
    console.log(`周长: ${shape.perimeter()}`);
}

const circle = new Circle(5);
const rectangle = new Rectangle(4, 6);

printShapeInfo(circle);    // 面积: 78.54, 周长: 31.42
printShapeInfo(rectangle); // 面积: 24, 周长: 20
```

## 设计模式

### 单例模式
```javascript
class Singleton {
    constructor() {
        if (Singleton.instance) {
            return Singleton.instance;
        }
        
        this.data = {};
        Singleton.instance = this;
    }
    
    getData(key) {
        return this.data[key];
    }
    
    setData(key, value) {
        this.data[key] = value;
    }
}

const instance1 = new Singleton();
const instance2 = new Singleton();

console.log(instance1 === instance2); // true
```

### 工厂模式
```javascript
class Car {
    constructor(model) {
        this.model = model;
    }
}

class Truck {
    constructor(model) {
        this.model = model;
    }
}

class VehicleFactory {
    static createVehicle(type, model) {
        switch (type) {
            case 'car':
                return new Car(model);
            case 'truck':
                return new Truck(model);
            default:
                throw new Error(`未知的车辆类型: ${type}`);
        }
    }
}

const car = VehicleFactory.createVehicle('car', '凯美瑞');
const truck = VehicleFactory.createVehicle('truck', '大货车');
```

### 观察者模式
```javascript
class EventEmitter {
    constructor() {
        this.events = {};
    }
    
    on(event, listener) {
        if (!this.events[event]) {
            this.events[event] = [];
        }
        this.events[event].push(listener);
    }
    
    emit(event, data) {
        if (this.events[event]) {
            this.events[event].forEach(listener => {
                listener(data);
            });
        }
    }
    
    off(event, listener) {
        if (this.events[event]) {
            this.events[event] = this.events[event].filter(l => l !== listener);
        }
    }
}

const emitter = new EventEmitter();

emitter.on('message', (data) => {
    console.log('收到消息:', data);
});

emitter.emit('message', 'Hello World'); // 收到消息: Hello World
```

## 总结

JavaScript 面向对象编程的核心概念包括：

1. **对象创建**：字面量、构造函数、Object.create()
2. **原型链**：理解 prototype 和 __proto__
3. **ES6 类**：现代 JavaScript 的类语法
4. **封装**：私有属性和方法的实现
5. **继承**：代码复用的重要机制
6. **多态**：同一接口的不同实现
7. **设计模式**：解决常见问题的最佳实践

掌握这些概念对于编写可维护的 JavaScript 代码至关重要。 