# `code` shim

Unity3d only produces `.sln` files if the editor is set to `code` or a few other binaries.

This shim lets us produce `.sln` files regardless of the editor.

For example, to use `emacs` with generated `.sln` files:

1. Navigate to `Edit > Preferences > External Tools`
2. Set "External Script Editor" to Visual Studio Code
3. Set "External Script Editor Args" to `emacsclient -n +$(Line):$(Column) $(File)`
