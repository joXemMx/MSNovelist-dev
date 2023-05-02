#!/bin/bash

rm $HOME/MSNovelist-dev/*.sif
cd $HOME/MSNovelist-dev/ && \
        singularity pull docker://stravsm/msnovelist6