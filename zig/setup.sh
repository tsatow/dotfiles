ghq get https://github.com/zigtools/zls
cd $(ghq root)/github.com/zigtools/zls
git checkout $(zig version | sed -E 's/([0-9]+\.[0-9]+)\.[0-9]+/\1.0/') # zlsはマイナーバージョン毎に作られるので、パッチバージョンを0にする
zig build -Doptimize=ReleaseSafe
cp zig-out/bin/zls ~/.local/bin
