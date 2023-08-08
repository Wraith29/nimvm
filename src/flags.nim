import strformat

const validFlags = ["-r", "--reload-cache", "-i", "--list-installed"]

type Flags* = ref object
  reloadCache*, listInstalled*: bool

func newFlags*(): Flags =
  return Flags(
    reloadCache: false,
    listInstalled: false
  )

func `$`*(flags: Flags): string =
  return fmt"Flags(reloadCache: {flags.reloadCache}, listInstalled: {flags.listInstalled})"

template isFlag*(flagName: string): bool = flagName in validFlags

template toggleFlag*(flags: var Flags, flagName: string): void =
  case flagName:
  of "-r", "--reload-cache":
    flags.reloadCache = not flags.reloadCache
  of "-i", "--list-installed":
    flags.listInstalled = not flags.listInstalled
  else: discard