## Disable Baloo (KDE file indexer)

Baloo is intentionally disabled to avoid background indexing,
disk IO, and duplicate search with fzf/rg.

Run once per user:

```bash
balooctl6 disable
rm -rf ~/.local/share/baloo ~/.cache/baloo

## Disable baloo results => plasma

systemctl --user stop plasma-baloorunner.service
systemctl --user mask plasma-baloorunner.service
