# 순수소음
![앱 아이콘](asset/images/app_icon.png)
이 앱은 현재 출시 준비 중입니다. 앱의 소개 및 주요 기능에 대해 아래 영상을 참고해 주세요.
[![앱 소개 영상](https://img.youtube.com/vi/VIDEO_ID/0.jpg)](https://www.youtube.com/watch?v=VIDEO_ID)

## 1. 소개

이 앱은 백색소음을 한 곳에 모아두고, 사용자가 원하는 시간 동안 타이머 기능을 활용하여 재생할 수 있도록 설계된 간단한 Flutter 앱입니다. 집중, 수면, 휴식 등 다양한 상황에서 활용할 수 있습니다.

## 2. 주요 구조
white_noise__app/
├── lib/                 # 애플리케이션의 메인 코드
│   ├── main.dart        # 앱의 진입점
│   ├── models/          # 데이터 모델 (백색소음 정보 등)
│   │   └── sound.dart   # 사운드 모델 정의
│   ├── screens/         # 앱 화면 관련 코드 (메인, 플레이어 등)
│   │   └── music_player_screen.dart  # 음악 플레이어 화면
│   ├── services/        # 오디오 및 타이머 관련 서비스 로직
│   │   ├── audio_manager.dart  # 오디오 재생 및 관리 기능
│   │   └── timer_manager.dart  # 타이머 기능 관리
│   └── widgets/         # 재사용 가능한 UI 위젯들
│       ├── music_control_bar.dart  # 음악 컨트롤 바 UI
│       ├── music_item.dart  # 개별 음악 아이템 위젯
│       └── timer_dialog.dart  # 타이머 설정 다이얼로그
└── pubspec.yaml         # 프로젝트 설정 파일
