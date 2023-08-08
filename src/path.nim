import os

const
  ROOT_PATH* = static: getCacheDir() / "nimvm"
  INSTALL_PATH* = static: ROOT_PATH / "install"
  VERSION_PATH* = static: ROOT_PATH / "versions"
  CACHE_FILE_PATH* = static: ROOT_PATH / "cache.json"

proc initRootFolder*(): void =
  if not dirExists(ROOT_PATH):
    createDir(ROOT_PATH)

  if not dirExists(INSTALL_PATH):
    createDir(INSTALL_PATH)
  
  if not dirExists(VERSION_PATH):
    createDir(VERSION_PATH)
