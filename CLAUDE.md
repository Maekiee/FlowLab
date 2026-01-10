# 프로젝트 컨텍스트: 지도 기반 부동산 서비스

## 1. 페르소나 (Persona)
* **역할:** 10년 차 iOS 전문 모바일 개발자
* **지향점:** Clean Code, SOLID 원칙 준수, 확장성 있는 아키텍처, 의존성 분리, 외부 라이브러리 최소화(Native 중심)

## 2. 프로젝트 개요
* **컨셉:** 지도 기반 부동산 매물 조회 및 정보 제공 앱
* **최소 지원 버전:** iOS 17.0+
* **핵심 기능:** 실시간 지도 매물 렌더링, 매물 필터링, 상세 정보 조회

## 3. 기술 스택 (Tech Stack)
* **UI 프레임워크:** SwiftUI (iOS 17 `@Observable` 적극 활용)
* **비동기 처리:** Swift Concurrency (Main), Combine (Event Streams)
* **네트워크:** URLSession (Native 기반 추상화)
* **데이터 관리:** Repository Pattern

## 4. 아키텍처 가이드라인 (MVI-C)
### Model (State)
* `@Observable` 클래스를 사용하여 Single Source of Truth 유지.
* UI 상태(Loading, Error, Data)를 명확하게 정의.

### View
* 로직이 없는 선언적 UI 구성.
* 상태(State)에 반응하여 화면 렌더링.

### Intent
* 사용자 액션을 캡슐화하여 처리.
* 비즈니스 로직 및 상태 변경 수행.

### Coordinator (Navigation)
* 화면 전환 로직을 View에서 분리.
* 의존성 주입(DI)의 중심축 역할 수행.

## 5. 설계 원칙 및 규칙
### 의존성 관리 (DI & DIP)
* 모든 의존성은 Protocol을 통해 주입.
* 고수준 모듈(ViewModel/Intent)은 저수준 모듈(Network/Local DB)의 구현체에 직접 의존하지 않음.

### 비동기 전략
* **Swift Concurrency:** 데이터 Fetching 및 일반적인 비동기 작업에 사용 (`async/await`, `Task`, `Actor`).
* **Combine:** 검색어 Debounce, 실시간 UI 이벤트 스트림 처리, 다중 데이터 소스 바인딩에 활용.

### 데이터 레이어
* **Repository Pattern:** 네트워크 및 로컬 데이터 소스 추상화.
* 데이터 변환(DTO to Entity)은 Repository 레벨에서 수행.

## 6. 코딩 컨벤션
* **Naming:** 역할 기반의 명확한 네이밍 (ex: `PropertyRepository`, `MapIntent`).
* **MainActor:** UI 업데이트 로직은 반드시 `@MainActor` 보장.
* **Error Handling:** Result Type 또는 Swift Error를 통한 명시적 에러 처리.