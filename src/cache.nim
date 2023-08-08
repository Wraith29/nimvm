import argparser
import asyncdispatch
import json
import os
import strformat
import times
import version
import path

type Cache* = ref object
  timestamp: Time
  versions*: seq[Version]

proc `$`*(cache: Cache): string =
  return fmt"Cache(timestamp: {cache.timestamp}, versions: {cache.versions})"

func newCache(timestamp: Time, versions: seq[Version]): Cache =
  return Cache(timestamp: timestamp, versions: versions)

proc isOutdated(cache: Cache): bool =
  return (cache.timestamp + days(1)) < (now().toTime())

proc reloadCache(): Future[Cache] {.async.} =
  let versions = await getAvailableVersions()
  let cache = newCache(now().toTime(), versions)

  writeFile(CACHE_FILE_PATH, $(%cache))

  return cache

proc getCache*(argParser: ArgParser): Future[Cache] {.async.} =
  if fileExists(CACHE_FILE_PATH):
    let cacheData = readFile(CACHE_FILE_PATH)

    var cache: Cache
    try:
      cache = parseJson(cacheData).to(Cache)
    except JsonParsingError:
      return await reloadCache()

    if cache.isOutdated() or argParser.flags.reloadCache:
      return await reloadCache()

    return cache

  return await reloadCache()

