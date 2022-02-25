# 1장
## 중요 내용
- 리팩토링 이전에 선행되어야 할 건 **테스트 코드**!  이게 있어야 코드를 수정해도 문제가 없나 파악할 수 있음
 
   `수정 -> 컴파일 -> 테스트` 가 하나의 사이클
- 코드가 길어지는 것 보다 **명확**하게 표현할 수 있는가가 더 중요. 
- 함수를 잘 **쪼개자**
- **다형성**을 잘 활용하자
- 변수 인라인하기 등의 기법 때문에 로직이 **여러번 호출**될 수 있음. 하지만 각종 **최적화** 기법 덕에 성능상 크게 차이가 없을 가능성이 많다고 함. 일단 리팩토링하고, 실제로 느려지면 그때 다시 수정,,하라고 함!
## swift 용 예시 코드
[Chapter1](https://github.com/sujinnaljin/Refactoring/tree/main/Chapter1)
## 나의 생각
- 🤔 "변수 인라인하기"가 많이 나오는데, 그러면 같은 값을 여러 곳에서 관리해야해서 오히려 더 유지보수하기 불편해지지 않나? 한줄도 길어져서 가독성도 떨어지고,,? 이거는 좋은지 잘 모르겠다
  ![image](https://user-images.githubusercontent.com/20410193/152670034-8b32a6fb-0c17-4988-bbad-c2e5e9844f46.png)
## 해보면 좋을것
- 저자가 똑같은 동작의 for 문이라도 의미가 분리된다면 loop 를 분리하라고 했는데, 사실 이것도 읭? 스럽긴 함. 실제로 컴파일러에서 이걸 최적화 해서 묶어주나? 테스트해보면 좋을듯 -> [[Swift] Canonical SIL 까지의 최적화에 대한 고찰](https://sujinnaljin.medium.com/swift-canonical-sil-%EA%B9%8C%EC%A7%80%EC%9D%98-%EC%B5%9C%EC%A0%81%ED%99%94%EC%97%90-%EB%8C%80%ED%95%9C-%EA%B3%A0%EC%B0%B0-69fa2b0d5a4d)
```swift
//전
let range = (1...10)

var totalAmount = 0
var volumeCredits = 0
range.forEach { amount in
    totalAmount += amount
    volumeCredits += amount
}

//후
let range = (1...10)

var totalAmount = 0
range.forEach { amount in
    totalAmount += amount
}

var volumeCredits = 0
range.forEach { amount in
    volumeCredits += amount
}
```
