# CLAUDE.md


This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

IceButler (냉집사) is an iOS refrigerator management app built with Swift. The app helps users manage their refrigerator contents, track food expiration dates, discover recipes, and reduce waste. It features social functionality allowing users to share fridges and shopping lists.

## Development Commands

### Building and Running
- Open `IceButler_iOS.xcworkspace` in Xcode (not the .xcodeproj file)
- Build: Cmd+B
- Run: Cmd+R
- Test: Cmd+U

### Dependencies
- Uses Swift Package Manager for dependency management
- Main dependencies include:
  - Alamofire (networking)
  - Swift Composable Architecture (TCA) - for state management
  - SwiftUI Navigation - for navigation
- Dependencies are managed through Package.resolved file

## Architecture

### Overall Pattern
- **MVVM + TCA (The Composable Architecture)**: The app is transitioning from traditional MVVM to TCA pattern
- **SwiftUI + UIKit Hybrid**: Mix of SwiftUI views (new features like Login) and UIKit ViewControllers (legacy code)
- **Layered Architecture**: Clear separation between Data, Network, Presentation layers

### Key Architectural Components

#### Data Layer (`IceButler_iOS/Data/`)
- **Models**: Request/Response models organized by feature (Auth, Cart, Food, Fridge, Recipe, etc.)
- **Services**: API service classes that handle network requests for each domain
- **Pattern**: Each feature has RequestModel and ResponseModel classes

#### Network Layer (`IceButler_iOS/Network/`)
- **APIManager**: Centralized networking class using Alamofire
- **Singleton pattern**: `APIManger.shared` handles all HTTP requests
- **Generic methods**: Type-safe API calls with Codable support

#### Presentation Layer (`IceButler_iOS/Presentation/`)
- **ViewControllers**: UIKit-based screens (legacy)
- **SwiftUI Views**: New features use SwiftUI + TCA (e.g., Login)
- **Cells**: Custom table/collection view cells with XIB files
- **ViewModels**: MVVM pattern for UIKit screens

#### TCA Integration
- **Stores**: TCA Reducer pattern (e.g., `LoginStore.swift`)
- **State Management**: Centralized state with actions and reducers
- **New features** should use TCA pattern, existing features use traditional MVVM

### Key Patterns
1. **Feature-based organization**: Code organized by app features (Auth, Cart, Food, Fridge, Recipe, etc.)
2. **Generic networking**: APIManager uses generic methods for type-safe API calls
3. **Coordinator pattern**: For navigation in UIKit portions
4. **Observer pattern**: Using Combine for reactive programming

## Code Style and Conventions

### Naming Conventions
- **Classes**: PascalCase (e.g., `LoginViewController`, `APIManager`)
- **Files**: Match class names, organized in feature folders
- **Assets**: Descriptive names in camelCase (e.g., `iceButlerMainIcon`)

### File Organization
- Group related files in feature folders
- Separate XIB files for custom cells
- Storyboards named after their main functionality

### Architecture Migration
- **New features**: Use SwiftUI + TCA
- **Existing features**: Maintain MVVM pattern unless major refactoring
- **Gradual migration**: Converting screens from UIKit to SwiftUI as needed

## Important Notes

### API Configuration
- Base URLs are hardcoded as "BASE_URL" and "RECIPE_URL" strings in APIManager
- Headers management through singleton pattern

### Asset Management
- Extensive use of image assets organized by feature
- Custom fonts: NanumSquare family
- Color assets defined in Colors.xcassets

### Testing
- Test targets: `IceButler_iOSTests` and `IceButler_iOSUITests`
- Run tests with Cmd+U in Xcode

### Git Workflow
- **Branch naming**: `feature/issue-number-description` (e.g., `feature/7-desserts-patchDessert`)
- **Commit format**: `#issue-number type: description` (e.g., `#1 feat: 일정 등록 API 추가`)
- **PR format**: `[branch-name] description`

## Current Development Context

The project is actively being refactored to use TCA (The Composable Architecture) for new features while maintaining existing MVVM architecture for legacy code. The Login feature demonstrates the new TCA pattern with SwiftUI views.

---

# IceButler iOS 앱 마이그레이션 최종 전략 (무료 Basic + 유료 구독 중심)

## 📌 핵심 방향성
1. "무료로 시작, 고급 기능은 유료" 모델  
   - 모든 사용자는 영수증 스캔 5회/월 무료 (기본 기능 체험 유도)  
   - 고빈도/고급 기능은 구독 필수 → 월 $4.99부터  

2. GPT API 비용 통제  
   - 무료 사용자: 월 5회 Hard Limit (초과 시 구독 유도)  
   - 유료 사용자: 10회~무제한 (티어별 차등 적용)  

3. AdMob으로 무료 사용자 수익화  
   - 게스트/무료 사용자에게 전면 광고 1회/일 강제 노출  

## 🔧 기능 재구성
### 1. 무료 제공 기능 (Free Tier)
| 기능 | 제한 사항 | 비즈니스 목적 |
|------|-----------|---------------|
| 영수증 스캔 + 유통기한 분석 | 월 5회 | GPT API 비용 통제 |
| 냉장고 아이템 수동 추가 | 무제한 | 기본 유틸리티 제공 |
| 유통기한 알림 (기본) | 3개 아이템까지 | 구독 유도 |

### 2. 유료 구독 기능 (Pro Tier - $4.99/월)
| 기능 | 제공 내용 | 핵심 가치 |
|------|-----------|-----------|
| 영수증 스캔 | 월 20회 | GPT API 비용 대비 수익 확보 |
| AI 식품 분석 | 유통기한 최적화 리포트 | 구독 전환 결정 요소 |
| 가족 공유 | 최대 3명 초대 | 확장성 제공 |
| 광고 제거 | 모든 광고 비활성화 | UX 개선 |

### 3. 프리미엄 구독 (Premium Tier - $9.99/월)
| 기능 | 제공 내용 | 타겟층 |
|------|-----------|--------|
| 영수증 스캔 | 무제한 | 고빈도 사용자 |
| AI 식품 조합 추천 | GPT 기반 레시피 생성 | 건강 관심층 |
| 가족 공유 | 최대 6명 초대 | 대가족 |

## 💰 수익 구조 시뮬레이션 (MAU 1,000명 기준)
| 항목 | Free Tier (70%) | Pro Tier (20%) | Premium Tier (10%) | 합계 |
|------|-----------------|----------------|--------------------|------|
| 사용자 수 | 700 | 200 | 100 | 1,000 |
| 구독 수익 | - | 200 × $4.99 = $998 | 100 × $9.99 = $999 | $1,997 |
| AdMob 수익 | 700 × $0.05 = $35 | - | - | $35 |
| GPT API 비용 | 700 × 5회 × $0.06 = $210 | 200 × 20회 × $0.06 = $240 | 100 × 100회 × $0.06 = $600 | $1,050 |
| 순익 | | | | $982 (≈ 월 $1,000) |

> ✅ MAU 1,000명으로 월 $1,000 흑자 가능  
> (전환율 30% 가정, GPT API 비용 최적화 포함)

## 🛠️ 마이그레이션 단계별 실행 계획
### 1. Phase 1: 핵심 기능 재설계 (4주)
- 기존 코드 정리: 장바구니, 공용 냉장고 모듈 삭제  
- 영수증 OCR + GPT 연동 MVP 개발  
  ```swift
  // 예: 스캔 횟수 제한 로직
  func isScanAvailable() -> Bool {
      let freeScansLeft = UserDefaults.standard.integer(forKey: "remainingScans")
      return freeScansLeft > 0 || isSubscribed()
  }
  ```

### 2. Phase 2: 구독 시스템 구축 (3주)
- RevenueCat 연동:  
  - Free/Pro/Premium 티어 설정  
  - 앱 내 구독 페이지 디자인  

### 3. Phase 3: 광고 통합 (2주)
- AdMob 전면 광고:  
  ```swift
  // 게스트 모드에서만 노출
  if !isSubscribed() && isGuestUser() {
      showInterstitialAd()
  }
  ```

### 4. Phase 4: 출시 후 최적화 (지속적)
- A/B 테스트:  
  - 무료 제공 횟수 (3회 vs 5회) 비교  
  - 구독 가격 ($4.99 vs $3.99) 테스트  

## 🎯 성공 핵심 전략
1. 무료 사용자 → 유료 전환 유도  
   - "5회 스캔으로는 부족해요!" → 팝업 유도  
2. Premium Tier 가치 부각  
   - "무제한 스캔 + 가족 6명과 공유" 강조  
3. GPT API 비용 제어  
   - 무료 사용자 Hard Limit, 유료는 Tier별 할당량 관리  

> ✨ 결론: "무료 체험 → 구독 전환" 모델로 MAU 1,000명에서도 수익 가능한 구조 완성!

---

# 🔄 기능 개편 계획

## ❌ 제거할 기능
### 1. 레시피 기능
- **제거 이유**: 사용자 피드백에 따라 주 사용 시나리오와 맞지 않음
- **관련 코드**: 
  - `IceButler_iOS/Presentation/Recipe/` 전체 폴더
  - `IceButler_iOS/Data/Model/Recipe/` 모델
  - `IceButler_iOS/Data/Service/Recipe/` 서비스
  - `IceButler_iOS/Presentation/ViewModel/Recipe/` 뷰모델

### 2. 장바구니 기능
- **제거 이유**: 주 사용 시나리오와 맞지 않음 (냉장고 관리가 핵심)
- **관련 코드**:
  - `IceButler_iOS/Presentation/ViewControllers/Cart/` 전체 폴더
  - `IceButler_iOS/Data/Model/Cart/` 모델
  - `IceButler_iOS/Data/Service/Cart/` 서비스
  - `IceButler_iOS/Presentation/ViewModel/Cart/` 뷰모델

### 3. 공용 냉장고 기능
- **제거 이유**: 보안 및 프라이버시 이슈, 복잡한 권한 관리
- **관련 코드**:
  - `APIManger.swift`의 `isMultiFridge` 관련 로직
  - 멀티 냉장고 관련 UI 컴포넌트

## 💰 유료 구독제로 전환할 기능

### 1. 식품 분석 기능 (Pro Tier - $4.99/월)
- **유통기한 알림 최적화**: 3개 → 무제한
- **식품 조합 추천**: GPT 기반 맞춤 추천
- **영양소 분석**: 냉장고 속 식품 영양 분석 리포트

### 2. 가족 초대 기능 (Pro Tier - $4.99/월)
- **가족 구성원**: 최대 3명 (Pro) / 6명 (Premium)
- **실시간 공유**: 냉장고 상태 실시간 동기화
- **권한 관리**: 보기/편집 권한 세분화

## ✨ 새로 추가할 기능

### 1. 영수증 OCR + GPT 기반 유통기한 관리
```swift
// 핵심 워크플로우
class ReceiptScanService {
    func scanReceipt(image: UIImage) async throws -> [FoodItem] {
        // 1. OCR로 상품 정보 추출
        let ocrResult = try await extractTextFromReceipt(image)
        
        // 2. GPT API로 유통기한 계산
        let foodItems = try await analyzeWithGPT(ocrResult)
        
        // 3. 자동으로 냉장고에 추가
        return foodItems
    }
}
```

**주요 장점**:
- ✅ 수동 입력 필요 없음
- ✅ 더 정확한 유통기한 예측  
- ✅ 사용자 편의성 극대화
- ✅ GPT API 사용으로 구독 유도

### 2. 스캔 횟수 제한 시스템
```swift
struct ScanLimitManager {
    static let freeMonthlyLimit = 5
    static let proMonthlyLimit = 20
    
    func canScan() -> Bool {
        let currentCount = getCurrentMonthScanCount()
        let limit = isSubscribed() ? proMonthlyLimit : freeMonthlyLimit
        return currentCount < limit
    }
}
```

## 🗂️ 코드 구조 변경 계획

### 제거될 주요 파일/폴더:
1. **Recipe 관련**: `~/Recipe/` 폴더 전체
2. **Cart 관련**: `~/Cart/` 폴더 전체  
3. **Graph 관련**: 통계 기능 단순화


## 📋 마이그레이션 우선순위

### Phase 1: 정리 (2주)
1. **코드 제거**: Recipe, Cart, 공용냉장고 모듈 삭제
2. **의존성 정리**: 불필요한 imports 및 references 제거
3. **UI 정리**: 탭바에서 해당 기능 제거

### Phase 2: 핵심 기능 구현 (4주)  
1. **영수증 OCR 연동**: Vision Framework 활용
2. **GPT API 연동**: OpenAI API 통합
3. **스캔 제한 로직**: 무료/유료 티어별 제한

### Phase 3: 구독 시스템 (3주)
1. **RevenueCat 연동**: 구독 관리 SDK
2. **결제 UI**: 구독 페이지 및 플랜 선택
3. **기능 잠금**: 유료 기능 접근 제어

### Phase 4: 가족 공유 (3주)
1. **초대 시스템**: 이메일/링크 기반 초대
2. **실시간 동기화**: Firebase 또는 WebSocket
3. **권한 관리**: 역할별 접근 제어



