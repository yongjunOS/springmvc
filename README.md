# Spring Framework 기반 게시판 프로젝트

이 프로젝트는 Spring Framework를 활용한 웹 게시판 시스템입니다. CRUD 기능과 댓글 시스템을 구현하였으며, RESTful API 설계 및 구현도 포함되어 있습니다.

## 주요 기능

- 게시판 CRUD 기능 구현
- 댓글 시스템 개발 (대댓글 포함)
- 사용자 인증 및 권한 관리
- 페이징 및 검색 기능 구현
- RESTful API 설계 및 구현

## 기술 스택

- 언어: Java 11, HTML, CSS, JavaScript, jQuery, JSP
- 프레임워크/라이브러리: Spring Framework, MyBatis
- 서버: Tomcat 9
- 데이터베이스: MySQL
- 개발 도구: IntelliJ
- 버전 관리: Git

## 주요 구현 사항

### 댓글 시스템의 비동기 처리를 위한 AJAX 구현

이 프로젝트에서 댓글 시스템은 사용자 경험을 향상시키기 위해 비동기적으로 처리되었습니다. 이는 페이지 전체를 새로고침하지 않고도 댓글을 추가, 수정, 삭제할 수 있게 해줍니다.

구현 방법:

1. jQuery를 사용하여 AJAX 요청을 처리했습니다.
2. RESTful API 엔드포인트를 만들어 댓글 관련 작업을 처리했습니다.
3. 클라이언트 측에서는 JavaScript를 사용하여 DOM을 동적으로 업데이트했습니다.

### Spring의 트랜잭션 관리를 통한 데이터 일관성 유지

트랜잭션 관리는 데이터베이스 작업의 원자성, 일관성, 격리성, 지속성(ACID)을 보장하는 중요한 개념입니다. 이 프로젝트에서는 Spring의 선언적 트랜잭션 관리를 사용하여 이를 구현했습니다.

구현 방법:

1. @Transactional 어노테이션을 사용하여 트랜잭션이 필요한 메서드나 클래스에 적용했습니다.
2. 설정 파일(root-context.xml)에서 트랜잭션 관리자를 설정했습니다.

이러한 구현을 통해 데이터의 무결성을 유지하고, 여러 데이터베이스 작업이 하나의 단위로 처리되도록 보장했습니다.

### 로그인화면
<img width="1440" alt="image" src="https://github.com/user-attachments/assets/8901a84b-3b74-41d0-925c-3bbda9a90a70">

### 게시글 목록
<img width="1440" alt="image" src="https://github.com/user-attachments/assets/c10a8448-a03e-411f-a9d8-48b3c7fd3dce">

### 게시글 작성
<img width="1440" alt="image" src="https://github.com/user-attachments/assets/6249c9e4-6e76-4558-81f3-d8fde8a7306f">

### 댓글 작성
<img width="1440" alt="image" src="https://github.com/user-attachments/assets/723aefeb-6b00-4b14-91cd-b7889802429b">
