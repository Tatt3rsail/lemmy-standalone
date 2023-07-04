FROM ubuntu
EXPOSE 3000
ENTRYPOINT ["tail", "-f", "/dev/null"]


apt update
apt install wget curl build-essential
apt install protobuf-compiler libprotobuf-dev
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
apt install ffmpeg exiftool libgexiv2-dev --no-install-recommends
wget https://download.imagemagick.org/ImageMagick/download/binaries/magick
mv magick /usr/bin/
chmod 755 /usr/bin/magick
apt install pkg-config libssl-dev libpq-dev postgresql
echo 'local   lemmy           lemmy                                   md5' >> /etc/postgresql/14/main/pg_hba.conf
/etc/init.d/postgresql start
cargo install lemmy_server --target-dir /usr/bin/ --locked --features embed-pictrs
sudo -iu postgres psql -c "CREATE USER lemmy WITH PASSWORD 'db-passwd';"
sudo -iu postgres psql -c "CREATE DATABASE lemmy WITH OWNER lemmy;"
adduser lemmy --system --disabled-login --no-create-home --group
