# Lazy-load Conda on first use

_conda_lazy_load() {
  unset -f conda
  source "$HOME/.local/share/miniconda3/etc/profile.d/conda.sh"
  conda "$@"
}

conda() {
  _conda_lazy_load "$@"
}
