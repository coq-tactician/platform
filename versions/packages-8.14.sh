#!/usr/bin/env bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020..2021 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### CONTROL VARIABLES #####################

# The two lines below are used by the package selection script
# DESCRIPTION Coq 8.14+rc1 (release candidate 1)
# SORTORDER 9000

# The package list name is the final part of the opam switch name.
# It is usually either empty ot starts with ~.
# It might also be used for installer package names, but with ~ replaced by _
# It is also used for version specific file selections in the smoke test kit.
COQ_PLATFORM_PACKAGELIST_NAME='~8.14+rc1'

# The corresponding Coq development branch and tag
COQ_PLATFORM_COQ_BRANCH='v8.14'
COQ_PLATFORM_COQ_TAG='8.14+rc1'

# This controls if opam repositories for development packages are selected
COQ_PLATFORM_USE_DEV_REPOSITORY='Y'

###################### PACKAGE SELECTION #####################

PACKAGES=""

# - Comment out packages you do not want.
# - Packages with system dependencies should be given first.
#   This avoids multiple sudo password requests
# - Packages which take a long time to build should be given last.
#   There is some evidence that they are built early then.
# - The picking tracker issue is https://github.com/coq/platform/issues/139

########## BASE PACKAGES ##########

# Build tools - this is selected early to avoid the version is changed later
# and everything has to be recompiled.
PACKAGES="${PACKAGES} dune.2.9.1"

# The Coq compiler coqc and the Coq standard library
PACKAGES="${PACKAGES} coq.8.14+rc1"

########## IDE PACKAGES ##########

# GTK based IDE for Coq - alternatives are VSCoq and Proofgeneral for Emacs
if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[iIfFxX] ]]
then
PACKAGES="${PACKAGES} coqide.8.14+rc1 lablgtk3.3.1.1"
fi

########## "FULL" COQ PLATFORM PACKAGES ##########

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[fFxX] ]]
then

  # General standard library extensions 
  PACKAGES="${PACKAGES} coq-bignums.8.14.0"
  PACKAGES="${PACKAGES} coq-ext-lib.0.11.4"           # pick confirmed https://github.com/coq-community/coq-ext-lib/issues/116

  # General mathematics
  PACKAGES="${PACKAGES} coq-mathcomp-ssreflect.1.12.0"
  PACKAGES="${PACKAGES} coq-mathcomp-fingroup.1.12.0"
  PACKAGES="${PACKAGES} coq-mathcomp-algebra.1.12.0"
  PACKAGES="${PACKAGES} coq-mathcomp-solvable.1.12.0"
  PACKAGES="${PACKAGES} coq-mathcomp-field.1.12.0"
  PACKAGES="${PACKAGES} coq-mathcomp-character.1.12.0"
  PACKAGES="${PACKAGES} coq-mathcomp-bigenough.1.0.0"
  PACKAGES="${PACKAGES} coq-mathcomp-finmap.1.5.1"
  PACKAGES="${PACKAGES} coq-mathcomp-real-closed.1.1.2"
  PACKAGES="${PACKAGES} coq-coquelicot.3.2.0"         # pick confirmed https://gitlab.inria.fr/coquelicot/coquelicot/-/issues/4

  # Numerical mathematics
  PACKAGES="${PACKAGES} coq-interval.4.3.0"           # pick confirmed https://gitlab.inria.fr/coqinterval/interval/-/issues/7
  PACKAGES="${PACKAGES} coq-flocq.3.4.2"              # pick confirmed https://gitlab.inria.fr/flocq/flocq/-/issues/17
  PACKAGES="${PACKAGES} coq-gappa.1.5.0 gappa.1.4.0"  # pick confirmed https://gitlab.inria.fr/gappa/coq/-/issues/9

  # Homotopy Type Theory (HoTT)
  PACKAGES="${PACKAGES} coq-hott.8.13~flex"           # TO BE UPDATED !!! See https://github.com/HoTT/HoTT/issues/1581

  # Proof automation / generation / helpers
  #PACKAGES="${PACKAGES} coq-equations.1.2.3+8.13"    # coq-equations.1.2.4+8.13~flex does not compile
  PACKAGES="${PACKAGES} coq-aac-tactics.8.14.0"       # pick confirmed https://github.com/coq-community/aac-tactics/issues/87
  PACKAGES="${PACKAGES} coq-unicoq.1.5+8.14"          # untagged pre release
  PACKAGES="${PACKAGES} coq-mtac2.1.4+8.14"           # pick confirmed https://github.com/Mtac2/Mtac2/issues/344
  PACKAGES="${PACKAGES} coq-elpi.1.11.2 elpi.1.13.7"  # pick confirmed https://github.com/LPCIC/coq-elpi/issues/291
  PACKAGES="${PACKAGES} coq-hierarchy-builder.1.2.0"  # pick confirmed https://github.com/math-comp/hierarchy-builder/issues/265
  PACKAGES="${PACKAGES} coq-quickchick.1.5.1"         # pick confirmed https://github.com/QuickChick/QuickChick/issues/236

  # Formal languages, compilers and code verification
  PACKAGES="${PACKAGES} coq-menhirlib.20210419 menhir.20210419" # pick confirmed https://gitlab.inria.fr/fpottier/menhir/-/issues/55

  case "$COQ_PLATFORM_COMPCERT" in
    [yY]) PACKAGES="${PACKAGES} coq-compcert.3.9~flex" ;;       # pick confirmed https://github.com/AbsInt/CompCert/issues/414
    [nN]) true ;;
    *) echo "Illegal value for COQ_PLATFORM_COMPCERT - aborting"; false ;;
  esac

  case "$COQ_PLATFORM_VST" in
    [yY]) PACKAGES="${PACKAGES} coq-vst.2.8~flex" ;;
    [nN]) true ;;
    *) echo "Illegal value for COQ_PLATFORM_VST - aborting"; false ;;
  esac

  # Code extraction
  PACKAGES="${PACKAGES} coq-simple-io.1.5.0~flex"

fi

########## EXTENDED" COQ PLATFORM PACKAGES ##########

# if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[xX] ]]
# then
# fi