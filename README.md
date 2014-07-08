# chicken-notmuch

Chicken Scheme bindings for the notmuch library.

## Requirements

You'll need to have the notmuch library installed. If you built notmuch from
source, you're fine. If you're on a Debian or Debian derivitive system, you'll
need to install these packages:

```bash
apt-get install notmuch libnotmuch-dev
```

## Installation

To install this, just run `chicken-install` inside this directory.

## Usage

Look at notmuch.scm and notmuch.h for documentation on how to use this.

```scheme
(import (prefix notmuch nm:))
```
