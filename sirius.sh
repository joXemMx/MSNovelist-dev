#!/bin/bash

eval "$(conda shell.bash hook)"
conda activate msnovelist-env
/home/vo87poq/MSNovelist-dev/sirius/bin/sirius $@