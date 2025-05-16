# Cloud-STARS
SK쉴더스 루키즈 최종프로젝트 클라우드 리포지토리 입니다.

# 1. 클라우드 스택 다 지우기
모든 문제의 원인

# 2. 아래 명령어 입력
aws eks update-kubeconfig --region ap-northeast-2 --name one-cluster


# 백엔드 배포 순서
- 인그레스 배포
- route53에서 (api.*, elasticsearch.*) 값 설정
  - 실제 코드에서 위의 dns를 사용해서 호출을 하기 때문에 설정 해둬야 코드가 정상 작동함
- 백엔드 배포