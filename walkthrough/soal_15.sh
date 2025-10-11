# ==== ELROND ====
apt update
apt install apache2-utils -y

ab -n 500 -c 10 http://www.k55.com/app/
ab -n 500 -c 10 http://www.k55.com/static/