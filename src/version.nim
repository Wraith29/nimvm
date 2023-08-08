import asyncdispatch
import httpclient
import json
import strformat
import path
import os

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

func getInstallPath*(version: Version): string = INSTALL_PATH / version.name & ".tar.gz"

func getVersionPath*(version: Version): string = VERSION_PATH / version.name
