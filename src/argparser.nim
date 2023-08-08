import command
import options
import flags
import strformat

type ArgParser* = ref object
  command*: Option[Command]
  flags*: Flags
  args*: seq[string]

func newArgParser*(): ArgParser {.raises: [].} =
  return ArgParser(
    command: none[Command](),
    flags: newFlags(),
    args: newSeq[string](),
  )

proc `$`*(argParser: ArgParser): string =
  return fmt"ArgParser(command: {argParser.command}, flags: {argParser.flags}, args: {argParser.args})"

proc parse*(argParser: var ArgParser, args: seq[string]): void =
  if args.len() == 0:
    argParser.command = some(cmdUsage)
    return

  for arg in args:
    if isNone(argParser.command):
      let cmd = arg.toCommand()
      argParser.command = some(cmd)
      continue
    
    if isFlag(arg):
      argParser.flags.toggleFlag(arg)
      continue

    argParser.args.add(arg)
