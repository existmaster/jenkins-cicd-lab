#!/bin/bash
# Jenkins 시작 대기 및 초기 비밀번호 표시

echo ""
echo "⏳ Jenkins 시작 대기중... (최대 3분)"
echo ""

# Jenkins 컨테이너에서 Docker 소켓 사용 가능하도록 권한 설정
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
  echo "✅ Jenkins가 준비되었습니다!"
  echo ""
  echo "   Jenkins URL: http://localhost:8080"
  echo "   초기 비밀번호: $PASSWORD"
  echo ""
  echo "   위 비밀번호를 복사하여 Jenkins에 붙여넣으세요."
else
  echo "⚠️  Jenkins가 아직 시작되지 않았습니다."
  echo ""
  echo "   아래 명령으로 비밀번호를 확인하세요:"
  echo "   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword"
  echo ""
  echo "   Jenkins 로그 확인:"
  echo "   docker logs jenkins"
fi
echo "================================================"
echo ""
