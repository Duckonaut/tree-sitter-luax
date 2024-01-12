ts := tree-sitter

generate:
	${ts} generate

test: generate
	make test_ts
	make test_docgen

test_ts: generate
	${ts} test

update: generate
	${ts} test --update

build_parser: generate
	mkdir -p build
	cc -o ./build/parser.so -I./src src/parser.c src/scanner.c -shared -Os -fPIC
	mkdir -p parser
	cp -u ./build/parser.so ./parser/luax.so || exit 0

gen_howto:
	nvim --headless --noplugin -u tests/init.luax -c "luafile ./scratch/gen_howto.lua" -c 'qa'

luaxlint:
	luaxcheck lua/docgen

dist:
	mkdir -p parser
	cc -o ./parser/luax.so -I./src src/parser.c src/scanner.c -shared -Os -fPIC

wasm: build_parser
	${ts} build-wasm

web: wasm
	${ts} web-ui
