# 12장

## 12-1. 메서드 올리기

- 서브클래스들의 메서드 **본문 코드가 같**으면 **위로** 올림
- 실직적으로 **하는 일은 같**지만, **코드가 다르**다면 본문 코드가 **같아질때까지 리팩터링**

## 12-2. 필드 올리기

- 서브 클래스들에 사용되는 필드들이 **비슷한 방식으로 쓰인**다고 판단되면 **슈퍼클래스**로 올림
- 이 방법을 통해 데이터 **중복 선언을 없애**고, 해당 필드를 사용하는 **동작 또한 슈퍼클래스로** 옮길 수 있음

## 12-3. 생성자 본문 올리기

```javascript
// 전
class Party { ... }
class Employee extends Party {
  constructor(name, id) {
    super();
    this._id = id;
    this._name = name;
  }
}
class Department extends Party {
  constructor(name, staff) {
    super();
    this._id = id;
    this._staff = staff;
  }
}

// 전
class Party {
  constructor(name) {
    this._name = name;
  }
}
class Employee extends Party {
  constructor(name, id) {
    super(name);
    this._id = id;
  }
}
class Department extends Party {
  constructor(name, id) {
    super(name);
    this._staff = staff;
  }
}
```

- 서브 클래스들에서 기능이 같은 메서드를 발견하면 그냥 올려버리면 되지만, 그 **메서드가 생성자**라면 스텝이 조금 **꼬임**.
- 생성자는 **할 수 있는 일과 호출 순서에 제약**이 있기 때문에 조금 다른 식으로 접근 필요

## 12-4. 메서드 내리기

- 반대 리팩터링: 메서드 올리기
- **특정 서브클래스** 하나(혹은 소수)와만 **관련**된 메서드는 **슈퍼클래스에서 제거**하고 해당 **서브클래스**에 추가하는 편이 깔끔

## 12-5. 필드 내리기

- **특정 서브클래스** 하나(혹은 소수)에서만 **사용**하는 필드는 해당 **서브클래스** (들) 로 옮긴다

## 12-6. 타입 코드를 서브클래스로 바꾸기

- 

## 12-7. 서브클래스 제거하기

- 

## 12-8. 슈퍼클래스 추출하기

- **비슷한 일을 수행**하는 **두 클래스**가 보이면, 상속 메커니즘을 이용해 비슷한 부분을 **공통의 슈퍼클래스**로 옮겨 담기 (12-1. 이랑 비슷해보이지만 그건 이미 상속이 되어있는 상황이고, 이건 새로 슈퍼클래스를 빼라는 것인듯?)

- 슈퍼 클래스 추출하기 **대안**으로는 **클래스 추출**하기(7-5)가 있음. (그냥 아예 새로운 클래스로 빼버리는거)

  무엇을 선택하느냐는 중복 동작을 상속으로 해결하느냐, 위임으로 해결하느냐에 따라 달림. 

  보통 슈퍼 클래스 추출하기 방법이 더 간단하며, 나중에라도 필요해지면 슈퍼클래스를 위임으로 바꾸기(12-11)는 어렵지 않음

## 12-9. 계층 합치기

- 어떤 클래스와 그 부모가 **너무 비슷**해져서 더는 독립적으로 존재해야할 이유가 사라질때 그 둘을 **합침**

## 12-10. 서브클래스를 위임으로 바꾸기

- 

## 12-11. 슈퍼클래스를 위임으로 바꾸기

- 

