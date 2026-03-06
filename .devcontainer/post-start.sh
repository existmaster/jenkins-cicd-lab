#!/bin/bash
# Jenkins 시작 안내

# Docker CLI가 있으면 자동 감지, 없으면 안내만 출력
if command -v docker &>/dev/null; then
  echo ""
  echo "Jenkins 시작 대기중... (최대 3분)"
  echo ""

  # Docker 소켓 권한 설정
  docker exec -u root jenkins chmod 666 /var/run/docker.sock 2>/dev/null

  PASSWORD=""
  for i in $(seq 1 60); do
    PASSWORD=$(docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null)
    if [ -n "$PASSWORD" ]; then
      break
    fi
    printf "."
    sleep 3
  done
  echo ""

  echo "================================================"
  if [ -n "$PASSWORD" ]; then
    echo "Jenkins가 준비되었습니다!"
    echo ""
    echo "   Jenkins URL: http://localhost:8080"
    echo "   초기 비밀번호: $PASSWORD"
    echo ""
    echo "   위 비밀번호를 복사하여 Jenkins에 붙여넣으세요."
  else
    echo "Jenkins가 아직 시작되지 않았습니다."
    echo ""
    echo "   아래 명령으로 비밀번호를 확인하세요:"
    echo "   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword"
  fi
  echo "================================================"
else
  echo ""
  echo "================================================"
  echo "Jenkins가 백그라운드에서 시작 중입니다."
  echo ""
  echo "   Jenkins URL: http://localhost:8080"
  echo ""
  echo "   초기 비밀번호 확인:"
  echo "   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword"
  echo ""
  echo "   Docker 소켓 권한 설정 (최초 1회):"
  echo "   docker exec -u root jenkins chmod 666 /var/run/docker.sock"
  echo "================================================"
fi
echo ""
