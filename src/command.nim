type Command* = enum
  cmdInstall
  cmdDelete
  cmdSelect
  cmdList
  cmdUsage

func `$`*(cmd: Command): string =
  return case cmd:
    of cmdInstall: "install"
    of cmdDelete: "delete"
    of cmdSelect: "select"
    of cmdList: "list"
    of cmdUsage: "usage"

proc toCommand*(cmd: string): Command =
  return if cmd == "list":
      cmdList
    elif cmd == "install":
      cmdInstall
    elif cmd == "select":
      cmdSelect
    elif cmd == "delete":
      cmdDelete
    else:
      cmdUsage
