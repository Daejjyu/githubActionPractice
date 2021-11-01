# CI/CD, Github Action, 배포

으로 React 와 express를 NginX, Docker로 배포하기

## CI/CD

### CI/CD란?

- CI/CD는 애플리케이션 개발 단계를 자동화하여 애플리케이션을 보다 짧은 주기로 고객에게 제공하는 방법이다.
- CI/CD는 파이프라인으로 표현되는 실제 프로세스를 의미하고, 애플리케이션 개발에 지속적인 자동화 및 지속적인 모니터링을 추가하는 것을 의미한다.

### CI

- CI는 개발자를 위한 자동화 프로세스인 지속적인 통합(Continuous Integration)을 의미한다.
- CI를 성공적으로 구현할 경우 애플리케이션에 대한 새로운 코드 변경 사항이 정기적으로 빌드 및 테스트되어 공유 리포지토리에 통합되므로 여러 개발자가 충돌할 수 있는 문제가 해결된다.
- ex) 빌드 자동화, 유닛 및 통합 테스트 수행
- CI의 전형적인 프로세스
  ![CI의 전형적인 프로세스](https://user-images.githubusercontent.com/37368480/139687799-01bc4347-1954-4c0a-a17a-73aa2647253c.png)

### CD

- CD는 지속적인 서비스 제공(Continuous Delivery) 및 지속적인 배포(Continuous Deployment)를 의미한다.
- 지속적인 제공(Delivery)이란 개발자들이 애플리케이션에 적용한 변경 사항이 버그 테스트를 거쳐 리포지토리에 자동으로 업로드 되는 것을 뜻한다. 지속적인 제공은 최소한의 노력으로 새로운 코드를 배포하는 것을 목표로 한다.
- ex) 코드 변경 사항 병합, 테스트 자동화, 코드 릴리스 자동화
- 지속적인 배포(Deployment)는 개발자의 변경 사항을 리포지토리에서 고객이 사용 가능한 프로덕션 환경까지 자동으로 릴리스하는 것을 의미한다.
- 실제 사례에서 지속적 배포란 개발자가 애플리케이션에 변경 사항을 작성한 후 몇 분 이내에 자동화된 테스트를 통과하고 애플리케이션을 자동으로 실행할 수 있는 것을 의미한다.
- ex) 애플리케이션을 프로덕션으로 릴리스하는 작업을 자동화
- CI/CD 파이프라인
  ![CI/CD 파이프라인](https://user-images.githubusercontent.com/37368480/139688524-e7382702-30a1-4b43-86a9-14d729b1ba67.png)

## Github Action

### [Github Action](https://docs.github.com/en/actions)이란?

- Github 저장소를 기반으로 소프트웨어 개발 workflow를 자동화 할 수 있는 도구, 간단하게 말하자면 Github에서 직접 제공하는 CI/CD 도구
- build, test, package, release, deploy 등 다양한 이벤트를 기반으로 직접 원하는 Workflow를 만들 수 있다.
- Workflow는 Runners라고 불리는 Github에서 호스팅 하는 Linux, macOS, Windows 환경에서 실행된다. (사용자가 호스팅하는 환경에서 직접 구동시킬 수도 있다.)
- Action Flow
  ![Action Flow](https://user-images.githubusercontent.com/37368480/139702938-42492b1b-7d36-4b33-a726-988c85f06805.png)

### 장점

1. 다른 CI/CD 툴보다 쉽고 간단하며 따로 CI/CD 툴을 설치할 필요가 없다.
2. github 이벤트들에 반응한다.
3. 플랫폼, 언어, 클라우드에 구애받지 않는다.
4. workflow 커뮤니티가 있다.

### Workflow 주요 구성

- 이벤트 발생 시 혹은 주기적(cron)으로 실행시킬 수 있다.
- 여러 개의 Job으로 구성되며 최소 1개 이상의 Job을 정의해야 한다.
- Job 안에는 여러 Step을 정의할 수 있다.
- Step 안에는 단순한 커맨드 실행이나 Action을 가져와 사용할 수 있다.
- Action은 Github 마켓플레이스에 공유된 Action을 이용하거나 현재 저장소에서 직접 만들어서 사용할 수 있다.

### 시작하기

1. Github Repo Action Tab 들어가기
2. 직접 workflow를 구성하거나 이미 존재하는 workflow를 사용한다.

- ![image](https://user-images.githubusercontent.com/37368480/139704019-60c229bb-bb55-4b7f-bf6e-0fc1a159045e.png)
- 예시

  ```
  name: my workflow                     # Workflow 이름
  on: [push]                            # Event 감지

  jobs:                                 # Job 설정
    build:                              # Job ID
      name: hello github action         # Job 이름
      runs-on: ubuntu-18.04             # Job 가상환경 인스턴스
      steps:                            # Steps
        - name: checkout source code    # Step 이름
          uses: actions/checkout@master # Uses를 통한 외부 설정 가져오기: 자신의 레포지토리 소스 받아오기

        - name: echo Hello              # Step 이름
          run: echo "Hello"             # Run을 통한 스크립트 실행: Hello 출력
  ```

### [참고]

- [레드햇 - CI/CD(지속적 통합/지속적 제공): 개념, 방법, 장점, 구현 과정](https://www.redhat.com/ko/topics/devops/what-is-ci-cd)
- [GithubAction+React+AWS S3 시리즈](https://velog.io/@loakick/series/GithubActionReactAWS-S3)
- [Github Action 빠르게 시작하기](https://jonnung.dev/devops/2020/01/31/github_action_getting_started/)
