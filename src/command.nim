type Command* = enum
  cmdInstall
  cmdDelete
  cmdSelect
  cmdList
  cmdUsage
  cmdClean

func `$`*(cmd: Command): string =
  return case cmd:
    of cmdInstall: "install"
    of cmdDelete: "delete"
    of cmdSelect: "select"
    of cmdList: "list"
    of cmdUsage: "usage"
    of cmdClean: "clean"

proc toCommand*(cmd: string): Command =
  return if cmd == "list":
      cmdList
    elif cmd == "install":
      cmdInstall
    elif cmd == "select":
      cmdSelect
    elif cmd == "delete":
      cmdDelete
    elif cmd == "clean":
      cmdClean
    else:
      cmdUsage
