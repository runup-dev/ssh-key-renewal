## 소개
서버에서 RSA 암호화 키 페어를 생성합니다   
특정유저 혹은 전체유저를 대상으로 키를 갱신합니다    
공개키는 자동으로 유저에 배포되고 개인키는 안전한 장소에 다운로드 하시면 됩니다    

하나의 서버에서 멀티 호스팅을 하고 있는경우 유용할 것이라고 기대합니다 

## 옵션
- u : 유저명 혹은 all(전체)
- p : 개인키 암호 

## 사용방법
<pre>
<code>
wget https://raw.githubusercontent.com/runup-dev/ssh-key-renewal/master/setRenewal.sh

./setRenewal.sh -u {유저명} -p {개인키암호}
</code>
</pre>

개인키를 안전한 장소에 보관후 로그인에 성공하면 완료된 것입니다 
