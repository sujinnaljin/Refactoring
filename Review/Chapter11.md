# 11장

## 11-1 질의 함수와 변경 함수 분리하기

- 함수에서 값 반환시 겉보기 부수 효과 (observable side effect) 가 없이 값을 반환하는 함수를 추구해야함
- 겉보기 부수효과가 있는 함수와 없는 함수는 명확히 구분하는게 좋음. 이를 위한 한가지 방법은 '**명령-질의 분리**' 원칙, 즉 **질의 함수(읽기 함수)는 모두 부수효과가 없어야 한다**'는 규칙을 따르는 것.

## 11-2. 함수 매개변수화하기

- 두 함수의 로직이 아주 비슷하고 **단지 리터럴 값만 다르다**면, 그 다른 값만 **매개 변수로 받아서 처리**하는 함수를 만드는 식으로 중복 제거 가능

## 11-3. 플래그 인수 제거하기

- 플래그 인수란 호출되는 함수가 실행할 로직을 호출하는 쪽에서 선택하기 위해 전달하는 인수

- 플래그 인수가 되려면 호출하는 쪽에서 불리언 값으로 변수같은 데이터가 아니라 `true` 나 `false` 같은 리터럴 값을 건네야 함

  ```javascript
  function bookingConcert(isPremium) {
    if isPremium {
    } else {
    }
  }
  bookingConcert(true)
  bookingConcert(false)
  ```

- 플래그 인수를 사용하지 않고, **명시적으로 함수로 분리**하는 것이 좋음. 호출자의 의도를 분명히 밝히고, 코드 분석시에도 각 호출되는 로직의 차이를 쉽게 파악할 수 있기 때문.

- 플래그 인수 두 개 이상을 사용하는 함수를 나누고자 한다면, 플래그 인수들의 가능한 조합의 수만큼 함수를 만들어야하기 때문에 이 경우는 플래그 인수를 써야하는 합당한 근거가 될 수 있음.

  하지만 애초에 플래그 인수가 둘 이상이면 함수 하나가 너무 많은 일을 처리하고 있다는 신호이기 때문에 같은 더 간단한 함수를 만들 방법을 고민해야함. 

## 11-4. 객체 통째로 넘기기

- 하나의 **레코드에서 값 두어개를 가져와 인수로** 넘기는 코드를 보면, 대신 **레코드를 통째로 넘기고** 함수 본문에서 필요한 값들을 꺼내 쓰도록 수정
- 레코드를 통째로 넘기면 해당 함수가 더 다양한 데이터를 사용하도록 바뀌어도 매개 변수 목록은 수정할 필요가 없고, 매개 변수도 짧아져서 함수를 이해하기 쉬워짐
- 하지만 **함수가 레코드 자체에 의존하기를 원치 않을 때**는 이 리팩터링을 수행하지 않음

## 11-5. 매개 변수를 질의 함수로 바꾸기

```javascript
// 전
get finalPrice() {
  const basePrice = this.quantity * this.itemPrice;
  let discountLevel;
  if (this.quantity > 100) discountLevel = 2;
  else discountLevel = 1;
  return this.discountedPrice(basePrice, discountLevel)
}

discountedPrice(basePrice, discountLevel) {
  switch (discountLevel) {}
}
// 후
get finalPrice() {
  const basePrice = this.quantity * this.itemPrice;
  return this.discountedPrice(basePrice)
}

get discountLevel() {
  return (this.quantity > 100) ? 2 : 1;
}

discountedPrice(basePrice) {
  switch (this.discountLevel) {}
}
```

- 매개변수는 함수의 동작에 변화를 줄 수 있는 일차적인 수단. 즉 함수의 변동 요인을 모아놓은 곳.
- 따라서 이 목록에서도 중복은 피하는게 좋으며 **짧을 수록 이해하기 쉬**움
- 피호출 함수가 스스로 쉽게 결정할 수 있는 값을 매개변수로 건네는 것도 일종의 중복
- 해당 **매개변수를 제거**하면 값을 결정하는 **책임 주체가 호출자에서 피호출 함수로 변경** 됨
- 저자는 습관적으로 호출하는 쪽을 간소하게 만든다고 함. (물론 피호출 함수가 그 역할을 수행하기 적합할때만)
- 하지만 매개 변수를 제거해서 피호출 함수에 **원하지 않는 의존성**이 생긴다면, 즉 해당 함수가 알지 못했으면 하는 프로그램 요소에 접근해야하는 상황을 만들때는 **매개변수를 질의 함수로 변경하면 안됨**.
- 또한 매개변수를 없애는 대신 **가변 전역 변수를 이용**하는 등의 일을 **하면 안됨.**

## 11-6. 질의 함수를 매개변수로 바꾸기

- 함수 안에서 전역 변수를 참조한다거나, 제거하기를 원하는 원소를 참조할 때는 **책임을 호출자로** 옮기는 게 좋음

- 보통 함수가 더 이상 **특정 원소에 의존하길 원치 않을때 매개 변수화** 함

- 이때 **두 극단 사이에서 적절한 균형**을 찾아야함

  - 모든 것을 매개 변수로 바꿔서 끝없는 매개 변수 목록 만들기 vs 함수끼리 많은 것을 공유하여 수많은 결합 만들어내기

  한 시점에 내린 결정이 영원히 옳다고 할 수 없는 문제. 따라서 나중에 더 나은 쪽으로 개선하기 쉽게 설계해두는 것이 중요

- 질의 함수를 매개변수로 바꾸면 어떤 값을 제공할지 호출자가 알아내야함. 결국 호출자가 복잡해짐.

  결국 **책임 소재를 프로그램의 어디에 배정**하느냐의 문제로 귀결 되는데, 답을 찾기 쉽지 않으며 항상 **정답이 있는 것도 아님**.

  프로젝트를 진행하면서 균형점이 이리저리 옮겨질 수 있으니, 이 리팩터링과 그 반대 리팩터링과는 아주 친해져야함

## 11-7. 세터 제거하기

- 수정되지 않길 원하는 필드라면 세터 제거

## 11-8. 생성자를 팩터리 함수로 바꾸기

```javascript
// 전
const leadEngineer = new Employee(document.leadingEngineer, 'E')
// 후
const leadEngineer = createEngineer(document.leadingEngineer);
function createEngineer(name) {
  return new Employee(name, 'E')
}
```

## 11-9. 함수를 명령으로 바꾸기

```javascript
// 전
function score(candidate, medicalExam, scoringGuide) {
  let result = 0;
  let healthLevel = 0;
  // .... 
}

// 후
class Scorer {
  constructor(candidate, medicalExam, scoringGuide) {
    //...
  }
  
  execute() {
    this._result = 0;
    this._healthLevel = 0;
    // ...
  }
}
```

- 함수를 그 **함수만을 위한 객체 안으로 캡슐화**하면 더 유용해지는 상황이 있음

- 이런 객체를 가리켜 **명령 객체**, 혹은 **명령**이라고 함

- 명령 객체 대부분은 **메서드 하나로 구성**되며, 이 메서드를 요청해 실행하는 것이 이 객체의 목적

- 명령은 평범한 함수 매커니즘 보다 유연하게 함수를 제어하고 표현할 수 있으며, 되돌리기 같은 보조 연산을 제공할 수 있음

- 저자가 명령을 선택할 때는 명령보다 더 간단한 방식으로 얻을 수 없는 기능이 필요할 때 뿐.

  따라서 일급함수와 명령 중 에는 일급 함수 선택하겠지만, **복잡한 함수를 잘게 쪼개서 이해하거나 수정하기 쉽게 만들 때**도 명령이 유용

## 11-10. 명령을 함수로 바꾸기

- **명령 객체**는 큰 **연산 하나를 여러개의 작은 메서드로 쪼개고**, 필드를 이용해 쪼개진 메서드들끼리 정보를 공유할 수 있음.
- 명령은 그저 **큰 연산 하나를 호출해 정해진 일을 수행**하는 용도로 주로 쓰이는데, 이때 로직이 크게 **복잡하지 않다면** 명령 객체는 단점이 더 크니 **평범한 함수**로 바꾸는게 좋음

## 11-11. 수정된 값 반환하기

```javascript
// 전
let totalAscent = 0;
calcuateAscent();

function calcuateAscent() {
  totalAscent = 1+2;
}

// 후
const totalAscent = calcuateAscent();

function calcuateAscent() {
  let result = 0;
  result = 1+2;
  return reuslt;
}
```

- 변수를 갱신하는 함수를 통해 데이터가 수정된다면, 함수 자체가 수정된 값을 반환하여 호출자가 그 값을 변수에 담아두도록 하는 것이 좋음
- **값 하나를 계산**한다는 분명한 목적이 있는 함수들에게 가장 **효과적**이고, 반대로 여러개를 갱신하는 함수에는 효과적이지 않음.

## 11-12. 오류 코드를 예외로 바꾸기

```javascript
// 전
if (data) 
  return new ShippingRules(data);
else 
  return -23;

// 후
if (data) 
  return new ShippingRules(data);
else 
  throw new OrderProcessingError(-23);
```

- 예외는 프로그래밍 언어에서 제공하는 독립적인 오류 처리 메커니즘으로, **적절한 예외 핸들러를 찾을 때까지 콜스택을 타고 위로 전파** 
- 예외는 프로그램의 정상 동작 범주에 들지 않는 오류를 나타낼때만 쓰여야함

## 11-13. 예외를 사전확인(Precheck)으로 바꾸기

```javascript
// 전
double getValueForPeriod(int periodNumber) {
  try {
    return values[periodNumber];
  } catch (ArrayIndexOutOfBoundsException e) {
    return 0;
  }
}

// 후
double getValueForPeriod(int periodNumber) {
  return (periodNumber >= values.length) ? 0 : values[periodNumber];
}
```

- 예외도 과용되면 좋지 않음. 말그대로 **예외적으로 동작할 때만** 쓰여야함
- 함수 시행 문제가 될 수 있는 조건을 **함수 호출 전에 검사**할 수 있다면, 예외를 던지는 대신 호출하는 곳에서 조건을 검사

## 나의 생각

- 11-3. 플래그 인수 제거하기에서 '불리언 플래그는 코드를 읽는 이에게 뜻을 온전히 전달하지 못하기 때문에 더욱 좋지 못하다' 고 함. 근데 이거는 자바스크립트 문법때문에 아닌가?? 스위프트에서는 호출할때 `booking(isPreminum: true)` 처럼 argument label 이용할 수 있는데 이 정도면 명확한거 아닌가 🤔

## 논의해볼 사항

- 11-3. '플래그 인수 제거하기' 에서 '플래그 인수를 사용하지 않고, 명시적으로 함수로 분리하는 것이 좋다' 라고 하는데,, 약간 케바케 아닌가?

  아래 코드에서는 플래그 인수를 사용하는게 더 간결하지 않나?

  ```swift
  // 플래그 인수 미사용
  func setNormalButtonBackground {
    button.background = .white
  }
  func setSelectedButtonBackground {
    button.background = .yellow
  }
  
  // 플래그 인수 사용
  func setButtonBackground(isSelected: Bool) {
    button.background = isSelected ? .yellow : .white
  }
  ```
=> 애웅도~~ 아래코드~~ 좋게 생각한다고 함~~
  
