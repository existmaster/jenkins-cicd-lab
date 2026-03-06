# Jenkins CI/CD Lab

Jenkins를 활용한 CI/CD 파이프라인 구축 실습입니다.
Todo 앱(Backend + Frontend)을 대상으로 파이프라인을 처음부터 끝까지 구축합니다.

---

## 시작하기

### 1. Fork

1. **https://github.com/frentis-ai-study/jenkins-cicd-lab** 에서 **Fork** 클릭
2. 본인 계정으로 Fork 완료

### 2. Codespaces 시작

1. Fork한 레포에서 **Code** > **Codespaces** > **Create codespace on main**
2. 약 2~3분 후 VS Code가 브라우저에서 열립니다

### 3. Jenkins 접속

터미널에서 초기 비밀번호를 확인합니다:

```bash
export DOCKER_API_VERSION=1.43
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

PORTS 탭에서 포트 **8080**을 클릭하여 Jenkins에 접속합니다.

> **"Offline" 화면이 나타날 때**: **Configure Proxy** 클릭 > 아무것도 입력하지 않고 **Submit**. 그래도 안 되면 **Skip plugin installation** 선택 후 **Manage Jenkins > Plugins**에서 수동 설치.

---

## 레포 구조

```
jenkins-cicd-lab/
├── .devcontainer/          # Codespaces 설정
├── apps/
│   ├── backend/            # Express.js Todo API
│   └── frontend/           # React/Vite Todo 앱
├── solutions/              # 단계별 Jenkinsfile 정답
├── docker-compose.staging.yml
├── docker-compose.prod.yml
├── Jenkinsfile             # 여기에 파이프라인을 작성합니다
└── README.md
```

## 포트 안내

| 포트 | 용도 |
|------|------|
| 8080 | Jenkins |
| 3000 | Backend (Staging) |
| 3001 | Frontend (Staging) |
| 4000 | Backend (Production) |
| 4001 | Frontend (Production) |

---

## 문제 해결

### Docker "API version is too new"

```bash
export DOCKER_API_VERSION=1.43
```

터미널을 새로 열 때마다 실행합니다. Codespaces **Rebuild Container** 후에는 자동 적용됩니다.

### Docker permission denied

```bash
docker exec -u root jenkins chmod 666 /var/run/docker.sock
```

### Stage View가 보이지 않을 때

Pipeline: Stage View 플러그인이 설치되지 않은 것입니다.
**Manage Jenkins > Plugins > Available plugins**에서 `Pipeline: Stage View`를 검색하여 설치합니다.
설치 후 Jenkins를 재시작하면 Job Status 페이지에 파이프라인 시각화가 표시됩니다.

### Pipeline "checkout scm" 실패

Repository URL이 본인 Fork의 HTTPS URL인지 확인합니다:
```
https://github.com/<본인계정>/jenkins-cicd-lab.git
```

### Telegram 알림이 오지 않을 때

Jenkins > Manage Jenkins > Credentials에 `telegram-bot-token`과 `telegram-chat-id`가 등록되어 있는지 확인합니다.
