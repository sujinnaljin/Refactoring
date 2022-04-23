# 10장

## 10-1. 조건문 분해하기

- 거대한 코드 블럭을 **부위별로 분해**한 다음 해체된 코드 덩어리를 **함수 호출로 바꾸**면 전체적인 의도가 확실히 드러남
- 특히 **조건식과 조건절**에 이 작업을 하면 해당 **조건이 무엇인지 강조**하고, 그래서 **무엇을 분기했는지가 명백**해짐.
- 이 리팩터링은 자신의 코드에 함수 추출하기를 적용하는 한 사례로 볼 수 있음

## 10-2. 조건식 통합하기

```javascript
// 전
if (anEmployee.seniority < 2) return 0;
if (anEmployee.monthsDisabled > 12) return 0;
if (anEmployee.seniority.isPartTime) return 0;

// 후 - or 로 결합
if (isNotEligibleForDisability()) return 0;

function isNotEligibleForDisability() {
  return ((anEmployee.seniority < 2)
         || (anEmployee.monthsDisabled > 12)
         || (anEmployee.seniority.isPartTime))
}

// 전
if (anEmployee.onVacation)
  if (anEmployee.seniority > 10) 
    return 1;
return 0.5

// 후 - if문이 중첩되면 and 로 결합
if ((anEmployee.onVacation)
    && (anEmployee.seniority > 10)) return 1;
return 0.5
```

- 비교하는 조건은 다르지만 그 **결과로 수행하는 동작은 똑같은** 코드가 있다면 **and 나 or** 을 사용해서 **조건 검사도 하나로 통합**하는게 나음
- 조건을 통합함으로써 하려는 일이 더 명확해짐
- 복잡한 조건식을 함수로 추출하면 코드의 의도가 분명하게 드러나기 때문에, 이 작업이 함수 추출까지 이어질 가능성이 높음
- 하지만 하나의 검사라고 생각할 수 없는, 즉 진짜로 **독립된 검사**들이라고 판단되면 **결과가 같더라도 이 리팩터링을 하면 안**됨

## 10-3. 중첩 조건문을 보호 구문으로 바꾸기

- 조건문은 보통 두가지 형태로 사용됨
  - 참인 결로와 거짓인 경로 모두 정상 동작으로 이어짐
  - 한쪽만 정상임
- 만약 **한쪽만 정상**인 경우라면, 비정상 조건을 if 에서 검사한 다음, **조건이 참이면 (비정상이면) 함수에서 빠져**나옴. -> 이를 **보호 구문**(guard clause)이라고 함
- 이 리팩터링의 핵심은 "이건 이 함수의 핵심이 아니니, 이 일어나면 무언가 조취를 취한 후 함수에서 빠져나온다"의 **의도를 부각**하는데 있음

## 10-4. 조건부 로직을 다형성으로 바꾸기

- 타입을 여러개 만들고 각 타입이 조건부 로직을 자신만의 방식으로 처리하도록 구성할 수 있음
- 다형성을 활용해서 어떻게 동작할지를 각 타입이 알아서 처리하도록 하면 됨

```javascript
// 전
function plumages(birds) {
  return new Map(birds.map(b => [b.name, b.plumage]));
}

function plumage(bird) {
  switch (bird.type) {
    case '유럽 제비':
      return "보통이다";
    case '아프리카 제비'
      return (bird.numberOfCoconuts > 2) ? "지쳤다" : "보통이다"; 
    default: 
      return "알 수 없다";
  }
}

// 후
function plumages(birds) {
  return new Map(birds
                .map(b => createBird(b))
                .map(bird => [bird.name, bird.plumage]))
}

function createBird(bird) {
  switch (bird.type) {
    case '유럽 제비':
      return new EuropeanSwallow(bird);
    case '아프리카 제비'
      return new AfricanSwallow(bird);
    default: 
      return new Bird(bird);
  }
}

class Bird {
  constructor(birdObject) {
    Object.assign(this, birdObject);
  }
  
  get plumage() {
    return "알 수 없다";
  }
}

class EuropeanSwallow extends Bird {
  get plumage() {
    return "보통이다"
  }
}

class AfricanSwallow extends Bird {
  get plumage() {
    return (this.numberOfCoconuts > 2) ? "지쳤다" : "보통이다"; 
  }
}
```

## 10-5. 특이 케이스 추가하기

- 특수한 경우 (ex. null 케이스) 에 공통 동작을 요소 하나에 모아서 사용
- 코드 베이스에서 특정 값에 대해 똑같이 반응하는 코드가 여러 곳이라면 그 반응들을 한데로 모으는게 효율적

```javascript
// 전
// client 1
if (aCustomer == "미확인 고객") customerName = "거주자";
else customerName = aCustomer.name
// client 2
const plan = (aCustomer == "미확인 고객") ? registry.billingPlans.basic 
  : aCustomer.biliingPlan

// 후
class UnknownCustomer {
  get name() {return "거주자";}
  get billingPlan() {return registry.billingPlans.basic;}
}
get customer() {
  return (this.customer === "미확인 고객" ? new UnknownCustomer() : this._customer);
}
// client 1
const customerName = aCustomer.name
// client 2
const plan = aCustomer.billingPlan
```

## 10-6. 어서션 추가하기

- 어서션은 항상 참이라고 가정하는 조건부 문장으로, 어서션이 실패했다는 건 프로그래머가 잘못했다는 뜻
- 어서션 실패는 시스템의 **다른 부분에서는 절대 검사하지 않아**야하며, 어서션이 있고 없고가 프로그램 **기능의 정상 동작에 아무런 영향을 주지 않도록** 작성돼야 함
- 어서션은 프로그램이 어떤 상태임을 가정한 채 실행되는지를 다른 개발자에게 알려주는 훌륭한 소통 도구
- 테스트 코드가 있다면 어서션의 디버깅 용도로서의 효용은 줄어들지만, 소통 측면에서는 여전히 매력적
- 어서션을 남발하는 것 역시 위험하며, 저자는 반드시 참이어야하는 곳, 절대로 실패하지 않으리라 믿는 곳에만 검사한다고 함
- 저자는 프로그래머가 일으킬만한 오류에만 어서션을 사용하고, 외부로부터 읽어온 데이터는 어서션의 대상이 아니라 예외 처리로 대응해야하는 프로그램 로직의 일부로 다룸

## 10-7. 제어 플래그를 탈출문으로 바꾸기

```java
// 전
for (const p of people) {
  if (!found) {
    if (p === "조커") {
      sendAlert();
      fount = true;
    }
  }
}

// 후
for (const p of people) {
  if (p === "조커") {
    sendAlert();
    break;
  }
}
```

- 제어 플래그란 코드의 동작을 변경하는 데 사용되는 변수를 말하며, 어딘가에서 값을 계산해 제어 플래그에 설정한 후 다른 어딘가의 조건문에서 검사하는 형태로 쓰임. 
- 저자는 이런 제어 플래그를 항상 악취로 봄. 리팩터링으로 충분히 간소화할 수 있음에도, 복잡하게 작성된 코드에서 흔히 나타나기 때문
- 제어 플래그의 주 서식지는 반복문

