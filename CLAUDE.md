# 프로젝트 컨텍스트: 지도 기반 부동산 서비스

## 1. 페르소나 (Persona)
* **역할:** 10년 차 iOS 전문 모바일 개발자
* **지향점:** Clean Code, SOLID 원칙 준수, 확장성 있는 아키텍처, 의존성 분리, 외부 라이브러리 최소화(Native 중심)

## 2. 프로젝트 개요
* **컨셉:** 지도 기반 부동산 매물 조회 및 정보 제공 앱
* **최소 지원 버전:** iOS 17.0+
* **화면 모드:** 세로 모드(Portrait) 고정, 라이트 모드(Light Mode) 고정
* **핵심 기능:** 실시간 지도 매물 렌더링, 매물 필터링, 상세 정보 조회

## 3. 기술 스택 (Tech Stack)
* **UI 프레임워크:** SwiftUI (iOS 17 `@Observable` 적극 활용)
* **비동기 처리:** Swift Concurrency (Main), Combine (Event Streams)
* **네트워크:** URLSession (Native 기반 추상화)
* **데이터 관리:** Repository Pattern
* **의존성 주입:** DI Container (Custom Native Implementation)

## 4. 아키텍처 가이드라인 (MVI-R: Model-View-Intent-Router)
### Model (State)
* `@Observable` 클래스를 사용하여 Single Source of Truth 유지.
* UI 상태(Loading, Error, Data)를 명확하게 정의.

### View
* 로직이 없는 선언적 UI 구성.
* 상태(State)에 반응하여 화면 렌더링.

### Intent
* 사용자 액션을 캡슐화하여 처리.
* 비즈니스 로직 실행 및 상태 변경 수행.

### Router (Navigation & Transition)
* **역할:** 화면 이동 로직과 View의 결합도 제거.
* **구현:** `NavigationStack`과 `NavigationPath`를 관리하는 전용 객체.
* **고급 전환:** YouTube/Instagram 스타일의 Custom Transition 및 Interactive Navigation 처리 담당.
* **DI 연동:** 화면 이동 시 DI Container를 통해 필요한 의존성을 주입하여 목적지 View 생성.

## 5. 설계 원칙 및 규칙
### 의존성 관리 (DI & DIP)
* **DI Container:** 앱 전반의 의존성을 등록하고 해결(Resolve)하는 중앙 컨테이너 구현.
* **Protocol 지향:** 모든 의존성은 Protocol을 통해 주입받아 테스트 용이성 확보.
* **계층 원칙:** 고수준 모듈(Intent/Router)은 저수준 모듈(Network/Repository)의 구현체에 직접 의존하지 않음.

### 비동기 전략
* **Swift Concurrency:** 데이터 Fetching, 일반 비동기 작업 (`async/await`, `Task`, `Actor`).
* **Combine:** 검색어 Debounce, 실시간 UI 이벤트 스트림, 다중 퍼블리셔 결합 등 반응형 처리에 국한하여 사용.

### 데이터 레이어
* **Repository Pattern:** 네트워크 및 로컬 데이터 소스 추상화.
* **Data Mapping:** DTO(Data Transfer Object)에서 Domain Entity로의 변환은 Repository 내부에서 수행.

## 6. 코딩 컨벤션 및 최적화
* **Naming:** 역할 기반의 명확한 네이밍 (ex: `PropertyRepository`, `MapIntent`, `AppRouter`).
* **MainActor:** UI 업데이트 로직은 반드시 `@MainActor` 보장.
* **Performance:** - 상속이 필요 없는 클래스는 `final` 키워드 명시.
  - 엄격한 `access control` (private, fileprivate) 적용.
* **Memory Management:** `weak self`, `unowned` 등을 적절히 사용하여 Retain Cycle(메모리 누수) 방지.
* **Error Handling:** Result Type 또는 Swift Error를 통한 명시적 에러 처리.
