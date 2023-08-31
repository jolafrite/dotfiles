# dotfiles

This dotfiles project is used to automatically reinstall and configure all the tools i need on my MacOSX.

## Installing

Run the `dotfiles` script:
```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/jolafrite/dotfiles/main/dotfiles)"
```

## Testing Stow

Simulate `stow` links

```sh
stow -nSv vim
```
