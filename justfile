update-theme:
  git submodule update --remote --merge

hugo-run:
  hugo server --disableFastRender -D

hugo-build:
  hugo --minify
