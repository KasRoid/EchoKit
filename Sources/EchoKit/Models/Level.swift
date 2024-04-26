//
//  Level.swift
//
//
//  Created by Lukas on 4/19/24.
//

public enum Level: String, CaseIterable {
    case debug    // 디버그 정보: 개발 중에 발생하는 일반적인 상태 정보나 진행 상황을 나타냅니다.
    case info     // 정보 메시지: 일반적인 운영 정보를 기록, 시스템이 예상대로 작동하고 있음을 알림.
    case warning  // 경고: 잠재적인 문제를 알림, 즉시 해결이 필요하지 않지만 주의가 필요한 상황.
    case error    // 에러 메시지: 예상치 못한 상황이 발생했으나 애플리케이션이 계속 실행 가능한 상태.
    case critical // 심각한 에러: 중대한 문제로 애플리케이션이 제대로 작동하지 않거나 중단될 위험이 있는 상황.
    case fatal    // 치명적 에러: 회복 불가능한 심각한 에러로, 프로그램의 즉각적인 종료를 초래할 수 있음.
}
