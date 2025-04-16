# ARGO 설치
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

- 안씀
kubectl apply -n default -f .\argo-install.yaml
```

# ARGO 패스워드 찾기
Powershell에서 실행
```
Base64로 인코딩된 비밀번호 확인 
kubectl get secret -n default argocd-initial-admin-secret -o jsonpath="{.data.password}"

디코딩 하는 코드
[System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String("패스워드"))
```

# 아르고 패스워드 변경
```
kubectl exec -it -n default deployment/argocd-server -- /bin/bash
kubectl exec -it -n argocd deployment/argocd-server -- /bin/bash

argocd login localhost:8080 --username admin --password "디코딩패스워드" --insecure
argocd login localhost:8080 --username admin --password "AOhaguDPwfx9GZ6G" --insecure

argocd account update-password

```

# 포트포워딩으로 실행
```
kubectl port-forward svc/argocd-server -n argocd 8889:443
```