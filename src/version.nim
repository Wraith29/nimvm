import asyncdispatch
import httpclient
import json
import strformat
import sugar
import path
import options
import os
import zippy/tarballs

const NIM_RElEASE_TAG_URL = "https://api.github.com/repos/nim-lang/nim/tags"

type Commit* = ref object
  sha, url*: string

func `$`*(commit: Commit): string =
  return fmt"Commit(sha: {commit.sha}, url: {commit.url})"

type Version* = ref object
  name*, zipball_url*, tarball_url*, node_id: string
  commit: Commit

func `$`*(version: Version): string =
  return fmt"Version(name: {version.name}, commit: {version.commit})"

proc getAvailableVersions*(): Future[seq[Version]] {.async.} =
  let client = newAsyncHttpClient()
  defer: client.close()

  let response = await client.getContent(NIM_RELEASE_TAG_URL)

  return parseJson(response).to(seq[Version])

func getDownloadUrl*(version: Version): string = version.tarball_url

func getInstallPath*(version: Version): string = INSTALL_PATH / version.name

func getTarballPath*(version: Version): string = version.getInstallPath() & ".tar.gz"

func getVersionPath*(version: Version): string = VERSION_PATH / version.name

proc extract*(version: Version): Option[string] =
  let tarballPath = version.getTarballPath()
  let extractPath = version.getInstallPath() & ".out"

  extractAll(tarballPath, extractPath)

  let extractedNimPath = collect(
    for subPath in walkDir(extractPath):
      if subPath.kind == pcDir:
        subPath.path
  )[0]

  copyDir(extractedNimPath, version.getVersionPath())

  none[string]()