AhnCache
==========================

Caching layer for Adhearsion's Celluloid Actors

## Usage

Add to your Adhearsion's app bundle

```
gem "ahn\_cache", :git => "git@github.com:/krakatoa/ahn_cache.git"
```

## Config file

Caching (per-environment) configuration is stored in **/config/cache.yml**

### Redis usage

```
development:
  backend: redis
  url: 'redis://ivr-db-dev.smrttouch.com:6379/0'
  ttl: 30
```

### Ehcache usage

```
development:
  backend: ehcache
  ttl: 30
```