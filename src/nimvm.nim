import argparser, asyncdispatch, cache,
       httpclient, options, os, path,
       sequtils, strformat, sugar,
       zippy/tarballs, version

proc downloadVersion(version: Version): Future[Option[string]] {.async.} =
  let client = newAsyncHttpClient()
  defer: client.close()

  let downloadUrl = version.getDownloadUrl()
  let contents = await client.getContent(downloadUrl)
  writeFile(version.getInstallPath(), contents)

  return none[string]()

proc unzipVersion(version: Version): Future[Option[string]] {.async.} =
  let versionPath = version.getInstallPath()

proc installVersion(argParser: ArgParser, cache: Cache): Future[Option[string]] {.async.} =
  ## None is returned in the successful case
  ## Some is returned in an error case
  if argParser.args.len() < 1:
    return some("Missing parameter 'version', try running `nimvm install latest`")

  let versionName = argParser.args[0]
  let versionToInstall = cache.versions.filter(v => v.name == versionName)

  if versionToInstall.len() == 0:
    return some(fmt"Invalid Version '{versionName}'")

  let version = versionToInstall[0]

  let dlMsg = await downloadVersion(version)
  if dlMsg.isSome():
    return dlMsg 

  await unzipVersion(version)

proc listVersions(argParser: ArgParser, cache: Cache): Future[Option[string]] {.async.} =
  if argParser.flags.listInstalled:
    echo "Listing Installed Versions"
    for version in walkDir(VERSION_PATH):
      let versionName = version.path.splitPath().tail
      echo fmt"{versionName}"
    return none[string]()

  echo "Listing Available Versions"
  for version in cache.versions:
    echo fmt"{version.name}"

  return none[string]()

proc main(): Future[void] {.async.} =
  initRootFolder()

  var argParser = newArgParser()
  argParser.parse(commandLineParams())

  let cache = await getCache(argParser)

  case argParser.command.get():
  of cmdInstall:
    let error = await installVersion(argParser, cache)
    if error.isNone():
      quit(0)
    echo fmt"ERROR: Failed to install version. {error.get()}"
  of cmdList:
    let error = await listVersions(argParser, cache)
    if error.isNone():
      quit(0)
    echo fmt"ERROR: Failed to list versions. {error.get()}"
  else: discard

when isMainModule:
  waitFor main()