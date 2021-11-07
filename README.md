# Github Action, NginX, Docker를 활용한 React & express CI/CD 구축 튜토리얼

- 목차

1. [CI/CD](#cicd)
2. [Github Action](#github-action)
3. [NginX](#nginx)
4. [PM2](#pm2)
5. [Docker](#docker)
6. [Docker-Compose](#dockercompose)
7. [무중단 배포](#무중단-배포)
8. [목표 프로젝트 구조](#목표-프로젝트-구조)
9. [CI/CD 동작 코드](#cicd-동작-코드)
10. [결론](#결론)
11. [참조](#참조)

---

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

1. Github Repo -> Action Tab
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

### 예제 Ncloud Object Storage에 업로드하기

- 권한은 공개로 설정
- ![CLI 사용 가이드](https://user-images.githubusercontent.com/37368480/139718567-6fcda002-6d7a-4558-b8f4-7b64926b1b5f.png)

- [Object Storage CLI 사용 가이드](https://cli.ncloud-docs.com/docs/guide-objectstorage)

```
name: React build
on:
  push:                               # main Branch에서 push 이벤트가 일어났을 때만 실행
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-18.04
    steps:
      - name: Checkout source code.   # 레포지토리 체크아웃
        uses: actions/checkout@v2

      - name: Cache node modules      # node modules 캐싱
        uses: actions/cache@v1
        with:
          path: ./client/node_modules
          key: ${{ runner.OS }}-build-${{ hashFiles('./client/package-lock.json') }}
          restore-keys: |
            ${{ runner.OS }}-build-
            ${{ runner.OS }}-

      - name: Install Dependencies    # 의존 파일 설치
        run: |
          cd client
          npm install

      - name: Build                   # React Build
        run: |
          cd client
          npm run build

      - name: Deploy                  # S3에 배포하기
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.NCLOUD_API_KEY_ID }}      # github repo의 settings탭의 Secrets에서 설정
          AWS_SECRET_ACCESS_KEY: ${{ secrets.NCLOUD_SECRET_KEY }}
        run: |
          cd client
          aws --endpoint-url=https://kr.object.ncloudstorage.com s3 cp \
            --recursive \
            --region ap-northeast-2 \
            build s3://your_bucket_name
```

## NginX

### NginX란?

- 특징

  - Event-driven 이면서 비동기 방식(Asynchronous)으로 동작
  - Single-threaded(worker 프로세스)
  - Non-blocking

- 정적 파일을 처리하는 정적 웹 서버 역할 - FE

  - 서버렌더링으로 react 정적파일 SPA 라우팅 처리 지원
  - event-driven 방식으로 트랜잭션 처리, 접속자 많아도 적절히 처리 가능
  - 포워드 프록시, 캐시 처리 가능
  - 참조 [#1](https://jacobyu.tistory.com/entry/React-nginx-%EB%B0%B0%ED%8F%AC%EA%B3%BC%EC%A0%95-1-%EC%9D%B4%EC%9C%A0) [#2](http://noartist.com/react-nginx-%EC%97%B0%EA%B2%B0-%EB%B0%A9%EB%B2%95-reverse-proxy%EB%8A%94-%EC%9D%B4%EC%A0%9C-%EA%B7%B8%EB%A7%8C/) [#3](https://kscory.com/dev/nginx/setting)

- 서버에 요청을 보내는 리버스 프록시 역할 - BE

  - 리버스 프록시이기에 보안, 로드밸런싱, 캐싱에 유용
  - ![리버스 프록시](https://user-images.githubusercontent.com/37368480/139732708-0f979e0f-30ac-4133-a6c5-2c9209cef5bc.png)

- 설정 파일 양식이 간단해 많은 설정을 쉽게할 수 있음
- 로드밸런싱을 이용한 무중단 배포 가능

### 리액트 build 배포를 위한 설정(Window)

1. [stable 버전 설치 후 압축 해제](http://nginx.org/en/download.html)
2. server의 host와 server_name(url)을 상황에 맞게 수정한다.

```
http{
  server{
    listen 80;
    server_name localhost;
  }
}
```

3. conf/nginx.conf의 정적파일 경로인 location을 수정한다.

- root : build 디렉토리가 들어갈 절대경로
- try_files : 어떤 경로에서 들어와도 `index.html`로 매핑시켜 SPA routing을 사용하기 위한 설정

```
location / {
  root   /your/absolute/path/build;
  index  index.html index.htm;
  try_files $uri /index.html;
}
```

4. nginX를 실행한다.

- 자세한 사항은 [링크](https://madfishdev.tistory.com/3) 참고

### 리액트 build 배포를 위한 설정(window WSL & linux)

- Docker 명령어에서는 linux 명령어를 사용하기 때문에 Window 사용자도 이 방식을 확인해두는 것이 좋다.
- [해당 글](https://www.hanumoka.net/2019/12/29/react-20191229-react-nginx-deploy/) 참고
- wsl에서 systemctl 명령어가 작동하지 않을 시 [참고](https://stackoverflow.com/questions/52197246/system-has-not-been-booted-with-systemd-as-init-system-pid-1-cant-operate)

## PM2

- [공식 홈페이지](https://pm2.keymetrics.io/)
- ADVANCED, PRODUCTION `PROCESS MANAGER` FOR NODE.JS
- PM2 is a daemon process manager that will help you manage and keep your application online 24/7

### 장점

- 서비스 제공 도중 서버가 중지되는 것 방지(Node는 본디 단일 스레드라 예외처리 실패 시 어플리케이션 죽음)
- 싱글 스레드 기반인 Node.js에서 멀티 코어 / 하이퍼 스레딩을 사용할 수 있게 함
- 로드밸런싱, 스케일 업/다운 구현 가능

### 유용한 옵션

- `--watch` : PM2가 실행된 프로젝트의 변경사항을 감지하여 서버를 자동 리로드
- `-i max(코어개수)` : Node.js의 싱글 스레드를 보완하기 위한 클러스터(Cluster) 모드
- `pm2 monit` : 실행된 PM2 프로세스 모니터링

### 추가 학습

- [PM2를 활용한 Node.js 무중단 서비스하기](https://engineering.linecorp.com/ko/blog/pm2-nodejs/)

## Docker

### Docker란?

- 컨테이너 기반 가상화 도구
- 다양한 프로그램, 실행환경을 컨테이너로 추상화하고 동일한 인터페이스를 제공하여 프로그램의 배포 및 관리를 단순하게 한다.

![Docker Overview](https://user-images.githubusercontent.com/37368480/139734831-71de5817-2b02-4cea-92ee-828e95815960.png)

### 컨테이너란?

- 컨테이너는 개별 소프트웨어의 실행에 필요한 실행환경을 독립적으로 운용할 수 있도록 확보해주는 운영체계 수준의 격리 기술이다.
- VM에 비교하여 생각하면 쉬우며 VM과 달리 운영체제 수준에서 가상화를 실시해 VM보다 가볍고 메모리를 적게 차지한다는 장점이 있다.

![VM vs Docker](https://user-images.githubusercontent.com/37368480/139734624-5d00d247-5f1b-4359-80b0-6bad4375caca.png)

### 이미지란?

- 이미지는 컨테이너 실행에 필요한 파일과 설정값등을 포함하고 있는 것으로 상태값을 가지고 변하지 않는다(immutable).
- 컨테이너는 이미지를 실행한 상태라고 볼 수 있고 추가되거나 변하는 값은 컨테이너에 저장된다.
- 같은 이미지에서 여러 개의 컨테이너를 생성할 수 있다.
- 이미지는 url방식으로 관리하며 태그를 붙일 수 있다. `ex) docker.io/library/ubuntu:14.04`

![docker Image](https://user-images.githubusercontent.com/37368480/139735408-67294504-9084-40d3-a6cb-a961e5b184bd.png)

### Dockerfile

- 이미지를 생성하기 위해 작성하는 스크립트 (일종의 설정 파일)
- 도커는 이미지를 만들기 위해 Dockerfile 이라는 파일에 자체 DSL(Domain-specific language) 언어를 이용하여 이미지 생성 과정을 적는다.
- Dockefile은 소스와 함께 버전관리할 수 있고 이미지 생성과정을 관리 및 공유하는데 용이하다.

### Container Port vs Host Port

- `docker run -p 80:5000 --name test centos:latest `명령어에서 앞의 80은 도커를 설치한 호스트의 80포트를, 컨테이너의 5000번 포트에 연결한다는 뜻
- 외부에서 서버 80포트로 접근 -> 80포트는 컨테이너의 5000번 포트에 연결 -> 외부에서 80번 포트에 접속 = 컨테이너의 5000번 포트에 접속

![Docker Port](https://user-images.githubusercontent.com/37368480/139737929-ec345386-1188-4a75-98f4-dc1aa764b2ee.png)

### Docker 기본 명령어

- 컨테이너 목록 확인
  - `docker ps [OPTIONS]`
- 컨테이너 중지
  - `docker stop [OPTIONS] CONTAINER [CONTAINER...]`
- 컨테이너 제거
  - `docker rm [OPTIONS] CONTAINER [CONTAINER...]`
- 이미지 목록 확인
  - `docker images [OPTIONS] [REPOSITORY[:TAG]]`
- 이미지 다운
  - `docker pull [OPTIONS] NAME[:TAG|@DIGEST]`
- 이미지 삭제
  - `docker rmi [OPTIONS] IMAGE [IMAGE...]`
- 컨테이너 로그 보기
  - `docker logs [OPTIONS] CONTAINER`
- 컨테이너 명령어 실행
  - `docker exec [OPTIONS] CONTAINER COMMAND [ARG...]`

### DockerFile 기본 명령어

[참조](https://cultivo-hy.github.io/docker/image/usage/2019/03/14/Docker%EC%A0%95%EB%A6%AC/)

![Docker 명령어1](https://user-images.githubusercontent.com/37368480/139736690-b8f305f4-1c8a-4630-aebc-62ac6a42ad54.png)

![Docker 명령어2](https://user-images.githubusercontent.com/37368480/139736724-ce7770de-4eb3-4620-94da-fa1b37fab493.png)

### Dockerfile로 React + Nginx 이미지 만들기

[React와 Nginx를 Dockerizing하는 방법](https://codechacha.com/ko/dockerizing-react-with-nginx/)

- CRA

```
npx create-react-app docker-react-ngnix
```

- nginx를 설정하기 위한 파일 생성
  - 프로젝트 폴더에 conf/conf.d/default.conf 폴더에 파일을 생성

```
server {
  listen 80;
  location / {
    root   /usr/share/nginx/html;
    index  index.html index.htm;
    try_files $uri $uri/ /index.html;
  }
  error_page   500 502 503 504  /50x.html;
  location = /50x.html {
    root   /usr/share/nginx/html;
  }
}
```

- Dockerfile

```
FROM node:14.16.0 as builder

# 작업 폴더를 만들고 npm 설치
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package.json /usr/src/app/package.json
RUN npm install --silent
RUN npm install react-scripts@2.1.3 -g --silent

# 소스를 작업폴더로 복사하고 빌드
COPY . /usr/src/app
RUN npm run build

FROM nginx:1.13.9-alpine
# nginx의 기본 설정을 삭제하고 앱에서 설정한 파일을 복사
RUN rm -rf /etc/nginx/conf.d
COPY conf /etc/nginx

# 위에서 생성한 앱의 빌드산출물을 nginx의 샘플 앱이 사용하던 폴더로 이동
COPY --from=builder /usr/src/app/build /usr/share/nginx/html

# 80포트 오픈하고 nginx 실행
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

- 실행

```
docker build -f Dockerfile -t docker-react-ngnix
docker run -it -p 80:80 docker-react-ngnix
```

- 새로운 터미널에서 잘 실행 중인지 확인

```
docker ps
```

- login 관련 에러 발생 시

```
$ docker run -it -p 80:80 docker-react-ngnix
Unable to find image 'docker-react-ngnix:latest' locally
docker: Error response from daemon: pull access denied for docker-react-ngnix, repository does not exist or may require 'docker login': denied: requested access to the resource is denied.
```

- 해당 경우
  1. docker login
  2. 이미지 이름을 `{유저명}/이미지이름`으로 수정해준다.

```
docker image tag {이미지} {내 유저명}/{이미지}
docker image tag docker-react-ngnix yourUserName/docker-react-ngnix
```

### [Dokcer 컨테이너에 데이터 저장](https://www.daleseo.com/docker-volumes-bind-mounts/)

- 볼륨 데이터란?
  - 도커는 컨테이너는 독립적인 저장소를 가지며 컨테이너 내부에 저장되는 데이터는 컨테이너가 삭제되었을 경우 함께 사라진다. (휘발성)
  - 컨테이너가 실행 중에 작성 혹은 수정된 파일을 이전 컨테이너가 삭제되더라도 새로운 버전의 컨테이너에서 사용할 수 있도록 따로 분리하여 관리하는 저장소
  - 컨테이너끼리 데이터를 공유할 떄 사용할 수도 있음
- 마운트란?
  - 볼륨을 컨테이너에 연결시키는 것
  - 여러 개의 컨테이너가 하나의 볼륨에 접근 가능(데이터 공유)
  - docker run 커맨드로 컨테이너를 실행할 때 -v 옵션을 사용하여 진행한다.
  - 볼륨 생성 방식, 바인드 마운트 방식이 있다.
  - ![volume_mount](https://user-images.githubusercontent.com/37368480/140637268-5bcc63af-f5cb-44e3-9a59-d7eaa05c4781.png)
- 볼륨 생성 방식 (Type: "volume")
  - 볼륨을 생성하여 마운트
  1. `docker volume create 볼륨이름`
  2. `docker run -v 볼륨_이름:컨테이너_경로`
- 바인드 마운트 방식 (Type: "bind")
  - 특정 경로를 컨테이너로 바로 마운트
  1. `docker run -v `호스트*경로`:컨테이너*경로`
- 볼륨 vs 바인드 마운트
  - 볼륨을 사용하는 것이 권장된다고 한다. 볼륨은 Docker에서 마운트 포인트를 관리해준다.
  - 일단 볼륨은 저장소를 만들어 도커 영역 내에서 관리할 수 있는 것, 바인드 마운트는 그런 기능 없이 단순히 파일시스템 디렉토리에 연결하는 것... 이라고 이해하였음 [참조](https://boying-blog.tistory.com/31)
  - 구체적으로는 경험해봐야 이해할 수 있을 듯

## Docker-Compose

### Compose란?

[공식문서](https://docs.docker.com/compose/compose-file/)

- 복수 개의 컨테이너를 실행시키는 도커 애플리케이션을 정의 하기 위한 툴이다.
- Compose를 사용하면 yaml 파일을 사용하여 서비스를 구성한 후 single command를 사용하여 모든 서비스를 시작할 수 있다.

### 기본적으로 3스텝의 프로세스로 진행

1. 어디에서나 재사용할 수 있는 Dockerfile 정의
2. docker-compose.yml에서 앱을 구성할 수 있는 서비스를 정의하여 단 하나의 환경에서 실행할 수 있게 함
3. docker-compose up 명령어를 실행하여 Compose를 시작시키고 전체 앱을 실행시킴

### 특징

1. 단일 호스트에 여러 개의 격리된 환경(컨테이너) 실행
2. 컨테이너를 만들 떄 볼륨 데이터를 보존함
3. 설정을 캐싱해 놓은 후 변경되지 않은 컨테이너는 재사용,변경된 컨테이너만 다시 작성
4. Compose files에서 변수 설정을 지원하여 다양한 환경에서 적용할 수 있음

### [React App Compose 예시](https://medium.com/sjk5766/create-react-app-docker-compose-%EA%B5%AC%EC%84%B1-b01e1219d14e)

- 이런 명령어 대신

```
docker run -v ./web/nginx.conf:/etc/nginx/nginx.conf -p 80:80
docker run -v ./client:/app -P
.. 이외 많은 명령어 실행
```

- 이렇게 yaml 파일 작성 후

```
version: '3.3'

services:
  web:
    image: nginx:latest
    container_name: web
    restart: "on-failure"
    ports:
      - 80:80
    volumes:
      - ./web/nginx.conf:/etc/nginx/nginx.conf
  client:
    build:
      context: ./client
    container_name: client
    restart: "on-failure"
    expose:
      - 3000
    volumes:
      - './client:/app'
      - '/app/node_modules'
    environment:
      - NODE_ENV=development
      - CHOKIDAR_USEPOLLING=true
    stdin_open: true
    tty: true
```

- 실행! 참 쉽죠?

```
docker-compose up -d --build
```

## 무중단 배포

- 무중단 배포에는 4가지가 있고 이 중 2가지가 대표적이다. [참고](https://wonit.tistory.com/330)

### 1. Rolling Deployment

- 배포된 서버를 한 대씩 순차적으로 연결을 끊어가며 구버전에서 새 버전으로 교체하는 방식
- 장점: 자원을 그대로 유지하고 무중단 배포가 가능하다.
- 단점: 업데이트 도중 서버를 끊어야 하기 때문에 서버 과부하가 생긴다, 롤백이 힘들다.
- ![Rolling Deployment](https://user-images.githubusercontent.com/37368480/140646859-4031fa4d-7c7a-4e63-9095-b5f90e3442a5.png)

### 2. Blue-Green Deployment

- Rolling update의 단점을 보완하는 방법

1. 서버를 그대로 본떠 새롭게 만든 후 버전 업그레이드를 한다.
2. 기존 연결을 새로운 서버의 연결로 변경한다. 이후 기존 서버는 삭제한다.

- 장점: 과부하가 일어나지 않는다.
- 단점: 기존 서버와 동일한 서버 그룹을 생성해야 하기 때문에 비용적 제약이 생긴다.
  - 물리적 서버를 이용해 확장하기 위해서는 2배의 비용이 요구되기 때문에 쉽게 인스턴스를 생성/삭제 할 수 있는 클라우드 환경/Docker 등 가상환경에서 진행하는 것이 좋다.
- ![Blue-Green Deployment](https://user-images.githubusercontent.com/37368480/140646883-8f5d7dcf-c324-49f7-9fde-e46937a49eac.png)

## 목표 프로젝트 구조

## CI/CD 동작 코드

## 결론

## 참조

- [레드햇 - CI/CD(지속적 통합/지속적 제공)](https://www.redhat.com/ko/topics/devops/what-is-ci-cd)
- [GithubAction + React + AWS S3 시리즈](https://velog.io/@loakick/series/GithubActionReactAWS-S3)
- [Github Action 빠르게 시작하기](https://jonnung.dev/devops/2020/01/31/github_action_getting_started/)
- [NGINX란?](https://medium.com/@su_bak/nginx-nginx%EB%9E%80-cf6cf8c33245)
- [NGINX 파일 HOSTING 하기(on Windows)](https://madfishdev.tistory.com/3)
- [[Node.js] PM2 소개와 설치 및 사용법](https://hellominchan.tistory.com/11)
- [React를 Nginx웹 서버에 배포하기](https://www.hanumoka.net/2019/12/29/react-20191229-react-nginx-deploy/)
- [[Docker] 개념 정리 및 사용방법까지](https://cultivo-hy.github.io/docker/image/usage/2019/03/14/Docker%EC%A0%95%EB%A6%AC/)
- [도커에서 Container 포트와 Host 포트의 개념](https://blog.naver.com/PostView.nhn?isHttpsRedirect=true&blogId=alice_k106&logNo=220278762795)
- [[도커] Docker Compose란?](https://scarlett-dev.gitbook.io/all/docker/untitled)
- [Docker 컨테이너에 데이터 저장 (볼륨/바인드 마운트)](https://www.daleseo.com/docker-volumes-bind-mounts/)
